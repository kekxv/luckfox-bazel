#include <iostream>
#include <vector>
#include <chrono>
#include <cstring>
#include <opencv2/opencv.hpp>
#include "im2d.h"
#include "rga.h"
#include "rknn_api.h"

// 计时宏
#define TICK(x) auto x = std::chrono::high_resolution_clock::now()
#define TOCK(x) std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::high_resolution_clock::now() - x).count() / 1000.0f

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cerr << "Usage: " << argv[0] << " <rknn_model_path> <image_path>" << std::endl;
        std::cerr << "Note: The model is only used to init NPU memory allocator." << std::endl;
        return -1;
    }

    const char* model_path = argv[1];
    const char* img_path = argv[2];

    // 1. 读取图片
    cv::Mat img = cv::imread(img_path);
    if (img.empty()) {
        std::cerr << "Failed to load image: " << img_path << std::endl;
        return -1;
    }

    int src_w = img.cols;
    int src_h = img.rows;
    int src_size = src_w * src_h * 3;

    int dst_w = 640;
    int dst_h = 640;
    int dst_size = dst_w * dst_h * 3;

    std::cout << "Source: " << src_w << "x" << src_h << " (BGR)" << std::endl;
    std::cout << "Target: " << dst_w << "x" << dst_h << " (RGB)" << std::endl;

    // 2. 初始化 RKNN Context (关键步骤！)
    // 为了分配 DMA 内存，必须先初始化 RKNN。
    // 这里我们加载你现有的 RetinaFace 模型即可，虽然我们在这个测试里不跑推理。
    rknn_context ctx = 0;
    int ret = rknn_init(&ctx, (void*)model_path, 0, 0, NULL);
    if (ret < 0) {
        std::cerr << "[Error] rknn_init failed! ret=" << ret << std::endl;
        return -1;
    }
    std::cout << "[Info] RKNN Context initialized (for DMA alloc)." << std::endl;

    // 3. 分配 DMA 内存
    rknn_tensor_mem* src_dma_mem = rknn_create_mem(ctx, src_size);
    if (!src_dma_mem) {
        std::cerr << "[Error] Failed to alloc src DMA memory." << std::endl;
        return -1;
    }

    rknn_tensor_mem* dst_dma_mem = rknn_create_mem(ctx, dst_size);
    if (!dst_dma_mem) {
        std::cerr << "[Error] Failed to alloc dst DMA memory." << std::endl;
        return -1;
    }

    std::cout << "[Info] DMA Memory Allocated. Src FD: " << src_dma_mem->fd
              << ", Dst FD: " << dst_dma_mem->fd << std::endl;

    // -----------------------------------------------------------
    // 4. 正确性验证
    // -----------------------------------------------------------
    std::cout << "\n[Verification] Running RGA process..." << std::endl;

    // Step A: memcpy (Virtual -> DMA)
    memcpy(src_dma_mem->virt_addr, img.data, src_size);

    // Step B: 配置 RGA (使用 FD)
    rga_buffer_t rga_src = wrapbuffer_fd(src_dma_mem->fd, src_w, src_h, RK_FORMAT_BGR_888);
    rga_buffer_t rga_dst = wrapbuffer_fd(dst_dma_mem->fd, dst_w, dst_h, RK_FORMAT_RGB_888);

    // Step C: 硬件执行
    IM_STATUS status = imresize(rga_src, rga_dst);
    if (status != IM_STATUS_SUCCESS) {
        std::cerr << "RGA Error: " << status << std::endl;
        return -1;
    }

    // Step D: 保存结果
    cv::Mat result_img(dst_h, dst_w, CV_8UC3, dst_dma_mem->virt_addr);
    cv::Mat save_img;
    cv::cvtColor(result_img, save_img, cv::COLOR_RGB2BGR);
    cv::imwrite("rga_dma_output.jpg", save_img);
    std::cout << "Saved rga_dma_output.jpg" << std::endl;

    // -----------------------------------------------------------
    // 5. 性能压测
    // -----------------------------------------------------------
    int loops = 100;
    std::cout << "\n[Benchmark] Running " << loops << " loops..." << std::endl;

    // CPU 测试
    TICK(t_cpu);
    for (int i = 0; i < loops; i++) {
        cv::Mat tmp;
        cv::resize(img, tmp, cv::Size(dst_w, dst_h));
        cv::cvtColor(tmp, tmp, cv::COLOR_BGR2RGB);
    }
    float time_cpu = TOCK(t_cpu) / loops;
    std::cout << "CPU (Resize+Cvt): " << time_cpu << " ms" << std::endl;

    // RGA + DMA 测试 (包含 memcpy)
    TICK(t_rga);
    for (int i = 0; i < loops; i++) {
        // 模拟真实每帧数据更新
        memcpy(src_dma_mem->virt_addr, img.data, src_size);

        rga_buffer_t s = wrapbuffer_fd(src_dma_mem->fd, src_w, src_h, RK_FORMAT_BGR_888);
        rga_buffer_t d = wrapbuffer_fd(dst_dma_mem->fd, dst_w, dst_h, RK_FORMAT_RGB_888);
        imresize(s, d);
    }
    float time_rga = TOCK(t_rga) / loops;
    std::cout << "RGA (Copy+Resize): " << time_rga << " ms" << std::endl;

    std::cout << "--------------------------------------" << std::endl;
    std::cout << "Speedup: " << time_cpu / time_rga << "x" << std::endl;

    // 清理
    rknn_destroy_mem(ctx, src_dma_mem);
    rknn_destroy_mem(ctx, dst_dma_mem);
    rknn_destroy(ctx);

    return 0;
}