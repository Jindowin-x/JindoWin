//
//  MainViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//


#import "MainViewController.h"

#import "ShopInfo.h"
#import "ViewController.h"
#import "ShopsViewController.h"
#import "ShopsTableViewCell.h"
#import "SearchViewController.h"
#import "ShopDetailViewController.h"
#import "LifeHelperViewController.h"
#import "OpenWebViewController.h"

#import "UNUrlConnection.h"

@interface MainViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;

//顶部的轮播父容器
@property (nonatomic,strong) UIView *topCarouselView;
//顶部的轮播容器
@property (nonatomic,strong) UIScrollView *topCarouselScroller;
//顶部的轮播小点
@property (nonatomic,strong) UIPageControl *topCarouselPageControl;
//顶部的轮播数据源
@property (nonatomic,strong) NSArray *topCarouselDataArray;

//顶部的功能区父view
@property (nonatomic,strong) UIView *topFunctionAreaView;


//底部的推荐商家模块父view
@property (nonatomic,strong) UIView *bottomRecommandShopsView;
//底部的推荐商家的显示view
@property (nonatomic,strong) UITableView *recommandShopsTableView;;
//底部的商家推荐数据源
@property (nonatomic,strong) NSMutableArray *recommandShopsDataArray;

@end



@implementation MainViewController{
    UIView *whiteScrollerContent;
    
    NSTimer *fastBannerAutoScrollTimer;
}

//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}


@synthesize contentView;

@synthesize topCarouselView,topCarouselScroller,topCarouselPageControl,topCarouselDataArray;

@synthesize topFunctionAreaView;

@synthesize bottomRecommandShopsView,recommandShopsTableView,recommandShopsDataArray;

-(void)setUpNavigation{
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
}

-(void)leftItemClick{
    
}

-(void)rightItemClick{
    
}

-(void)viewDidLoad{
    UIView *bottomFixView = [[UIView alloc] init];
    bottomFixView.frame = (CGRect){0,HEIGHT(self.view)-100,WIDTH(self.view),200};
    [self.view addSubview:bottomFixView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)};
    contentView.contentSize = (CGSize){WIDTH(contentView),10000};
    contentView.backgroundColor = UN_RedColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    whiteScrollerContent = [[UIView alloc] init];
    whiteScrollerContent.frame = (CGRect){0,0,contentView.contentSize.width,contentView.contentSize.height+1000};
    whiteScrollerContent.backgroundColor = UN_WhiteColor;
    [contentView addSubview:whiteScrollerContent];
    
    //顶部的搜索框  uisearchbar
    float topSearchViewHeight = 44.f;
    UIView *topSearchView = [[UIView alloc] init];
    topSearchView.frame = (CGRect){0,0,WIDTH(self.view),topSearchViewHeight};
    topSearchView.backgroundColor = UN_RedColor;
    [contentView addSubview:topSearchView];
    
    UISearchBar *topSearchBar = [[UISearchBar alloc] init];
    topSearchBar.searchBarStyle = UISearchBarStyleProminent;
    topSearchBar.placeholder = @"搜索商户或商品名称";
    topSearchBar.barTintColor = UN_RedColor;
    [topSearchBar setBackgroundImage:[UIImage new]];
    topSearchBar.frame = (CGRect){0,0,WIDTH(topSearchView)-0*2,HEIGHT(topSearchView)};
    topSearchBar.translucent = YES;
    [topSearchView addSubview:topSearchBar];
    
    UIButton *searchButton = [[UIButton alloc] init];
    searchButton.frame = topSearchBar.frame;
    [topSearchView addSubview:searchButton];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部的轮播图
    float topCarouselScrollerHeight = 140.f;
    topCarouselView = [[UIView alloc] init];
    topCarouselView.frame = (CGRect){0,HEIGHT(topSearchView),WIDTH(self.view),topCarouselScrollerHeight};
    [contentView addSubview:topCarouselView];
    
    topCarouselScroller = [[UIScrollView alloc] init];
    topCarouselScroller.frame  = (CGRect){0,0,WIDTH(topCarouselView),topCarouselScrollerHeight};
    //    topCarouselScroller.backgroundColor = [UIColor redColor];
    [topCarouselView addSubview:topCarouselScroller];
    topCarouselScroller.pagingEnabled = YES;
    topCarouselScroller.showsHorizontalScrollIndicator= NO;
    topCarouselScroller.showsVerticalScrollIndicator = NO;
    topCarouselScroller.delegate = self;
    
    [self initTopCarouselViews];
    
    float topFunctionAreaViewHeight =  IS5_5Inches()?210:170;
    topFunctionAreaView = [[UIView alloc] init];
    topFunctionAreaView.frame = (CGRect){0,HEIGHT(topSearchView)+HEIGHT(topCarouselView),WIDTH(self.view),topFunctionAreaViewHeight};
    topFunctionAreaView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:topFunctionAreaView];
    
    [self initTopFunctionView];
    
    bottomRecommandShopsView = [[UIView alloc] init];
    bottomRecommandShopsView.frame = (CGRect){0,BOTTOM(topFunctionAreaView)+8,WIDTH(self.view),HEIGHT(self.view)-BOTTOM(topFunctionAreaView)-8};
    bottomRecommandShopsView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bottomRecommandShopsView];
    
    [self initBottomRecommandShopsView];
}

