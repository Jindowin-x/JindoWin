//
//  XYAnimateTagsView.h
//  SimpleRead
//
//  Created by xiaoyu on 15/7/4.
//  Copyright © 2015年 __comany name__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAnimateTagsView : UIView

typedef void (^TagClickBlock)(NSString *tagString);

@property (nonatomic,strong,nonnull) NSArray *tagsArray;

@property (nonatomic) float maxHeight;

@property (nonatomic,strong,nonnull) UIFont *showableFont;

@property (nonatomic) int showableRowNumbers;

@property (nonatomic,copy,nonnull) TagClickBlock tagClickBlock;

-(instancetype)initWithFrame:(CGRect)frame rowNumbers:(int)nums;

-(void)draw;

-(void)reDraw;

@end
