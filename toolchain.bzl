"""Syft toolchain definitions."""

SyftInfo = provider(
    doc = "Information about the syft binary",
    fields = {
        "syft_binary": "The syft executable File",
    },
)

def _syft_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            syft_info = SyftInfo(
                syft_binary = ctx.executable.syft,
            ),
        ),
    ]

syft_toolchain = rule(
    implementation = _syft_toolchain_impl,
    attrs = {
        "syft": attr.label(
            mandatory = True,
            executable = True,
            cfg = "exec",
            doc = "The syft executable",
        ),
    },
    doc = "Defines a syft toolchain.",
)
