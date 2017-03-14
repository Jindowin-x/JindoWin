//
//  UIButton+Block.m
//  Byids
//
//  Created by levin on 14-7-30.
//  Copyright (c) 2014年 Byte. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char *overViewKey;

@implementation UIButton(Block)

-(void)handleClickEvent:(UIControlEvents)aEvent withClickBlock:(ActionBlock)buttonClickEvent
{
    objc_setAssociatedObject(self, &overViewKey, buttonClickEvent, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:aEvent];
}

-(void)buttonClick
{
    ActionBlock blockClick = objc_getAssociatedObject(self, &overViewKey);
    if (blockClick != nil){
        blockClick();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
