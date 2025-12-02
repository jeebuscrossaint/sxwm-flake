{
  description = "sxwm - A very SeXy Window Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sxwm";
          version = "1.8";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            gcc
            gnumake
          ];

          buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXinerama
            xorg.libXcursor
          ];

          makeFlags = [
            "PREFIX=$(out)"
          ];

          installFlags = [
            "PREFIX=$(out)"
          ];

          meta = with pkgs.lib; {
            description = "A user-friendly, easily configurable yet powerful tiling window manager";
            homepage = "https://github.com/uint23/sxwm";
            license = licenses.gpl3Plus;
            platforms = platforms.linux;
            maintainers = [ ];
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/sxwm";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          
          packages = with pkgs; [
            clang-tools
          ];
        };
      }
    );
}