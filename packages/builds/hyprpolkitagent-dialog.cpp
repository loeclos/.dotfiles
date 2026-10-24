#include "Dialog.hpp"

#include "../core/Agent.hpp"
#include "../config/Config.hpp"

#include <hyprtoolkit/element/Rectangle.hpp>
#include <hyprtoolkit/element/RowLayout.hpp>
#include <hyprtoolkit/element/ColumnLayout.hpp>
#include <hyprtoolkit/element/Combobox.hpp>
#include <hyprtoolkit/types/SizeType.hpp>
#include <hyprtoolkit/types/FontTypes.hpp>
#include <hyprtoolkit/palette/Color.hpp>
#include <hyprtoolkit/core/Input.hpp>

#include <xkbcommon/xkbcommon-keysyms.h>
#include <unistd.h>
#include <print>

using namespace Hyprutils::Memory;
using namespace Hyprutils::Math;
using namespace Hyprtoolkit;

CDialog::CDialog(const CPolkitListener::SAuthRequest& req, CSharedPointer<IBackend> backend) : m_backend(backend), m_req(req) {
    build();
}

CDialog::~CDialog() {
    if (m_window)
        m_window->close();
}

void CDialog::show() {
    if (!m_window)
        return;
    m_window->open();
    if (m_passwordField)
        m_passwordField->focus();
}

void CDialog::close() {
    if (m_window) {
        m_window->close();
        m_window.reset();
    }
}

void CDialog::setPrompt(const std::string& text, bool echo) {
    std::string newPrompt = text;
    while (!newPrompt.empty() && (newPrompt.back() == ' ' || newPrompt.back() == '\t'))
        newPrompt.pop_back();
    if (!newPrompt.empty() && newPrompt.back() == ':')
        newPrompt.pop_back();
    while (!newPrompt.empty() && (newPrompt.back() == ' ' || newPrompt.back() == '\t'))
        newPrompt.pop_back();
    if (newPrompt.empty())
        newPrompt = "Password";

    // a real password prompt: pam wants typed input now, so reveal the field.
    // no-op when already visible (password-only auth).
    m_sawPasswordPrompt = true;
    showPasswordField(true);

    // initial prompt arrives after build() and would clobber the first keystroke
    const bool clean = m_currentPassword.empty() && newPrompt == m_promptText && echo == m_promptEcho;

    m_promptText = newPrompt;
    m_promptEcho = echo;

    if (clean) {
        if (m_passwordField)
            m_passwordField->focus();
        return;
    }

    if (!m_passwordField)
        return;

    m_currentPassword.clear();
    m_passwordField->rebuild()->placeholder(std::string{newPrompt})->commence();
    m_passwordField->setText(std::string{});
    m_passwordField->setPassword(!echo);
    if (m_authEnabled && m_authButton) {
        m_authEnabled = false;
        m_authButton->setEnabled(false);
    }
    m_passwordField->focus();
}

void CDialog::buildPasswordField() {
    const auto& cfg = g_pConfigManager->get();
    m_passwordField = CTextboxBuilder::begin()
                          ->placeholder(std::string{m_promptText})
                          ->password(!m_promptEcho)
                          ->eyeIcon(true)
                          ->multiline(false)
                          ->size({CDynamicSize::HT_SIZE_ABSOLUTE, CDynamicSize::HT_SIZE_ABSOLUTE, {(double)cfg.passwordFieldWidth, 36.0}})
                          ->onTextEdited([this](CSharedPointer<CTextboxElement>, const std::string& s) {
                              m_currentPassword     = s;
                              const bool nowEnabled = !s.empty();
                              if (nowEnabled != m_authEnabled && m_authButton) {
                                  m_authEnabled = nowEnabled;
                                  m_authButton->setEnabled(nowEnabled);
                              }
                              // keep the previous error visible until a new one arrives or the
                              // dialog closes. clearing on first keystroke produced a red flash
                              // because the helper restart resets the field, fires onTextEdited
                              // with an empty string, then again with the first typed char.
                          })
                          ->commence();
}

