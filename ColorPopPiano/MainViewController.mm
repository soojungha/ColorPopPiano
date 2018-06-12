//
//  ViewController.m
//  ColorPopPiano
//
//  Created by Soojung Ha on 6/11/18.
//  Copyright © 2018 Soojung Ha. All rights reserved.
//

#import "MainViewController.h"

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
  // Do some OpenCV stuff with the image
  Mat image_copy;
  cvtColor(image, image_copy, CV_BGRA2BGR);

  // invert image
  bitwise_not(image_copy, image_copy);
  cvtColor(image_copy, image, CV_BGR2BGRA);
}
#endif


@end
