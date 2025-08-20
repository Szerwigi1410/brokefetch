{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux.brokefetch = pkgs.stdenv.mkDerivation {
        pname = "brokefetch";
        version = "1.7";

        src = ./.;

        buildInputs = [
          pkgs.bash
        ];

        installPhase = ''
          mkdir -p $out/bin
          cp ./brokefetch.sh $out/bin/brokefetch
          chmod +x $out/bin/brokefetch
        '';
      };
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.brokefetch;
    };
}
