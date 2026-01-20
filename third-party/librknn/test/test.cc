#include <iostream>
#include "rknn_api.h" // 直接引用，Bazel 会处理路径

int main()
{
  printf("Luckfox Face Detect System Starting...\n");

  rknn_context ctx;
  // 只是测试链接，这里没有加载真实模型，init 会返回错误，但说明函数调用成功
  int ret = rknn_init(&ctx, nullptr, 0, 0, nullptr);

  printf("RKNN Init check (expected error if model is null): %d\n", ret);

  return 0;
}
