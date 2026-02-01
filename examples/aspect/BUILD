# Example: syft_sbom_aspect auto-generates SBOMs for OCI image targets.
#
# No syft_sbom() rule needed -- the aspect attaches automatically via .bazelrc.
#
# Usage:
#   bazel build :example_image --output_groups=sbom
#   bazel build :another_image --output_groups=sbom

load("@rules_img//img:image.bzl", "image_manifest")

image_manifest(
    name = "example_image",
    base = select({
        "@platforms//cpu:arm64": "@alpine_linux_arm64",
        "@platforms//cpu:x86_64": "@alpine_linux_amd64",
    }),
)

image_manifest(
    name = "another_image",
    base = select({
        "@platforms//cpu:arm64": "@alpine_linux_arm64",
        "@platforms//cpu:x86_64": "@alpine_linux_amd64",
    }),
)
