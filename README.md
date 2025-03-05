# Deterministic SSH ED25519 Key Generation

## Overview

This project provides a script to generate deterministic ED25519 SSH key pairs from a flexible seed input.

## Features

- Generate SSH key pairs from various seed inputs:
  - Base64 encoded strings
  - Hex encoded strings
  - Raw text strings
- Writes keys directly to `id_ed25519` and `id_ed25519.pub`
- Flexible seed parsing with consistent key generation

## Usage

### With Nix

```bash
# Build the package
nix build

# Generate keys with various seed types
./result/bin/deterministic-ssh-keygen "my secret passphrase"
./result/bin/deterministic-ssh-keygen 0123456789abcdef0123456789abcdef
./result/bin/deterministic-ssh-keygen $(openssl rand -base64 32)
```

### In Development Shell

```bash
# Enter development shell
nix develop

# Generate keys
deterministic-ssh-keygen "my secret passphrase"
```

## Seed Generation

The script supports multiple seed input methods:
- Any string (will be hashed to 32 bytes)
- Base64 encoded 32-byte seed
- Hex encoded 32-byte seed

## Notes

- Always keep your seed secret
- The same seed will always generate the same key pair
- Seed is processed to ensure consistent 32-byte length

## Dependencies

- Nix
- Python 3
- cryptography library
