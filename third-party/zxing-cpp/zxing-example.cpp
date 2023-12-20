//
// Created by caesar kekxv on 2022/5/6.
//
#include <opencv2/opencv.hpp>
#include<iostream>
#include<thread>

#include "ReadBarcode.h"
#include "TextUtfEncoding.h"

using namespace std;
using namespace cv;

void display(Mat &im, Mat &bbox) {
    int n = bbox.rows;
    for (int i = 0; i < n; i++) {
        line(im, Point2i(bbox.at<float>(i, 0), bbox.at<float>(i, 1)),
             Point2i(bbox.at<float>((i + 1) % n, 0), bbox.at<float>((i + 1) % n, 1)), Scalar(255, 0, 0), 3);
    }
    imshow("Result", im);
}

inline ZXing::ImageView ImageViewFromMat(const cv::Mat &image) {
    using ZXing::ImageFormat;

    auto fmt = ImageFormat::None;
    switch (image.channels()) {
        case 1:
            fmt = ImageFormat::Lum;
            break;
        case 3:
            fmt = ImageFormat::BGR;
            break;
        case 4:
            fmt = ImageFormat::BGRX;
            break;
    }

    if (image.depth() != CV_8U || fmt == ImageFormat::None)
        return {nullptr, 0, 0, ImageFormat::None};

    return {image.data, image.cols, image.rows, fmt};
}

inline ZXing::Result ReadBarcode(const cv::Mat &image, const ZXing::DecodeHints &hints = {}) {
    return ZXing::ReadBarcode(ImageViewFromMat(image), hints);
}

inline void DrawResult(cv::Mat &img, ZXing::Result res) {
    auto pos = res.position();
    auto zx2cv = [](ZXing::PointI p) { return cv::Point(p.x, p.y); };
    auto contour = std::vector<cv::Point>{zx2cv(pos[0]), zx2cv(pos[1]), zx2cv(pos[2]), zx2cv(pos[3])};
    const auto *pts = contour.data();
    int npts = contour.size();

    cv::polylines(img, &pts, &npts, 1, true, CV_RGB(0, 255, 0));
    cv::putText(img, ZXing::TextUtfEncoding::ToUtf8(res.text()), cv::Point(10, 20), cv::FONT_HERSHEY_DUPLEX, 0.5,
                CV_RGB(0, 255, 0));
}

int main(int argc, char *argv[]) {

    cout << "OpenCV version : " << CV_VERSION << endl;

    // Read image
    Mat inputImage;
    if (argc == 1) {
        return 0;
    }
    inputImage = imread(argv[1]);
    if (inputImage.empty()) {
        cout << "read image error : " << argv[1] << endl;
        return -1;
    }
    QRCodeDetector qrDecoder;
    Mat bbox, rectifiedImage;

    std::string data = qrDecoder.detectAndDecode(inputImage, bbox, rectifiedImage);
    if (data.length() > 0) {
        cout << "OpenCV Decoded Data : " << data << endl;
    } else {
        cout << "OpenCV QR Code not detected" << endl;
        ZXing::Result result = ReadBarcode(inputImage);
        if (ZXing::DecodeStatus::NoError == result.status()) {
            cout << "ZXing Decoded Data : " << ZXing::TextUtfEncoding::ToUtf8(result.text()) << endl;
        } else {
            cout << "ZXing not detected : " << ToString(result.status()) << endl;
        }
    }
    return 0;
}