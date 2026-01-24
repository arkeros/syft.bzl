# syft.bzl rules_oci Example

This example demonstrates how to generate SBOMs for container images built with [rules_oci](https://github.com/bazel-contrib/rules_oci).

## Requirements

This example uses Bazel 8.x (see `.bazelversion`). rules_oci 2.2.7 is not yet compatible with Bazel 9.

## Usage

Build the SBOM in SPDX JSON format (default):

```bash
bazel build //:sbom
```

Build the SBOM in CycloneDX format:

```bash
bazel build //:cyclonedx
```

View the generated SBOM:

```bash
cat bazel-bin/sbom.spdx.json | jq '.packages[].name'
```

## How it works

1. **Pull a base image** using `rules_oci`'s `oci.pull` extension
2. **Create an image** using `oci_image`
3. **Create a tarball** using `oci_load` (required for syft to scan)
4. **Generate SBOM** using `syft_sbom` which scans the tarball

## Key difference from rules_img

With `rules_oci`, you need an intermediate `oci_load` step to create a tarball that syft can scan. The `syft_sbom` rule accepts targets with a `tarball` output group (from `oci_load`).

```starlark
# rules_oci requires oci_load to create a tarball
oci_load(
    name = "my_image.tar",
    image = ":my_image",
    repo_tags = ["my-image:latest"],
)

syft_sbom(
    name = "my_sbom",
    image = ":my_image.tar",
)
```

## Platform configuration

Container images are Linux-based. By default, the build uses your host platform. For cross-compilation, you can specify a platform:

```bash
# For arm64
bazel build //:sbom --platforms=@oci_crane_linux_arm64//:platform

# For amd64
bazel build //:sbom --platforms=@oci_crane_linux_amd64//:platform
```

## Supported SBOM formats

- `spdx-json` (default)
- `spdx-tag-value`
- `cyclonedx-json`
- `cyclonedx-xml`
- `syft-json`
- `github-json`
