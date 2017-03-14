//
//  tagForReorder.h
//  Byids
//
//  Created by 拜爱智能科技(武汉)科技有限公司 on 14/3/14.
//  Copyright (c) 2014年 拜爱智能科技(武汉)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(tag)

@property (nonatomic) int tagForReorder;

@property (nonatomic) int tagControl;

-(UIView *)viewForTagReorder:(int)tagForReorder;

@end
