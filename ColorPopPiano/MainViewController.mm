//
//  ViewController.m
//  ColorPopPiano
//
//  Created by Soojung Ha on 6/11/18.
//  Copyright © 2018 Soojung Ha. All rights reserved.
//

#import "MainViewController.h"
#import "ImageUtil.h"

@interface MainViewController () <CvVideoCameraDelegate>
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
  self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
  self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
  self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
  self.videoCamera.defaultFPS = 30;
  self.videoCamera.grayscaleMode = NO;
  self.videoCamera.delegate = self;

  [self.videoCamera start];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
  [self piano:image];
}

- (void)piano:(Mat&)image
{
  Mat dst;
  medianBlur(image, dst, 5);
  Mat canny_dst;
  Canny(dst, canny_dst, 50, 200, 3);

  cvtColor(dst, dst, COLOR_BGR2GRAY);
  int const MAX_BINARY = 2147483647;
  threshold(dst, dst, 0.5, MAX_BINARY, THRESH_OTSU);
  Mat element = getStructuringElement(MORPH_RECT, cv::Size(5, 5));
  morphologyEx(dst, dst, MORPH_OPEN, element);
  morphologyEx(dst, dst, MORPH_CLOSE, element);

  std::vector<Vec4i> lines;
  HoughLinesP( canny_dst, lines, 1, CV_PI/180, 70, 30, 10);

  cvtColor(dst, image, CV_GRAY2BGR);
  for( size_t i = 0; i < lines.size(); i++ )
  {
    line( image, cv::Point(lines[i][0], lines[i][1]),
         cv::Point(lines[i][2], lines[i][3]),
         [self colorForLine:lines[i] image:dst],
         2, 8 );
  }

  // Find upper and lower piano boundaries

  // Try highlighting black keys!


}

- (bool)lineIsHorizontal:(Vec4i)line
{
  float angle = atan2(line[1] - line[3], line[0] - line[2]);
  return abs(angle) < CV_PI/4.0 || abs(angle) > CV_PI * (3.0/4.0);
}

- (bool)leftOfBlackKey:(Vec4i)line image:(Mat&)image
{
  std::vector<float> blackProportions = [ImageUtil blackProportionsForVLine:line image:image];
  return blackProportions[0] < 0.4 && blackProportions[1] > 0.8;
}

- (bool)rightOfBlackKey:(Vec4i)line image:(Mat&)image
{
  std::vector<float> blackProportions = [ImageUtil blackProportionsForVLine:line image:image];
  return blackProportions[0] > 0.8 && blackProportions[1] < 0.4;
}

- (Scalar)colorForLine:(Vec4i)line image:(Mat&)image
{
  Scalar horizontal = Scalar(255, 0, 0); // RED
  Scalar vertical = Scalar(100, 100, 100); // GREY
  Scalar verticalLeft = Scalar(0, 255, 0); // GREEN
  Scalar verticalRight = Scalar(0, 0, 255); // BLUE
  if ([self lineIsHorizontal:line]) {
    return horizontal;
  }
  if ([self leftOfBlackKey:line image:image]) {
    return verticalLeft;
  } else if ([self rightOfBlackKey:line image:image]) {
    return verticalRight;
  }
  return vertical;
}

- (void)houghLine:(Mat&)image
{
  Mat dst, color_dst;
  Canny( image, dst, 50, 200, 3 );
  cvtColor( dst, color_dst, COLOR_GRAY2BGR );

  std::vector<Vec4i> lines;
  HoughLinesP( dst, lines, 1, CV_PI/180, 80, 30, 10 );
  for( size_t i = 0; i < lines.size(); i++ )
  {
    line( color_dst, cv::Point(lines[i][0], lines[i][1]),
         cv::Point(lines[i][2], lines[i][3]), Scalar(0,0,255), 2, 8 );
  }

  cvtColor(color_dst, image, CV_BGR2BGRA);
}

- (void)invertImage:(Mat&)image
{
  Mat image_copy;
  cvtColor(image, image_copy, CV_BGRA2BGR);

  // invert image
  bitwise_not(image_copy, image_copy);
  cvtColor(image_copy, image, CV_BGR2BGRA);
}

- (void)showContours:(Mat&)image
{
  int const MAX_BINARY = 2147483647;
  Mat dst = image.clone();
  cvtColor(image, dst, COLOR_RGB2GRAY);
  std::vector<std::vector<cv::Point>> contours;
  std::vector<Vec4i> hierarchy;
  threshold(dst, dst, 0.5, MAX_BINARY, THRESH_OTSU);

//  cvtColor(dst, image, CV_GRAY2RGBA);

  Mat contourOutput = dst.clone();
  findContours(contourOutput, contours, hierarchy, RETR_LIST, CHAIN_APPROX_SIMPLE);
  Mat contourImage(dst.size(), CV_8UC3, Scalar(0, 0, 0));
  Scalar colors[3];
  colors[0] = Scalar(250, 100, 0);
  colors[1] = Scalar(100, 240, 80);
  colors[2] = Scalar(0, 30, 200);
  for (size_t idx = 0; idx < contours.size(); idx++) {
    drawContours(contourImage, contours, idx, colors[idx % 3]);
  }
  cvtColor(contourImage, image, CV_RGB2RGBA);
}
#endif

@end
