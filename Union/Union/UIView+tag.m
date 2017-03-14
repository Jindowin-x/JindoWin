//
//  tagForReorder.m
//  Byids
//
//  Created by 拜爱智能科技(武汉)科技有限公司 on 14/3/14.
//  Copyright (c) 2014年 拜爱智能科技(武汉)科技有限公司. All rights reserved.
//

#import "UIView+tag.h"
#import <objc/runtime.h>

static char *staticTagForReorder;

@implementation UIView(tag)

+(NSMutableDictionary*)sharetagDic{
    static NSMutableDictionary *tagdic;
    if (!tagdic) {
        tagdic = [NSMutableDictionary dictionary];
    }
    return tagdic;
}

-(int)tagForReorder{
    return (int)[objc_getAssociatedObject(self, &staticTagForReorder) integerValue];
}

-(void)setTagForReorder:(int)tagForReorder{
    objc_setAssociatedObject(self, &staticTagForReorder, @(tagForReorder), OBJC_ASSOCIATION_COPY_NONATOMIC);
    weak(weakself, self.superview);
    weak(weakS, self)
    void *p = (__bridge void*)weakself;
    //NSLog(@"void:%@",[NSString stringWithFormat:@"%p_%@",p,@(tagForReorder)]);
    [[UIView sharetagDic] setObject:weakS forKey:[NSString stringWithFormat:@"%p_%@",p,@(tagForReorder)]];
}

-(UIView*)viewForTagReorder:(int)tagForReorder{
    weak(weakself, self);
    void *p = (__bridge void*)weakself;
    //NSLog(@"%@",[UIView sharetagDic]);
    return [UIView sharetagDic][[NSString stringWithFormat:@"%p_%@",p,@(tagForReorder)]];
}

@dynamic tagControl;
-(int)tagControl{
    id i = objc_getAssociatedObject(self, @selector(tagControl));
    if (i) {
        return [i intValue];
    }
    return -1;
}

-(void)setTagControl:(int)params{
    objc_setAssociatedObject(self, @selector(tagControl),@(params), OBJC_ASSOCIATION_RETAIN);
}


@end
