//
// Created by caesar kekxv on 2023/12/10.
//
#include <stdio.h>
#include "opencv2/opencv.hpp"

int main(int argc, const char *argv[]) {
    cv::Mat mat;
    printf("mat empty %s\n", mat.empty() ? "true" : "false");
    printf("Hello, opencv.%s on LuckFox Pico Plus!\n", CV_VERSION);
    return 0;
}