-(void)searchButtonClick{
    [self.tabBarController.navigationController pushViewController:[SearchViewController new] animated:YES];
}

-(void)initTopCarouselViews{
    topCarouselPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT(topCarouselView)-15, WIDTH(topCarouselView), 15)];
    topCarouselPageControl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    topCarouselPageControl.alpha = 0;
    topCarouselPageControl.numberOfPages = 0;
    [topCarouselPageControl addTarget:self action:@selector(topCarouselPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [topCarouselView addSubview:topCarouselPageControl];
    
    [self setupTopCarouselWithArray:nil];
    [self getTopCarouselData];
}

-(void)getTopCarouselData{
    [UNUrlConnection getMainViewCarouselComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *listArray = resultDic[@"content"];
            [self setupTopCarouselWithArray:listArray];
        }
    }];
}

-(void)setupTopCarouselWithArray:(NSArray *)array{
    if (array && [array isKindOfClass:[NSArray class]] && array.count != 0) {
        topCarouselDataArray = array;
    }else{
        topCarouselDataArray = @[@{@"path":@"banner01"},
                                 @{@"path":@"banner02"},
                                 @{@"path":@"banner03"}];
    }
    
    if (!topCarouselDataArray || topCarouselDataArray.count == 0) {
        return;
    }
    
    topCarouselPageControl.alpha = 1;
    topCarouselPageControl.currentPage = 1;
    topCarouselPageControl.numberOfPages = topCarouselDataArray.count;
    
    [topCarouselScroller setContentOffset:(CGPoint){0,0} animated:YES];
    [topCarouselScroller setContentSize:(CGSize){WIDTH(topCarouselScroller)*topCarouselDataArray.count,0}];
    
    [topCarouselScroller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < topCarouselDataArray.count; i++) {
        UIImageView *imag = [[UIImageView alloc] init];
        imag.frame = (CGRect){WIDTH(topCarouselScroller)*i,0,WIDTH(topCarouselScroller),HEIGHT(topCarouselScroller)};
        
        NSString *imagePath = topCarouselDataArray[i][@"path"];
        imagePath = [UNUrlConnection replaceUrl:imagePath];
        UIImage *immmmmmage = [UIImage imageNamed:imagePath];
        if (immmmmmage) {
            imag.image = immmmmmage;
        }
        imag.contentMode = UIViewContentModeScaleAspectFit;
        imag.clipsToBounds = YES;
        [imag setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        //        NSString *openUrl = topCarouselDataArray[i][@"url"];
        [topCarouselScroller addSubview:imag];
        imag.tag = i;
        imag.userInteractionEnabled = YES;
        [imag addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topCarouselImageTapped:)]];
    }
    
    [fastBannerAutoScrollTimer invalidate];
    fastBannerAutoScrollTimer = nil;
    fastBannerAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fastBannerAutoScrollTimerActive:) userInfo:nil repeats:YES];
}

