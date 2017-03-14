//
//  UIButton+Block.h
//  Byids
//
//  Created by levin on 14-7-30.
//  Copyright (c) 2014年 Byte. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();

@interface UIButton (Block) <UIAlertViewDelegate>

-(void)handleClickEvent:(UIControlEvents)aEvent withClickBlock:(ActionBlock)buttonClickEvent;

@end