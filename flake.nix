{
  description = "The Nixarr Media Server Nixos Module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    # Systems supported
    supportedSystems = [
      "x86_64-linux" # 64-bit Intel/AMD Linux
      "aarch64-linux" # 64-bit ARM Linux
      "x86_64-darwin" # 64-bit Intel macOS
      "aarch64-darwin" # 64-bit ARM macOS
    ];

    # Helper to provide system-specific attributes
    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    nixosModules.default.imports = [./nixarr];

    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          nixd
        ];
      };
    });


    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}
