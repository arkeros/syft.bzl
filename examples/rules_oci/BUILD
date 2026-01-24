# Example BUILD file demonstrating syft_sbom usage with rules_oci

load("@rules_oci//oci:defs.bzl", "oci_image", "oci_load")
load("@syft.bzl//syft:defs.bzl", "syft_sbom")

# Create a simple image based on Alpine Linux
# Uses select() to pick the correct platform-specific base image
oci_image(
    name = "example_image",
    base = select({
        "@platforms//cpu:arm64": "@alpine_linux_arm64_v8",
        "@platforms//cpu:x86_64": "@alpine_linux_amd64",
    }),
)

# Create a loadable tarball from the OCI image
# This is required for syft to scan the image
oci_load(
    name = "example.tar",
    image = ":example_image",
    repo_tags = ["example:latest"],
)

# Generate SBOM in SPDX JSON format (default)
syft_sbom(
    name = "sbom",
    image = ":example.tar",
)

# Generate SBOM in CycloneDX format
syft_sbom(
    name = "cyclonedx",
    format = "cyclonedx-json",
    image = ":example.tar",
)
