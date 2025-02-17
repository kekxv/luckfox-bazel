load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "artifact_name_pattern",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]
dynamic_link_actions = [
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]
executable_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.objc_executable,
]

all_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.lto_backend,
]

all_cpp_compile_actions = [
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
]

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = "wrappers/gcc.br_real",
        ),
        tool_path(
            name = "ld",
            path = "wrappers/ld",
        ),
        tool_path(
            name = "cpp",
            path = "wrappers/g++.br_real",
        ),
        tool_path(
            name = "ranlib",
            path = "wrappers/ranlib",
        ),
        tool_path(
            name = "nm",
            path = "wrappers/nm",
        ),
        tool_path(
            name = "objdump",
            path = "wrappers/objdump",
        ),
        tool_path(
            name = "objcopy",
            path = "wrappers/objcopy",
        ),
        tool_path(
            name = "ar",
            path = "wrappers/ar",
        ),
        tool_path(
            name = "strip",
            path = "wrappers/strip",
        ),
    ]

    default_compiler_flags = feature(
        name = "default_compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            # "--sysroot=external/glibc-linux-gnu-x86_64/x86_64-buildroot-linux-gnu/sysroot",
                            # "--sysroot=external/glibc-linux-gnu-x86_64/x86_64-buildroot-linux-gnu/",
                            "-fno-canonical-system-headers",
                            "-no-canonical-prefixes",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                            "-fPIC",
                            #"-fPIE",
                            #"-pie",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_cpp_compile_flags = feature(
        name = "default_cpp_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_cpp_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            # "--sysroot=external/glibc-linux-gnu-x86_64/x86_64-buildroot-linux-gnu/sysroot",
                            # "--sysroot=external/glibc-linux-gnu-x86_64/x86_64-buildroot-linux-gnu/",
                            "-std=c++17",
                            "-fno-canonical-system-headers",
                            "-no-canonical-prefixes",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                            "-fPIC",
                            #"-fPIE",
                            #"-pie",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            #"--sysroot=external/glibc-linux-gnu-x86_64/x86_64-buildroot-linux-gnu/sysroot",
                            "-lstdc++",
                            "-ldl",
                            "-lpthread",
                            #"-static",
                            "-static-libgcc",
                            "-static-libstdc++",
                            #"-fPIC",
                            #"-fPIE",
                            #"-pie",
                            # "-Wl,-Bstatic",
                            "-lm",
                        ],
                    ),
                ]),
            ),
            flag_set(
                actions = executable_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "-static",
                        ],
                    ),
                ]),
            ),
            flag_set(
                actions = dynamic_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "-shared",
                        ],
                    ),
                ]),
            ),
        ],
    )

    features = [
        default_compiler_flags,
        default_cpp_compile_flags,
        default_linker_flags,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        cxx_builtin_include_directories = [
        ],
        toolchain_identifier = "x86_64-linux-toolchain",
        host_system_name = "linux",
        target_system_name = "linux",
        target_cpu = "linux-x86_64",
        target_libc = "unknown",
        compiler = "linux",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