-(void)topCarouselPageControlValueChanged:(UIPageControl *)pageControl{
    [topCarouselScroller setContentOffset:(CGPoint){pageControl.currentPage * WIDTH(topCarouselScroller),0} animated:YES];
    
    [fastBannerAutoScrollTimer invalidate];
    fastBannerAutoScrollTimer = nil;
    fastBannerAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fastBannerAutoScrollTimerActive:) userInfo:nil repeats:YES];
}

-(void)topCarouselImageTapped:(UITapGestureRecognizer *)tap{
    @try {
        NSString *openUrl = topCarouselDataArray[tap.view.tag][@"url"];
        if (openUrl) {
            OpenWebViewController *openWebVC = [[OpenWebViewController alloc] init];
            openWebVC.openUrl = openUrl;
            [self.navigationController pushViewController:openWebVC animated:YES];
        }
    }
    @catch (NSException *exception) {}
}

-(void)fastBannerAutoScrollTimerActive:(NSTimer *)timer{
    if (topCarouselDataArray == nil || topCarouselDataArray.count == 0 || topCarouselDataArray.count == 1) {
        return;
    }
    int currentPage = (int)topCarouselPageControl.currentPage;
    if (currentPage == topCarouselDataArray.count-1) {
        [topCarouselScroller setContentOffset:CGPointMake(0, 0) animated:NO];
        topCarouselPageControl.currentPage = 0;
    }else{
        [topCarouselScroller setContentOffset:CGPointMake(WIDTH(self.view)*(currentPage+1), 0) animated:YES];
        topCarouselPageControl.currentPage = currentPage+1;
    }
}

