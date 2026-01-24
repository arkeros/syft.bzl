# syft.bzl Compiled Syft Toolchain Example

This example demonstrates how to use a **compiled syft binary** as a toolchain instead of the pre-built binaries. The syft binary is compiled from Go source using `rules_go` and `gazelle`, then registered as a toolchain.

## When to use a compiled syft toolchain

Use this approach when you need:

- **Hermetic builds**: Syft binary compiled from source within Bazel
- **Custom patches**: Apply modifications to syft source code
- **Go monorepo integration**: Consistent dependency management with existing Go code
- **Reproducibility**: Full control over the exact syft version and build

## Usage

Build the SBOM:

```bash
bazel build //:sbom
```

Build the SBOM in CycloneDX format:

```bash
bazel build //:sbom_cyclonedx
```

View the generated SBOM:

```bash
cat bazel-bin/sbom.spdx.json | jq '.packages[].name'
```

## How it works

1. **Go dependencies**: `go.mod` declares syft as a dependency
2. **Gazelle extension**: `go_deps.from_file()` imports Go dependencies
3. **Patch syft**: A patch fixes Bazel BUILD files for embedded resources
4. **Define toolchain**: `syft_toolchain` rule wraps the compiled binary
5. **Register toolchain**: `register_toolchains("//:syft_toolchain")` in MODULE.bazel
6. **Generate SBOM**: `syft_sbom` automatically uses the registered toolchain

## Key difference from pre-built toolchain

Instead of downloading a pre-built binary:

```starlark
# Pre-built approach (downloads binary)
syft = use_extension("@syft.bzl//syft:extensions.bzl", "syft")
syft.toolchain(version = "1.40.1")
use_repo(syft, "syft_toolchains")
register_toolchains("@syft_toolchains//:all")
```

This example compiles from source and registers the toolchain:

```starlark
# In BUILD file - define toolchain with compiled binary
syft_toolchain(
    name = "compiled_syft_toolchain",
    syft = "@com_github_anchore_syft//cmd/syft",
)

toolchain(
    name = "syft_toolchain",
    toolchain = ":compiled_syft_toolchain",
    toolchain_type = "@syft.bzl//syft:toolchain",
)

# In MODULE.bazel - register the toolchain
register_toolchains("//:syft_toolchain")
```

Then `syft_sbom` rules work without any explicit `syft` attribute:

```starlark
syft_sbom(
    name = "sbom",
    image = ":example_image",
    # No syft attribute needed - uses registered toolchain
)
```

## Platform configuration

Container images are Linux-based, so builds require a Linux target platform. The `.bazelrc` sets this by default:

```
build --platforms=@rules_img//img/private/platforms:linux_arm64
```

For x86_64/amd64 builds:

```bash
bazel build //:sbom --platforms=@rules_img//img/private/platforms:linux_amd64
```

## Supported SBOM formats

- `spdx-json` (default)
- `spdx-tag-value`
- `cyclonedx-json`
- `cyclonedx-xml`
- `syft-json`
- `github-json`
