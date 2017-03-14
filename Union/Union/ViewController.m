//
//  ViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ViewController.h"

#import "BYToastView.h"
#import "UNUserDefaults.h"
#import "MainViewController.h"
#import "ShopsViewController.h"
#import "OrdersViewController.h"
#import "UserViewController.h"
#import "UNUrlConnection.h"
#import "AppDelegate.h"
#import "MainChooseAddressViewController.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface ViewController () <UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
}

@property (nonatomic,strong) NSArray *tabNaviViewControllers;

@end


@implementation ViewController{
    BMKLocationService *service;
    BMKGeoCodeSearch *searcher;
    
    UIView *welcomeView;
    UIPageControl *welcomePageControl;
    
    NSString *titleLocationString;
    
    UIView *naviTitleView;
    UILabel *titleLabel;
    UIImageView *downArrawImage;
    
    ShopsViewController *shops;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MainViewController *main =[[MainViewController alloc]init];
    
    shops = [[ShopsViewController alloc]init];
    
    OrdersViewController *orders=[[OrdersViewController alloc]init];
    
    UserViewController *user=[[UserViewController alloc]init];
    
    NSDictionary *normalTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Tabbar_NormalColor};
    NSDictionary *selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Tabbar_SelectedColor};
    
    main.tabBarItem.title=@"首页";
    main.tabBarItem.image=[UIImage imageNamed:@"foot_index"];
    main.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_index_on"];
    [main.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [main.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    shops.tabBarItem.title=@"商家";
    shops.tabBarItem.image=[UIImage imageNamed:@"foot_sj"];
    shops.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_sj_on"];
    [shops.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [shops.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    orders.tabBarItem.title=@"订单";
    orders.tabBarItem.image=[UIImage imageNamed:@"foot_order"];
    orders.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_order_on"];
    [orders.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [orders.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    user.tabBarItem.title=@"我的";
    user.tabBarItem.image=[UIImage imageNamed:@"foot_my"];
    user.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_my_on"];
    [user.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [user.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    self.tabNaviViewControllers = @[main,shops,orders,user];
    self.viewControllers = self.tabNaviViewControllers;
    
    naviTitleView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, WIDTH(self.view), 44)];
    self.navigationItem.titleView = naviTitleView;
    
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = (CGRect){0,0,WIDTH(naviTitleView),HEIGHT(naviTitleView)};
    titleLabel.text = @"正在定位...";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(16);
    [titleLabel sizeToFit];
    [naviTitleView addSubview:titleLabel];
    titleLabel.center = CGPointMake(WIDTH(naviTitleView)/2-10,HEIGHT(naviTitleView)/2);
    titleLabel.userInteractionEnabled = YES;
    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapTrigger:)]];
    
    downArrawImage = [[UIImageView alloc] init];
    //    downArrawImage.image = [UIImage imageNamed:@"down_arrow"];
    //    downArrawImage.frame = (CGRect){RIGHT(titleLabel),(HEIGHT(naviTitleView)-15)/2,15,15};
    [naviTitleView addSubview:downArrawImage];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(naviTitleViewTap)];
    [naviTitleView addGestureRecognizer:tapGes];
    
    self.tabBar.tintColor= [UIColor redColor];
    self.delegate = self;
    self.tabBar.selectedImageTintColor = UN_Tabbar_SelectedColor;
    
    UN_TabbarHeight = HEIGHT(self.tabBar);
    UN_NarbarHeight = 64;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UN_DidSelectTabControllernotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        int num = [[note object] intValue];
        if (num < self.viewControllers.count) {
            [self setSelectedViewController:self.viewControllers[num]];
            [self selectedWithIndex:num];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UN_LocationDidRequestUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self startLocateUserLocation];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UN_MainAddressDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        MainChooseAddressInfo *info = [note object];
        titleLocationString = info.name;
        [UNUserDefaults saveMainAddressLatitude:info.latitude longitude:info.longitude];
        [self updateCurrentNavigation];
    }];
    
    [self startLocateUserLocation];
    [self getMainPageCategroy];
    
    
    
}