-(void)initTopFunctionView{
    [topFunctionAreaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *functionAreaDataSource = self.dataSourceArray;
    if (!self.dataSourceArray) {
        functionAreaDataSource = @[@{@"node":@{@"id":@"5",@"name":@"餐饮美食"}},
                                   @{@"node":@{@"id":@"12",@"name":@"超市购"}},
                                   @{@"node":@{@"id":@"13",@"name":@"水果生鲜"}},
                                   @{@"node":@{@"id":@"14",@"name":@"下午茶"}},
                                   @{@"node":@{@"id":@"15",@"name":@"夜宵"}},
                                   @{@"node":@{@"id":@"16",@"name":@"鲜花蛋糕"}}
                                   ];
    }
    
    int everyWidth = (int)lroundf(WIDTH(topFunctionAreaView)/4.f);
    int imageWidth = IS5_5Inches()?60:46;
    int functionButtonHeight = IS5_5Inches()?100:80;
    int functionLabelFontSize = IS5_5Inches()?14:12;
    for (int i = 0; i < 8; i ++) {
        UIButton *functionButton = [[UIButton alloc] init];
        functionButton.frame = (CGRect){everyWidth*(int)(i%4),functionButtonHeight*(int)(i/4),everyWidth,functionButtonHeight};
        [topFunctionAreaView addSubview:functionButton];
        [functionButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = (CGRect){(everyWidth-imageWidth)/2,((functionButtonHeight-20)-imageWidth)/2,imageWidth,imageWidth};
        [functionButton addSubview:imageview];
        
        UILabel *functionlabel = [[UILabel alloc] init];
        float labelHieght = IS5_5Inches()?30:20;
        functionlabel.frame = (CGRect){0,HEIGHT(functionButton)-labelHieght,everyWidth,labelHieght};
        [functionButton addSubview:functionlabel];
        functionlabel.textAlignment = NSTextAlignmentCenter;
        functionlabel.textColor = UN_FontBlackColor;
        functionlabel.font = Font(functionLabelFontSize);
        
        NSString *name;
        UIImage *ima;
        int tag;
        if (i == 6) {
            name = @"联合外卖";
            tag = 1000;
        }else if (i == 7) {
            name = @"生活助手";
            tag = 2000;
        }else{
            name = functionAreaDataSource[i][@"node"][@"name"];
            tag = [functionAreaDataSource[i][@"node"][@"id"] intValue];
        }
        ima = [UIImage imageNamed:[NSString stringWithFormat:@"func_area_%@",name]];
        if (!ima) {
            ima = [UIImage imageNamed:@"func_area_餐饮美食"];
        }
        functionButton.tag = tag;
        imageview.image = ima;
        functionlabel.text = name;
    }
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    [self initTopFunctionView];
}

-(void)functionButtonClick:(UIButton *)but{
    switch (but.tag) {
        case 1000:{
            ViewController *viewController = (ViewController *)self.tabBarController;
            UIViewController *VC = viewController.viewControllers[1];
            if ([VC isKindOfClass:[ShopsViewController class]]) {
                ShopsViewController *shopsVC = (ShopsViewController *)VC;
                shopsVC.isUnionPS = YES;
                [viewController selectedWithIndex:1];
                [viewController setSelectedViewController:shopsVC];
            }
        }
            break;
        case 2000:{
            LifeHelperViewController *lhVC = [LifeHelperViewController new];
            [self.navigationController pushViewController:lhVC animated:YES];
        }
            break;
        default:{
            ViewController *viewController = (ViewController *)self.tabBarController;
            UIViewController *VC = viewController.viewControllers[1];
            if ([VC isKindOfClass:[ShopsViewController class]]) {
                ShopsViewController *shopsVC = (ShopsViewController *)VC;
                shopsVC.nodesourceid = (int)but.tag;
                [viewController selectedWithIndex:1];
                [viewController setSelectedViewController:shopsVC];
            }
        }
            break;
    }
}

static float bottomRecommandShopsViewHeaderHeight = 40;
-(void)initBottomRecommandShopsView{
    UIView *headView = [[UIView alloc] init];
    headView.frame = (CGRect){0,0,WIDTH(bottomRecommandShopsView),bottomRecommandShopsViewHeaderHeight};
    [bottomRecommandShopsView addSubview:headView];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(headView)-0.5,WIDTH(headView),0.5};
    sepLine.backgroundColor = UN_LineSeperateColor;
    [headView addSubview:sepLine];
    
    UIView *tagView = [[UIView alloc] init];
    tagView.frame = (CGRect){10,10,2,HEIGHT(headView)-10*2};
    tagView.backgroundColor = UN_RedColor;
    [headView addSubview:tagView];
    
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.frame = (CGRect){14,0,WIDTH(headView)-14*2,HEIGHT(headView)};
    tagLabel.text = @"推荐商家";
    tagLabel.textColor = UN_FontBlackColor;
    tagLabel.font = IS5_5Inches()?Font(15):Font(13);
    tagLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:tagLabel];
    
    
    recommandShopsTableView = [[UITableView alloc] init];
    recommandShopsTableView.frame = (CGRect){0,BOTTOM(headView),WIDTH(bottomRecommandShopsView),200};
    //    recommandShopsTableView.alpha = 0;
    recommandShopsTableView.tag = 10001;
    recommandShopsTableView.delegate = self;
    recommandShopsTableView.dataSource = self;
    recommandShopsTableView.scrollEnabled = NO;
    recommandShopsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bottomRecommandShopsView addSubview:recommandShopsTableView];
    
    [self getRecommandShops];
}

