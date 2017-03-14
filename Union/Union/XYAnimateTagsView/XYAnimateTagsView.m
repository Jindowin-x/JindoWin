//
//  XYAnimateTagsView.m
//  SimpleRead
//
//  Created by xiaoyu on 15/7/4.
//  Copyright © 2015年 __comany name__. All rights reserved.
//

#import "XYAnimateTagsView.h"

@interface XYAnimateTagsView ()

@end

@implementation XYAnimateTagsView{
    NSMutableArray *showableTagsArray;
    NSMutableArray *showableButtonsArray;
    
    NSMutableArray *reuseableButtonsArray;
    
    
    float frameWidth;
    
    
    float setedOriginX,setedOriginY,everyHeight,everyButtonAligh;
}

-(instancetype)initWithFrame:(CGRect)frame rowNumbers:(int)nums{
    self = [super initWithFrame:frame];
    if (self) {
        frameWidth = frame.size.width;
        self.showableRowNumbers = nums;
    }
    return self;
}

-(void)setTagsArray:(NSArray * __nonnull)tagsArray{
    _tagsArray = tagsArray;
    showableTagsArray = [NSMutableArray arrayWithArray:tagsArray];
}

-(void)draw{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!showableTagsArray) {
        showableTagsArray = [NSMutableArray array];
    }
    if (!showableButtonsArray) {
        showableButtonsArray = [NSMutableArray array];
    }
    if (!reuseableButtonsArray) {
        reuseableButtonsArray = [NSMutableArray array];
    }
    
    BOOL isCreated = YES;
    if (showableButtonsArray.count != 0) {
        isCreated = NO;
    }
    
    if (!showableTagsArray && showableTagsArray.count == 0) {
        NSLog(@"XYAnimateTagsView  selector draw : 需要显示的标签数组不能为空");
        return;
    }
    if(!self.showableFont){
        self.showableFont = [UIFont systemFontOfSize:13.f];
    }
    
    setedOriginX = 5,
    setedOriginY = 10;
    everyHeight = 26;
    everyButtonAligh = 10;
    int rowindex = 1;
    
    for (int index = 0; index < showableTagsArray.count; index++) {
        //        NSLog(@"showableTagsArray %d",index);
        if (reuseableButtonsArray.count == 0) {
            for (int i = 0; i<5; i++) {
                UIButton *bu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [reuseableButtonsArray addObject:bu];
            }
        }
        
        NSString *tagString = showableTagsArray[index];
        float width = [self widthWithString:tagString font:self.showableFont lineHeight:everyHeight];
        
        if (setedOriginX + width+15*2 > frameWidth) {
            setedOriginY +=everyHeight+everyButtonAligh;
            setedOriginX = 10;
            rowindex += 1;
        }
        
        if (self.showableRowNumbers != 0) {
            if (rowindex > self.showableRowNumbers) {
                setedOriginY = setedOriginY - everyHeight-everyButtonAligh;
                break;
            }
        }
        UIButton *button;
        if (isCreated || index > showableButtonsArray.count-1) {
            button = [reuseableButtonsArray firstObject];
            [reuseableButtonsArray removeObject:button];
            [showableButtonsArray addObject:button];
        }else{
            button = [showableButtonsArray objectAtIndex:index];
        }
        
        button.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        button.layer.borderWidth = 1.f;
        button.layer.cornerRadius = 13.f;
        button.layer.masksToBounds = YES;
        button.tag = index;
        [button setTitle:tagString forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
        button.titleLabel.font = self.showableFont;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (index > showableButtonsArray.count-1) {
            button.frame = (CGRect){frameWidth+15,setedOriginY,width+15*2,everyHeight};
        }
        [UIView animateWithDuration:0.2 animations:^{
            button.frame = (CGRect){setedOriginX,setedOriginY,width+15*2,everyHeight};
        }];
        
        setedOriginX += width+15*2 + 15;
        
    }
    CGRect selfRect = (CGRect){self.frame.origin.x,self.frame.origin.y,self.frame.size.width,setedOriginY+everyHeight+5};
    self.frame = selfRect;
}

-(void)buttonClick:(UIButton *)button{
    //    [button removeFromSuperview];
    //    [reuseableButtonsArray addObject:button];
    //    [showableButtonsArray removeObject:button];
    //    [showableTagsArray removeObjectAtIndex:button.tag];
    //    [self draw];
    if (self.tagClickBlock) {
        self.tagClickBlock(button.titleLabel.text);
    }
}

-(float)widthWithString:(NSString *)targetString font:(UIFont *)font lineHeight:(float)lineheight{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        
        CGSize retSize = [targetString boundingRectWithSize:(CGSize){MAXFLOAT,lineheight}
                                                    options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
        return retSize.width;
    }else{
        CGSize titleSize = [targetString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, lineheight)];
        return titleSize.width;
    }
}

-(void)reDraw{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [showableButtonsArray removeAllObjects];
    showableTagsArray = showableTagsArray = [NSMutableArray arrayWithArray:_tagsArray];
    [self draw];
}

@end
