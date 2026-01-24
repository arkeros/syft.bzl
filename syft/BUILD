load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

exports_files([
    "defs.bzl",
    "extensions.bzl",
])

toolchain_type(
    name = "toolchain",
)

bzl_library(
    name = "defs",
    srcs = ["defs.bzl"],
    deps = ["//syft/toolchain"],
)

bzl_library(
    name = "extensions",
    srcs = ["extensions.bzl"],
    deps = [":versions"],
)

bzl_library(
    name = "versions",
    srcs = ["versions.bzl"],
)
