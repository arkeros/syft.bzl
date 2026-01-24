# syft.bzl

Bazel rules for generating Software Bills of Materials (SBOMs) using [Syft](https://github.com/anchore/syft).

## Setup

Add the following to your `MODULE.bazel`:

```starlark
bazel_dep(name = "syft.bzl", version = "0.1.0")

syft = use_extension("@syft.bzl//syft:extensions.bzl", "syft")
syft.toolchain(version = "1.40.1")  # Optional: uses latest if omitted
use_repo(syft, "syft_toolchains")

register_toolchains("@syft_toolchains//:all")
```

## Usage

### With rules_img

```starlark
load("@rules_img//img:image.bzl", "image_manifest")
load("@syft.bzl//syft:defs.bzl", "syft_sbom")

image_manifest(
    name = "my_image",
    base = "@alpine",
)

syft_sbom(
    name = "my_sbom",
    image = ":my_image",
)
```

### With rules_oci

```starlark
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_load")
load("@syft.bzl//syft:defs.bzl", "syft_sbom")

oci_image(
    name = "my_image",
    base = "@alpine",
)

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

### Custom Format

```starlark
syft_sbom(
    name = "my_sbom",
    image = ":my_image",
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
    image = ":my_image",
    syft = "@com_github_anchore_syft//cmd/syft",
)
```

## Compatibility

The `image` target must expose a tarball output group:

| OCI Rules | Output Group | Target Type |
|-----------|--------------|-------------|
| [rules_img](https://github.com/bazel-contrib/rules_img) | `oci_tarball` | `image_manifest` |
| [rules_oci](https://github.com/bazel-contrib/rules_oci) | `tarball` | `oci_load` |

## Examples

- [rules_img example](examples/rules_img/) - SBOM generation with rules_img
- [rules_oci example](examples/rules_oci/) - SBOM generation with rules_oci

## Building

```bash
bazel build //:my_sbom
```

The output file will be named `<name>.<format-extension>` (e.g., `my_sbom.spdx.json`).

## License

Apache-2.0
