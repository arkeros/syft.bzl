# Aspect Example

Auto-generate SBOMs for all OCI image targets without per-target `syft_sbom` rules.

## How it works

The `.bazelrc` attaches `syft_sbom_aspect` to all targets:

```
build --aspects=@syft.bzl//syft:defs.bzl%syft_sbom_aspect
```

The aspect no-ops on non-image targets. For image targets (those with `oci_tarball` or `tarball` output groups), it generates an SBOM in `spdx-json` format.

## Usage

```bash
# Generate SBOM for any image target
bazel build :example_image --output_groups=sbom

# Works for all images -- no per-target configuration needed
bazel build :another_image --output_groups=sbom
```
