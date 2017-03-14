//
//  TOCropOverlayView.h
//
//  Copyright 2015 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

static NSString *TOCropLabelPositionVertical = @"TOCropLabelPositionVertical";
static NSString *TOCropLabelPositionHorizontal = @"TOCropLabelPositionHorizontal";


@interface TOCropOverlayView : UIView

@property (nonatomic, assign) BOOL gridHidden;

@property (nonatomic,strong) UIFont *noteFont;

/**
 Shows and hides the interior grid lines
 */
- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated;

-(void)setNoteLabelAttributes:(NSDictionary *)attributes andFont:(UIFont *)font;

@end

typedef NS_ENUM(NSUInteger, LineDashViewDirction) {
    LineDashViewDirctionVertical = 1 << 0,
    LineDashViewDirctionHorizontal = 1 << 1,
};

@interface LineDashView : UIView

@property (nonatomic,assign) LineDashViewDirction direction;

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

@property (nonatomic, assign) CGSize     lineRatio;

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end

@interface UILabel (FrameOrigin)

@property (nonatomic,assign) CGFloat frameOriginY;

@property (nonatomic,assign) CGFloat frameOriginX;

@property (nonatomic,assign) CGFloat leftAligh;

@property (nonatomic,assign) CGFloat upAligh;

@end