-(void)getRecommandShops{
    recommandShopsDataArray = [NSMutableArray array];
    
    [UNUrlConnection getMainPageRecomandShopsComplete:^(NSDictionary *resultDic, NSString *errorString) {
        NSArray *contentArray = resultDic[@"content"];
        if (contentArray && [contentArray isKindOfClass:[NSArray class]] && contentArray.count > 0) {
            [contentArray enumerateObjectsUsingBlock:^(NSDictionary *shopDic, NSUInteger idx, BOOL *stop) {
                ShopInfo *info = [ShopInfo shopInfoWithNetWorkDictionary:shopDic];
                [recommandShopsDataArray addObject:info];
                
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            }];
        }else{
            [BYToastView showToastWithMessage:@"获取推荐商家失败,请稍候再试"];
        }
    }];
    
    //测试数据
    //    
    //    ShopInfo *info1 = [[ShopInfo alloc] init];
    //    info1.name = @"味必鲜排骨米饭";
    //    info1.isSelfDelivery = YES;
    //    info1.businessState = ShopInfoBusinessStateOpen;
    //    info1.minBuyNumber = 30;
    //    info1.deliveryNumber = 5;
    //    info1.starJudge = 3;
    //    info1.monthSaleNumber = 99;
    //    info1.juanEnabel = YES;
    //    info1.piaoEnabel = YES;
    //    info1.fuEnabel = YES;
    //    info1.peiEnabel = YES;
    //    info1.deliveryAverage = @"44";
    //    info1.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info1.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info1.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加917吃货节14:00档",
    //                                @"减": @"满90元减20元"};
    //    
    //    [recommandShopsDataArray addObject:info1];
    //    
    //    ShopInfo *info2 = [[ShopInfo alloc] init];
    //    info2.name = @"天禧海鲜馆";
    //    info2.businessState = ShopInfoBusinessStateBreak;
    //    info2.minBuyNumber = 50;
    //    info2.deliveryNumber = 0;
    //    info2.starJudge = 3;
    //    info2.monthSaleNumber = 99;
    //    info2.peiEnabel = YES;
    //    info2.deliveryAverage = @"44";
    //    info2.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info2.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info2.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",};
    //    
    //    [recommandShopsDataArray addObject:info2];
    //    
    //    ShopInfo *info3 = [[ShopInfo alloc] init];
    //    info3.name = @"民以食为天";
    //    info3.businessState = ShopInfoBusinessStateBreak;
    //    info3.minBuyNumber = 50;
    //    info3.deliveryNumber = 0;
    //    info3.starJudge = 3;
    //    info3.monthSaleNumber = 99;
    //    info3.piaoEnabel = YES;
    //    info3.deliveryAverage = @"44";
    //    info3.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info3.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info3.huodongDictionary = @{@"减": @"新用户在线支付满30减5元"};
    //    
    //    [recommandShopsDataArray addObject:info3];
    //    
    //    ShopInfo *info4 = [[ShopInfo alloc] init];
    //    info4.name = @"锅巴饭";
    //    info4.businessState = ShopInfoBusinessStateBreak;
    //    info4.minBuyNumber = 25;
    //    info4.deliveryNumber = 0;
    //    info4.starJudge = 3;
    //    info4.monthSaleNumber = 99;
    //    info4.fuEnabel = YES;
    //    info4.deliveryAverage = @"44";
    //    info4.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info4.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info4.huodongDictionary = @{@"新": @"新用户在线支付满30减5元"};
    //    
    //    [recommandShopsDataArray addObject:info4];
    
    [self reloadTableView];
}

-(void)reloadTableView{
    CGFloat tableHeight = [ShopsTableViewCell staticHeightWithShopInfos:[NSArray arrayWithArray:recommandShopsDataArray]];
    CGRect tableRect = recommandShopsTableView.frame;
    tableRect.size.height = tableHeight;
    recommandShopsTableView.frame = tableRect;
    recommandShopsTableView.backgroundColor = [UIColor redColor];
    
    [recommandShopsTableView reloadData];
    
    //这里最后要加上64+44 因为导航栏的高度和toolbar的高度
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, TOP(bottomRecommandShopsView)+bottomRecommandShopsViewHeaderHeight+HEIGHT(recommandShopsTableView)+UN_NarbarHeight+UN_TabbarHeight)};
    whiteScrollerContent.frame = (CGRect){0,0,contentView.contentSize.width,contentView.contentSize.height+1000};
}

