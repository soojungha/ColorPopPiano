//
//  ImageUtil.m
//  ColorPopPiano
//
//  Created by Soojung Ha on 6/13/18.
//  Copyright © 2018 Soojung Ha. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+ (std::vector<float>)blackProportionsForHLine:(Vec4i)line image:(Mat&)image {
  std::vector<float> res;
  res.push_back(0.0f);
  res.push_back(0.0f);
  return res;
}

+ (std::vector<float>)blackProportionsForVLine:(Vec4i)line image:(Mat&)image {
  int offset = 5;
  std::vector<float> res;
  cv::Point left0 = cv::Point(line[0] - offset, line[1]);
  cv::Point left1 = cv::Point(line[2] - offset, line[3]);
  int whiteCount = 0, blackCount = 0;
  LineIterator it = LineIterator(image, left0, left1);
  for (int i = 0; i < it.count; i++, ++it) {
    uchar val = image.at<uchar>(it.pos());
    if (val < 50) {
      blackCount++;
    }
    else if (val > 200) {
      whiteCount++;
    }
  }
  res.push_back((float) blackCount / (whiteCount + blackCount));

  cv::Point right0 = cv::Point(line[0] + offset, line[1]);
  cv::Point right1 = cv::Point(line[2] + offset, line[3]);
  whiteCount = blackCount = 0;
  it = LineIterator(image, right0, right1);
  for (int i = 0; i < it.count; i++, ++it) {
    uchar val = image.at<uchar>(it.pos());
    if (val < 50) {
      blackCount++;
    }
    else if (val > 200) {
      whiteCount++;
    }
  }
  res.push_back((float) blackCount / (whiteCount + blackCount));
  return res;
}

@end
