{
  description = "Bun.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        setup-script = pkgs.writeScriptBin "setup-project" ''
                #!${pkgs.bash}/bin/bash
          	if [[ ! -d node_modules ]]; then
                    ${pkgs.bun}/bin/bun i
          	fi
        '';
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
          ];

          buildInputs = with pkgs; [ bun ];

          shellHook = ''
            setup-project
            ${pkgs.gum}/bin/gum format <<EOF
            # Welcome to the Sutherland development environment!

            - [Visit the github repository](https://github.com/alexwarth/sutherland)

            ## Quick start tips

            - Run \`bun run dev\` to get started with development

            Have fun with a reimplementation of Ivan Sutherland's sketchpad! :)
            EOF
          '';
        };
      });
}
