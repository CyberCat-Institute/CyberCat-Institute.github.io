{
  description = "Simple Ruby + Jekyll devshell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        myDevTools = [
          pkgs.ruby
          pkgs.rubyPackages.jekyll
        ];

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = myDevTools;
        };
      });
}
