"Re-export for syntax sugar load."

load(
    "//syft:defs.bzl",
    _SUPPORTED_FORMATS = "SUPPORTED_FORMATS",
    _SyftSBOMInfo = "SyftSBOMInfo",
    _syft_sbom = "syft_sbom",
    _syft_sbom_aspect = "syft_sbom_aspect",
)
load("//syft/toolchain:toolchain.bzl", _syft_toolchain = "syft_toolchain")

syft_sbom = _syft_sbom
syft_sbom_aspect = _syft_sbom_aspect
syft_toolchain = _syft_toolchain
SyftSBOMInfo = _SyftSBOMInfo
SUPPORTED_FORMATS = _SUPPORTED_FORMATS
