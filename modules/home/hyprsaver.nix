{
  pkgs,
  lib,
  ...
}:

let
  hyprsaver = pkgs.hyprsaver.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeBinaryWrapper ];
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/hyprsaver \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
            pkgs.libGL
            pkgs.mesa
            pkgs.libxkbcommon
            pkgs.wayland
          ]}
      '';
  });
in
{
  home.packages = [ hyprsaver ];

  xdg.configFile."hypr/hyprsaver.toml" = {
    text = ''
      [general]
      fps = 30
      shader = "cycle"
      palette = "cycle"
      shader_cycle_interval = 120
      palette_cycle_interval = 20
      cycle_order = "random"
      synced = true

      [behavior]
      fade_in_ms = 800
      fade_out_ms = 400
      dismiss_on = ["key", "mouse_move", "mouse_click", "touch"]
    '';
  };
}