void CDialog::showStatus(CSharedPointer<IElement>& wrap, bool& shown, bool show) {
    if (!m_statusContainer || !wrap)
        return;
    if (show && !shown) {
        m_statusContainer->addChild(wrap);
        shown = true;
    } else if (!show && shown) {
        m_statusContainer->removeChild(wrap);
        shown = false;
    }
}

void CDialog::showPasswordField(bool show) {
    if (show == m_passwordVisible || !m_passwordWrap)
        return;
    m_passwordVisible = show;
    if (show) {
        m_passwordWrap->addChild(m_passwordField);
        if (m_btnRow && m_authButton)
            m_btnRow->addChild(m_authButton);
        m_passwordField->focus();
    } else {
        m_passwordWrap->removeChild(m_passwordField);
        if (m_btnRow && m_authButton)
            m_btnRow->removeChild(m_authButton);
    }
}

void CDialog::setInfo(const std::string& text) {
    // a pam cue (fingerprint reader, security key) that arrives before any password
    // prompt means pam is not asking for a password yet. hide the field until it does,
    // and reveal it only if pam falls back to a password prompt. matches polkit-gnome.
    if (!text.empty() && !m_sawPasswordPrompt)
        showPasswordField(false);
    if (m_infoLabel)
        m_infoLabel->setText(std::string{text});
    showStatus(m_infoWrap, m_infoShown, !text.empty());
}

void CDialog::setError(const std::string& text) {
    if (m_errorLabel)
        m_errorLabel->setText(std::string{text});
    showStatus(m_errWrap, m_errShown, !text.empty());
}

