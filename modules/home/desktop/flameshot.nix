{ config, theme, ... }:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
        savePathFixed = false;
        saveAsFileExtension = ".png";
        filenamePattern = "%F_%H-%M-%S";
        uiColor = theme.palette.orange;
        contrastUiColor = theme.palette.bg0;
        drawColor = theme.palette.brightRed;
        userColors = "picker, ${theme.palette.brightRed}, ${theme.palette.brightYellow}, ${theme.palette.brightGreen}, ${theme.palette.brightAqua}, ${theme.palette.brightBlue}, ${theme.palette.brightPurple}, ${theme.palette.orange}, ${theme.palette.fg}";
        showHelp = false;
        showDesktopNotification = true;
        showAbortNotification = false;
        showStartupLaunchMessage = false;
        disabledTrayIcon = false;
        saveAfterCopy = true;
        copyURLAfterUpload = true;
        drawThickness = 3;
        contrastOpacity = 190;
      };
    };
  };
}
