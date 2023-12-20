#include "ReadBarcode.h"
#include <iostream>

int main(int argc, char** argv)
{
  int width, height;
  unsigned char* data;
  // load your image data from somewhere. ImageFormat::Lum assumes grey scale image data.

  auto image = ZXing::ImageView(data, width, height, ZXing::ImageFormat::Lum);
  auto options = ZXing::ReaderOptions().setFormats(ZXing::BarcodeFormat::Any);
  auto results = ZXing::ReadBarcodes(image, options);

  for (const auto& r : results)
    std::cout << ZXing::ToString(r.format()) << ": " << r.text() << "\n";

  return 0;
}