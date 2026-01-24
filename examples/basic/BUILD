# Example BUILD file showing syft_sbom usage
#
# Usage with rules_img:
#
#   load("@rules_img//img:image.bzl", "image_manifest")
#   load("@syft.bzl//:defs.bzl", "syft_sbom")
#
#   image_manifest(
#       name = "my_image",
#       base = "@distroless_static",
#   )
#
#   syft_sbom(
#       name = "my_sbom",
#       image = ":my_image",
#       format = "spdx-json",  # default
#   )
#
# The image target must provide an "oci_tarball" output group.
