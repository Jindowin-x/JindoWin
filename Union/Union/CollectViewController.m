//
//  CollectViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "CollectViewController.h"
#import "ShopDetailViewController.h"

#import "UNUrlConnection.h"
#import "ShopsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIScrollView+XYRefresh.h"


@interface CollectViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@end

@implementation CollectViewController{
    int currentCollectionIndex;
    
    NSMutableArray *contentDataArray;
    
    UIButton *noCollectionShopsButton;
    UILabel *noItemRefreshLabel;
}

@synthesize contentView,contentTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的收藏";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    noCollectionShopsButton = [[UIButton alloc] init];
    noCollectionShopsButton.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    noCollectionShopsButton.alpha = 1;
    [contentView addSubview:noCollectionShopsButton];
    [noCollectionShopsButton addTarget:self action:@selector(noCollectionShopsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    noItemRefreshLabel = [[UILabel alloc] init];
    noItemRefreshLabel.frame = (CGRect){10,WIDTH(noCollectionShopsButton)/2,WIDTH(noCollectionShopsButton)-20,40};
    noItemRefreshLabel.text = @"正在获取收藏店铺";
    noItemRefreshLabel.textColor = RGBColor(140, 140, 140);
    noItemRefreshLabel.font = Font(14);
    noItemRefreshLabel.textAlignment = NSTextAlignmentCenter;
    [noCollectionShopsButton addSubview:noItemRefreshLabel];
    
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 7301;
    contentTableView.alpha = 0;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weak(weakself, self);
    [contentTableView initDownRefresh];
    [contentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getAllCollectionShopWithIndex:1];
    }];
    
    [contentTableView initPullUpRefresh];
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getAllCollectionShopWithIndex:currentCollectionIndex+1];
    }];
    
    //    [self reloadContentDataTableView];
    currentCollectionIndex = 1;
    [self getAllCollectionShopWithIndex:1];
}

-(void)noCollectionShopsButtonClick{
    noItemRefreshLabel.text = @"正在获取收藏店铺";
    [self getAllCollectionShopWithIndex:1];
}

-(void)getAllCollectionShopWithIndex:(int)index{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        [BYToastView showToastWithMessage:@"还未登录"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@(index) forKey:@"pageNumber"];
    [paramsDic setObject:@(20) forKey:@"pageSize"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:token forKey:@"token"];
    
    [UNUrlConnection getAllCollectionWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *listArray = dataDic[@"list"];
            
            if (listArray && [listArray isKindOfClass:[NSArray class]] && listArray.count != 0) {
                NSMutableArray *arrayTmp = [NSMutableArray array];
                [listArray enumerateObjectsUsingBlock:^(NSDictionary *shopDic, NSUInteger idx, BOOL *stop) {
                    ShopInfo *shopInfo = [ShopInfo shopInfoWithNetWorkDictionary:shopDic];
                    if (shopInfo) {
                        [arrayTmp addObject:shopInfo];
                    }
                }];
                
                if (index == 1) {
                    contentDataArray = [NSMutableArray array];
                }
                if (arrayTmp.count > 0) {
                    [contentDataArray addObjectsFromArray:arrayTmp];
                    currentCollectionIndex = index;
                }
                [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:contentDataArray waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:nil waitUntilDone:YES];
            }
        }
        if (index == 1) {
            [contentTableView endDownRefresh];
        }else{
            [contentTableView endPullUpRefresh];
        }
    }];
}

-(void)reloadContentDataTableViewWithArray:(NSMutableArray *)array{
    if (array) {
        noCollectionShopsButton.alpha = 0;
        contentTableView.alpha = 1;
        contentDataArray = array;
        [contentTableView reloadData];
    }else{
        noCollectionShopsButton.alpha = 1;
        contentTableView.alpha = 0;
        noItemRefreshLabel.text = @"您还没有收藏店铺哦";
    }
    //test
    //    return;
    //    contentDataArray = [NSMutableArray array];
    //    ShopInfo *info1 = [[ShopInfo alloc] init];
    //    info1.name = @"味必鲜排骨米饭";
    //    info1.isSelfDelivery = YES;
    //    info1.businessState = ShopInfoBusinessStateOpen;
    //    info1.minBuyNumber = 30;
    //    info1.deliveryNumber = 5;
    //    info1.starJudge = 3.5;
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
    //    [contentDataArray addObject:info1];
    //    
    //    ShopInfo *info2 = [[ShopInfo alloc] init];
    //    info2.name = @"天禧海鲜馆";
    //    info2.isSelfDelivery = YES;
    //    info2.businessState = ShopInfoBusinessStateOpen;
    //    info2.minBuyNumber = 50;
    //    info2.deliveryNumber = 0;
    //    info2.starJudge = 4;
    //    info2.monthSaleNumber = 99;
    //    info2.peiEnabel = YES;
    //    info2.deliveryAverage = @"44";
    //    info2.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info2.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info2.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",};
    //    
    //    [contentDataArray addObject:info2];
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
    //    info3.huodongDictionary = @{@"减": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加双十一特价满20减10",};
    //    
    //    [contentDataArray addObject:info3];
    //    
    //    ShopInfo *info4 = [[ShopInfo alloc] init];
    //    info4.name = @"锅巴饭";
    //    info4.isSelfDelivery = YES;
    //    info4.businessState = ShopInfoBusinessStateBreak;
    //    info4.minBuyNumber = 25;
    //    info4.deliveryNumber = 0;
    //    info4.starJudge = 4.5;
    //    info4.monthSaleNumber = 99;
    //    info4.fuEnabel = YES;
    //    info4.deliveryAverage = @"44";
    //    info4.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info4.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info4.huodongDictionary = @{@"新": @"新用户在线支付满30减5元"};
    //    
    //    [contentDataArray addObject:info4];
    //    
    //    ShopInfo *info5 = [[ShopInfo alloc] init];
    //    info5.name = @"油焖大虾";
    //    info5.businessState = ShopInfoBusinessStateBreak;
    //    info5.minBuyNumber = 10;
    //    info5.deliveryNumber = 10;
    //    info5.starJudge = 5;
    //    info5.monthSaleNumber = 1034;
    //    info5.fuEnabel = YES;
    //    info5.deliveryAverage = @"44";
    //    info5.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info5.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info5.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加双十一特价满20减10",};
    //    
    //    [contentDataArray addObject:info5];
    
    //    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return [ShopsTableViewCell staticHeightWithShopInfo:contentDataArray[indexPath.row]];
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (contentDataArray) {
            return contentDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *ShopsTableViewCellIdentifier7301 = @"ShopsTableViewCellIdentifier7301";
        ShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopsTableViewCellIdentifier7301];
        if (!cell) {
            cell = [[ShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ShopsTableViewCellIdentifier7301];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ShopInfo *info = contentDataArray[indexPath.row];
        cell.shopInfo = info;
        if (info.imageUrl && ![info.imageUrl isKindOfClass:[NSNull class]] && ![info.imageUrl isEqualToString:@""] ) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:cell.shopInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopInfo *info = contentDataArray[indexPath.row];
    ShopDetailViewController *sdVC = [[ShopDetailViewController alloc] init];
    sdVC.shopInfo = info;
    [self.navigationController pushViewController:sdVC animated:YES];
}

-(void)setUpNavigation{
    
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

@end
