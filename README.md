# Luckfox Bazel 项目介绍

本项目旨在为 [Luckfox (幸狐)](https://www.luckfox.cn/) 开发板提供一套高效的开发框架。

项目采用 [Bazel](https://bazel.build/install?hl=zh-cn) 进行构建管理，集成了 [OpenCV Mobile](https://github.com/nihui/opencv-mobile)、`RKNN` 以及 `RGA` 等核心组件，帮助开发者快速搭建环境并上手开发。

## 1. 环境与构建

本项目基于 Linux 环境开发。推荐使用 **Linux 原生系统**、**虚拟机** 或 **Windows WSL**。

> **注意**：如果在非 Linux 环境下开发，建议使用远程编译模式，详见 [remote-docker-deploy/buildbarn/README.md](remote-docker-deploy/buildbarn/README.md)。

项目已预定义 `.bazelrc` 配置文件，支持跨平台构建：

```bash
# .bazelrc 配置片段
build:linux                --platforms=@cc_toolchains_linux//:linux-x86_64
build:linux-luckfox        --platforms=@cc_toolchains_linux//:linux-armv7l-luckfox

# 额外执行平台配置
build:linux-remote         --host_platform=@cc_toolchains_linux//:linux-x86_64
build:linux-remote         --extra_execution_platforms=@cc_toolchains_linux//:linux-x86_64
```

### 编译示例

只需指定 `--config=linux-luckfox`，即可编译出适用于 Luckfox 的目标产物：

```shell
  luckfox-bazel git:(main) $ bazel build --config=linux-luckfox test/helloworld:helloworld
...
INFO: Analyzed target //test/helloworld:helloworld (111 packages loaded, 3523 targets configured).
Target //test/helloworld:helloworld up-to-date:
  bazel-bin/test/helloworld/helloworld
INFO: Build completed successfully, 6 total actions

# 验证文件格式
  luckfox-bazel git:(main) $ file bazel-bin/test/helloworld/helloworld
bazel-bin/test/helloworld/helloworld: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV)...
```

## 2. 第三方依赖管理

为了简化开发流程，项目已将 `librknn`、`librga`、`ncnn` 及 `opencv` 等常用库封装为 Bazel 依赖：

```text
third-party
├── librga
├── librknn
├── ncnn
└── zxing-cpp
```

### 接入方式

在 `BUILD.bazel` 中，只需将依赖添加到 `deps` 字段即可。

**示例：集成 RKNN**
*[test/yolov5/BUILD.bazel](test/yolov5/BUILD.bazel)*

```bazel
cc_library(
    name = "yolov5s",
    srcs = ["src/postprocess.cpp"],
    hdrs = ["include/postprocess.h"],
    defines = ["RV1106_RV1103"],
    deps = [
        ":yolov5s_640_640_rknn_bin",
        "//third-party/librknn",  # 引入 RKNN 依赖
    ],
)
```

**示例：集成 RGA 与 OpenCV**
*[third-party/librga/BUILD.bazel](third-party/librga/BUILD.bazel)*

```bazel
cc_binary(
    name = "test_rga",
    srcs = ["test/test.cc"],
    deps = [
        ":librga",
        "//third-party/librknn",
        "@opencv-mobile-luckfox//:opencv", # 引入 OpenCV 依赖
    ],
)
```

## 3. 实战案例：YOLOv5 推理

本节以 YOLOv5 为例，演示如何从源码编译到板端运行。

### 目录结构

```text
test/yolov5
├── include          # 头文件
├── model            # 模型与标签 (rknn, txt)
├── src              # 后处理逻辑
└── test             # 主程序入口
```

### 编译与构建

直接通过 Bazel 构建目标：

```shell
  luckfox-bazel git:(main) $ bazel build --config=linux-luckfox test/yolov5:test-yolov5s  
...
INFO: Analyzed target //test/yolov5:test-yolov5s (40 packages loaded, 5542 targets configured).
INFO: From Generating C/C++ resources: yolov5s-640-640.rknn -> model_yolov5s-640-640...
Target //test/yolov5:test-yolov5s up-to-date:
  bazel-bin/test/yolov5/test-yolov5s
INFO: Build completed successfully, 18 total actions
```

### 板端运行结果

将生成的 `test-yolov5s` 可执行文件传输至 Luckfox 开发板并执行：

```shell
[root@luckfox tmp]# ./test-yolov5s bus.jpg
rknn_api/rknnrt version: 2.3.2 ...
model input num: 1, output num: 3
...
Begin perf ...
   0: Elapse Time = 100.09ms, FPS = 9.99
model is NHWC input fmt
 post_process Time = 10.06ms, FPS = 99.38
person @ (208 244 286 506) 0.884136
person @ (479 238 560 526) 0.863766
bus @ (94 130 553 464) 0.697389
```

从日志可以看出，模型成功加载并准确识别了图像中的目标，性能表现符合预期。

## 参考资料

*   **Bazel 远程执行**：[Remote Execution Overview](https://bazel.build/remote/rbe), [Remote Services](https://bazel.build/community/remote-execution-services?hl=zh-cn)
*   **Bazel 交叉编译**：[Cross Compiling with Bazel](https://ltekieli.com/cross-compiling-with-bazel/)
*   **OpenCV Mobile**：[知乎专栏介绍](https://zhuanlan.zhihu.com/p/670191385)


# Introduction to Luckfox Bazel Project

This project aims to provide an efficient development framework for the [Luckfox](https://www.luckfox.cn/) development board.

It utilizes [Bazel](https://bazel.build/install?hl=en) for build management and integrates core components such as [OpenCV Mobile](https://github.com/nihui/opencv-mobile), `RKNN`, and `RGA`, allowing developers to quickly set up their environment and get started.

## 1. Environment & Build

This project is designed for a Linux environment. **Native Linux**, **Virtual Machines (VMs)**, or **Windows WSL** are recommended.

> **Note:** If developing in a non-Linux environment, it is recommended to use the remote build mode. Please refer to [remote-docker-deploy/buildbarn/README.md](remote-docker-deploy/buildbarn/README.md) for details.

The project comes with a pre-configured `.bazelrc` supporting cross-platform builds:

```bash
# .bazelrc snippet
build:linux                --platforms=@cc_toolchains_linux//:linux-x86_64
build:linux-luckfox        --platforms=@cc_toolchains_linux//:linux-armv7l-luckfox

# Extra execution platforms
build:linux-remote         --host_platform=@cc_toolchains_linux//:linux-x86_64
build:linux-remote         --extra_execution_platforms=@cc_toolchains_linux//:linux-x86_64
```

### Build Example

Simply specify the `--config=linux-luckfox` flag to compile the target artifacts for Luckfox:

```shell
  luckfox-bazel git:(main) $ bazel build --config=linux-luckfox test/helloworld:helloworld
...
INFO: Analyzed target //test/helloworld:helloworld (111 packages loaded, 3523 targets configured).
Target //test/helloworld:helloworld up-to-date:
  bazel-bin/test/helloworld/helloworld
INFO: Build completed successfully, 6 total actions

# Verify file format
  luckfox-bazel git:(main) $ file bazel-bin/test/helloworld/helloworld
bazel-bin/test/helloworld/helloworld: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV)...
```

## 2. Third-party Dependencies

To simplify the development workflow, common libraries such as `librknn`, `librga`, `ncnn`, and `opencv` have been encapsulated as Bazel dependencies:

```text
third-party
├── librga
├── librknn
├── ncnn
└── zxing-cpp
```

### Integration

In `BUILD.bazel`, simply add the libraries to the `deps` field.

**Example: RKNN Integration**
*[test/yolov5/BUILD.bazel](test/yolov5/BUILD.bazel)*

```bazel
cc_library(
    name = "yolov5s",
    srcs = ["src/postprocess.cpp"],
    hdrs = ["include/postprocess.h"],
    defines = ["RV1106_RV1103"],
    deps = [
        ":yolov5s_640_640_rknn_bin",
        "//third-party/librknn",  # Import RKNN dependency
    ],
)
```

**Example: RGA & OpenCV Integration**
*[third-party/librga/BUILD.bazel](third-party/librga/BUILD.bazel)*

```bazel
cc_binary(
    name = "test_rga",
    srcs = ["test/test.cc"],
    deps = [
        ":librga",
        "//third-party/librknn",
        "@opencv-mobile-luckfox//:opencv", # Import OpenCV dependency
    ],
)
```

## 3. Practical Case: YOLOv5 Inference

This section demonstrates how to compile from source and run on the board using YOLOv5 as an example.

### Directory Structure

```text
test/yolov5
├── include          # Headers
├── model            # Models & Labels (rknn, txt)
├── src              # Post-processing logic
└── test             # Main entry point
```

### Compilation

Build the target directly using Bazel:

```shell
  luckfox-bazel git:(main) $ bazel build --config=linux-luckfox test/yolov5:test-yolov5s  
...
INFO: Analyzed target //test/yolov5:test-yolov5s (40 packages loaded, 5542 targets configured).
INFO: From Generating C/C++ resources: yolov5s-640-640.rknn -> model_yolov5s-640-640...
Target //test/yolov5:test-yolov5s up-to-date:
  bazel-bin/test/yolov5/test-yolov5s
INFO: Build completed successfully, 18 total actions
```

### Running on Board

Transfer the generated `test-yolov5s` executable to the Luckfox board and execute it:

```shell
[root@luckfox tmp]# ./test-yolov5s bus.jpg
rknn_api/rknnrt version: 2.3.2 ...
model input num: 1, output num: 3
...
Begin perf ...
   0: Elapse Time = 100.09ms, FPS = 9.99
model is NHWC input fmt
 post_process Time = 10.06ms, FPS = 99.38
person @ (208 244 286 506) 0.884136
person @ (479 238 560 526) 0.863766
bus @ (94 130 553 464) 0.697389
```

As seen in the logs, the model loads successfully and accurately identifies objects in the image, with performance meeting expectations.

## References

*   **Bazel Remote Execution**: [Remote Execution Overview](https://bazel.build/remote/rbe), [Remote Services](https://bazel.build/community/remote-execution-services)
*   **Bazel Cross-compiling**: [Cross Compiling with Bazel](https://ltekieli.com/cross-compiling-with-bazel/)
*   **OpenCV Mobile**: [Zhihu Article](https://zhuanlan.zhihu.com/p/670191385)