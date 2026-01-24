load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

# Prefer generated BUILD files to be called BUILD over BUILD.bazel
# gazelle:build_file_name BUILD,BUILD.bazel
# gazelle:prefix github.com/arkeros/syft.bzl
# gazelle:exclude bazel-syft.bzl

exports_files([
    "BUILD",
    "LICENSE",
    "MODULE.bazel",
])

bzl_library(
    name = "syft",
    srcs = ["syft.bzl"],
    visibility = ["//visibility:public"],
    deps = [
        "//syft:defs",
        "//syft/toolchain",
    ],
)
