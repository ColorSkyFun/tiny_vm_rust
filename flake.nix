{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };
    in
    {
      devShells."x86_64-linux".default =
        with pkgs;
        mkShell {
          buildInputs = [
            openssl
            pkg-config
            eza
            fd
            (rust-bin.beta.latest.default.override {
              extensions = [ "rust-src" ];
            })
          ];

          shellHook = ''
            alias ls=eza
            alias find=fd
          '';
        };
    };
}
