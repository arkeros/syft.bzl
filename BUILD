load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

# Prefer generated BUILD files to be called BUILD over BUILD.bazel
# gazelle:build_file_name BUILD,BUILD.bazel
# gazelle:prefix github.com/arkeros/syft.bzl
# gazelle:exclude bazel-syft.bzl

exports_files(
    [
        "BUILD",
        "defs.bzl",
        "extensions.bzl",
        "toolchain.bzl",
        "versions.bzl",
    ],
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "defs",
    srcs = ["defs.bzl"],
    visibility = ["//visibility:public"],
    deps = [":toolchain"],
)

bzl_library(
    name = "extensions",
    srcs = ["extensions.bzl"],
    visibility = ["//visibility:public"],
    deps = [":versions"],
)

# Toolchain type for syft
toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "toolchain",
    srcs = ["toolchain.bzl"],
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "versions",
    srcs = ["versions.bzl"],
    visibility = ["//visibility:public"],
)
