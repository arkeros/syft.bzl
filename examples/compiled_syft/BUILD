# Example BUILD file demonstrating syft_sbom usage with a compiled syft toolchain
#
# This example compiles syft from Go source and registers it as a toolchain.
# This is useful when you need:
# - Hermetic builds with syft compiled from source
# - Custom syft patches or modifications
# - Integration with existing Go dependency management

load("@rules_img//img:image.bzl", "image_manifest")
load("@syft.bzl", "syft_sbom", "syft_toolchain")

# Define a syft toolchain using the compiled binary
syft_toolchain(
    name = "compiled_syft_toolchain",
    syft = "@com_github_anchore_syft//cmd/syft",
    visibility = ["//visibility:public"],
)

# Register the toolchain (referenced in MODULE.bazel)
toolchain(
    name = "syft_toolchain",
    toolchain = ":compiled_syft_toolchain",
    toolchain_type = "@syft.bzl//syft:toolchain",
)

# Create a simple image based on Alpine Linux
image_manifest(
    name = "example_image",
    base = select({
        "@platforms//cpu:arm64": "@alpine_linux_arm64",
        "@platforms//cpu:x86_64": "@alpine_linux_amd64",
    }),
)

# Generate SBOM using the registered toolchain (no explicit syft attribute needed)
syft_sbom(
    name = "sbom",
    image = ":example_image",
)

# Generate SBOM in CycloneDX format
syft_sbom(
    name = "sbom_cyclonedx",
    format = "cyclonedx-json",
    image = ":example_image",
)
