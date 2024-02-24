{
  description = "Nix hash collection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:

    (flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in 
    {
      devShells.default = pkgs.mkShell {
 nativeBuildInputs = with pkgs; [ rustc cargo gcc pkg-config ];
    buildInputs = [
      (pkgs.python3.withPackages (
        ps: [
          ps.fastapi
          ps.uvicorn
          ps.sqlalchemy
          ps.pydantic
        ]
      ))
      pkgs.jq
      pkgs.rust-analyzer
      pkgs.openssl
      pkgs.nixVersions.nix_2_19
      pkgs.nlohmann_json
      pkgs.libsodium
      pkgs.boost
      pkgs.rustfmt

    ];

      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

      };
    }));


}