#pragma mark - scrollview Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == topCarouselScroller){
        [fastBannerAutoScrollTimer invalidate];
        fastBannerAutoScrollTimer = nil;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == topCarouselScroller){
        [fastBannerAutoScrollTimer invalidate];
        fastBannerAutoScrollTimer = nil;
        fastBannerAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fastBannerAutoScrollTimerActive:) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float offsetX = scrollView.contentOffset.x;
    if (scrollView == topCarouselScroller){
        if (offsetX <= 0 || (offsetX > 0 && offsetX < WIDTH(self.view)-50)) {
            topCarouselPageControl.currentPage = 0;
        }else if (offsetX >= WIDTH(self.view)-50 && offsetX < WIDTH(self.view)*2-50){
            topCarouselPageControl.currentPage = 1;
        }else if (offsetX >= WIDTH(self.view)*2-50 && offsetX < WIDTH(self.view)*3-50){
            topCarouselPageControl.currentPage = 2;
        }else if (offsetX >= WIDTH(self.view)*3-50 && offsetX < WIDTH(self.view)*4-50){
            topCarouselPageControl.currentPage = 3;
        }else if (offsetX >= WIDTH(self.view)*4-50 && offsetX < WIDTH(self.view)*5-50){
            topCarouselPageControl.currentPage = 4;
        }else if (offsetX >= WIDTH(self.view)*5-50 && offsetX < WIDTH(self.view)*6-50){
            topCarouselPageControl.currentPage = 5;
        }else if (offsetX >= WIDTH(self.view)*6-50 && offsetX < WIDTH(self.view)*7-50){
            topCarouselPageControl.currentPage = 6;
        }else if (offsetX >= WIDTH(self.view)*7-50 && offsetX < WIDTH(self.view)*8-50){
            topCarouselPageControl.currentPage = 7;
        }else if (offsetX >= WIDTH(self.view)*8-50 && offsetX < WIDTH(self.view)*9-50){
            topCarouselPageControl.currentPage = 8;
        }else if (offsetX >= WIDTH(self.view)*9-50 && offsetX < WIDTH(self.view)*10-50){
            topCarouselPageControl.currentPage = 9;
        }
        
        //        [self loadBannerListImageViewWithIndex:(int)fastBannerPageControl.currentPage+1];
        //        [self loadBannerListImageViewWithIndex:(int)fastBannerPageControl.currentPage];
    }
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recommandShopsTableView) {
        if (recommandShopsDataArray && recommandShopsDataArray.count != 0) {
            return [ShopsTableViewCell staticHeightWithShopInfo:recommandShopsDataArray[indexPath.row]];
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == recommandShopsTableView) {
        if (recommandShopsDataArray) {
            return recommandShopsDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recommandShopsTableView) {
        static NSString *recommandShopsTableViewCellIdentifier = @"recommandShopsTableViewCellIdentifier";
        ShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommandShopsTableViewCellIdentifier];
        if (!cell) {
            cell = [[ShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:recommandShopsTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ShopInfo *info = recommandShopsDataArray[indexPath.row];
        cell.shopInfo = info;
        [cell.imageView setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recommandShopsTableView) {
        ShopDetailViewController *dvc = [[ShopDetailViewController alloc] init];
        dvc.shopInfo = recommandShopsDataArray[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [fastBannerAutoScrollTimer invalidate];
    fastBannerAutoScrollTimer = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [fastBannerAutoScrollTimer invalidate];
    fastBannerAutoScrollTimer = nil;
    fastBannerAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fastBannerAutoScrollTimerActive:) userInfo:nil repeats:YES];
}

@end
