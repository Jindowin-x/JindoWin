//
//  TOCropOverlayView.m
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

#import "TOCropOverlayView.h"

#import <objc/runtime.h>

static const CGFloat kTOCropOverLayerCornerWidth = 20.0f;

@interface TOCropOverlayView ()

@property (nonatomic, strong) NSMutableArray *horizontalGridLines;
@property (nonatomic, strong) NSMutableArray *verticalGridLines;

@property (nonatomic, strong) NSArray *outerLineViews;   //top, right, bottom, left

@property (nonatomic, strong) NSArray *topLeftLineViews; //vertical, horizontal
@property (nonatomic, strong) NSArray *bottomLeftLineViews;
@property (nonatomic, strong) NSArray *bottomRightLineViews;
@property (nonatomic, strong) NSArray *topRightLineViews;

@property (nonatomic, strong) NSMutableArray *horizontalNoteLabels;
@property (nonatomic, strong) NSMutableArray *verticalNoteLabels;

@property (nonatomic, strong) NSMutableArray *horizontalLabelDotViews;
@property (nonatomic, strong) NSMutableArray *verticalLabelDotViews;

- (void)setup;
- (void)layoutLines;

@end

@implementation TOCropOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        [self setup];
    }
    
    return self;
}

static int VerticalGridLineNumber = 8;
static int HorizontalGridLineNumber = 4;
- (void)setup
{
    UIView *(^newLineView)(void) = ^UIView *(void){
        UIView *newLine = [[UIView alloc] initWithFrame:CGRectZero];
        newLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:newLine];
        return newLine;
    };
    
    UIView *(^newLabelDotView)(void) = ^UIView *(void){
        UIView *labelDotView = [[UIView alloc] init];
        labelDotView.backgroundColor = [UIColor whiteColor];
        labelDotView.layer.cornerRadius = 1.5f;
        labelDotView.layer.masksToBounds = YES;
        [self addSubview:labelDotView];
        return labelDotView;
    };
    
    LineDashView *(^newLineDashView)(LineDashViewDirction direction) = ^LineDashView *(LineDashViewDirction direction){
        LineDashView *lineDashView = [[LineDashView alloc] initWithFrame:CGRectZero
                                                  lineDashPattern:@[@5, @5]
                                                        endOffset:0.495];
        lineDashView.backgroundColor = [UIColor whiteColor];
        lineDashView.direction = direction;
        [self addSubview:lineDashView];
        return lineDashView;
    };
    
    _outerLineViews     = @[newLineView(), newLineView(), newLineView(), newLineView()];
    
    _topLeftLineViews   = @[newLineView(), newLineView()];
    _bottomLeftLineViews = @[newLineView(), newLineView()];
    _topRightLineViews  = @[newLineView(), newLineView()];
    _bottomRightLineViews = @[newLineView(), newLineView()];
    
//    _horizontalGridLines = @[newLineView(), newLineView()];
//    _verticalGridLines = @[newLineView(), newLineView()];

