# Example BUILD file demonstrating syft_sbom usage with rules_img

load("@rules_img//img:image.bzl", "image_manifest")
load("@syft.bzl//syft:defs.bzl", "syft_sbom")

# Create a simple image based on Alpine Linux
# Uses select() to pick the correct platform-specific base image
image_manifest(
    name = "example_image",
    base = select({
        "@platforms//cpu:arm64": "@alpine_linux_arm64",
        "@platforms//cpu:x86_64": "@alpine_linux_amd64",
    }),
)

# Generate SBOM in SPDX JSON format (default)
syft_sbom(
    name = "example_sbom",
    image = ":example_image",
)

# Generate SBOM in CycloneDX format
syft_sbom(
    name = "example_sbom_cyclonedx",
    format = "cyclonedx-json",
    image = ":example_image",
)
