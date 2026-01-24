"""Syft version definitions with URLs and checksums."""

DEFAULT_VERSION = "1.40.1"

# Format: "VERSION-PLATFORM": (filename, sha256)
# Platforms: darwin_amd64, darwin_arm64, linux_amd64, linux_arm64, windows_amd64
SYFT_VERSIONS = {
    "1.40.1-darwin_amd64": (
        "syft_1.40.1_darwin_amd64.tar.gz",
        "9e84d1f152ef9d3bb541cc7cedf81ed4c7ed78f6cc2e4c8f0db9e052b64cd7be",
    ),
    "1.40.1-darwin_arm64": (
        "syft_1.40.1_darwin_arm64.tar.gz",
        "c0f6a4fc0563ef1dfe1acf9a4518db66cb37bbb1391889aba3be773dff3487dd",
    ),
    "1.40.1-linux_amd64": (
        "syft_1.40.1_linux_amd64.tar.gz",
        "c229137c919f22aa926c1c015388db5ec64e99c078e0baac053808e8f36e2e00",
    ),
    "1.40.1-linux_arm64": (
        "syft_1.40.1_linux_arm64.tar.gz",
        "13c03a712ad496083d164bdd009c458fda854fb4c8456441fc9c286bbb500e07",
    ),
    "1.40.1-windows_amd64": (
        "syft_1.40.1_windows_amd64.zip",
        "eedac363e277dfecac420b6e4ed0a861bc2c9c84a7544157f52807a99bff07cd",
    ),
}

def get_syft_url(version, filename):
    """Returns the download URL for a syft release."""
    return "https://github.com/anchore/syft/releases/download/v{}/{}".format(version, filename)