//    LineDashView *hline1 = [[LineDashView alloc] initWithFrame:CGRectZero
//                                              lineDashPattern:@[@5, @5]
//                                                    endOffset:0.495];
//    hline1.backgroundColor = [UIColor whiteColor];
//    hline1.direction = LineDashViewDirctionHorizontal;
//    [self addSubview:hline1];
//    
//    LineDashView *hline2 = [[LineDashView alloc] initWithFrame:CGRectZero
//                                               lineDashPattern:@[@5, @5]
//                                                     endOffset:0.495];
//    hline2.backgroundColor = [UIColor whiteColor];
//    hline2.direction = LineDashViewDirctionHorizontal;
//    [self addSubview:hline2];
//    
//    
//    LineDashView *vline1 = [[LineDashView alloc] initWithFrame:CGRectZero
//                                               lineDashPattern:@[@5, @5]
//                                                     endOffset:0.495];
//    vline1.backgroundColor = [UIColor whiteColor];
//    vline1.direction = LineDashViewDirctionVertical;
//    [self addSubview:vline1];
//    
//    LineDashView *vline2 = [[LineDashView alloc] initWithFrame:CGRectZero
//                                               lineDashPattern:@[@5, @5]
//                                                     endOffset:0.495];
//    vline2.backgroundColor = [UIColor whiteColor];
//    vline2.direction = LineDashViewDirctionVertical;
//    [self addSubview:vline2];
    
    
    _horizontalGridLines = [NSMutableArray array];
    _verticalGridLines = [NSMutableArray array];
    
    _horizontalNoteLabels = [NSMutableArray array];
    _verticalNoteLabels = [NSMutableArray array];
    
    _horizontalLabelDotViews = [NSMutableArray array];
    _verticalLabelDotViews = [NSMutableArray array];
    
    for (int i = 0; i < VerticalGridLineNumber; i++) {
        LineDashView *lineView = newLineDashView(LineDashViewDirctionVertical);
        lineView.tag = 100*(i+1)+1;
        lineView.backgroundColor = [UIColor whiteColor];
        [_verticalGridLines addObject:lineView];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100*(i+1)+1;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:label];
        [_verticalNoteLabels addObject:label];
        
        UIView *dotView = newLabelDotView();
        dotView.tag = 100*(i+1)+1;
        [_verticalLabelDotViews addObject:dotView];
    }
    
    for (int i = 0; i < HorizontalGridLineNumber; i++) {
        LineDashView *lineView = newLineDashView(LineDashViewDirctionHorizontal);
        lineView.tag = 1000*(i+1)+1;
        lineView.backgroundColor = [UIColor whiteColor];
        [_horizontalGridLines addObject:lineView];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1000*(i+1)+1;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:label];
        
        [_horizontalNoteLabels addObject:label];
        
        UIView *dotView = newLabelDotView();
        dotView.tag = 1000*(i+1)+1;
        [_horizontalLabelDotViews addObject:dotView];
    }
}

