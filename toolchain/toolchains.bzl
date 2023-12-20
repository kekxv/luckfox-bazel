load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def toolchains():
    if "cc-armv7l-luckfox" not in native.existing_rules():
        http_archive(
            name = "cc-armv7l-luckfox",
            build_file = Label("//toolchain/toolchains:cc-armv7l-luckfox.bzl"),
            type = "tar.gz",
            url = "https://github.com/kekxv/luckfox-bazel/releases/download/linux-rockchip830-uclibcgnu-toolchain/arm-rockchip830-linux-uclibcgnueabihf.tar.gz",
            sha256 = "f6af1030a746b4ac6bf3270a46d79f62a212a9dcc7e661b4a152ce4767f80ee2",
        )

def register_all_toolchains():
    native.register_toolchains(
        "//toolchain/toolchains/cc-armv7l-luckfox:armv7l_luckfox_linux_toolchain",
    )
    # native.register_execution_platforms(
    #     "//toolchain/platforms:luckfox",
    # )
