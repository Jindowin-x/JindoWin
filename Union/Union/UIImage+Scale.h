//
//  UIImage+Color.h
//  ColorTest
//
//  Created by xiaoyu on 15/9/19.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Scale)

-(UIImage *)scaleWithRadio:(float)radio;

-(UIImage *)scaleWithSize:(CGSize)tosize;

@end
