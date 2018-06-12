//
//  ViewController.h
//  ColorPopPiano
//
//  Created by Soojung Ha on 6/11/18.
//  Copyright © 2018 Soojung Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/videoio/cap_ios.h>
using namespace cv;

@interface MainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, retain) CvVideoCamera *videoCamera;

@end

