"""Module extension for syft toolchains."""

load(":versions.bzl", "DEFAULT_VERSION", "SYFT_VERSIONS", "get_syft_url")

_PLATFORM_CONSTRAINTS = {
    "darwin_amd64": ["@platforms//os:macos", "@platforms//cpu:x86_64"],
    "darwin_arm64": ["@platforms//os:macos", "@platforms//cpu:arm64"],
    "linux_amd64": ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    "linux_arm64": ["@platforms//os:linux", "@platforms//cpu:arm64"],
    "windows_amd64": ["@platforms//os:windows", "@platforms//cpu:x86_64"],
}

def _detect_platform(rctx):
    """Detects the current platform."""
    os = rctx.os.name.lower()
    arch = rctx.os.arch

    if "mac" in os or "darwin" in os:
        platform_os = "darwin"
    elif "linux" in os:
        platform_os = "linux"
    elif "windows" in os:
        platform_os = "windows"
    else:
        fail("Unsupported OS: " + os)

    if arch in ("aarch64", "arm64"):
        platform_arch = "arm64"
    elif arch in ("x86_64", "amd64"):
        platform_arch = "amd64"
    else:
        fail("Unsupported arch: " + arch)

    return platform_os + "_" + platform_arch

def _syft_repo_impl(rctx):
    version = rctx.attr.version
    platform = _detect_platform(rctx)
    key = version + "-" + platform

    if key not in SYFT_VERSIONS:
        fail("Syft {} not available for {}. Available: {}".format(
            version,
            platform,
            [k for k in SYFT_VERSIONS.keys() if k.startswith(version)],
        ))

    filename, sha256 = SYFT_VERSIONS[key]
    url = get_syft_url(version, filename)

    rctx.download_and_extract(
        url = url,
        sha256 = sha256,
    )

    constraints = _PLATFORM_CONSTRAINTS[platform]

    # Determine executable name (syft.exe on Windows, syft otherwise)
    exe_name = "syft.exe" if "windows" in platform else "syft"

    rctx.file("BUILD.bazel", """
load("@rules_shell//shell:sh_binary.bzl", "sh_binary")
load("@syft.bzl//:toolchain.bzl", "syft_toolchain")

# Wrap the binary as a sh_binary so it can be used as an executable
sh_binary(
    name = "syft_bin",
    srcs = ["{exe_name}"],
    visibility = ["//visibility:public"],
)

syft_toolchain(
    name = "toolchain",
    syft = ":syft_bin",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "syft_toolchain",
    toolchain = ":toolchain",
    toolchain_type = "@syft.bzl//:toolchain_type",
    exec_compatible_with = {constraints},
)
""".format(constraints = constraints, exe_name = exe_name))

_syft_repo = repository_rule(
    implementation = _syft_repo_impl,
    attrs = {
        "version": attr.string(mandatory = True),
    },
)

def _syft_extension_impl(mctx):
    version = DEFAULT_VERSION
    for mod in mctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.version:
                version = toolchain.version

    _syft_repo(name = "syft_toolchains", version = version)

syft = module_extension(
    implementation = _syft_extension_impl,
    tag_classes = {
        "toolchain": tag_class(attrs = {
            "version": attr.string(
                doc = "Syft version to use. Defaults to " + DEFAULT_VERSION,
            ),
        }),
    },
)