//-(void)setNoteLabelAttributes:(NSDictionary *)attributes andFont:(UIFont *)font{
//    self.noteFont = font;
//    if (attributes && attributes.count != 0) {
//        [attributes enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSDictionary *obj, BOOL *stop) {
//            
//            NSString *position = [obj objectForKey:@"position"];
//            if (position) {
//                int keyInt = [key intValue];
//                int findKeyint = 0;
//                int findLineKeyInt = 0;
//                if ([position isEqualToString:TOCropLabelPositionVertical]) {
//                    findKeyint = 100 * (keyInt/100) + keyInt%100;
//                    findLineKeyInt = 100 * (keyInt/100) + 1;
//                }else if ([position isEqualToString:TOCropLabelPositionHorizontal]){
//                    findKeyint = 1000 * (keyInt/1000) + keyInt%100;
//                    findLineKeyInt = 1000 * (keyInt/1000) + 1;
//                }
//                UILabel *label = [self findLabelWithTag:findKeyint];
//                if (label) {
//                    id tmp = [obj objectForKey:@"originY"];
//                    if (tmp && [tmp isKindOfClass:[NSNumber class]]) {
//                        label.frameOriginY = [tmp floatValue];
//                    }
//                    id tmp2 = [obj objectForKey:@"originX"];
//                    if (tmp2 && [tmp2 isKindOfClass:[NSNumber class]]) {
//                        label.frameOriginX = [tmp2 floatValue];
//                    }
//                    id tmp3 = [obj objectForKey:@"leftAligh"];
//                    if (tmp3 && [tmp3 isKindOfClass:[NSNumber class]]) {
//                        label.leftAligh = [tmp3 floatValue];
//                    }
//                    id tmp4 = [obj objectForKey:@"upAligh"];
//                    if (tmp4 && [tmp4 isKindOfClass:[NSNumber class]]) {
//                        label.upAligh = [tmp4 floatValue];
//                    }
//                    NSString *text = [obj objectForKey:@"text"];
//                    if (text) {
//                        label.text = text;
//                    }else{
//                        label.text = @"";
//                    }
//                    UIColor *textcolor = [obj objectForKey:@"textColor"];
//                    if (textcolor) {
//                        label.textColor = textcolor;
//                    }else{
//                        label.textColor = [UIColor whiteColor];
//                    }
//                }
//                LineDashView *lineDashView = [self findLineWithTag:findLineKeyInt];
//                if (lineDashView) {
//                    NSString *ratio = [obj objectForKey:@"lineRatio"];
//                    if (ratio) {
//                        CGSize radioSize = CGSizeFromString(ratio);
//                        if (radioSize.width != 0 && radioSize.height != 0) {
//                            lineDashView.lineRatio = radioSize;
//                        }
//                    }
//                    UIColor *lineColor = [obj objectForKey:@"lineColor"];
//                    if (lineColor) {
//                        lineDashView.backgroundColor = lineColor;
//                    }else{
//                        lineDashView.backgroundColor = [UIColor whiteColor];
//                    }
//                }
//                UIView *dotView = [self findLineDotViewWithTag:findKeyint];
//                if (dotView) {
//                    UIColor *dotViewColor = [obj objectForKey:@"dotColor"];
//                    if (dotViewColor) {
//                        dotView.backgroundColor = dotViewColor;
//                    }else{
//                        dotView.backgroundColor = [UIColor whiteColor];
//                    }
//                }
//            }
//        }];
//    }
//}
//
//- (UILabel *)findLabelWithTag:(int)tag{
//    for (int i = 0; i < self.horizontalNoteLabels.count; i++) {
//        UILabel *label = self.horizontalNoteLabels[i];
//        if (label.tag == tag) {
//            return label;
//        }
//    }
//    for (int i = 0; i < self.verticalNoteLabels.count; i++) {
//        UILabel *label = self.verticalNoteLabels[i];
//        if (label.tag == tag) {
//            return label;
//        }
//    }
//    return nil;
//}
//
//- (LineDashView *)findLineWithTag:(int)tag{
//    for (int i = 0; i < self.horizontalGridLines.count; i++) {
//        LineDashView *view = self.horizontalGridLines[i];
//        if (view.tag == tag) {
//            return view;
//        }
//    }
//    for (int i = 0; i < self.verticalGridLines.count; i++) {
//        LineDashView *view = self.verticalGridLines[i];
//        if (view.tag == tag) {
//            return view;
//        }
//    }
//    return nil;
//}
//
//- (UIView *)findLineDotViewWithTag:(int)tag{
//    for (int i = 0; i < self.horizontalLabelDotViews.count; i++) {
//        UIView *view = self.horizontalLabelDotViews[i];
//        if (view.tag == tag) {
//            return view;
//        }
//    }
//    for (int i = 0; i < self.verticalLabelDotViews.count; i++) {
//        UIView *view = self.verticalLabelDotViews[i];
//        if (view.tag == tag) {
//            return view;
//        }
//    }
//    return nil;
//}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)layoutLines
{
    CGSize boundsSize = self.bounds.size;
    
    //border lines
    for (NSInteger i = 0; i < 4; i++) {
        UIView *lineView = self.outerLineViews[i];
        
        CGRect frame = CGRectZero;
        switch (i) {
            case 0: frame = (CGRect){0,-1.0f,boundsSize.width+2.0f, 1.0f}; break; //top
            case 1: frame = (CGRect){boundsSize.width,0.0f,1.0f,boundsSize.height}; break; //right
            case 2: frame = (CGRect){-1.0f,boundsSize.height,boundsSize.width+2.0f,1.0f}; break; //bottom
            case 3: frame = (CGRect){-1.0f,0,1.0f,boundsSize.height+1.0f}; break; //left
        }
        
        lineView.frame = frame;
    }
    
    //corner liness
    NSArray *cornerLines = @[self.topLeftLineViews, self.topRightLineViews, self.bottomRightLineViews, self.bottomLeftLineViews];
    for (NSInteger i = 0; i < 4; i++) {
        NSArray *cornerLine = cornerLines[i];
        
        CGRect verticalFrame, horizontalFrame;
        switch (i) {
            case 0: //top left
                verticalFrame = (CGRect){-3.0f,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
                horizontalFrame = (CGRect){0,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
                break;
            case 1: //top right
                verticalFrame = (CGRect){boundsSize.width,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
                break;
            case 2: //bottom right
                verticalFrame = (CGRect){boundsSize.width,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth+3.0f};
                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,boundsSize.height,kTOCropOverLayerCornerWidth,3.0f};
                break;
            case 3: //bottom left
                verticalFrame = (CGRect){-3.0f,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth};
                horizontalFrame = (CGRect){-3.0f,boundsSize.height,kTOCropOverLayerCornerWidth+3.0f,3.0f};
                break;
        }
        
        [cornerLine[0] setFrame:verticalFrame];
        [cornerLine[1] setFrame:horizontalFrame];
    }
    
    //grid lines - horizontal
    CGFloat thickness = 1.0f / [UIScreen mainScreen].scale;
//    NSInteger numberOfLines = self.horizontalGridLines.count;
//    CGFloat padding = (CGRectGetHeight(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
//    for (NSInteger i = 0; i < numberOfLines; i++) {
//        UIView *lineView = self.horizontalGridLines[i];
//        CGRect frame = CGRectZero;
//        frame.size.height = thickness;
//        frame.size.width = CGRectGetWidth(self.bounds);
//        frame.origin.y = (padding * (i+1)) + (thickness * i);
//        lineView.frame = frame;
//    }
    
    //水平线条设置
    for (NSInteger i = 0; i < HorizontalGridLineNumber; i++) {
        LineDashView *lineView = self.horizontalGridLines[i];
        
        UILabel *label = self.horizontalNoteLabels[i];
        
        UIView *dotView = self.horizontalLabelDotViews[i];
        
        CGRect dashframe = CGRectZero;
        dashframe.size.height = thickness;
        dashframe.size.width = CGRectGetWidth(self.bounds);
        
        dashframe.origin.x = 0;
        
        CGSize ratio = lineView.lineRatio;
        
        if (ratio.width == 0 || ratio.height == 0) {
            lineView.frame = CGRectZero;
            label.frame = CGRectZero;
            dotView.frame = CGRectZero;
        }else{
            float dashOriginY = CGRectGetHeight(self.bounds)*((ratio.width*1.f)/(float)(ratio.width + ratio.height));
            dashframe.origin.y = dashOriginY;
            lineView.frame = dashframe;
            
            if (!label.text || [label.text isEqualToString:@""]) {
                label.frame = CGRectZero;
                dotView.frame = CGRectZero;
            }else{
                label.font = self.noteFont;
                
                float upAlgh = label.upAligh;
                float originX = label.frameOriginX;
                
                CGRect labelFrame = CGRectZero;
                labelFrame.origin.x = originX;
                labelFrame.origin.y = dashOriginY + upAlgh;
                labelFrame.size.width = 70;
                labelFrame.size.height = 15;
                
                label.frame = labelFrame;
                
                CGRect dotFrame = CGRectZero;
                dotFrame.size = (CGSize){3,3};
                dotFrame.origin.x = originX;
                dotFrame.origin.y = dashOriginY + CGRectGetHeight(dashframe)/2-1;
                dotView.frame = dotFrame;
            }
        }
    }
    
    //竖线设置
    for (NSInteger i = 0; i< VerticalGridLineNumber; i++) {
        LineDashView *lineView = self.verticalGridLines[i];
        
        UILabel *label = self.verticalNoteLabels[i];
        
        UIView *dotView = self.verticalLabelDotViews[i];
        
        CGRect dashframe = CGRectZero;
        dashframe.size.height = CGRectGetHeight(self.bounds);
        dashframe.size.width = thickness;
        
        dashframe.origin.y = 0;
        
        CGSize ratio = lineView.lineRatio;
        if (ratio.width == 0 || ratio.height == 0) {
            lineView.frame = CGRectZero;
            label.frame = CGRectZero;
            dotView.frame = CGRectZero;
        }else{
            float dashOriginX = CGRectGetWidth(self.bounds)*((ratio.width*1.f)/(float)(ratio.width + ratio.height));
            dashframe.origin.x = dashOriginX;
            lineView.frame = dashframe;
            
            if (!label.text || [label.text isEqualToString:@""]) {
                label.frame = CGRectZero;
                dotView.frame = CGRectZero;
            }else{
                label.font = self.noteFont;
                
                float leftAligh = label.leftAligh;
                float originY = label.frameOriginY;
                
                CGRect labelFrame = CGRectZero;
                labelFrame.origin.x = dashOriginX + leftAligh + 5;
                if (originY > CGRectGetHeight(self.bounds)) {
                    originY = CGRectGetHeight(self.bounds) - arc4random()%10-10;
                }
                labelFrame.origin.y = originY;
                labelFrame.size.width = 70;
                labelFrame.size.height = 15;
                
                label.frame = labelFrame;
                
                CGRect dotFrame = CGRectZero;
                dotFrame.size = (CGSize){3,3};
                dotFrame.origin.x = dashOriginX +  CGRectGetWidth(dashframe)/2-1;
                dotFrame.origin.y = originY;
                dotView.frame = dotFrame;
            }
        }
    }
    
    
    //grid lines - vertical
//    numberOfLines = self.verticalGridLines.count;
//    padding = (CGRectGetWidth(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
//    for (NSInteger i = 0; i < numberOfLines; i++) {
//        UIView *lineView = self.verticalGridLines[i];
//        CGRect frame = CGRectZero;
//        frame.size.width = thickness;
//        frame.size.height = CGRectGetHeight(self.bounds);
//        frame.origin.x = (padding * (i+1)) + (thickness * i);
//        lineView.frame = frame;
//    }
    //这里的label的设置必须和vertical line 一起设置 因为要获取padding参数
//    NSInteger count = self.noteLabels.count;
//    for (NSInteger i = 0; i < count; i++) {
//        UILabel *label = self.noteLabels[i];
//        label.font = self.noteFont;
////        label.backgroundColor = [UIColor redColor];
//        int lineNumber = (int)label.tag/100;
//        CGRect frame = CGRectZero;
//        frame.origin.y = label.frameOriginY;
//        frame.size.height = 20;
//        
//        if (lineNumber == 1) {
//            frame.origin.x = (int)(padding+5);
//            frame.size.width = (int)padding-5;
//            label.textAlignment = NSTextAlignmentLeft;
//        }else if (lineNumber == 2){
//            frame.origin.x = (int)(padding + thickness);
//            frame.size.width = (int)padding-5;
//            label.textAlignment = NSTextAlignmentRight;
//        }
//        label.frame = frame;
//        
//        UIView *labelDotView = self.noteLabelDotViews[i];
//        CGRect dotFrame = CGRectZero;
//        dotFrame.size = (CGSize){3,3};
//        dotFrame.origin.x = (padding * (i+1)) + (thickness * i);
//        dotFrame.origin.y = label.frameOriginY + CGRectGetHeight(frame)/2-1;
//        labelDotView.frame = dotFrame;
//    }
}

- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated
{
    _gridHidden = hidden;
    
    if (animated == NO) {
        for (UIView *lineView in self.horizontalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
        
        for (UIView *lineView in self.verticalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
        
        
        
        for (UIView *view in self.verticalLabelDotViews) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.horizontalLabelDotViews) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.verticalNoteLabels) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.horizontalNoteLabels) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        return;
    }
    
    [UIView animateWithDuration:hidden?0.35f:0.2f animations:^{
        for (UIView *lineView in self.horizontalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
        
        for (UIView *lineView in self.verticalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
        
        for (UIView *view in self.verticalLabelDotViews) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.horizontalLabelDotViews) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.verticalNoteLabels) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
        for (UIView *view in self.horizontalNoteLabels) {
            view.alpha = hidden ? 0.0f : 1.0f;
        }
    }];
}

- (void)setGridHidden:(BOOL)gridHidden
{
    [self setGridHidden:gridHidden animated:NO];
}

@end

@interface LineDashView () {
    CAShapeLayer  *_shapeLayer;
}

@end

@implementation LineDashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setFrame:frame];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self initPath];
}

