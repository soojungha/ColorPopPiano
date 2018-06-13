//
//  ImageUtil.h
//  ColorPopPiano
//
//  Created by Soojung Ha on 6/11/18.
//  Copyright © 2018 Soojung Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/core/mat.hpp>
using namespace cv;

@interface ImageUtil : NSObject

+ (std::vector<float>)blackProportionsForHLine:(Vec4i)line image:(Mat&)image;
+ (std::vector<float>)blackProportionsForVLine:(Vec4i)line image:(Mat&)image;

@end

