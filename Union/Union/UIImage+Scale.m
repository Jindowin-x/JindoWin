//
//  UIImage+Scale.m
//  ColorTest
//
//  Created by xiaoyu on 15/9/19.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

-(UIImage*)scaleWithRadio:(float)radio{
    CGFloat windowScale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(self.size.width * radio*windowScale, self.size.height*radio*windowScale);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *returnImage = [UIImage imageWithCGImage:scaledImage.CGImage scale:windowScale orientation:UIImageOrientationUp];
    return returnImage;
}

-(UIImage *)scaleWithSize:(CGSize)tosize{
    CGSize selfImageSize = self.size;
    return [self scaleWithRadio:tosize.width/selfImageSize.width];
}

@end
