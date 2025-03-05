{
  description = "Deterministic SSH ED25519 Key Generation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Python with required packages
        pythonWithPackages = pkgs.python3.withPackages (ps: [
          ps.cryptography
        ]);

        # Python script for deterministic key generation
        deterministicKeyGen = pkgs.stdenv.mkDerivation {
          pname = "deterministic-ssh-keygen";
          version = "0.1.0";

          src = ./.;

          buildInputs = [ pythonWithPackages ];

          installPhase = ''
            mkdir -p $out/bin
            cp ${./deterministic-ssh-keygen.py} $out/bin/deterministic-ssh-keygen.py
            chmod +x $out/bin/deterministic-ssh-keygen.py

            # Create wrapper script
            cat > $out/bin/deterministic-ssh-keygen << EOF
            #!${pkgs.bash}/bin/bash
            ${pythonWithPackages}/bin/python3 $out/bin/deterministic-ssh-keygen.py "\$@"
            EOF
            chmod +x $out/bin/deterministic-ssh-keygen
          '';
        };

        # Development shell with required packages
        devShell = pkgs.mkShell {
          buildInputs = [
            pythonWithPackages
          ];

          shellHook = ''
            echo "Deterministic SSH Key Generation Dev Shell"
            echo "Usage: deterministic-ssh-keygen <seed>"
            echo "Seed can be base64, hex, or any string"
          '';
        };

      in {
        # Expose the development shell and the key generation script
        devShells.default = devShell;
        packages.default = deterministicKeyGen;
      }
    );
}
