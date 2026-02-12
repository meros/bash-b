{
  description = "Interactive Git branch selector using fuzzy finding";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        git-branch-selector = pkgs.callPackage ./default.nix { };
      in
      {
        packages = {
          default = git-branch-selector;
          git-branch-selector = git-branch-selector;
        };

        apps.default = {
          type = "app";
          program = "${git-branch-selector}/bin/b";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            fzf
            bash
          ];
        };

        checks = {
          package = git-branch-selector;
        };
      }
    );
}
