//
//  UIScrollView+PullUpRefresh.m
//  TableRefresh
//
//  Created by xiaoyu on 15/7/17.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import "UIScrollView+XYRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (XYRefresh)

static float refreshActiveHeight_down = 87.5;
static float refreshViewHeight_down = 15;

//static float refreshActiveHeight_pull = 87.5;
static float refreshViewHeight_pull = 15;

static float refreshViewHeightAlign = 8;


#pragma mark ————————————————————————————————
#pragma mark 上拉刷新
#pragma mark ————————————————————————————————
#pragma mark 设置变量
@dynamic isDownRefreshInit,isDownRefrshing,prepareToRefresh_down;
-(BOOL)isDownRefreshInit{
    id i = objc_getAssociatedObject(self, @selector(isDownRefreshInit));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
-(void)setIsDownRefreshInit:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isDownRefreshInit),@(params), OBJC_ASSOCIATION_RETAIN);
}
-(BOOL)isDownRefrshing{
    id i = objc_getAssociatedObject(self, @selector(isDownRefrshing));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
-(void)setIsDownRefrshing:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isDownRefrshing),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic isOpacityAdded_down;
-(BOOL)isOpacityAdded_down{
    id i = objc_getAssociatedObject(self, @selector(isOpacityAdded_down));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
- (void)setIsOpacityAdded_down:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isOpacityAdded_down),@(params), OBJC_ASSOCIATION_RETAIN);
}
-(BOOL)prepareToRefresh_down{
    id i = objc_getAssociatedObject(self, @selector(prepareToRefresh_down));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
- (void)setPrepareToRefresh_down:(BOOL)params{
    objc_setAssociatedObject(self, @selector(prepareToRefresh_down),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic inBubbleView_down,outBubbleView_down;
-(UIImageView *)inBubbleView_down{
    id i = objc_getAssociatedObject(self, @selector(inBubbleView_down));
    if (i) {
        return (UIImageView *)i;
    }
    return nil;
}
- (void)setInBubbleView_down:(UIImageView *)params{
    objc_setAssociatedObject(self, @selector(inBubbleView_down),params, OBJC_ASSOCIATION_RETAIN);
}
-(UIImageView *)outBubbleView_down{
    id i = objc_getAssociatedObject(self, @selector(outBubbleView_down));
    if (i) {
        return (UIImageView *)i;
    }
    return nil;
}
- (void)setOutBubbleView_down:(UIImageView *)params{
    objc_setAssociatedObject(self, @selector(outBubbleView_down),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic opacityAnimation_down,inposAnimation_down,outposAnimation_down;
-(CABasicAnimation *)opacityAnimation_down{
    id i = objc_getAssociatedObject(self, @selector(opacityAnimation_down));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setOpacityAnimation_down:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(opacityAnimation_down),params, OBJC_ASSOCIATION_RETAIN);
}
-(CABasicAnimation *)inposAnimation_down{
    id i = objc_getAssociatedObject(self, @selector(inposAnimation_down));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setInposAnimation_down:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(inposAnimation_down),params, OBJC_ASSOCIATION_RETAIN);
}
-(CABasicAnimation *)outposAnimation_down{
    id i = objc_getAssociatedObject(self, @selector(outposAnimation_down));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setOutposAnimation_down:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(outposAnimation_down),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic downRefreshBlock;
-(DownRefreshBlockIn)downRefreshBlock{
    id i = objc_getAssociatedObject(self, @selector(downRefreshBlock));
    if (i) {
        return (PullUpRefreshBlockIn)i;
    }
    return nil;
}
- (void)setDownRefreshBlock:(DownRefreshBlockIn)params{
    objc_setAssociatedObject(self, @selector(downRefreshBlock),params, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark -
#pragma mark --下拉刷新构造函数
-(void)initDownRefreshCompletion:(DownRefreshBlockIn)completion{
    self.downRefreshBlock = completion;
    [self initDownRefresh];
}

-(void)initDownRefresh{
    self.isDownRefreshInit = YES;
    self.isDownRefrshing = NO;
    [self initDownRefreshBubbleView];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark -
-(void)initDownRefreshBubbleView{
    [self.inBubbleView_down.layer removeAllAnimations];
    [self.outBubbleView_down.layer removeAllAnimations];
    
    [self.inBubbleView_down removeFromSuperview];
    [self.outBubbleView_down removeFromSuperview];
    
    self.inBubbleView_down = [[UIImageView alloc] init];
    self.inBubbleView_down.frame = (CGRect){(int)((self.frame.size.width-refreshViewHeight_down)/2),-15-refreshViewHeightAlign,refreshViewHeight_down,refreshViewHeight_down};
    self.inBubbleView_down.alpha = 1.f;
    [self.inBubbleView_down setImage:[UIImage imageNamed:@"refreshBubble_blue"]];
    
    [self.inBubbleView_down.layer setZPosition:-1.0];
    [self addSubview:self.inBubbleView_down];
    
    
    self.outBubbleView_down = [[UIImageView alloc] init];
    self.outBubbleView_down.frame = (CGRect){(int)((self.frame.size.width-refreshViewHeight_down)/2),-refreshActiveHeight_down,refreshViewHeight_down,refreshViewHeight_down};
    self.outBubbleView_down.alpha = 1.f;
    [self.outBubbleView_down setImage:[UIImage imageNamed:@"refreshBubble_red"]];
    [self.outBubbleView_down.layer setZPosition:1.0];
    [self addSubview:self.outBubbleView_down];
}


-(CABasicAnimation *)downOpacityAnimation{
    if (!self.opacityAnimation_down) {
        self.opacityAnimation_down = [CABasicAnimation animationWithKeyPath:@"opacity"];
        self.opacityAnimation_down.fromValue = @1;
        self.opacityAnimation_down.toValue = @0.1;
        self.opacityAnimation_down.duration = 0.2f;
        self.opacityAnimation_down.delegate = self;
        self.opacityAnimation_down.autoreverses = YES;
        self.opacityAnimation_down.repeatCount = 1;
        self.opacityAnimation_down.fillMode = kCAFillModeForwards;
        self.opacityAnimation_down.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.opacityAnimation_down setValue:@"opacityAnimation" forKey:@"UIScrollView_DownRefresh_XY_RedOpacityAnimation_ValueKey"];
        self.opacityAnimation_down.removedOnCompletion = YES;
    }
    return self.opacityAnimation_down;
}

-(void)downBeginRefreshTransformAnimation{
    if (!self.isDownRefrshing) {
        self.isDownRefrshing = YES;
        
        self.outposAnimation_down = [CABasicAnimation animationWithKeyPath:@"position"];
        self.outposAnimation_down.fromValue = [NSValue valueWithCGPoint:(CGPoint){self.frame.size.width/2-7.5,-refreshViewHeight_down-refreshViewHeightAlign+refreshViewHeight_down/2}];
        self.outposAnimation_down.toValue = [NSValue valueWithCGPoint:(CGPoint){self.frame.size.width/2+7.5,-refreshViewHeight_down-refreshViewHeightAlign+refreshViewHeight_down/2}];
        self.outposAnimation_down.duration = .5f;
        self.outposAnimation_down.delegate = self;
        self.outposAnimation_down.repeatCount = -1;
        self.outposAnimation_down.fillMode = kCAFillModeForwards;
        self.outposAnimation_down.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.outposAnimation_down.removedOnCompletion = NO;
        
        [self.outposAnimation_down setValue:@"outposAnimation" forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_ValueKey"];
        
        [self.outBubbleView_down.layer addAnimation:self.outposAnimation_down forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_AnimationKey"];
        
        self.inposAnimation_down = [CABasicAnimation animationWithKeyPath:@"position"];
        self.inposAnimation_down.fromValue = [NSValue valueWithCGPoint:(CGPoint){self.frame.size.width/2+7.5,-refreshViewHeight_down-refreshViewHeightAlign+refreshViewHeight_down/2}];
        self.inposAnimation_down.toValue = [NSValue valueWithCGPoint:(CGPoint){self.frame.size.width/2-7.5,-refreshViewHeight_down-refreshViewHeightAlign+refreshViewHeight_down/2}];
        self.inposAnimation_down.duration = .5f;
        self.inposAnimation_down.delegate = self;
        self.inposAnimation_down.repeatCount = -1;
        self.inposAnimation_down.fillMode = kCAFillModeForwards;
        self.inposAnimation_down.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.inposAnimation_down.removedOnCompletion = NO;
        [self.inposAnimation_down setValue:@"inposAnimation" forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_ValueKey"];
        
        [self.inBubbleView_down.layer addAnimation:self.inposAnimation_down forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_AnimationKey"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isPullUpRefreshing) {
                self.isDownRefrshing = NO;
                return;
            }
            if (self.downRefreshBlock) {
                self.downRefreshBlock(self);
            }
        });
    }
}

-(void)endDownRefresh{
    if (!self.isDownRefrshing) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f animations:^{
            self.contentInset = UIEdgeInsetsZero;
        }completion:^(BOOL finished) {
            [self.inBubbleView_down.layer removeAllAnimations];
            [self.outBubbleView_down.layer removeAllAnimations];
        }];
        [UIView animateWithDuration:0.7f animations:^{
            self.inBubbleView_down.alpha = 0.0f;
            self.outBubbleView_down.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [self.inBubbleView_down.layer removeAllAnimations];
            [self.outBubbleView_down.layer removeAllAnimations];
            self.isDownRefrshing = NO;
            [self initDownRefresh];
        }];
    });
}


#pragma mark ————————————————————————————————
#pragma mark 上拉刷新
#pragma mark ————————————————————————————————
#pragma mark 设置变量
@dynamic isPullUpRefreshing;
-(BOOL)isPullUpRefreshing{
    id i = objc_getAssociatedObject(self, @selector(isPullUpRefreshing));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
-(void)setIsPullUpRefreshing:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isPullUpRefreshing),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic isPullUpRefreshInit;
-(BOOL)isPullUpRefreshInit{
    id i = objc_getAssociatedObject(self, @selector(isPullUpRefreshInit));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
- (void)setIsPullUpRefreshInit:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isPullUpRefreshInit),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic isOpacityAdded_pull;
-(BOOL)isOpacityAdded_pull{
    id i = objc_getAssociatedObject(self, @selector(isOpacityAdded_pull));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
- (void)setIsOpacityAdded_pull:(BOOL)params{
    objc_setAssociatedObject(self, @selector(isOpacityAdded_pull),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic prepareToRefresh_pull;
-(BOOL)prepareToRefresh_pull{
    id i = objc_getAssociatedObject(self, @selector(prepareToRefresh_pull));
    if (i) {
        return [i boolValue];
    }
    return NO;
}
- (void)setPrepareToRefresh_pull:(BOOL)params{
    objc_setAssociatedObject(self, @selector(prepareToRefresh_pull),@(params), OBJC_ASSOCIATION_RETAIN);
}
@dynamic inBubbleView_pull;
-(UIImageView *)inBubbleView_pull{
    id i = objc_getAssociatedObject(self, @selector(inBubbleView_pull));
    if (i) {
        return (UIImageView *)i;
    }
    return nil;
}
- (void)setInBubbleView_pull:(UIImageView *)params{
    objc_setAssociatedObject(self, @selector(inBubbleView_pull),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic outBubbleView_pull;
-(UIImageView *)outBubbleView_pull{
    id i = objc_getAssociatedObject(self, @selector(outBubbleView_pull));
    if (i) {
        return (UIImageView *)i;
    }
    return nil;
}
- (void)setOutBubbleView_pull:(UIImageView *)params{
    objc_setAssociatedObject(self, @selector(outBubbleView_pull),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic opacityAnimation_pull;
-(CABasicAnimation *)opacityAnimation_pull{
    id i = objc_getAssociatedObject(self, @selector(opacityAnimation_pull));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setOpacityAnimation_pull:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(opacityAnimation_pull),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic outposAnimation_pull;
-(CABasicAnimation *)outposAnimation_pull{
    id i = objc_getAssociatedObject(self, @selector(outposAnimation_pull));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setOutposAnimation_pull:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(outposAnimation_pull),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic inposAnimation_pull;
-(CABasicAnimation *)inposAnimation_pull{
    id i = objc_getAssociatedObject(self, @selector(inposAnimation_pull));
    if (i) {
        return (CABasicAnimation *)i;
    }
    return nil;
}
- (void)setInposAnimation_pull:(CABasicAnimation *)params{
    objc_setAssociatedObject(self, @selector(inposAnimation_pull),params, OBJC_ASSOCIATION_RETAIN);
}
@dynamic pullUpRefreshBlock;
-(PullUpRefreshBlockIn)pullUpRefreshBlock{
    id i = objc_getAssociatedObject(self, @selector(pullUpRefreshBlock));
    if (i) {
        return (PullUpRefreshBlockIn)i;
    }
    return nil;
}
- (void)setPullUpRefreshBlock:(PullUpRefreshBlockIn)params{
    objc_setAssociatedObject(self, @selector(pullUpRefreshBlock),params, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark -
#pragma mark --上拉刷新构造函数
-(void)initPullUpRefreshCompletion:(PullUpRefreshBlockIn)completion{
    self.pullUpRefreshBlock = completion;
    [self initPullUpRefresh];
}

-(void)initPullUpRefresh{
    self.isPullUpRefreshInit = YES;
    self.isPullUpRefreshing = NO;
    [self initPullUpRefreshBubbleView];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark -
-(void)initPullUpRefreshBubbleView{
    [self.inBubbleView_pull.layer removeAllAnimations];
    [self.outBubbleView_pull.layer removeAllAnimations];
    
    [self.inBubbleView_pull removeFromSuperview];
    [self.outBubbleView_pull removeFromSuperview];
    
    self.inBubbleView_pull = [[UIImageView alloc] init];
    self.inBubbleView_pull.alpha = 1.f;
    [self.inBubbleView_pull setImage:[UIImage imageNamed:@"refreshBubble_blue"]];
    
    [self.inBubbleView_pull.layer setZPosition:-1.0];
    
    self.outBubbleView_pull = [[UIImageView alloc] init];
    self.outBubbleView_pull.alpha = 1.f;
    [self.outBubbleView_pull setImage:[UIImage imageNamed:@"refreshBubble_red"]];
    [self.outBubbleView_pull.layer setZPosition:1.0];
}

-(CABasicAnimation *)pullOpacityAnimation{
    if (!self.opacityAnimation_pull) {
        self.opacityAnimation_pull = [CABasicAnimation animationWithKeyPath:@"opacity"];
        self.opacityAnimation_pull.fromValue = @1;
        self.opacityAnimation_pull.toValue = @0.1;
        self.opacityAnimation_pull.duration = 0.2f;
        self.opacityAnimation_pull.delegate = self;
        self.opacityAnimation_pull.autoreverses = YES;
        self.opacityAnimation_pull.repeatCount = 1;
        self.opacityAnimation_pull.fillMode = kCAFillModeForwards;
        self.opacityAnimation_pull.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.opacityAnimation_pull setValue:@"opacityAnimation" forKey:@"UIScrollView_PullUpRefresh_XY_RedOpacityAnimation_ValueKey"];
        self.opacityAnimation_pull.removedOnCompletion = YES;
    }
    return self.opacityAnimation_pull;
}

-(void)pullBeginPullRefreshTransformAnimation{
    if (!self.isPullUpRefreshing) {
        self.isPullUpRefreshing = YES;
        
        self.outposAnimation_pull = [CABasicAnimation animationWithKeyPath:@"position"];
        self.outposAnimation_pull.fromValue = [NSValue valueWithCGPoint:(CGPoint){self.contentSize.width/2-7.5,self.contentSize.height+5+refreshViewHeight_pull/2}];
        self.outposAnimation_pull.toValue = [NSValue valueWithCGPoint:(CGPoint){self.contentSize.width/2+7.5,self.contentSize.height+5+refreshViewHeight_pull/2}];
        self.outposAnimation_pull.duration = .5f;
        self.outposAnimation_pull.delegate = self;
        self.outposAnimation_pull.repeatCount = -1;
        self.outposAnimation_pull.fillMode = kCAFillModeForwards;
        self.outposAnimation_pull.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.outposAnimation_pull.removedOnCompletion = NO;
        
        [self.outposAnimation_pull setValue:@"outposAnimation" forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_ValueKey"];
        
        [self.outBubbleView_pull.layer addAnimation:self.outposAnimation_pull forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_AnimationKey"];
        
        self.inposAnimation_pull = [CABasicAnimation animationWithKeyPath:@"position"];
        self.inposAnimation_pull.fromValue = [NSValue valueWithCGPoint:(CGPoint){self.contentSize.width/2+7.5,self.contentSize.height+5+refreshViewHeight_pull/2}];
        self.inposAnimation_pull.toValue = [NSValue valueWithCGPoint:(CGPoint){self.contentSize.width/2-7.5,self.contentSize.height+5+refreshViewHeight_pull/2}];
        self.inposAnimation_pull.duration = .5f;
        self.inposAnimation_pull.delegate = self;
        self.inposAnimation_pull.repeatCount = -1;
        self.inposAnimation_pull.fillMode = kCAFillModeForwards;
        self.inposAnimation_pull.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.inposAnimation_pull.removedOnCompletion = NO;
        [self.inposAnimation_pull setValue:@"inposAnimation" forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_ValueKey"];
        
        [self.inBubbleView_pull.layer addAnimation:self.inposAnimation_pull forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_AnimationKey"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isDownRefrshing) {
                self.isPullUpRefreshing = NO;
                return;
            }
            if (self.pullUpRefreshBlock) {
                self.pullUpRefreshBlock(self);
            }
        });
    }
}

-(void)backToNormalPullUpState{
    self.contentInset = UIEdgeInsetsZero;
    self.isPullUpRefreshing = NO;
    self.outBubbleView_pull.alpha = 0.f;
    self.inBubbleView_pull.alpha = 0.f;
    [self.outBubbleView_pull.layer removeAllAnimations];
    [self.inBubbleView_pull.layer removeAllAnimations];
    [self.outBubbleView_pull removeFromSuperview];
    [self.inBubbleView_pull removeFromSuperview];
}

-(void)endPullUpRefresh{
    if (!self.isPullUpRefreshing) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f animations:^{
            self.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            [self.inBubbleView_pull.layer removeAllAnimations];
            [self.outBubbleView_pull.layer removeAllAnimations];
        }];
        [UIView animateWithDuration:0.7f animations:^{
            self.inBubbleView_pull.alpha = 0.0;
            self.outBubbleView_pull.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self.outBubbleView_pull removeFromSuperview];
            [self.inBubbleView_pull removeFromSuperview];
            self.isPullUpRefreshing = NO;
        }];
    });
}

#pragma mark ————————————————————————————————
#pragma mark 核心函数  动画结束代理
#pragma mark ————————————————————————————————
-(void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //down refresh animation stop
        //下拉刷新动画结束的事件
        NSString *animKey = [anim valueForKey:@"UIScrollView_DownRefresh_XY_RedOpacityAnimation_ValueKey"];
        if (animKey && [animKey isEqualToString:@"opacityAnimation"]) {
            self.prepareToRefresh_down = YES;
            return;
        }
        animKey = [anim valueForKey:@"UIScrollView_DownRefresh_XY_PosAnimation_ValueKey"];
        if (animKey && [animKey isEqualToString:@"outposAnimation"]){
            [CATransaction begin];
            self.outBubbleView_down.layer.zPosition *=-1;
            NSValue *value = self.outposAnimation_down.toValue;
            self.outposAnimation_down.toValue = self.outposAnimation_down.fromValue;
            self.outposAnimation_down.fromValue = value;
            [self.outBubbleView_down.layer addAnimation:self.outposAnimation_down forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_AnimationKey"];
            [CATransaction commit];
            [self.outBubbleView_down.layer setPosition:[self.outposAnimation_down.toValue CGPointValue]];
            return;
        }else if (animKey && [animKey isEqualToString:@"inposAnimation"]){
            [CATransaction begin];
            self.inBubbleView_down.layer.zPosition *=-1;
            NSValue *value = self.inposAnimation_down.toValue;
            self.inposAnimation_down.toValue = self.inposAnimation_down.fromValue;
            self.inposAnimation_down.fromValue = value;
            [self.inBubbleView_down.layer addAnimation:self.inposAnimation_down forKey:@"UIScrollView_DownRefresh_XY_PosAnimation_AnimationKey"];
            [CATransaction commit];
            [self.inBubbleView_down.layer setPosition:[self.inposAnimation_down.toValue CGPointValue]];
            return;
        }
        
        //pullup refresh animation stop
        //上拉刷新动画结束的事件
        animKey = [anim valueForKey:@"UIScrollView_PullUpRefresh_XY_RedOpacityAnimation_ValueKey"];
        if (animKey && [animKey isEqualToString:@"opacityAnimation"]) {
            self.prepareToRefresh_pull = YES;
            return;
        }
        animKey = [anim valueForKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_ValueKey"];
        if (animKey && [animKey isEqualToString:@"outposAnimation"]){
            [CATransaction begin];
            self.outBubbleView_pull.layer.zPosition *=-1;
            NSValue *value = self.outposAnimation_pull.toValue;
            self.outposAnimation_pull.toValue = self.outposAnimation_pull.fromValue;
            self.outposAnimation_pull.fromValue = value;
            [self.outBubbleView_pull.layer addAnimation:self.outposAnimation_pull forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_AnimationKey"];
            [CATransaction commit];
            [self.outBubbleView_pull.layer setPosition:[self.outposAnimation_pull.toValue CGPointValue]];
            return;
        }else if (animKey && [animKey isEqualToString:@"inposAnimation"]){
            [CATransaction begin];
            self.inBubbleView_pull.layer.zPosition *=-1;
            NSValue *value = self.inposAnimation_pull.toValue;
            self.inposAnimation_pull.toValue = self.inposAnimation_pull.fromValue;
            self.inposAnimation_pull.fromValue = value;
            [self.inBubbleView_pull.layer addAnimation:self.inposAnimation_pull forKey:@"UIScrollView_PullUpRefresh_XY_PosAnimation_AnimationKey"];
            [CATransaction commit];
            [self.inBubbleView_pull.layer setPosition:[self.inposAnimation_pull.toValue CGPointValue]];
            return;
        }
    }
}

-(void)dealloc{
    @try {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

#pragma mark ————————————————————————————————
#pragma mark 核心函数  KVO代理
#pragma mark ————————————————————————————————
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object != self || ![keyPath isEqualToString:@"contentOffset"]){
        return;
    }
    NSValue *contentOffsetValue = change[NSKeyValueChangeNewKey];
    CGPoint point;
    [contentOffsetValue getValue:&point];
    if (point.y < 0) {
        if (self.isDownRefreshInit) {
            float maxMove = refreshActiveHeight_down-refreshViewHeight_down-refreshViewHeightAlign;
            float offsetMove = MIN(-point.y,maxMove);
            if (self.contentInset.top != 30){
                self.inBubbleView_down.alpha = 1.f;
                self.outBubbleView_down.alpha = 1.f;
                self.outBubbleView_down.frame = CGRectMake((self.frame.size.width-refreshViewHeight_down)/2,-refreshActiveHeight_down + offsetMove,refreshViewHeight_down,refreshViewHeight_down);
            }
            if (offsetMove == maxMove) {
                if(!self.isOpacityAdded_down && !self.isDownRefrshing){
                    self.isOpacityAdded_down = YES;
                    self.prepareToRefresh_down = NO;
                    [self.outBubbleView_down.layer addAnimation:[self downOpacityAnimation] forKey:@"UIScrollView_DownRefresh_XY_RedOpacityAnimation"];
                }
            }else if(offsetMove + 10 <= maxMove){
                self.prepareToRefresh_down = NO;
            }
            if(self.isDecelerating && self.prepareToRefresh_down){
                [UIView animateWithDuration:0.6f animations:^{
                    self.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
                }];
                [self downBeginRefreshTransformAnimation];
            }
            if (self.isOpacityAdded_down && offsetMove < maxMove && ![self.outBubbleView_down.layer animationForKey:@"UIScrollView_DownRefresh_XY_RedOpacityAnimation"]) {
                self.isOpacityAdded_down = NO;
            }
        }
    }else{
        if (self.isPullUpRefreshInit) {
            CGFloat moveOffsetY = point.y + self.bounds.size.height - self.contentSize.height;
            //            NSLog(@"%.2f,%.2f,%.2f ,%.2f",point.y,self.bounds.size.height,self.contentSize.height,moveOffsetY);
            if (moveOffsetY < 0) {
                [self backToNormalPullUpState];
                return;
            }
            if (self.contentSize.height < self.bounds.size.height) {
                if (self.outBubbleView_pull.alpha != 0) {
                    [self backToNormalPullUpState];
                }
                return;
            }else{
                if (![self.subviews containsObject:self.outBubbleView_pull]) {
                    self.isPullUpRefreshing = NO;
                    [self.outBubbleView_pull.layer removeAllAnimations];
                    [self.inBubbleView_pull.layer removeAllAnimations];
                    self.outBubbleView_pull.alpha = 1.f;
                    self.inBubbleView_pull.alpha = 1.f;
                    self.inBubbleView_pull.frame = (CGRect){(int)((self.contentSize.width-refreshViewHeight_pull)/2),(self.contentSize.height)+refreshViewHeightAlign,refreshViewHeight_pull,refreshViewHeight_pull};
                    self.outBubbleView_pull.frame = (CGRect){(int)((self.contentSize.width-refreshViewHeight_pull)/2),self.contentSize.height+70+refreshViewHeightAlign,refreshViewHeight_pull,refreshViewHeight_pull};
                    self.inBubbleView_pull.alpha = 1.f;
                    [self addSubview:self.outBubbleView_pull];
                    [self addSubview:self.inBubbleView_pull];
                }
            }
            moveOffsetY = MIN(moveOffsetY, 70);
            if (self.contentInset.bottom != 30) {
                self.outBubbleView_pull.frame = (CGRect){(int)((self.contentSize.width-refreshViewHeight_pull)/2),self.contentSize.height+70+refreshViewHeightAlign-moveOffsetY,refreshViewHeight_pull,refreshViewHeight_pull};
            }
            if (moveOffsetY == 70) {
                if (!self.isOpacityAdded_pull && !self.isPullUpRefreshing) {
                    self.isOpacityAdded_pull = YES;
                    self.prepareToRefresh_pull= NO;
                    [self.outBubbleView_pull.layer addAnimation:[self pullOpacityAnimation] forKey:@"UIScrollView_PullUpRefresh_XY_RedOpacityAnimation"];
                }
            }else if(moveOffsetY <= 60){
                self.prepareToRefresh_pull= NO;
            }
            if (self.isDecelerating && self.prepareToRefresh_pull) {
                [UIView animateWithDuration:0.6f animations:^{
                    self.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
                }];
                [self pullBeginPullRefreshTransformAnimation];
            }
            if (self.isOpacityAdded_pull && moveOffsetY < 70 && ![self.outBubbleView_pull.layer animationForKey:@"UIScrollView_PullUpRefresh_XY_RedOpacityAnimation"]) {
                self.isOpacityAdded_pull = NO;
            }
            
        }
    }
}

@end
