"Re-export for syntax sugar load."

load("//syft:defs.bzl", _SUPPORTED_FORMATS = "SUPPORTED_FORMATS", _syft_sbom = "syft_sbom")
load("//syft/toolchain:toolchain.bzl", _syft_toolchain = "syft_toolchain")

syft_sbom = _syft_sbom
syft_toolchain = _syft_toolchain
SUPPORTED_FORMATS = _SUPPORTED_FORMATS