-(void)initPath{
    UIBezierPath *path      = [UIBezierPath bezierPathWithRect:self.bounds];
    _shapeLayer             = (CAShapeLayer *)self.layer;
    _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeStart = 0.001;
    _shapeLayer.strokeEnd   = 0.499;
    if (self.direction == LineDashViewDirctionVertical) {
        _shapeLayer.lineWidth   = self.bounds.size.width;
    }else if (self.direction == LineDashViewDirctionHorizontal){
        _shapeLayer.lineWidth   = self.bounds.size.height;
    }else{
        _shapeLayer.lineWidth = 0;
    }
    _shapeLayer.path        = path.CGPath;
}

-(void)setDirection:(LineDashViewDirction)direction{
    _direction = direction;
    [self initPath];
}

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset
{
    LineDashView *lineDashView   = [[LineDashView alloc] initWithFrame:frame];
    lineDashView.lineDashPattern = lineDashPattern;
    lineDashView.endOffset       = endOffset;
    return lineDashView;
}

#pragma mark - 修改view的backedLayer为CAShapeLayer
+ (Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - 改写属性的getter,setter方法
@synthesize lineDashPattern = _lineDashPattern;
- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern            = lineDashPattern;
    _shapeLayer.lineDashPattern = lineDashPattern;
}
- (NSArray *)lineDashPattern
{
    return _lineDashPattern;
}

