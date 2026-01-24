# syft.bzl

Bazel rules for generating Software Bills of Materials (SBOMs) using [Syft](https://github.com/anchore/syft).

## Setup

Add the following to your `MODULE.bazel`:

```starlark
bazel_dep(name = "syft.bzl", version = "0.1.0")

syft = use_extension("@syft.bzl//:extensions.bzl", "syft")
syft.toolchain(version = "1.40.1")  # Optional: uses latest if omitted
use_repo(syft, "syft_toolchains")

register_toolchains("@syft_toolchains//:all")
```

## Usage

### Basic Example

```starlark
load("@syft.bzl//:defs.bzl", "syft_sbom")

syft_sbom(
    name = "my_sbom",
    image = ":my_oci_image",  # Must have oci_tarball output group
)
```

### Custom Format

```starlark
syft_sbom(
    name = "my_sbom",
    image = ":my_oci_image",
    format = "cyclonedx-json",  # or spdx-json, syft-json, etc.
)
```

### Supported Formats

- `spdx-json` (default) - SPDX 2.3 JSON
- `spdx-tag-value` - SPDX 2.3 tag-value
- `cyclonedx-json` - CycloneDX 1.5 JSON
- `cyclonedx-xml` - CycloneDX 1.5 XML
- `syft-json` - Syft's native JSON format
- `github-json` - GitHub's dependency submission format

### Custom Syft Binary

If you prefer to use your own syft binary (e.g., from `go_deps`):

```starlark
syft_sbom(
    name = "my_sbom",
    image = ":my_oci_image",
    syft = "@com_github_anchore_syft//cmd/syft",
)
```

## Requirements

The `image` target must expose an `oci_tarball` output group. This is compatible with:

- [rules_img](https://github.com/bazel-contrib/rules_img) `image_manifest` targets
- Any rule that provides `OutputGroupInfo` with an `oci_tarball` field

## Building

```bash
bazel build //:my_sbom
```

The output file will be named `<name>.<format-extension>` (e.g., `my_sbom.spdx.json`).

## License

Apache-2.0