-(void)titleLabelTapTrigger:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    if (label.hidden) {
        return;
    }
    NSString *titleText = label.text;
    if ([titleText isEqualToString:@"商家"] ||
        [titleText isEqualToString:@"订单"]) {
        return;
    }
    MainChooseAddressViewController *mcaVC = [[MainChooseAddressViewController alloc] init];
    [self.navigationController pushViewController:mcaVC animated:YES];
}

-(void)judgeToShowWeclome{
    if ([UNUserDefaults getIsNotFirshLuanch]) {
        return;
    }
    welcomeView = [[UIView alloc] init];
    welcomeView.frame = (CGRect){0,0,WIDTH(self.view),HEIGHT(self.view)};
    UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    [window addSubview:welcomeView];
    
    UIScrollView *welcomeScroller = [[UIScrollView alloc] init];
    welcomeScroller.frame = welcomeView.bounds;
    welcomeScroller.contentSize = (CGSize){WIDTH(self.view)*4,HEIGHT(self.view)};
    welcomeScroller.showsHorizontalScrollIndicator = NO;
    welcomeScroller.showsVerticalScrollIndicator = NO;
    welcomeScroller.pagingEnabled = YES;
    welcomeScroller.bounces = NO;
    welcomeScroller.delegate = self;
    welcomeScroller.tag = 12120;
    [welcomeView addSubview:welcomeScroller];
    
    NSArray *welcomeImageArray = @[@"welcome01",@"welcome02",@"welcome03",@"welcome04"];
    
    welcomePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT(welcomeScroller)-55, WIDTH(welcomeScroller), 15)];
    welcomePageControl.numberOfPages = welcomeImageArray.count;
    welcomePageControl.currentPage = 0;
    [welcomeView addSubview:welcomePageControl];
    
    [welcomeImageArray enumerateObjectsUsingBlock:^(NSString *imagename, NSUInteger idx, BOOL *stop) {
        UIImageView *welcomeImage = [[UIImageView alloc] init];
        welcomeImage.image = [UIImage imageNamed:imagename];
        welcomeImage.frame = (CGRect){WIDTH(welcomeScroller)*idx,0,WIDTH(welcomeScroller),HEIGHT(welcomeScroller)};
        [welcomeScroller addSubview:welcomeImage];
        
        if (idx == welcomeImageArray.count - 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.backgroundColor = RGBColor(253, 253, 253);
            button.frame = (CGRect){WIDTH(welcomeScroller)*idx+(WIDTH(welcomeScroller)-150)/2,HEIGHT(welcomeScroller)-100,150,40};
            [welcomeScroller addSubview:button];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 10.f;
            [button setTitleColor:RGBAColor(100, 125, 210,0.8) forState:UIControlStateNormal];
            [button setTitle:@"点击进入" forState:UIControlStateNormal];
            button.titleLabel.font = Font(20);
            [button addTarget:self action:@selector(welcomeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

-(void)welcomeButtonClick:(UIButton *)button{
    [UIView animateWithDuration:0.5f animations:^{
        [welcomeView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        welcomeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [UNUserDefaults setIsNotFirshLuanch:YES];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 12120) {
        float offsetX = scrollView.contentOffset.x;
        if (offsetX <= 0 || (offsetX > 0 && offsetX < WIDTH(self.view)-50)) {
            welcomePageControl.currentPage = 0;
        }else if (offsetX >= WIDTH(self.view)-50 && offsetX < WIDTH(self.view)*2-50){
            welcomePageControl.currentPage = 1;
        }else if (offsetX >= WIDTH(self.view)*2-50 && offsetX < WIDTH(self.view)*3-50){
            welcomePageControl.currentPage = 2;
        }else if (offsetX >= WIDTH(self.view)*3-50 && offsetX < WIDTH(self.view)*4-50){
            welcomePageControl.currentPage = 3;
        }else if (offsetX >= WIDTH(self.view)*4-50 && offsetX < WIDTH(self.view)*5-50){
            welcomePageControl.currentPage = 4;
        }else if (offsetX >= WIDTH(self.view)*5-50 && offsetX < WIDTH(self.view)*6-50){
            welcomePageControl.currentPage = 5;
        }else if (offsetX >= WIDTH(self.view)*6-50 && offsetX < WIDTH(self.view)*7-50){
            welcomePageControl.currentPage = 6;
        }else if (offsetX >= WIDTH(self.view)*7-50 && offsetX < WIDTH(self.view)*8-50){
            welcomePageControl.currentPage = 7;
        }else if (offsetX >= WIDTH(self.view)*8-50 && offsetX < WIDTH(self.view)*9-50){
            welcomePageControl.currentPage = 8;
        }else if (offsetX >= WIDTH(self.view)*9-50 && offsetX < WIDTH(self.view)*10-50){
            welcomePageControl.currentPage = 9;
        }
    }
}

-(void)startLocateUserLocation{
    if (!service) {
        service = [[BMKLocationService alloc] init];
        //启动LocationService
    }
    service.delegate = self;
    [service startUserLocationService];
}

-(void)startSearchWithLocation:(CLLocationCoordinate2D)location{
    if (!searcher) {
        searcher =[[BMKGeoCodeSearch alloc]init];
    }
    searcher.delegate = self;
    //发起检索
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = location;
    BOOL flag = [searcher reverseGeoCode:option];
    if(flag){
    }else{
        NSLog(@"反地址编码解析查询发送失败");
    }
}

-(void)naviTitleViewTap{
    if (self.selectedIndex == 0) {
    }else if (self.selectedIndex == 3){
        UserViewController *user = [self.tabNaviViewControllers objectAtIndex:3];
        [user pushToUserProfileViewController];
    }else{
        return;
    }
}

-(void)hideTitleView{
    titleLabel.hidden = YES;
    downArrawImage.hidden = YES;
}

-(void)showTitleView {
    titleLabel.hidden = NO;
    if (downArrawImage.hidden) {
        titleLabel.center = CGPointMake(WIDTH(naviTitleView)/2,HEIGHT(naviTitleView)/2);
    }else{
        titleLabel.center = CGPointMake(WIDTH(naviTitleView)/2-10,HEIGHT(naviTitleView)/2);
        downArrawImage.frame = (CGRect){RIGHT(titleLabel),(HEIGHT(naviTitleView)-15)/2,15,15};
    }
}

-(void)getMainPageCategroy{
    [UNUrlConnection getMainPageTotalGategoryComplete:^(NSDictionary *resultDic, NSString *errorString) {
        NSArray *contentArray = resultDic[@"content"];
        if (contentArray && [contentArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int i = 0; i < contentArray.count; i++) {
                NSDictionary *dicTmp = contentArray[i];
                [resultArray addObject:@{@"node":[dicTmp objectForKey:@"node"],@"children":[dicTmp objectForKey:@"children"]}];
            }
            
            [UNUserDefaults saveMainGategroy:resultArray];
            [(MainViewController *)self.viewControllers[0] setDataSourceArray:resultArray];
            [(ShopsViewController *)self.viewControllers[1] setDataSourceArray:resultArray];
        }
    }];
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [service stopUserLocationService];
    
    float latitude = userLocation.location.coordinate.latitude;
    
    float longitude = userLocation.location.coordinate.longitude;
    
    [UNUserDefaults saveLocationLatitude:latitude longitude:longitude];
    [UNUserDefaults saveMainAddressLatitude:latitude longitude:longitude];
    
    [self startSearchWithLocation:userLocation.location.coordinate];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    if (error.code == 0) {
        [BYToastView showToastWithMessage:@"模拟器定位失败"];
        return;
    }
    [BYToastView showToastWithMessage:@"定位失败,可能是未开启定位服务"];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)errorCode{
    //    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
    //    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    //    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    //    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    //    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    //    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    //    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    //    BMK_SEARCH_KEY_ERROR,///<key错误
    //    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    //    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
    //    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    if(errorCode != BMK_SEARCH_NO_ERROR){
        NSString *errorString;
        switch (errorCode) {
            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
                errorString = @"检索词有岐义";
                break;
            case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
                errorString = @"检索地址有岐义";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS:
                errorString = @"该城市不支持公交搜索";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
                errorString = @"不支持跨城市公交";
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:
                errorString = @"没有找到检索结果";
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:
                errorString = @"起终点太近";
                break;
            case BMK_SEARCH_KEY_ERROR:
                errorString = @"key错误";
                break;
            case BMK_SEARCH_NETWOKR_ERROR:
                errorString = @"网络连接错误";
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:
                errorString = @"网络连接超时";
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:
                errorString = @"还未完成鉴权，请在鉴权通过后重试";
                break;
            default:
                break;
        }
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }
        return;
    }
    BMKAddressComponent *commponent = result.addressDetail;
    NSArray *poiArray = result.poiList;
    
    NSString *city = commponent.city;
    
    if (city && ![city isEqualToString:@""]) {
        [UNUserDefaults saveCity:city];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (poiArray && poiArray.count >= 1) {
                BMKPoiInfo *poiInfo = poiArray[0];
                [UNUserDefaults saveLocationAddress:poiInfo.name];
            }
            NSString *locationAddress = [UNUserDefaults getLocationAddress];
            if (locationAddress && ![locationAddress isEqualToString:@""]) {
                titleLocationString = locationAddress;
            }else{
                titleLocationString = city;
            }
            [self updateCurrentNavigation];
            [[NSNotificationCenter defaultCenter] postNotificationName:UN_LocationDidGetPoiListNotification object:locationAddress];
        });
    }
}

#pragma mark - UITabbarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[MainViewController class]]) {
        [self selectedWithIndex:0];
    }else if ([viewController isKindOfClass:[ShopsViewController class]]){
        [self selectedWithIndex:1];
    }else if ([viewController isKindOfClass:[OrdersViewController class]]){
        [self selectedWithIndex:2];
    }else if ([viewController isKindOfClass:[UserViewController class]]){
        [self selectedWithIndex:3];
    }
}

-(void)selectedWithIndex:(int)index{
    UIView *view;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                if (imageView.frame.size.height == 64) {
                    view = imageView;
                }
            }
        }
    }
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
    if (index == 0) {
        self.navigationController.view.backgroundColor = UN_RedColor;
        self.navigationController.navigationBar.barTintColor = UN_RedColor;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        view.hidden = NO;
        if (titleLocationString) {
            titleLabel.text = titleLocationString;
            [titleLabel sizeToFit];
        }else{
            titleLabel.text = @"正在定位...";
        }
        downArrawImage.hidden = NO;
        [self showTitleView];
    }else if (index == 1){
        self.navigationController.view.backgroundColor = UN_RedColor;
        self.navigationController.navigationBar.barTintColor = UN_RedColor;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        view.hidden = NO;
        titleLabel.text = @"商家";
        downArrawImage.hidden = YES;
        [self showTitleView];
    }else if (index == 2){
        self.navigationController.view.backgroundColor = UN_RedColor;
        self.navigationController.navigationBar.barTintColor = UN_RedColor;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        view.hidden = NO;
        titleLabel.text = @"订单";
        downArrawImage.hidden = YES;
        [self showTitleView];
    }else if (index == 3){
        self.navigationController.view.backgroundColor = UN_RedColor;
//        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
//        self.navigationController.navigationBar.translucent = NO;
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        
        self.navigationItem.title = @"";
        view.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        titleLabel.text = @"";
        downArrawImage.hidden = YES;
        [self hideTitleView];
    }
}

-(void)updateCurrentNavigation{
    [self selectedWithIndex:(int)self.selectedIndex];
}

-(void)updateOtherNavigation{
    self.navigationController.view.backgroundColor = UN_RedColor;
    self.navigationController.navigationBar.barTintColor = UN_RedColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                if (imageView.frame.size.height == 64) {
                    imageView.hidden = NO;
                }else{
                    imageView.hidden = YES;
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    service.delegate = self;
    searcher.delegate = self;
    if (self.viewControllers.count != 0) {
        [self.selectedViewController viewWillAppear:animated];
    }
    [self judgeToShowWeclome];
}

-(void)viewDidAppear:(BOOL)animated{
    [self updateCurrentNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    service.delegate = nil;
    searcher.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
