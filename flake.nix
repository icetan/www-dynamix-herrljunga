{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      # packages = forEachSystem (system: {
      #   devenv-up = self.devShells.${system}.default.config.procfileScript;
      # });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = pkgs.mkShell {
              buildInputs = [
                (pkgs.ruby.withPackages (ps: with ps; [ jekyll ]))
                pkgs.instaloader
                pkgs.yq
                pkgs.jq
                pkgs.gnugrep
                pkgs.coreutils
              ];
              shellHook = ''
                echo >&2 'Welcome to the Nix shell!'
              '';
            };
          });
    };
}
