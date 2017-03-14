
//
//  UIScrollView+PullUpRefresh.h
//  TableRefresh
//
//  Created by xiaoyu on 15/7/17.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PullUpRefreshBlockIn)(id refreshView);
typedef void (^DownRefreshBlockIn)(id refreshView);

@interface UIScrollView (XYRefresh)

@property (nonatomic) DownRefreshBlockIn downRefreshBlock;

@property (nonatomic) PullUpRefreshBlockIn pullUpRefreshBlock;

#pragma mark -
#pragma mark --下拉刷新构造函数
-(void)initDownRefreshCompletion:(DownRefreshBlockIn)completion;
-(void)initDownRefresh;
#pragma mark --下拉刷新结束函数
-(void)endDownRefresh;


#pragma mark -
#pragma mark --上拉刷新构造函数
-(void)initPullUpRefreshCompletion:(PullUpRefreshBlockIn)completion;
-(void)initPullUpRefresh;
#pragma mark --上拉刷新结束函数
-(void)endPullUpRefresh;



#pragma mark -
#pragma mark 下拉刷新变量
@property (nonatomic) BOOL isDownRefreshInit;
@property (nonatomic) BOOL isDownRefrshing;
@property (nonatomic) BOOL isOpacityAdded_down;
@property (nonatomic) BOOL prepareToRefresh_down;
@property (nonatomic,strong) UIImageView *outBubbleView_down,*inBubbleView_down;
@property (nonatomic,strong) CABasicAnimation *opacityAnimation_down,*outposAnimation_down,*inposAnimation_down;


#pragma mark -
#pragma mark 上拉刷新变量
@property (nonatomic) BOOL isPullUpRefreshing;
@property (nonatomic) BOOL isPullUpRefreshInit;
@property (nonatomic) BOOL isOpacityAdded_pull;
@property (nonatomic) BOOL prepareToRefresh_pull;
@property (nonatomic,strong) CABasicAnimation *opacityAnimation_pull,*outposAnimation_pull,*inposAnimation_pull;
@property (nonatomic,strong) UIImageView *inBubbleView_pull,*outBubbleView_pull;
@end