void CDialog::build() {
    const auto& cfg = g_pConfigManager->get();

    // Minimal floating prompt: no card, no title, no buttons, no details.
    // Just "Allow: <command>" above the password field. Enter submits,
    // Escape cancels (see key listener). Error/info/caps lines only take
    // space while visible.
    const double targetHeight = (double)cfg.windowHeight;

    m_window = CWindowBuilder::begin()
                   ->preferredSize({(double)cfg.windowWidth, targetHeight})
                   ->minSize({(double)cfg.windowWidth, targetHeight})
                   ->maxSize({(double)cfg.windowWidth, targetHeight})
                   ->appTitle("Authentication Required")
                   ->appClass("hyprpolkitagent")
                   ->commence();

    m_closeListener = m_window->m_events.closeRequest.listen([] { g_pAgent->cancel(); });

    m_keyListener = m_window->m_events.keyboardKey.listen([this](const Input::SKeyboardKeyEvent& ev) {
        const bool caps = ev.modMask & Input::HT_MODIFIER_CAPS;
        if (caps != m_capsLockOn) {
            m_capsLockOn = caps;
            if (m_capsLockLabel && caps)
                m_capsLockLabel->setText(std::string{"Caps Lock is on"});
            showStatus(m_capsWrap, m_capsShown, caps);
        }

        if (!ev.down || ev.repeat)
            return;
        if (ev.xkbKeysym == XKB_KEY_Return || ev.xkbKeysym == XKB_KEY_KP_Enter) {
            if (!m_currentPassword.empty())
                g_pAgent->submitPassword(m_currentPassword);
        } else if (ev.xkbKeysym == XKB_KEY_Escape) {
            g_pAgent->cancel();
        }
    });

    // NOTE: no opaque background on purpose. A single translucent dark card
    // sits behind the content so the white letters stay readable on any
    // wallpaper (bg0 #1d2021 at 80% — mirrors theme.palette.bg0, which this
    // file can't import). Everything else remains chrome-free.
    {
        const auto palette = g_pAgent->backend()->getPalette();
        auto       card    = CRectangleBuilder::begin()
                       ->color([] { return CHyprColor{0x1d / 255.F, 0x20 / 255.F, 0x21 / 255.F, 0.8F}; })
                       ->rounding(palette->m_vars.bigRounding)
                       ->size({CDynamicSize::HT_SIZE_ABSOLUTE, CDynamicSize::HT_SIZE_ABSOLUTE, {(double)cfg.windowWidth - 16.0, targetHeight - 16.0}})
                       ->commence();
        card->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
        card->setPositionFlag(IElement::HT_POSITION_FLAG_CENTER, true);
        m_window->m_rootElement->addChild(card);
    }

    auto outer = CColumnLayoutBuilder::begin()->size({CDynamicSize::HT_SIZE_PERCENT, CDynamicSize::HT_SIZE_AUTO, {0.9F, 0.0F}})->gap(8)->commence();
    outer->setMargin(4);
    outer->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
    outer->setPositionFlag(IElement::HT_POSITION_FLAG_CENTER, true);
    m_window->m_rootElement->addChild(outer);

    // "Allow: <command>" — the only label. Falls back to the polkit message
    // when no command is attached (non-pkexec actions).
    {
        std::string allow = m_req.command.empty() ? m_req.message : std::string{"Allow: "} + m_req.command;

        constexpr size_t MAX_ALLOW = 90;
        if (allow.size() > MAX_ALLOW)
            allow = allow.substr(0, MAX_ALLOW - 3) + "...";

        const auto palette = g_pAgent->backend()->getPalette();

        auto wrap = CRowLayoutBuilder::begin()->commence();
        wrap->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
        wrap->setPositionFlag(IElement::HT_POSITION_FLAG_HCENTER, true);
        wrap->addChild(CTextBuilder::begin()
                           ->text(std::string{allow})
                           ->fontFamily(std::string{palette->m_vars.fontFamilyMonospace})
                           ->clampSize({(double)cfg.passwordFieldWidth, -1.0})
                           ->color([] { return g_pAgent->backend()->getPalette()->m_colors.text; })
                           ->commence());
        outer->addChild(wrap);
    }

    {
        auto wrap = CRowLayoutBuilder::begin()->commence();
        wrap->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
        wrap->setPositionFlag(IElement::HT_POSITION_FLAG_HCENTER, true);
        buildPasswordField();
        wrap->addChild(m_passwordField);
        outer->addChild(wrap);
        // kept as a member so the field can be pulled out and put back while a
        // fingerprint or security key is pending (see showPasswordField).
        m_passwordWrap = wrap;
    }

    // wraps are only attached when their label has text, so empty labels reserve no space
    {
        auto statusCol = CColumnLayoutBuilder::begin()->gap(4)->commence();
        statusCol->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
        statusCol->setPositionFlag(IElement::HT_POSITION_FLAG_HCENTER, true);
        outer->addChild(statusCol);
        m_statusContainer = statusCol;

        auto makeWrap = [](CSharedPointer<CTextElement> label) {
            auto w = CRowLayoutBuilder::begin()->commence();
            w->setPositionMode(IElement::HT_POSITION_ABSOLUTE);
            w->setPositionFlag(IElement::HT_POSITION_FLAG_HCENTER, true);
            w->addChild(label);
            return w;
        };

        m_capsLockLabel = CTextBuilder::begin()->text(std::string{""})->fontSize({CFontSize::HT_FONT_SMALL})->color([] { return CHyprColor{1.0F, 0.75F, 0.2F, 1.F}; })->commence();
        m_errorLabel    = CTextBuilder::begin()->text(std::string{""})->color([] { return CHyprColor{0.9F, 0.4F, 0.4F, 1.F}; })->commence();
        m_infoLabel     = CTextBuilder::begin()->text(std::string{""})->color([] { return g_pAgent->backend()->getPalette()->m_colors.text.darken(0.4); })->commence();

        m_capsWrap = makeWrap(m_capsLockLabel);
        m_errWrap  = makeWrap(m_errorLabel);
        m_infoWrap = makeWrap(m_infoLabel);
    }

    // NOTE: no Cancel/Authenticate buttons and no details panel on purpose.
    // Enter submits, Escape cancels. m_authButton/m_btnRow stay null — every
    // touch point already null-checks them.

    if (m_passwordField)
        m_passwordField->focus();
}
