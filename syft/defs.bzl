"""Syft SBOM generation rules."""

SUPPORTED_FORMATS = [
    "spdx-json",
    "spdx-tag-value",
    "cyclonedx-json",
    "cyclonedx-xml",
    "syft-json",
    "github-json",
]

# File extensions for each format
_FORMAT_EXTENSIONS = {
    "spdx-json": "spdx.json",
    "spdx-tag-value": "spdx",
    "cyclonedx-json": "cdx.json",
    "cyclonedx-xml": "cdx.xml",
    "syft-json": "syft.json",
    "github-json": "github.json",
}

def _syft_sbom_impl(ctx):
    """Generate SBOM from OCI image using syft."""

    # Support both rules_img (oci_tarball output group) and rules_oci (tarball output group)
    tarball = None
    if OutputGroupInfo in ctx.attr.image:
        output_group_info = ctx.attr.image[OutputGroupInfo]
        if hasattr(output_group_info, "oci_tarball"):
            # rules_img: uses oci_tarball output group
            tarball = output_group_info.oci_tarball.to_list()[0]
        elif hasattr(output_group_info, "tarball"):
            # rules_oci: uses tarball output group from oci_load
            tarball = output_group_info.tarball.to_list()[0]

    if tarball == None:
        fail("image must be a target with an 'oci_tarball' (rules_img) or 'tarball' (rules_oci) output group")
    output = ctx.outputs.sbom

    # Get syft binary from explicit attr or toolchain
    if ctx.attr.syft:
        syft = ctx.executable.syft
    else:
        toolchain_info = ctx.toolchains["@syft.bzl//syft:toolchain"]
        if not toolchain_info:
            fail("No syft toolchain found. Either set the 'syft' attribute or register the syft toolchain.")
        syft = toolchain_info.syft_info.syft_binary

    format = ctx.attr.format

    ctx.actions.run_shell(
        inputs = [tarball],
        outputs = [output],
        tools = [syft],
        command = """
export SYFT_CHECK_FOR_APP_UPDATE=false
export SYFT_CACHE_DIR=$(mktemp -d)
{syft} "$PWD/{tarball}" -o {format}={output}
""".format(
            tarball = tarball.path,
            output = output.path,
            syft = syft.path,
            format = format,
        ),
        mnemonic = "SyftSBOM",
        progress_message = "Generating SBOM (%s) for %s" % (format, ctx.label),
    )

    return [DefaultInfo(files = depset([output]))]

def _sbom_output(name, format):
    """Generate output filename based on format."""
    ext = _FORMAT_EXTENSIONS.get(format, "json")
    return {
        "sbom": "%s.%s" % (name, ext),
    }

syft_sbom = rule(
    implementation = _syft_sbom_impl,
    attrs = {
        "image": attr.label(
            mandatory = True,
            doc = "OCI image target with an 'oci_tarball' (rules_img) or 'tarball' (rules_oci) output group",
        ),
        "format": attr.string(
            default = "spdx-json",
            values = SUPPORTED_FORMATS,
            doc = "Output format for the SBOM. One of: " + ", ".join(SUPPORTED_FORMATS),
        ),
        "syft": attr.label(
            executable = True,
            cfg = "exec",
            doc = "Optional: custom syft binary. If not set, uses toolchain.",
        ),
    },
    outputs = _sbom_output,
    toolchains = [
        config_common.toolchain_type("@syft.bzl//syft:toolchain", mandatory = False),
    ],
    doc = """Generate SBOM from OCI image using Syft.

This rule generates a Software Bill of Materials (SBOM) from an OCI container image
using [Syft](https://github.com/anchore/syft).

Example:
    ```starlark
    load("@syft.bzl//syft:defs.bzl", "syft_sbom")

    syft_sbom(
        name = "my_sbom",
        image = ":my_oci_image",
        format = "spdx-json",
    )
    ```
""",
)
