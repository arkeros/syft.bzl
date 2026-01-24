# syft.bzl rules_img Example

This example demonstrates how to generate SBOMs for container images built with [rules_img](https://github.com/bazel-contrib/rules_img).

## Usage

Build the SBOM in SPDX JSON format (default):

```bash
bazel build //:example_sbom
```

Build the SBOM in CycloneDX format:

```bash
bazel build //:example_sbom_cyclonedx
```

View the generated SBOM:

```bash
cat bazel-bin/example_sbom.spdx.json | jq '.packages[].name'
```

## How it works

1. **Pull a base image** using `rules_img`'s `pull` repository rule
2. **Create an image** using `image_manifest`
3. **Generate SBOM** using `syft_sbom` which scans the OCI tarball

## Platform configuration

Container images are Linux-based, so builds require a Linux target platform. The `.bazelrc` sets this by default:

```
build --platforms=@rules_img//img/private/platforms:linux_arm64
```

For x86_64/amd64 builds:

```bash
bazel build //:example_sbom --platforms=@rules_img//img/private/platforms:linux_amd64
```

## Supported SBOM formats

- `spdx-json` (default)
- `spdx-tag-value`
- `cyclonedx-json`
- `cyclonedx-xml`
- `syft-json`
- `github-json`
