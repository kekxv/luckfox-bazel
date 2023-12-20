# luckfox 编译环境

当前仓库是为了学习bazel 以及 luckfox 而创立。

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

对于其他系统，可以考虑将 [toolchains.bzl](toolchain%2Ftoolchains.bzl) 里面的编译链修改为对应系统的编译链，其中`windows`还需要修改[wrappers](toolchain%2Ftoolchains%2Fcc-armv7l-luckfox%2Fwrappers)下的脚本
（`windows`比较麻烦，建议直接使用 `wsl`）。

### 远程编译

所有的系统都可以进行远程编译。需要部署`bazel远程服务`，具体可以参考[远程执行概览](https://bazel.build/remote/rbe)，这里为了快速部署使用了 [buildfarm](https://github.com/bazelbuild/bazel-buildfarm)。可以通过[docker-compose.yaml](docker-bazel-buildfarm%2Fdocker-compose.yaml)快速启动。

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

然后就可以在项目里面进行编译：

```shell
# 编译测试项目
bazel build //test/...
# 编译整个项目
bazel build //...
```


# 参考文章

>
> 关于 bazel 远程服务 [远程执行概览](https://bazel.build/remote/rbe) [远程执行服务](https://bazel.build/community/remote-execution-services?hl=zh-cn)
>
> bazel 交叉编译链 参考了 https://ltekieli.com/cross-compiling-with-bazel/
> 
> opencv-mobile 参考 https://zhuanlan.zhihu.com/p/670191385
> 
