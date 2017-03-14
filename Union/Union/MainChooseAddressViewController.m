//
//  MainChooseAddressViewController.m
//  Union
//
//  Created by xiaoyu on 16/1/29.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import "MainChooseAddressViewController.h"
#import "UNUrlConnection.h"
#import "AdressTableViewCell.h"
#import "AddAddressViewController.h"
#import "MapAddressViewController.h"
#import "UserLoginViewController.h"

@interface MainChooseAddressViewController () <UITableViewDataSource,UITableViewDelegate,AdressTableViewCellDelegate>

@end

@implementation MainChooseAddressViewController{
    UIView *contentView;
    
    UILabel *locationAddressTextLabel;
    
    UILabel *moreUsedAddressLabel;
    UIButton *noLoginSelfAddressChooseView;
    UITableView *selfAddressChooseTableView;
    
    NSMutableArray *contentDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择收货地址";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(235,235,235);
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    //定位地址
    UIView *locationAddressView = [[UIView alloc] init];
    locationAddressView.frame = (CGRect){0,10,WIDTH(contentView),75};
    locationAddressView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:locationAddressView];
    
    UILabel *locationAddressTitleLabel = [[UILabel alloc] init];
    locationAddressTitleLabel.frame = (CGRect){12,0,WIDTH(locationAddressView)-24,35};
    locationAddressTitleLabel.text = @"定位地址";
    locationAddressTitleLabel.textColor = RGBColor(150, 150, 150);
    locationAddressTitleLabel.font = Font(14);
    [locationAddressView addSubview:locationAddressTitleLabel];
    
    UIView *locationAddressTitleLabelSepLine = [[UIView alloc] init];
    locationAddressTitleLabelSepLine.frame = (CGRect){0,BOTTOM(locationAddressTitleLabel)-0.5,WIDTH(locationAddressView),0.5};
    locationAddressTitleLabelSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [locationAddressView addSubview:locationAddressTitleLabelSepLine];
    
    UIView *locationAddressTextView = [[UIView alloc] init];
    locationAddressTextView.frame = (CGRect){0,BOTTOM(locationAddressTitleLabel),WIDTH(locationAddressView),HEIGHT(locationAddressView)-BOTTOM(locationAddressTitleLabel)};
    locationAddressTextView.backgroundColor = locationAddressView.backgroundColor;
    [locationAddressView addSubview:locationAddressTextView];
    [locationAddressTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationAddressTextViewClick)]];
    
    locationAddressTextLabel = [[UILabel alloc] init];
    locationAddressTextLabel.frame = (CGRect){12,0,WIDTH(locationAddressTextView)-24-70,HEIGHT(locationAddressTextView)};
    locationAddressTextLabel.text = @"";
    locationAddressTextLabel.textColor = RGBColor(80, 80, 80);
    locationAddressTextLabel.font = Font(15);
    [locationAddressTextView addSubview:locationAddressTextLabel];
    
    NSString *locationAddress = [UNUserDefaults getLocationAddress];
    if (locationAddress && ![locationAddress isEqualToString:@""]) {
        locationAddressTextLabel.text = locationAddress;
    }else{
        locationAddressTextLabel.text = @"点击定位";
    }
    
    UIButton *locationAddressRefreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationAddressRefreshButton.frame = (CGRect){WIDTH(locationAddressTextView)-10-70,0,70,HEIGHT(locationAddressTextView)};
    locationAddressRefreshButton.tintColor = RGBColor(80, 80, 80);
    [locationAddressRefreshButton setTitle:@"重新定位" forState:UIControlStateNormal];
    locationAddressRefreshButton.titleLabel.font = Font(14);
    [locationAddressTextView addSubview:locationAddressRefreshButton];
    [locationAddressRefreshButton addTarget:self action:@selector(locationAddressRefreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chooseMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseMoreButton.backgroundColor = RGBColor(250, 250, 250);
    chooseMoreButton.frame = (CGRect){0,BOTTOM(locationAddressView)+10,WIDTH(contentView),40};
    [contentView addSubview:chooseMoreButton];
    [chooseMoreButton addTarget:self action:@selector(chooseMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *chooseMoreButtonTextLabel = [[UILabel alloc] init];
    chooseMoreButtonTextLabel.frame = (CGRect){12,0,WIDTH(chooseMoreButton)-24-70,HEIGHT(chooseMoreButton)};
    chooseMoreButtonTextLabel.text = @"更多地址";
    chooseMoreButtonTextLabel.textColor = RGBColor(80, 80, 80);
    chooseMoreButtonTextLabel.font = Font(15);
    [chooseMoreButton addSubview:chooseMoreButtonTextLabel];
    
    UIImageView *moreImage = [[UIImageView alloc] init];
    moreImage.image = [UIImage imageNamed:@"more"];
    moreImage.frame = (CGRect){WIDTH(chooseMoreButton)-30,(HEIGHT(chooseMoreButton)-11)/2,7,11};
    [chooseMoreButton addSubview:moreImage];
    
    moreUsedAddressLabel = [[UILabel alloc] init];
    moreUsedAddressLabel.frame = (CGRect){0,BOTTOM(chooseMoreButton)+10,WIDTH(contentView),35};
    moreUsedAddressLabel.text = @"   常用地址";
    moreUsedAddressLabel.backgroundColor = RGBColor(250, 250, 250);
    moreUsedAddressLabel.textColor = RGBColor(150, 150, 150);
    moreUsedAddressLabel.font = Font(14);
    [contentView addSubview:moreUsedAddressLabel];
    
    UIView *moreUsedAddressLabelSepLine = [[UIView alloc] init];
    moreUsedAddressLabelSepLine.frame = (CGRect){0,BOTTOM(moreUsedAddressLabel)-0.5,WIDTH(contentView),0.5};
    moreUsedAddressLabelSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:moreUsedAddressLabelSepLine];
    
    [self setupSelfAddressChooseView];
}

-(void)setupSelfAddressChooseView{
    if (!selfAddressChooseTableView) {
        selfAddressChooseTableView = [[UITableView alloc] init];
        selfAddressChooseTableView.frame = (CGRect){0,BOTTOM(moreUsedAddressLabel),WIDTH(contentView),HEIGHT(contentView)-HEIGHT(moreUsedAddressLabel)};
        [contentView addSubview:selfAddressChooseTableView];
        selfAddressChooseTableView.tag = 11101;
        selfAddressChooseTableView.delegate = self;
        selfAddressChooseTableView.dataSource = self;
        selfAddressChooseTableView.showsHorizontalScrollIndicator = NO;
        selfAddressChooseTableView.showsVerticalScrollIndicator = NO;
        selfAddressChooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if (!noLoginSelfAddressChooseView) {
        noLoginSelfAddressChooseView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        noLoginSelfAddressChooseView.tintColor = RGBColor(80, 80, 80);
        noLoginSelfAddressChooseView.backgroundColor = RGBColor(250, 250, 250);
        noLoginSelfAddressChooseView.frame = (CGRect){0,BOTTOM(moreUsedAddressLabel),WIDTH(contentView),40};
        [contentView addSubview:noLoginSelfAddressChooseView];
        [noLoginSelfAddressChooseView setTitle:@"登录后使用常用收货地址" forState:UIControlStateNormal];
        [noLoginSelfAddressChooseView addTarget:self action:@selector(noLoginSelfAddressChooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([UNUserDefaults getIsLogin]) {
        selfAddressChooseTableView.alpha = 1.f;
        noLoginSelfAddressChooseView.alpha = 0.f;
        
        [self reloadContentDataTableView];
    }else{
        selfAddressChooseTableView.alpha = 0.f;
        noLoginSelfAddressChooseView.alpha = 1.f;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UN_LocationDidGetPoiListNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSString *string = [note object];
        if (string && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""]) {
            locationAddressTextLabel.text = string;
        }else{
            locationAddressTextLabel.text = @"定位失败,请稍候再试";
        }
    }];
}

-(void)locationAddressRefreshButtonClick:(UIButton *)button{
    locationAddressTextLabel.text = @"正在定位";
    [[NSNotificationCenter defaultCenter] postNotificationName:UN_LocationDidRequestUpdateNotification object:nil];
}

-(void)locationAddressTextViewClick{
    MainChooseAddressInfo *info = [[MainChooseAddressInfo alloc] init];
    info.name = [UNUserDefaults getLocationAddress];
    info.latitude = [UNUserDefaults getLocationLatitude];
    info.longitude = [UNUserDefaults getLocationLongitude];
    [[NSNotificationCenter defaultCenter] postNotificationName:UN_MainAddressDidChangeNotification object:info];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)chooseMoreButtonClick{
    MapAddressViewController *mapAVC = [[MapAddressViewController alloc] init];
    mapAVC.resultBlock = ^(NSString *name,NSString *address,float latitude,float longitude){
        dispatch_async(dispatch_get_main_queue(), ^{
            MainChooseAddressInfo *info = [[MainChooseAddressInfo alloc] init];
            info.name = name;
            info.latitude = latitude;
            info.longitude = longitude;
            [[NSNotificationCenter defaultCenter] postNotificationName:UN_MainAddressDidChangeNotification object:info];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    [self.navigationController pushViewController:mapAVC animated:YES];
}

-(void)noLoginSelfAddressChooseButtonClick{
    [self pushToLogin];
}

-(void)pushToLogin{
    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:[UserLoginViewController new]];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
    [loginNavi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    if ([loginNavi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = loginNavi.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *ar = imageView.subviews;
                [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                imageView.hidden=YES;
            }
        }
    }
    loginNavi.view.backgroundColor = UN_RedColor;
    loginNavi.navigationBar.barTintColor = UN_RedColor;
    loginNavi.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:loginNavi animated:YES completion:nil];
}

-(void)reloadContentDataTableView{
    [self getAllReceiverAddress];
}

-(void)getAllReceiverAddress{
    [UNUrlConnection getAllReceiverListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        NSArray *array = resultDic[@"content"];
        if ([array isKindOfClass:[NSArray class]] && array && array.count != 0) {
            contentDataArray = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                NSString *detailaddress = obj[@"address"];
                NSString *mapaddress = obj[@"areaName"];
                NSString *name = obj[@"consignee"];
                NSString *idstring = obj[@"id"];
                BOOL isDefault = [obj[@"isDefault"] boolValue];
                NSString *phone = obj[@"phone"];
                NSString *zipCode = obj[@"zipCode"];
                NSString *sex = obj[@"sex"];
                NSString *latitudeString = obj[@"latitude"];
                NSString *longitudeString = obj[@"longitude"];
                
                int sexInt;
                if (sex) {
                    if (![sex isKindOfClass:[NSNull class]] && [sex isEqualToString:@"female"]) {
                        sexInt = 1;
                    }
                }
                
                float latitude,longitude;
                if (latitudeString && ![latitudeString isKindOfClass:[NSNull class]]) {
                    latitude = [obj[@"latitude"] floatValue];
                }
                if (longitudeString && ![longitudeString isKindOfClass:[NSNull class]]) {
                    longitude = [obj[@"longitude"] floatValue];
                }
                
                AdressInfo *adressInfo = [[AdressInfo alloc] init];
                adressInfo.addressID = [NSString stringWithFormat:@"%lld",[idstring longLongValue]];
                adressInfo.mapAdress = mapaddress;
                adressInfo.detailAdress = detailaddress;
                adressInfo.zipCode = zipCode;
                adressInfo.name = name;
                adressInfo.isDefault = isDefault;
                adressInfo.phone = phone;
                adressInfo.sex = sexInt;
                adressInfo.mapLatitude = latitude;
                adressInfo.mapLongitude = longitude;
                
                [contentDataArray addObject:adressInfo];
                
                [UNUserDefaults saveAdressInfo:adressInfo];
            }];
            [selfAddressChooseTableView reloadData];
        }
    }];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == selfAddressChooseTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return AdressCellViewHeight;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == selfAddressChooseTableView) {
        if (contentDataArray) {
            return contentDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == selfAddressChooseTableView) {
        static NSString *AdressTableViewCellIdentifier = @"AdressTableViewCell11101";
        AdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AdressTableViewCellIdentifier];
        if (!cell) {
            cell = [[AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AdressTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.adressInfo = contentDataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == selfAddressChooseTableView) {
        AdressInfo *address = contentDataArray[indexPath.row];
        MainChooseAddressInfo *info = [[MainChooseAddressInfo alloc] init];
        info.name = address.mapAdress;
        info.latitude = address.mapLatitude;
        info.longitude = address.mapLongitude;
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_MainAddressDidChangeNotification object:info];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)addressTableDidTapEditImage:(AdressTableViewCell *)cell{
    if (!cell.adressInfo) {
        return;
    }
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    aavc.addressInfo = cell.adressInfo;
    [self.navigationController pushViewController:aavc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == selfAddressChooseTableView){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != selfAddressChooseTableView) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AdressInfo *addressInfo = contentDataArray[indexPath.row];
        
        [UNUrlConnection deleteReceiveAddressWithAddressInfo:addressInfo complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:@"删除失败,请稍候重试"];
                runInMainThread(^{
                    [tableView reloadData];
                });
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *type = [messageDic objectForKey:@"type"];
            if (type && [type isKindOfClass:[NSString class]] && [type isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"删除收货地址成功"];
                runInMainThread(^{
                    [contentDataArray removeObject:addressInfo];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                    [tableView reloadData];
                });
                return;
            }else{
                NSString *content = [messageDic objectForKey:@"content"];
                if (content) {
                    [BYToastView showToastWithMessage:content];
                }else{
                    [BYToastView showToastWithMessage:@"删除失败,请稍候重试"];
                }
                runInMainThread(^{
                    [tableView reloadData];
                });
                return;
            }
        }];
    }
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"新增地址" forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,62,20};
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(15);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:aavc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

-(void)viewDidAppear:(BOOL)animated{
    if (contentView) {
        [self setupSelfAddressChooseView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation MainChooseAddressInfo
@end
