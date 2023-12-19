//
// Created by caesar kekxv on 2023/12/10.
//
#include <ncnn/platform.h>
#include <ncnn/net.h>
#include "ncnn/c_api.h"
#include "iostream"

int main(int argc, char *argv[]) {
    std::cout << ncnn_version() << std::endl;
    return 0;
}
