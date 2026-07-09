{
  description = "Interactive Git branch selector using fuzzy finding";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      overlays.default = final: prev: {
        bash-b = final.callPackage ./default.nix { };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          git-branch-selector = pkgs.callPackage ./default.nix { };
        in
        {
          default = git-branch-selector;
          git-branch-selector = git-branch-selector;
          bash-b = git-branch-selector;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/b";
        };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              fzf
              bash
            ];
          };
        }
      );

      checks = forAllSystems (system: {
        package = self.packages.${system}.default;
      });
    };
}
