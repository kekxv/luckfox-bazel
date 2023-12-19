//
// Created by caesar kekxv on 2023/12/10.
//

#include "opencv2/opencv.hpp"
#include <thread>
#include <iostream>

int main(int argc, const char *argv[]) {
  cv::VideoCapture cap;
  std::string out_image = argv[1];
  cap.set(cv::CAP_PROP_FRAME_WIDTH, 640);
  cap.set(cv::CAP_PROP_FRAME_HEIGHT, 480);
  int wait_times = 5;
  cap.open(0);
  if (!cap.isOpened()) {
    std::cerr << "cap isOpened():" << "false";
    return 1;
  }
  // 获取当前时间
  auto start = std::chrono::high_resolution_clock::now();

  std::cout << "waiting cap init.";
  for (int i = 0; i < wait_times; i++) {
    cv::Mat tmp;
    cap >> tmp;
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
  }
  {
    // 获取结束时间
    auto end = std::chrono::high_resolution_clock::now();
    // 计算运行时间
    auto duration = end - start;
    // 输出运行时间
    std::cout << "cap init success: "
              << std::chrono::duration_cast<std::chrono::milliseconds>(duration).count()
              << " ms";
  }

  cv::Mat out;
  cap >> out;
  cap.release();
  cv::imwrite(out_image, out);
  std::cout << "write image : " << out_image;
  return 0;
}