@synthesize endOffset = _endOffset;
- (void)setEndOffset:(CGFloat)endOffset
{
    _endOffset = endOffset;
    if (endOffset < 0.499 && endOffset > 0.001)
    {
        _shapeLayer.strokeEnd = _endOffset;
    }
}
- (CGFloat)endOffset
{
    return _endOffset;
}

#pragma mark - 重写了系统的backgroundColor属性
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _shapeLayer.strokeColor = backgroundColor.CGColor;
}
- (UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:_shapeLayer.strokeColor];
}

@end

@implementation UILabel (FrameOrigin)

@dynamic frameOriginY,frameOriginX,leftAligh,upAligh;

-(void)setFrameOriginY:(CGFloat)params{
    objc_setAssociatedObject(self, @selector(frameOriginY),@(params), OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)frameOriginY{
    id i = objc_getAssociatedObject(self, @selector(frameOriginY));
    if (i) {
        return [i floatValue];
    }
    return 0;
}

-(void)setFrameOriginX:(CGFloat)params{
    objc_setAssociatedObject(self, @selector(frameOriginX),@(params), OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)frameOriginX{
    id i = objc_getAssociatedObject(self, @selector(frameOriginX));
    if (i) {
        return [i floatValue];
    }
    return 0;
}

-(void)setLeftAligh:(CGFloat)params{
    objc_setAssociatedObject(self, @selector(leftAligh),@(params), OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)leftAligh{
    id i = objc_getAssociatedObject(self, @selector(leftAligh));
    if (i) {
        return [i floatValue];
    }
    return 0;
}

-(void)setUpAligh:(CGFloat)params{
    objc_setAssociatedObject(self, @selector(upAligh),@(params), OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)upAligh{
    id i = objc_getAssociatedObject(self, @selector(upAligh));
    if (i) {
        return [i floatValue];
    }
    return 0;
}

@end
