中文 
[English](#luckfox-compilation-environment) 

# luckfox 编译环境

当前仓库是为了学习bazel 以及 luckfox 而创立。

> 注意：由于MODULE模式暂不支持参数，需要目前还需要定义一个 宿主机 的工具链才能工作。当前定义为 Linux amd64 作为宿主机的工具链。

## 使用方式

### Linux 系统

目前只测试过`ubuntu`，理论上包括`wsl`在内都可以使用。

```shell
# 编译测试项目
bazel build //test/...
# 编译整个项目
bazel build //...
```

### windows or macos 系统

对于其他系统，可以考虑将 [toolchains.bzl](toolchain%2Ftoolchains.bzl) 里面的编译链修改为对应系统的编译链，其中`windows`
还需要修改[wrappers](toolchain%2Ftoolchains%2Fcc-armv7l-luckfox%2Fwrappers)下的脚本
（`windows`比较麻烦，建议直接使用 `wsl`）。

### 远程编译

所有的系统都可以进行远程编译。需要部署`bazel远程服务`，具体可以参考[远程执行概览](https://bazel.build/remote/rbe)
，这里为了快速部署使用了 [buildfarm](https://github.com/bazelbuild/bazel-buildfarm)
。可以通过[docker-compose.yaml](docker-bazel-buildfarm%2Fdocker-compose.yaml)快速启动。

启动成功之后，记录IP地址，例如：192.168.1.100；或者127.0.0.1。然后修改文件 [.bazelrc](.bazelrc)

更改为：

```git
- build:remote            --remote_executor=grpc://IP地址或者域名:8980
- build:remote            --remote_cache=grpc://IP地址或者域名:8980
+ build:remote            --remote_executor=grpc://192.168.1.100:8980
+ build:remote            --remote_cache=grpc://192.168.1.100:8980

- # build                   --config=remote
+ build                   --config=remote
```

> 注意：
> 如果远程编译没有工具链，则需要将[toolchains.MODULE.bazel](toolchains/toolchains.MODULE.bazel)的22取消注释

然后就可以在项目里面进行编译：

```shell
# 编译测试项目
bazel build //test/...
# 编译整个项目
bazel build //...
```

# 参考文章

>
> 关于 bazel
> 远程服务 [远程执行概览](https://bazel.build/remote/rbe) [远程执行服务](https://bazel.build/community/remote-execution-services?hl=zh-cn)
>
> bazel 交叉编译链 参考了 https://ltekieli.com/cross-compiling-with-bazel/
>
> opencv-mobile 参考 https://zhuanlan.zhihu.com/p/670191385
>



# luckfox Compilation Environment

The current repository is established for learning Bazel and Luckfox.

> Note: Since the MODULE mode currently does not support parameters, a toolchain for the host machine needs to be defined for it to work. It is currently defined for the Linux amd64 as the host toolchain.

## How to Use

### Linux Systems

Currently, it has only been tested on `Ubuntu`, but theoretically, it should work on other distributions including `WSL`.

```shell
# Build the test project
bazel build //test/...
# Build the entire project
bazel build //...
```

### Windows or macOS Systems

For other systems, you may consider modifying the compiler toolchain in [toolchains.bzl](toolchain%2Ftoolchains.bzl) to match the corresponding system. For `Windows`, you also need to modify the scripts under [wrappers](toolchain%2Ftoolchains%2Fcc-armv7l-luckfox%2Fwrappers) (compiling on Windows is more complicated, so it is recommended to use `WSL` directly).

### Remote Compilation

All systems can perform remote compilation. You need to deploy the `Bazel remote service`. For specifics, you can refer to the [Remote Execution Overview](https://bazel.build/remote/rbe). To expedite deployment, [Buildfarm](https://github.com/bazelbuild/bazel-buildfarm) is used. You can quickly start it up using [docker-compose.yaml](docker-bazel-buildfarm%2Fdocker-compose.yaml).

After the successful start, record the IP address, for example: 192.168.1.100 or 127.0.0.1. Then modify the file [.bazelrc](.bazelrc)

Change it to:

```git
- build:remote            --remote_executor=grpc://IP_address_or_domain:8980
- build:remote            --remote_cache=grpc://IP_address_or_domain:8980
+ build:remote            --remote_executor=grpc://192.168.1.100:8980
+ build:remote            --remote_cache=grpc://192.168.1.100:8980

- # build                   --config=remote
+ build                   --config=remote
```

> Note:
> If the remote build does not have a toolchain, you need to uncomment line 22 in [toolchains.MODULE.bazel](toolchains/toolchains.MODULE.bazel).

Then you can proceed to compile in the project:

```shell
# Build the test project
bazel build //test/...
# Build the entire project
bazel build //...
```

# References

>
> About Bazel
> Remote services [Remote Execution Overview](https://bazel.build/remote/rbe) [Remote Execution Services](https://bazel.build/community/remote-execution-services?hl=en)
>
> Bazel Cross-Compilation Chain reference: https://ltekieli.com/cross-compiling-with-bazel/
>
> OpenCV for mobile reference: https://zhuanlan.zhihu.com/p/670191385
>
