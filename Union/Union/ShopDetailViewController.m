//
//  ShopDetailViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/22.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "OrderComfirmViewController.h"
#import "UserLoginViewController.h"

#import "RatingView/RatingView.h"
#import "UNTools.h"
#import "UIView+tag.h"
#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

@interface ShopDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ShopItemDetailTableCellDelegate>

@property (nonatomic,strong) UIView *shopContentView;

@end

@implementation ShopDetailViewController{
    UIImage *rightCollectimage;
    BOOL isShopCollect;
    
    
    float topFunctionViewHeight;
    UIView *topFunctionButtoView;
    NSMutableArray *topFunctionButtonsArray;
    UIView *topSelectedView;
    
    UIScrollView *shopContentScroll;
    
    UIButton *noItemsRefreshButton;
    UILabel *noItemRefreshLabel;
    
    UIView *shopItemContentView;
    UIView *shopItemBuyCarView;
    
    float bottomBuyCarViewHeight;
    UITableView *itemMenuTableView;
    UITableView *itemInfoTableView;
    NSMutableArray *currentShopItemDataArray;
    
    UILabel *buyCarIconBadgeLabel;
    UILabel *buyCarEmptyNumberLabel;
    UILabel *buyCarTotalNumberLabel;
    UILabel *buyCarRightEmptyLabel;
    UIButton *buyCarRightInfoNoteButton;
    
    NSMutableArray *totalBuyCarShopItemArray;
    NSOperationQueue *totalBuyCarOpeationQueue;
    
    //商铺评价
    UIView *judgeTotalRatingViewBottomView;
    UIView *judgeTotalRatingShowView;
    
    UILabel *judgeTotalInfoLabel;
    NSMutableArray *judgeTopHeadButtons;
    int judgeTopHeadButtonSelectIndex;
    UITableView *shopJudgementTableView;
    
    int currentJudgeTotalPageIndex;
    int currentJudgePositivePageIndex;
    int currentJudgeModerratePageIndex;
    int currentJudgeNegativePageIndex;
    NSMutableArray *shopTotalJudgementDataArray;
    NSMutableArray *shopPositiveJudgementDataArray;
    NSMutableArray *shopModerrateJudgementDataArray;
    NSMutableArray *shopNegativeJudgementDataArray;
    NSMutableArray *currentShopJudgementDataArray;
    
    //商铺介绍
    UIScrollView *shopIntroductionTotalView;
    
    UILabel *shopNameLabel;
    UIImageView *shopIntroImage;
    RatingView *shopIntroRatingView;
    UILabel *shopMonthSaleNumberLabel;
    UILabel *businessStateLabel;
    UILabel *shopIntroDeliveryTimeLabel;
    UILabel *shopIntroMinBuyNumberLabel;
    UILabel *shopIntroDeliveryNumberLabel;
    UILabel *shopIntroAddressLabel;
    UILabel *shopIntroTimeLabel;
    UILabel *shopIntroNotificationLabel;
    UILabel *shopIntroductionShortLabel;
    
    //计算高度需要
    UILabel *shopIntroNotificationNoteLabel;
    UIView *shopIntroNotificationView;
    UIView *shopIntroYouHuiView;
    UILabel *shopIntroductionShortNoteLabel;
    UIView *shopIntroductionShortView;
    
    //商品详情弹出界面
    //点击tableviewcell 出来后的商品详细的视图
    UIScrollView *shopItemTotalScrollView;
    UIButton *shopItemTotalCloseButton;
    NSMutableArray *shopItemTotalArray;
    NSMutableArray *shopItemDetailScrollViewArray;
    int totalShopItemsCount;
    int currentDetailItemSelectionIndex;
    
    //购物车弹出界面
    UIButton *shopCarListWholeButton;
    UIView *shopCarListHeaderView;
    UIScrollView *shopCarListScrollView;
    
}

@synthesize shopContentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.shopInfo) {
        self.navigationItem.title = self.shopInfo.name;
    }else{
        self.navigationItem.title = @"商铺详情";
    }
    
    totalBuyCarShopItemArray = [NSMutableArray array];
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    shopContentView = [[UIView alloc] init];
    shopContentView.frame = contentView.bounds;
    shopContentView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:shopContentView];
    
    topFunctionViewHeight = 45;
    if (Is3_5Inches() || Is4Inches()) {
        topFunctionViewHeight = 40;
    }
    
    topFunctionButtoView = [[UIView alloc] init];
    topFunctionButtoView.frame = (CGRect){0,0,WIDTH(contentView),topFunctionViewHeight};
    [shopContentView addSubview:topFunctionButtoView];
    
    NSArray *topbuttonTitle = @[@"点菜",@"评价",@"商家"];
    topFunctionButtonsArray = [NSMutableArray array];
    
    [topbuttonTitle enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *buut = [[UIButton alloc] init];
        buut.frame = (CGRect){WIDTH(topFunctionButtoView)/3*idx,0,WIDTH(topFunctionButtoView)/3,HEIGHT(topFunctionButtoView)};
        [buut setTitle:obj forState:UIControlStateNormal];
        [buut setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
        [buut addTarget:self action:@selector(topFunctionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buut.tag = idx;
        buut.titleLabel.font = Font(14);
        [topFunctionButtoView addSubview:buut];
        [topFunctionButtonsArray addObject:buut];
    }];
    
    UIView *topFunctionBottomSepline = [[UIView alloc] init];
    topFunctionBottomSepline.frame = (CGRect){0,topFunctionViewHeight-0.5,WIDTH(topFunctionButtoView),0.5};
    topFunctionBottomSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [topFunctionButtoView addSubview:topFunctionBottomSepline];
    
    topSelectedView = [[UIView alloc] init];
    topSelectedView.frame = (CGRect){10,topFunctionViewHeight-2,WIDTH(topFunctionButtoView)/3-10*2,2};
    topSelectedView.backgroundColor = UN_RedColor;
    [topFunctionButtoView addSubview:topSelectedView];
    
    shopContentScroll = [[UIScrollView alloc] init];
    shopContentScroll.frame = (CGRect){0,topFunctionViewHeight,WIDTH(shopContentView),HEIGHT(shopContentView)-topFunctionViewHeight};
    shopContentScroll.delegate = self;
    shopContentScroll.bounces = NO;
    shopContentScroll.pagingEnabled = YES;
    shopContentScroll.contentSize = (CGSize){WIDTH(shopContentScroll)*3,HEIGHT(shopContentScroll)};
    shopContentScroll.showsHorizontalScrollIndicator = NO;
    shopContentScroll.showsVerticalScrollIndicator = NO;
    [shopContentView addSubview:shopContentScroll];
    
    [self topFunctionButtonClick:topFunctionButtonsArray[0]];
    
    [self setUpShopItemView];
    
    [self setUpShopJudgementView];
    
    [self setUpShopIntroductionView];
    
    //test
    //    self.selectedItemID = @"5";
    
    //endtest
    
    [self judgePropertyShopItem];
    
    [self getShopDetailInfo];
    
    [self judgeCollectedFormNetwork];
}

static NSArray *collectedArray;
#pragma mark - 从网络获取收藏的信息
-(void)judgeCollectedFormNetwork{
    if (![UNUserDefaults getIsLogin]) {
        [self setShopCollectState:NO];
        return;
    }
    if (self.shopInfo.shopID && ![self.shopInfo.shopID isEqualToString:@""]&&
        ![self.shopInfo.shopID isEqualToString:@"0"]) {
        [UNUrlConnection getIsShopCollectWithShopID:self.shopInfo.shopID complete:^(BOOL isCollect) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setShopCollectState:isCollect];
            });
        }];
    }
}

#pragma mark - 从网络获取商铺信息
-(void)getShopDetailInfo{
    [UNUrlConnection getShopInfoDetailWithShopID:self.shopInfo.shopID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *contentDic = resultDic[@"content"];
        if (contentDic) {
            [self.shopInfo updateWithNetworkDictionary:contentDic];
            [self performSelectorOnMainThread:@selector(reloadCurrentView) withObject:nil waitUntilDone:YES];
        }
    }];
}

-(void)reloadCurrentView{
    float totalJudgeValue = self.shopInfo.starJudge;
    [self setJudgeRatingViewWithValue:totalJudgeValue];
    
    [self resetShopIntrduceView];
}

#pragma mark - 网络获取商铺商品列表
-(void)getShopItemDetails{
    [UNUrlConnection getShopItemsDetailWithShopID:self.shopInfo.shopID complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *contentsArray = resultDic[@"content"];
            if (contentsArray && [contentsArray isKindOfClass:[NSArray class]] && contentsArray.count != 0) {
                NSMutableArray *dataArray = [NSMutableArray array];
                [contentsArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSString *menuID = [NSString stringWithFormat:@"%ld",[[obj objectForKey:@"brandCategory_id"] longValue]];
                    NSString *name = [obj objectForKey:@"name"];
                    
                    NSArray *itemsArray = [obj objectForKey:@"items"];
                    NSMutableDictionary *menuInfoDic = [NSMutableDictionary dictionary];
                    if (name && menuID) {
                        [menuInfoDic setObject:menuID forKey:@"menuid"];
                        [menuInfoDic setObject:name forKey:@"menu"];
                        NSMutableArray *itemsMutableArray = [NSMutableArray array];
                        if (itemsArray && itemsArray.count != 0) {
                            [itemsArray enumerateObjectsUsingBlock:^(NSDictionary *itemDic, NSUInteger idx, BOOL *stop) {
                                ShopItem *item = [ShopItem shopItemWithNetworkDictionary:itemDic];
                                item.shopID = self.shopInfo.shopID;
                                [itemsMutableArray addObject:item];
                            }];
                        }
                        [menuInfoDic setObject:itemsMutableArray forKey:@"data"];
                        [dataArray addObject:menuInfoDic];
                    }
                }];
                [self performSelectorOnMainThread:@selector(reloadContentItemTableViewWithArray:) withObject:dataArray waitUntilDone:YES];
            }else{
                //数组为空
                [self performSelectorOnMainThread:@selector(reloadContentItemTableViewWithArray:) withObject:nil waitUntilDone:YES];
            }
        }
    }];
}

-(void)reloadContentItemTableViewWithArray:(NSMutableArray *)array{
    if (array) {
        itemMenuTableView.alpha = 1.f;
        itemInfoTableView.alpha = 1.f;
        shopItemBuyCarView.alpha = 1.f;
        noItemsRefreshButton.alpha = 0.f;
        noItemRefreshLabel.text = @"";
        
        currentShopItemDataArray = array;
    }else{
        itemMenuTableView.alpha = 0.f;
        itemInfoTableView.alpha = 0.f;
        shopItemBuyCarView.alpha = 0.f;
        noItemsRefreshButton.alpha = 1;
        noItemRefreshLabel.text = @"该商家还没有添加任何商品";
        return;
        //test
        ShopItem *shopItem1 = [[ShopItem alloc] init];
        shopItem1.itemID = @"1";
        shopItem1.itemName = @"米饭";
        shopItem1.soldNum = 6562;
        shopItem1.recommendNum = 112;
        shopItem1.chooseCount = 0;
        shopItem1.price = 3;
        
        ShopItem *shopItem2 = [[ShopItem alloc] init];
        shopItem2.itemID = @"2";
        shopItem2.itemName = @"餐盒费(必选)";
        shopItem2.soldNum = 3333;
        shopItem2.recommendNum = 121;
        shopItem2.chooseCount = 0;
        shopItem2.price = 0.5;
        
        ShopItem *shopItem3 = [[ShopItem alloc] init];
        shopItem3.itemID = @"3";
        shopItem3.itemName = @"小炒肉丝";
        shopItem3.soldNum = 10911;
        shopItem3.recommendNum = 876;
        shopItem3.chooseCount = 0;
        shopItem3.price = 17;
        
        ShopItem *shopItem4 = [[ShopItem alloc] init];
        shopItem4.itemID = @"4";
        shopItem4.itemName = @"香干回锅肉";
        shopItem4.soldNum = 897;
        shopItem4.recommendNum = 141;
        shopItem4.chooseCount = 0;
        shopItem4.price = 19;
        
        ShopItem *shopItem5 = [[ShopItem alloc] init];
        shopItem5.itemID = @"5";
        shopItem5.itemName = @"土豆牛肉盖饭";
        shopItem5.soldNum = 15988;
        shopItem5.recommendNum = 11756;
        shopItem5.chooseCount = 0;
        shopItem5.price = 20;
        
        ShopItem *shopItem6 = [[ShopItem alloc] init];
        shopItem6.itemID = @"6";
        shopItem6.itemName = @"青椒肉丝盖饭";
        shopItem6.soldNum = 1989;
        shopItem6.recommendNum = 990;
        shopItem6.chooseCount = 0;
        shopItem6.price = 14;
        
        ShopItem *shopItem7 = [[ShopItem alloc] init];
        shopItem7.itemID = @"7";
        shopItem7.itemName = @"小茗同学";
        shopItem7.soldNum = 986;
        shopItem7.recommendNum = 134;
        shopItem7.chooseCount = 0;
        shopItem7.price = 5;
        
        ShopItem *shopItem8 = [[ShopItem alloc] init];
        shopItem8.itemID = @"8";
        shopItem8.itemName = @"百事可乐";
        shopItem8.soldNum = 564;
        shopItem8.recommendNum = 187;
        shopItem8.chooseCount = 0;
        shopItem8.price = 3;
        
        ShopItem *shopItem9 = [[ShopItem alloc] init];
        shopItem9.itemID = @"9";
        shopItem9.itemName = @"茶叶蛋";
        shopItem9.soldNum = 19;
        shopItem9.recommendNum = 2;
        shopItem9.chooseCount = 0;
        shopItem9.price = 2;
        
        ShopItem *shopItem10 = [[ShopItem alloc] init];
        shopItem10.itemID = @"10";
        shopItem10.itemName = @"荷包蛋";
        shopItem10.soldNum = 1099;
        shopItem10.recommendNum = 254;
        shopItem10.chooseCount = 0;
        shopItem10.price = 2;
        
        NSArray *shopItemArray1 = @[shopItem1,shopItem2];
        NSDictionary *dic1 = @{@"menu":@"热销",
                               @"data":shopItemArray1};
        [currentShopItemDataArray addObject:dic1];
        [shopItemTotalArray addObjectsFromArray:shopItemArray1];
        
        NSArray *shopItemArray2 = @[shopItem3,shopItem4];
        NSDictionary *dic2 = @{@"menu":@"风味小炒",
                               @"data":shopItemArray2};
        [currentShopItemDataArray addObject:dic2];
        [shopItemTotalArray addObjectsFromArray:shopItemArray2];
        
        NSArray *shopItemArray3 = @[shopItem5,shopItem6];
        NSDictionary *dic3 = @{@"menu":@"盖饭系列",
                               @"data":shopItemArray3};
        [currentShopItemDataArray addObject:dic3];
        [shopItemTotalArray addObjectsFromArray:shopItemArray3];
        
        NSArray *shopItemArray4 = @[shopItem7,shopItem8];
        NSDictionary *dic4 = @{@"menu":@"饮料",
                               @"data":shopItemArray4};
        [currentShopItemDataArray addObject:dic4];
        [shopItemTotalArray addObjectsFromArray:shopItemArray4];
        
        NSArray *shopItemArray5 = @[shopItem9,shopItem10];
        NSDictionary *dic5 = @{@"menu":@"小吃",
                               @"data":shopItemArray5};
        [currentShopItemDataArray addObject:dic5];
        [shopItemTotalArray addObjectsFromArray:shopItemArray5];
    }
    shopItemTotalArray = [NSMutableArray array];
    [currentShopItemDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSArray *arrTmp = [obj objectForKey:@"data"];
        [shopItemTotalArray addObjectsFromArray:arrTmp];
    }];
    //要先计算出所有的item的数量 再去创建detailitem   view
    totalShopItemsCount = (int)shopItemTotalArray.count;
    [self createShopDetailItemInfoView];
    
    [itemMenuTableView reloadData];
    [itemInfoTableView reloadData];
}


#pragma mark - 

-(void)topFunctionButtonClick:(UIButton *)button{
    int buttonTag = (int)button.tag;
    if (buttonTag < 0 || buttonTag > 2) {
        return;
    }
    [self judgeTopClickedButtonWithIndex:buttonTag];
    [shopContentScroll setContentOffset:(CGPoint){WIDTH(shopContentScroll)*buttonTag} animated:YES];
}

-(void)judgeTopClickedButtonWithIndex:(int)index{
    [topFunctionButtonsArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == index) {
            [obj setTitleColor:UN_RedColor forState:UIControlStateNormal];
        }else{
            [obj setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - 店铺商品展示页面
-(void)setUpShopItemView{
    shopItemContentView = [[UIView alloc] init];
    shopItemContentView.frame = (CGRect){0,0,WIDTH(shopContentScroll),HEIGHT(shopContentScroll)};
    shopItemContentView.backgroundColor = [UIColor whiteColor];
    [shopContentScroll addSubview:shopItemContentView];
    
    noItemsRefreshButton = [[UIButton alloc] init];
    noItemsRefreshButton.frame = shopItemContentView.bounds;
    noItemsRefreshButton.alpha = 1;
    [shopItemContentView addSubview:noItemsRefreshButton];
    [noItemsRefreshButton addTarget:self action:@selector(noItemsRefreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    noItemRefreshLabel = [[UILabel alloc] init];
    noItemRefreshLabel.frame = (CGRect){10,WIDTH(noItemsRefreshButton)/2,WIDTH(noItemsRefreshButton)-20,40};
    noItemRefreshLabel.text = @"正在获取商品列表...";
    noItemRefreshLabel.textColor = RGBColor(140, 140, 140);
    noItemRefreshLabel.font = Font(14);
    noItemRefreshLabel.textAlignment = NSTextAlignmentCenter;
    [noItemsRefreshButton addSubview:noItemRefreshLabel];
    
    bottomBuyCarViewHeight = 55;
    
    itemMenuTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,WIDTH(shopItemContentView)/3-10,HEIGHT(shopItemContentView)-bottomBuyCarViewHeight} style:UITableViewStylePlain];
    itemMenuTableView.backgroundColor = RGBColor(240, 240, 240);
    itemMenuTableView.tag = 2211;
    itemMenuTableView.alpha = 0.f;
    itemMenuTableView.delegate = self;
    itemMenuTableView.dataSource = self;
    itemMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [shopItemContentView addSubview:itemMenuTableView];
    
    itemInfoTableView = [[UITableView alloc] initWithFrame:(CGRect){WIDTH(shopItemContentView)/3,0,WIDTH(shopItemContentView)*2/3,HEIGHT(shopItemContentView)-bottomBuyCarViewHeight} style:UITableViewStylePlain];
    itemInfoTableView.backgroundColor = [UIColor whiteColor];
    itemInfoTableView.tag = 2212;
    itemInfoTableView.delegate = self;
    itemInfoTableView.alpha = 0.f;
    itemInfoTableView.dataSource = self;
    itemInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [shopItemContentView addSubview:itemInfoTableView];
    
    shopItemBuyCarView = [[UIView alloc] init];
    shopItemBuyCarView.frame = (CGRect){0,HEIGHT(shopItemContentView)-bottomBuyCarViewHeight,WIDTH(shopItemContentView),bottomBuyCarViewHeight};
    shopItemBuyCarView.alpha = 0.f;
    shopItemBuyCarView.backgroundColor = RGBColor(55, 55, 55);
    [shopItemContentView addSubview:shopItemBuyCarView];
    
    UIButton *buyCarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyCarButton.frame = (CGRect){0,0,bottomBuyCarViewHeight,bottomBuyCarViewHeight};
    [shopItemBuyCarView addSubview:buyCarButton];
    [buyCarButton addTarget:self action:@selector(buyCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *buyCarImageBadgeContentView = [[UIView alloc] init];
    buyCarImageBadgeContentView.backgroundColor = [UIColor blackColor];
    buyCarImageBadgeContentView.frame = (CGRect){5,5,WIDTH(buyCarButton)-10,HEIGHT(buyCarButton)-10};
    buyCarImageBadgeContentView.layer.masksToBounds = YES;
    buyCarImageBadgeContentView.layer.cornerRadius = WIDTH(buyCarImageBadgeContentView)/2;
    buyCarImageBadgeContentView.userInteractionEnabled = NO;
    [buyCarButton addSubview:buyCarImageBadgeContentView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buycar"]];
    imageview.frame = (CGRect){(WIDTH(buyCarButton)-38)/2,HEIGHT(buyCarButton)-27-10,38,27};
    [buyCarButton addSubview:imageview];
    
    buyCarIconBadgeLabel = [[UILabel alloc] init];
    buyCarIconBadgeLabel.textColor = [UIColor whiteColor];
    buyCarIconBadgeLabel.backgroundColor = [UIColor redColor];
    buyCarIconBadgeLabel.frame = (CGRect){bottomBuyCarViewHeight-15-5,3,16,16};
    buyCarIconBadgeLabel.font = Font(13);
    buyCarIconBadgeLabel.textAlignment = NSTextAlignmentCenter;
    buyCarIconBadgeLabel.layer.cornerRadius = HEIGHT(buyCarIconBadgeLabel)/2;
    buyCarIconBadgeLabel.layer.masksToBounds = YES;
    buyCarIconBadgeLabel.text = @"";
    buyCarIconBadgeLabel.alpha = 0.f;
    [buyCarButton addSubview:buyCarIconBadgeLabel];
    
    float bottomRightInfoNoteLabelWidth = 150;
    
    buyCarEmptyNumberLabel = [[UILabel alloc] init];
    buyCarEmptyNumberLabel.textColor = [UIColor whiteColor];
    buyCarEmptyNumberLabel.frame = (CGRect){bottomBuyCarViewHeight+5,0,120,HEIGHT(shopItemBuyCarView)};
    buyCarEmptyNumberLabel.font = Font(17);
    buyCarEmptyNumberLabel.textAlignment = NSTextAlignmentLeft;
    buyCarEmptyNumberLabel.text = @"购物车是空的";
    buyCarEmptyNumberLabel.backgroundColor = shopItemBuyCarView.backgroundColor;
    [shopItemBuyCarView addSubview:buyCarEmptyNumberLabel];
    
    
    buyCarTotalNumberLabel = [[UILabel alloc] init];
    buyCarTotalNumberLabel.textColor = [UIColor whiteColor];
    buyCarTotalNumberLabel.frame = (CGRect){bottomBuyCarViewHeight+5,bottomBuyCarViewHeight-20-7,WIDTH(shopItemBuyCarView)-bottomRightInfoNoteLabelWidth-bottomBuyCarViewHeight-5,20};
    buyCarTotalNumberLabel.font = Font(17);
    buyCarTotalNumberLabel.textAlignment = NSTextAlignmentLeft;
    //    buyCarTotalNumberLabel.alpha = 0;
    buyCarTotalNumberLabel.text = @"共￥ 0 元";
    buyCarTotalNumberLabel.backgroundColor = shopItemBuyCarView.backgroundColor;
    [shopItemBuyCarView addSubview:buyCarTotalNumberLabel];
    
    buyCarRightEmptyLabel = [[UILabel alloc] init];
    buyCarRightEmptyLabel.textColor = [UIColor whiteColor];
    buyCarRightEmptyLabel.frame = (CGRect){WIDTH(shopItemBuyCarView)-100,0,100,HEIGHT(shopItemBuyCarView)};
    buyCarRightEmptyLabel.font = Font(17);
    buyCarRightEmptyLabel.textAlignment = NSTextAlignmentCenter;
    buyCarRightEmptyLabel.text = [NSString stringWithFormat:@"￥%d元起送",self.shopInfo.minBuyNumber];
    buyCarRightEmptyLabel.backgroundColor = shopItemBuyCarView.backgroundColor;
    [shopItemBuyCarView addSubview:buyCarRightEmptyLabel];
    
    
    buyCarRightInfoNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buyCarRightInfoNoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyCarRightInfoNoteButton.frame = (CGRect){WIDTH(shopItemBuyCarView)-bottomRightInfoNoteLabelWidth,0,bottomRightInfoNoteLabelWidth,HEIGHT(shopItemBuyCarView)};
    buyCarRightInfoNoteButton.titleLabel.font = Font(16);
    //    buyCarRightInfoNoteButton.text = @"还差16元起送";
    buyCarRightInfoNoteButton.backgroundColor = [UIColor grayColor];
    [shopItemBuyCarView addSubview:buyCarRightInfoNoteButton];
    
    [buyCarRightInfoNoteButton addTarget:self action:@selector(orderComfirmTapClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self getShopItemDetails];
    //reloadContentItemTableView
}

-(void)noItemsRefreshButtonClick{
    noItemRefreshLabel.text = @"正在获取商品列表...";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getShopItemDetails];
    });
}

-(void)orderComfirmTapClick{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"请先登录"];
        
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
        return;
    }
    /**
     *  todo  商家营业状态
     */
    //    if (self.shopInfo.businessState != ShopInfoBusinessStateOpen) {
    //        [BYToastView showToastWithMessage:@"商家不在营业中"];
    //        return;
    //    }
    //判断金额是否达到要求
    __block float totalNum = 0;
    [totalBuyCarShopItemArray enumerateObjectsUsingBlock:^(ShopItem *obj, NSUInteger idx, BOOL *stop) {
        float shopNumber = obj.price * obj.chooseCount;
        totalNum += shopNumber;
    }];
    
    if (totalNum < self.shopInfo.minBuyNumber) {
        [BYToastView showToastWithMessage:@"没有达到起送金额哦"];
        return;
    }
    [self dismissShopItemDetailView];
    
    [self addOrder];
}

//从网路获取订单信息 成功就跳转到下一个页面
-(void)addOrder{
    NSMutableArray *itemIDArray = [NSMutableArray array];
    NSMutableArray *itemCountArray = [NSMutableArray array];
    for (ShopItem *item in totalBuyCarShopItemArray) {
        [itemIDArray addObject:item.itemID];
        [itemCountArray addObject:[NSString stringWithFormat:@"%d",item.chooseCount]];
    }
    NSString *itemidString = [itemIDArray componentsJoinedByString:@"-"];
    NSString *itemcountString = [itemCountArray componentsJoinedByString:@"-"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:itemidString forKey:@"product_id"];
    [paramsDic setObject:itemcountString forKey:@"product_quantity"];
    
    [UNUrlConnection addToOrderWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        //        NSLog(@"%@,%@",resultDic,errorString);
        NSDictionary *contentDic = resultDic[@"content"];
        if (contentDic && [contentDic isKindOfClass:[NSDictionary class]] && contentDic.count != 0) {
            NSArray *productItemArrayReturn = [contentDic objectForKey:@"product_list"];
            NSMutableArray *productItemArray = [NSMutableArray array];
            for (NSDictionary *itemdic in productItemArrayReturn) {
                NSString *name = itemdic[@"product_name"];
                NSString *unitprice = [NSString stringWithFormat:@"%.1f",[itemdic[@"product_price"] floatValue]];
                NSString *number = [NSString stringWithFormat:@"%d",[itemdic[@"quantity"] intValue]];
                
                if (name && unitprice && number) {
                    [productItemArray addObject:@{@"name":name,@"unitprice":unitprice,@"number":number}];
                }
            }
            
            NSArray *promotionListReturn = [contentDic objectForKey:@"promotion_list"];
            NSMutableArray *promotionItemArray = [NSMutableArray array];
            for (NSDictionary *promotiondic in promotionListReturn) {
                NSString *type = promotiondic[@"promotion_type"];
                NSString *desciption = promotiondic[@"promotion_name"];
                NSString *number = [NSString stringWithFormat:@"%d",[promotiondic[@"promotion_discount"] intValue]];
                
                if (desciption && number) {
                    [promotionItemArray addObject:@{@"type":type,@"desciption":desciption,@"number":number}];
                }
            }
            
            OrderInfo *orderInfo = [[OrderInfo alloc] init];
            orderInfo.orderID = [NSString stringWithFormat:@"%ld",[[contentDic objectForKey:@"cart_id"] longValue]];
            orderInfo.deliveryNumber = [[contentDic objectForKey:@"fee"] floatValue];
            orderInfo.originNumber = [[contentDic objectForKey:@"originalPrice"] floatValue];
            orderInfo.orderNumber = [[contentDic objectForKey:@"effectivePrice"] floatValue];
            orderInfo.orderMenuDetail = productItemArray;
            orderInfo.youhuiDetail = promotionItemArray;
            NSString *deliveryMethod = contentDic[@"shippingMethod"];
            if (deliveryMethod) {
                if ([deliveryMethod intValue] == 0) {
                    orderInfo.isSelfDelivery = YES;
                }else{
                    orderInfo.isSelfDelivery = NO;
                }
            }else{
                orderInfo.isSelfDelivery = NO;
            }
            
            OrderComfirmViewController *OCVC = [[OrderComfirmViewController alloc] init];
            OCVC.shopInfo = self.shopInfo;
            OCVC.orderInfo = orderInfo;
            OCVC.orderInfo.shopID = self.shopInfo.shopID;
            OCVC.orderInfo.shopName = self.shopInfo.name;
            OCVC.shopItemBuyArray = [NSArray arrayWithArray:totalBuyCarShopItemArray];
            [self.navigationController pushViewController:OCVC animated:YES];
        }
    }];
}

-(void)setBuyCarIconBadgeNum:(int)num{
    if (num == 0) {
        buyCarIconBadgeLabel.alpha = 0.f;
    }else{
        buyCarIconBadgeLabel.alpha = 1;
        NSString *numString = [NSString stringWithFormat:@"%d",num];
        
        buyCarIconBadgeLabel.text = numString;
        
        CGSize size = [UNTools getSizeWithString:numString andSize:(CGSize){MAXFLOAT,16} andFont:Font(13)];
        buyCarIconBadgeLabel.frame = (CGRect){bottomBuyCarViewHeight-15-5,3,size.width+10,16};
    }
}

-(void)setBuyCarShopTotalNumber:(float)num{
    if (num <= 0.1f) {
        buyCarTotalNumberLabel.alpha = 0.f;
        buyCarEmptyNumberLabel.alpha = 1.f;
        buyCarRightEmptyLabel.text = [NSString stringWithFormat:@"￥%d元起送",self.shopInfo.minBuyNumber];
        buyCarRightEmptyLabel.alpha = 1.f;
        
        buyCarRightInfoNoteButton.alpha = 0.f;
    }else{
        if ((num*10)-((int)num)*10 == 0) {
            buyCarTotalNumberLabel.text = [NSString stringWithFormat:@"共￥%d 元",(int)num];
        }else{
            buyCarTotalNumberLabel.text = [NSString stringWithFormat:@"共￥%.1f 元",num];
        }
        
        buyCarTotalNumberLabel.alpha = 1.f;
        
        buyCarEmptyNumberLabel.alpha = 0.f;
        
        float remainNum = self.shopInfo.minBuyNumber - num;
        if (remainNum <= 0.1f) {
            //            buyCarRightInfoNoteButton.text = @"选好了";
            [buyCarRightInfoNoteButton setTitle:@"选好了" forState:UIControlStateNormal];
            buyCarRightInfoNoteButton.backgroundColor = UN_RedColor;
        }else{
            if ((remainNum*10)-((int)remainNum)*10 == 0) {
                [buyCarRightInfoNoteButton setTitle:[NSString stringWithFormat:@"还差￥%d 起送",(int)remainNum] forState:UIControlStateNormal];
            }else{
                [buyCarRightInfoNoteButton setTitle:[NSString stringWithFormat:@"还差￥%.1f 起送",remainNum] forState:UIControlStateNormal];
            }
            buyCarRightInfoNoteButton.backgroundColor = [UIColor grayColor];
        }
        buyCarRightInfoNoteButton.alpha = 1.f;
    }
}

#pragma mark - 购物车弹出界面
-(void)buyCarButtonClick:(UIButton *)button{
    if ([self.view.subviews containsObject:shopCarListWholeButton]) {
        return;
    }
    if (!totalBuyCarShopItemArray || totalBuyCarShopItemArray.count == 0) {
        [BYToastView showToastWithMessage:@"还未选择任何商品"];
        return;
    }
    if (!shopCarListWholeButton) {
        shopCarListWholeButton = [[UIButton alloc] init];
        shopCarListWholeButton.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT-bottomBuyCarViewHeight};
        [shopCarListWholeButton addTarget:self action:@selector(shopCarListWholeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        shopCarListHeaderView = [[UIView alloc] init];
        shopCarListHeaderView.frame = (CGRect){0,HEIGHT(shopCarListWholeButton)-100,WIDTH(shopCarListWholeButton),40};
        shopCarListHeaderView.backgroundColor = RGBColor(220, 220, 220);
        [shopCarListWholeButton addSubview:shopCarListHeaderView];
        
        UILabel *shopCarListNameLabel = [[UILabel alloc] init];
        shopCarListNameLabel.textColor = RGBColor(100, 100, 100);
        shopCarListNameLabel.frame = (CGRect){10,0,100,HEIGHT(shopCarListHeaderView)};
        shopCarListNameLabel.font = Font(16);
        shopCarListNameLabel.textAlignment = NSTextAlignmentLeft;
        shopCarListNameLabel.text = @"购物车";
        shopCarListNameLabel.backgroundColor = shopCarListHeaderView.backgroundColor;
        [shopCarListHeaderView addSubview:shopCarListNameLabel];
        
        UIButton *shopCarListClearAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shopCarListClearAllButton.frame = (CGRect){WIDTH(shopCarListHeaderView)-100-10,0,100,HEIGHT(shopCarListHeaderView)};
        [shopCarListClearAllButton setTitle:@"清空购物车" forState:UIControlStateNormal];
        [shopCarListClearAllButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        shopCarListClearAllButton.titleLabel.font = Font(15);
        [shopCarListClearAllButton addTarget:self action:@selector(shopCarListClearAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [shopCarListHeaderView addSubview:shopCarListClearAllButton];
        
        UIView *shopListViewHeaderSeplineView1 = [[UIView alloc] init];
        shopListViewHeaderSeplineView1.frame = (CGRect){0,0,WIDTH(shopCarListHeaderView),1};
        shopListViewHeaderSeplineView1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [shopCarListHeaderView addSubview:shopListViewHeaderSeplineView1];
        
        UIView *shopListViewHeaderSeplineView2 = [[UIView alloc] init];
        shopListViewHeaderSeplineView2.frame = (CGRect){0,HEIGHT(shopCarListHeaderView)-0.5,WIDTH(shopCarListHeaderView),0.5};
        shopListViewHeaderSeplineView2.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [shopCarListHeaderView addSubview:shopListViewHeaderSeplineView2];
        
        shopCarListScrollView = [[UIScrollView alloc] init];
        shopCarListScrollView.frame = (CGRect){0,HEIGHT(shopCarListHeaderView),WIDTH(shopCarListWholeButton),HEIGHT(shopCarListWholeButton)/2};
        shopCarListScrollView.bounces = YES;
        shopCarListScrollView.contentSize = (CGSize){WIDTH(shopCarListWholeButton),HEIGHT(shopCarListWholeButton)/2+1};
        shopCarListScrollView.showsHorizontalScrollIndicator = NO;
        shopCarListScrollView.showsVerticalScrollIndicator = NO;
        [shopCarListWholeButton addSubview:shopCarListScrollView];
    }
    
    [self reloadShopCarListScrollView];
    
    [self.view addSubview:shopCarListWholeButton];
}

static float shopItemViewHeight = 50;
-(void)reloadShopCarListScrollView{
    if (!totalBuyCarShopItemArray || totalBuyCarShopItemArray.count == 0) {
        [self dismissShopCarListView];
        return;
    }
    [shopCarListScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int shopItemCount = (int)totalBuyCarShopItemArray.count;
    
    float scrollerHight = MIN(HEIGHT(shopCarListWholeButton)/2+1, shopItemCount*shopItemViewHeight);
    
    shopCarListScrollView.frame = (CGRect){0,HEIGHT(shopCarListWholeButton)-scrollerHight,WIDTH(shopCarListWholeButton),scrollerHight};
    
    shopCarListHeaderView.frame = (CGRect){0,HEIGHT(shopCarListWholeButton)-scrollerHight-40,WIDTH(shopCarListWholeButton),40};
    
    shopCarListScrollView.contentSize = (CGSize){WIDTH(shopCarListScrollView),MAX(scrollerHight+1, shopItemCount*shopItemViewHeight+1)};
    
    [totalBuyCarShopItemArray enumerateObjectsUsingBlock:^(ShopItem *obj, NSUInteger idx, BOOL *stop) {
        UIView *shopItemView = [[UIView alloc] init];
        shopItemView.frame = (CGRect){0,idx*shopItemViewHeight,WIDTH(shopCarListScrollView),shopItemViewHeight};
        shopItemView.backgroundColor = RGBColor(250, 250, 250);
        [shopCarListScrollView addSubview:shopItemView];
        
        UIButton *itemAddbutton = [[UIButton alloc] init];
        [itemAddbutton setImage:[UIImage imageNamed:@"item_add"] forState:UIControlStateNormal];
        [itemAddbutton addTarget:self action:@selector(shopCarListItemAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemAddbutton.tag = idx;
        itemAddbutton.frame = (CGRect){WIDTH(shopItemView)-10-30,(HEIGHT(shopItemView)-30)/2,30,30};
        [shopItemView addSubview:itemAddbutton];
        
        UIButton *itemMinusButton = [[UIButton alloc] init];
        [itemMinusButton setImage:[UIImage imageNamed:@"item_minus"] forState:UIControlStateNormal];
        [itemMinusButton addTarget:self action:@selector(shopCarListItemMinusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemMinusButton.tag = idx;
        [shopItemView addSubview:itemMinusButton];
        itemMinusButton.frame = (CGRect){WIDTH(shopItemView)-10-30*2-30,(HEIGHT(shopItemView)-30)/2,30,30};
        
        UILabel *itemDetailCountLabel = [[UILabel alloc] init];
        itemDetailCountLabel.frame = (CGRect){WIDTH(shopItemView)-10-35-30,(HEIGHT(shopItemView)-30)/2,35,30};
        itemDetailCountLabel.textColor = RGBColor(100, 100, 100);
        itemDetailCountLabel.textAlignment = NSTextAlignmentCenter;
        itemDetailCountLabel.font = Font(13);
        itemDetailCountLabel.text = [NSString stringWithFormat:@"%d",obj.chooseCount];
        [shopItemView addSubview:itemDetailCountLabel];
        
        UILabel *shopItemNameLabel = [[UILabel alloc] init];
        shopItemNameLabel.textColor = RGBColor(80, 80, 80);
        shopItemNameLabel.frame = (CGRect){10,0,100,HEIGHT(shopItemView)};
        shopItemNameLabel.font = Font(16);
        shopItemNameLabel.textAlignment = NSTextAlignmentLeft;
        shopItemNameLabel.text = obj.itemName;
        [shopItemView addSubview:shopItemNameLabel];
        
        UIView *shopItemSepLine = [[UIView alloc] init];
        shopItemSepLine.frame = (CGRect){0,HEIGHT(shopItemView)-0.5,WIDTH(shopItemView),0.5};
        shopItemSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [shopItemView addSubview:shopItemSepLine];
    }];
}

-(void)dismissShopCarListView{
    [shopCarListWholeButton removeFromSuperview];
}

-(void)shopCarListWholeButtonClick:(UIButton *)button{
    [self dismissShopCarListView];
}

-(void)shopCarListClearAllButtonClick{
    [self operateToRemoveAllItemInShopCarCompelte:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadShopCarListScrollView];
            [self reloadContentItemTableViewWithArray:currentShopItemDataArray];
        });
    }];
}

-(void)shopCarListItemAddButtonClick:(UIButton *)button{
    ShopItem *item = totalBuyCarShopItemArray[button.tag];
    [UIView animateWithDuration:0.1f animations:^{
        [button setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            [button setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
    }];
    if (item.chooseCount == 999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能选择更多了" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    item.chooseCount += 1;
    [self operateWithItem:item typeIsAdd:YES compelte:^{
        [self reloadShopCarListScrollView];
    }];
    [self reloadContentItemTableViewWithArray:currentShopItemDataArray];
}

-(void)shopCarListItemMinusButtonClick:(UIButton *)button{
    ShopItem *item = totalBuyCarShopItemArray[button.tag];
    [UIView animateWithDuration:0.1f animations:^{
        [button setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            [button setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
    }];
    if (item.chooseCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能减少更多了" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    item.chooseCount -= 1;
    [self operateWithItem:item typeIsAdd:NO compelte:^{
        [self reloadShopCarListScrollView];
    }];
    [self reloadContentItemTableViewWithArray:currentShopItemDataArray];
}

#pragma mark - 增加或减少购物车item
-(void)operateWithItem:(ShopItem *)item typeIsAdd:(BOOL)isAdd compelte:(void (^)(void))compelte{
    if (!totalBuyCarOpeationQueue) {
        totalBuyCarOpeationQueue = [NSOperationQueue currentQueue];
        totalBuyCarOpeationQueue.maxConcurrentOperationCount = 1;
    }
    if (isAdd) {
        NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
            [self addToBuyCarWithItem:item];
            if (compelte) {
                compelte();
            }
        }];
        [totalBuyCarOpeationQueue addOperation:blockOp];
    }else{
        NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
            [self removeFromBuyCarWithItem:item];
            if (compelte) {
                compelte();
            }
        }];
        [totalBuyCarOpeationQueue addOperation:blockOp];
    }
}

-(void)operateToRemoveAllItemInShopCarCompelte:(void (^)(void))compelte{
    if (!totalBuyCarOpeationQueue) {
        totalBuyCarOpeationQueue = [NSOperationQueue currentQueue];
        totalBuyCarOpeationQueue.maxConcurrentOperationCount = 1;
    }
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        [self removeAllItemInBuyCar];
        if (compelte) {
            compelte();
        }
    }];
    [totalBuyCarOpeationQueue addOperation:blockOp];
}

-(void)addToBuyCarWithItem:(ShopItem *)item{
    if (!totalBuyCarShopItemArray) {
        totalBuyCarShopItemArray = [NSMutableArray array];
        [totalBuyCarShopItemArray addObject:item];
    }else{
        __block BOOL findExist = NO;
        [totalBuyCarShopItemArray enumerateObjectsUsingBlock:^(ShopItem *obj, NSUInteger idx, BOOL *stop) {
            if (obj.itemID == item.itemID) {
                if (obj.chooseCount > 999) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"选择数量超过上限" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                    [alert show];
                }
                stop = (BOOL *)YES;
                findExist = YES;
            }
        }];
        if (!findExist) {
            [totalBuyCarShopItemArray addObject:item];
        }
    }
    [self refreshTotalShopCarNumber];
}

-(void)removeFromBuyCarWithItem:(ShopItem *)item{
    if (!totalBuyCarShopItemArray) {
        totalBuyCarShopItemArray = [NSMutableArray array];
    }else{
        [totalBuyCarShopItemArray enumerateObjectsUsingBlock:^(ShopItem *obj, NSUInteger idx, BOOL *stop) {
            if (obj.itemID == item.itemID) {
                if (obj.chooseCount <= 0) {
                    [totalBuyCarShopItemArray removeObject:obj];
                }
                stop = (BOOL *)YES;
            }
        }];
    }
    [self refreshTotalShopCarNumber];
}

-(void)removeAllItemInBuyCar{
    if (!totalBuyCarShopItemArray) {
        totalBuyCarShopItemArray = [NSMutableArray array];
    }else{
        for (ShopItem *item in totalBuyCarShopItemArray) {
            item.chooseCount = 0;
        }
        [totalBuyCarShopItemArray removeAllObjects];
    }
    [self refreshTotalShopCarNumber];
}

-(void)refreshTotalShopCarNumber{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!totalBuyCarShopItemArray || totalBuyCarShopItemArray.count == 0) {
            [self setBuyCarIconBadgeNum:0];
            [self setBuyCarShopTotalNumber:0.f];
        }else{
            __block float totalNum = 0;
            __block int totalSelectNum = 0;
            [totalBuyCarShopItemArray enumerateObjectsUsingBlock:^(ShopItem *obj, NSUInteger idx, BOOL *stop) {
                float shopNumber = obj.price * obj.chooseCount;
                totalNum += shopNumber;
                totalSelectNum += obj.chooseCount;
            }];
            [self setBuyCarIconBadgeNum:totalSelectNum];
            [self setBuyCarShopTotalNumber:totalNum];
        }
        
        [itemInfoTableView reloadData];
    });
}

-(void)judgePropertyShopItem{
    if (self.selectedItemID) {
        for (int x = 0; x < currentShopItemDataArray.count; x++) {
            NSDictionary *tabelInfoDic = [currentShopItemDataArray objectAtIndex:x];
            NSArray *tableItemArray = [tabelInfoDic objectForKey:@"data"];
            for (int y = 0; y < tableItemArray.count; y++) {
                ShopItem *item = [tableItemArray objectAtIndex:y];
                if ([item.itemID isEqualToString:self.selectedItemID]) {
                    item.chooseCount += 1;
                    
                    [self operateWithItem:item typeIsAdd:YES compelte:nil];
                    
                    [itemInfoTableView reloadData];
                    
                    [itemInfoTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:y inSection:x] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    [itemMenuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }
        }
    }else{
        [self setBuyCarIconBadgeNum:0];
        [self setBuyCarShopTotalNumber:0.f];
    }
}


#pragma mark - 评价页面
-(void)setUpShopJudgementView{
    UIView *shopJudgeMentTotalView = [[UIView alloc] init];
    shopJudgeMentTotalView.frame = (CGRect){WIDTH(shopContentScroll),0,WIDTH(shopContentScroll),HEIGHT(shopContentScroll)};
    shopJudgeMentTotalView.backgroundColor = [UIColor whiteColor];
    [shopContentScroll addSubview:shopJudgeMentTotalView];
    
    float judgeHeadViewHeight = 80;
    UIView *judgeHeadView = [[UIView alloc] init];
    judgeHeadView.frame = (CGRect){0,0,WIDTH(shopJudgeMentTotalView),judgeHeadViewHeight};
    judgeHeadView.backgroundColor = shopJudgeMentTotalView.backgroundColor;
    [shopJudgeMentTotalView addSubview:judgeHeadView];
    
    UILabel *totalJudgeNoteLabel = [[UILabel alloc] init];
    totalJudgeNoteLabel.frame = (CGRect){10,10,65,15};
    totalJudgeNoteLabel.text = @"综合评分：";
    totalJudgeNoteLabel.textColor = RGBColor(80, 80, 80);
    totalJudgeNoteLabel.textAlignment = NSTextAlignmentLeft;
    totalJudgeNoteLabel.font = Font(12);
    [totalJudgeNoteLabel sizeToFit];
    [judgeHeadView addSubview:totalJudgeNoteLabel];
    
    judgeTotalRatingViewBottomView = [[UIView alloc] init];
    judgeTotalRatingViewBottomView.frame = (CGRect){RIGHT(totalJudgeNoteLabel),10,65,15};
    judgeTotalRatingViewBottomView.backgroundColor = RGBColor(140, 140, 140);
    [judgeHeadView addSubview:judgeTotalRatingViewBottomView];
    
    judgeTotalRatingShowView = [[UIView alloc] init];
    judgeTotalRatingShowView.frame = (CGRect){0,0,0,15};
    judgeTotalRatingShowView.backgroundColor = UN_RedColor;
    [judgeTotalRatingViewBottomView addSubview:judgeTotalRatingShowView];
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = (CGRect){0,0,65,15};
    layer.contents = (id)[UIImage imageNamed:@"star5"].CGImage;
    [judgeTotalRatingViewBottomView.layer setMask:layer];
    
    //    UIView *bacl = [[UIView alloc] init];
    //    bacl.frame = (CGRect){0,0,75,15};
    //    bacl.backgroundColor  =[UIColor redColor];
    //    [judgeTotalRatingViewBottomView addSubview:bacl];
    
    //    for (int i = 0; i<5; i++) {
    //        UIView *vvview = [[UIView alloc] init];
    //        vvview.frame = (CGRect){15*i,0,15,15};
    //        vvview.backgroundColor = [UIColor grayColor];
    //        [judgeTotalRatingViewBottomView addSubview:vvview];
    //
    //    }
    //    
    
    //    RatingView *judgeTotalRatingView;
    //    judgeTotalRatingView = [[RatingView alloc] init];
    //    [judgeTotalRatingView setImagesDeselected:@"star" partlySelected:@"star_on" fullSelected:@"star_on"];
    //    judgeTotalRatingView.frame = (CGRect){0,0,75,15};
    //    [judgeHeadView addSubview:judgeTotalRatingView];
    //    [judgeTotalRatingViewBottomView.layer setMask:judgeTotalRatingView.layer];
    //
    
    judgeTotalInfoLabel = [[UILabel alloc] init];
    judgeTotalInfoLabel.frame = (CGRect){RIGHT(judgeTotalRatingViewBottomView)+10,10,70,15};
    
    judgeTotalInfoLabel.textColor = UN_RedColor;
    judgeTotalInfoLabel.textAlignment = NSTextAlignmentLeft;
    judgeTotalInfoLabel.font = Font(15);
    [judgeHeadView addSubview:judgeTotalInfoLabel];
    
    NSArray *judgeTopTitleStringArray = @[@"全部",@"好评",@"中评",@"差评"];
    judgeTopHeadButtons = [NSMutableArray array];
    
    
    float everyButtonWidth = (WIDTH(judgeHeadView)-20-5*3)/4.f;
    
    [judgeTopTitleStringArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = (CGRect){10+(everyButtonWidth+5)*idx,BOTTOM(judgeTotalInfoLabel)+15,everyButtonWidth,30};
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(140, 140, 140) forState:UIControlStateNormal];
        button.layer.borderColor = RGBColor(200,200, 200).CGColor;
        button.layer.borderWidth = 1;
        button.titleLabel.font = Font(14);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        button.tag = idx;
        [button addTarget:self action:@selector(judgeTopHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [judgeHeadView addSubview:button];
        [judgeTopHeadButtons addObject:button];
    }];
    
    judgeTopHeadButtonSelectIndex = 0;
    UIButton *bbbbb = judgeTopHeadButtons[judgeTopHeadButtonSelectIndex];
    [bbbbb setTitleColor:UN_RedColor forState:UIControlStateNormal];
    bbbbb.layer.borderColor = UN_RedColor.CGColor;
    
    UIView *headSepLineView = [[UIView alloc] init];
    headSepLineView.frame = (CGRect){0,judgeHeadViewHeight-0.5,WIDTH(judgeHeadView),0.5};
    headSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeHeadView addSubview:headSepLineView];
    
    
    shopJudgementTableView = [[UITableView alloc] initWithFrame:(CGRect){0,judgeHeadViewHeight,WIDTH(shopJudgeMentTotalView),HEIGHT(shopJudgeMentTotalView)-judgeHeadViewHeight} style:UITableViewStylePlain];
    shopJudgementTableView.tag = 2221;
    shopJudgementTableView.tagControl = 0;
    shopJudgementTableView.delegate = self;
    shopJudgementTableView.dataSource = self;
    shopJudgementTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [shopJudgeMentTotalView addSubview:shopJudgementTableView];
    
    [shopJudgementTableView initDownRefresh];
    [shopJudgementTableView initPullUpRefresh];
    
    weak(weakself, self);
    [shopJudgementTableView setDownRefreshBlock:^(id refreshView){
        if (shopJudgementTableView.tagControl == 0) {
            [weakself getShopsTotalJudgeDataWithPageIndex:1];
        }else if (shopJudgementTableView.tagControl == 1) {
            [weakself getShopsPositiveJudgeDataWithPageIndex:1];
        }else if (shopJudgementTableView.tagControl == 2) {
            [weakself getShopsModerateJudgeDataWithPageIndex:1];
        }else if (shopJudgementTableView.tagControl == 3) {
            [weakself getShopsNegativeJudgeDataWithPageIndex:1];
        }
    }];
    
    [shopJudgementTableView setDownRefreshBlock:^(id refreshView){
        if (shopJudgementTableView.tagControl == 0) {
            [weakself getShopsTotalJudgeDataWithPageIndex:currentJudgeTotalPageIndex+1];
        }else if (shopJudgementTableView.tagControl == 1) {
            [weakself getShopsPositiveJudgeDataWithPageIndex:currentJudgePositivePageIndex+1];
        }else if (shopJudgementTableView.tagControl == 2) {
            [weakself getShopsModerateJudgeDataWithPageIndex:currentJudgeModerratePageIndex+1];
        }else if (shopJudgementTableView.tagControl == 3) {
            [weakself getShopsNegativeJudgeDataWithPageIndex:currentJudgeNegativePageIndex+1];
        }
    }];
    
    if (!shopTotalJudgementDataArray) {
        shopTotalJudgementDataArray = [NSMutableArray array];
    }
    if (!shopPositiveJudgementDataArray) {
        shopPositiveJudgementDataArray = [NSMutableArray array];
    }
    if (!shopModerrateJudgementDataArray) {
        shopModerrateJudgementDataArray = [NSMutableArray array];
    }
    if (!shopNegativeJudgementDataArray) {
        shopNegativeJudgementDataArray = [NSMutableArray array];
    }
    if (!currentShopJudgementDataArray) {
        currentShopJudgementDataArray = [NSMutableArray array];
    }
    currentJudgeTotalPageIndex = 1;
    currentJudgePositivePageIndex = 1;
    currentJudgeModerratePageIndex = 1;
    currentJudgeNegativePageIndex = 1;
    [self getShopsTotalJudgeDataWithPageIndex:1];
    
    float totalJudgeValue = self.shopInfo.starJudge;
    [self setJudgeRatingViewWithValue:totalJudgeValue];
}

-(void)setJudgeRatingViewWithValue:(float)value{
    judgeTotalInfoLabel.text = [NSString stringWithFormat:@"%.1f 分",value];
    judgeTotalRatingShowView.frame = (CGRect){0,0,WIDTH(judgeTotalRatingViewBottomView)*value/5.f,HEIGHT(judgeTotalRatingShowView)};
}

-(void)judgeTopHeadButtonClick:(UIButton *)button{
    if (button.tag == judgeTopHeadButtonSelectIndex) {
        return;
    }
    judgeTopHeadButtonSelectIndex = (int)button.tag;
    [judgeTopHeadButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == button.tag) {
            [obj setTitleColor:UN_RedColor forState:UIControlStateNormal];
            obj.layer.borderColor = UN_RedColor.CGColor;
        }else{
            [obj setTitleColor:RGBColor(140, 140, 140) forState:UIControlStateNormal];
            obj.layer.borderColor = RGBColor(200,200, 200).CGColor;
        }
    }];
    [shopJudgementTableView setContentOffset:(CGPoint){0,0} animated:YES];
    switch (judgeTopHeadButtonSelectIndex) {
        case 0:{
            [self getShopsTotalJudgeDataWithPageIndex:1];
        }
            break;
        case 1:{
            [self getShopsPositiveJudgeDataWithPageIndex:1];
        }
            break;
        case 2:{
            [self getShopsModerateJudgeDataWithPageIndex:1];
        }
            break;
        case 3:{
            [self getShopsNegativeJudgeDataWithPageIndex:1];
        }
            break;
        default:
            break;
    }
}

//pageindex从1开始  默认一页返回20个
//获取店铺所有评价
-(void)getShopsTotalJudgeDataWithPageIndex:(int)index{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:@(index) forKey:@"pageSize"];
    [paramsDic setObject:@"20" forKey:@"pageNumber"];
    
    [UNUrlConnection getShopJudgeWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *judgeListArray = dataDic[@"list"];
            
            if (judgeListArray && [judgeListArray isKindOfClass:[NSArray class]]) {
                if (index == 1) {
                    shopTotalJudgementDataArray = [NSMutableArray arrayWithArray:judgeListArray];
                }else{
                    [shopTotalJudgementDataArray addObjectsFromArray:judgeListArray];
                }
            }
            
            currentShopJudgementDataArray = [NSMutableArray arrayWithArray:shopTotalJudgementDataArray];
            currentJudgeTotalPageIndex = index;
            shopJudgementTableView.tagControl = 0;
            [self shopJudgementsReloadTable];
            
            int totalNumber = [dataDic[@"total"] intValue];
            int posiNumber = [dataDic[@"positive"] intValue];
            int moderateNumber = [dataDic[@"moderate"] intValue];
            int negativeNumber = [dataDic[@"negative"] intValue];
            
            [self setJudgementButtonTitleWithTotalCount:totalNumber positiveCount:posiNumber moderateCount:moderateNumber negativeCount:negativeNumber];
        }else{
            [BYToastView showToastWithMessage:@"获取评价失败,请稍候再试.."];
        }
        [shopJudgementTableView endDownRefresh];
        [shopJudgementTableView endPullUpRefresh];
    }];
}

//获取店铺所有好评
-(void)getShopsPositiveJudgeDataWithPageIndex:(int)index{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:@"positive" forKey:@"type"];
    [paramsDic setObject:@(index) forKey:@"pageSize"];
    [paramsDic setObject:@"20" forKey:@"pageNumber"];
    
    [UNUrlConnection getShopJudgeWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *judgeListArray = dataDic[@"list"];
            
            if (judgeListArray && [judgeListArray isKindOfClass:[NSArray class]]) {
                if (index == 1) {
                    shopPositiveJudgementDataArray = [NSMutableArray arrayWithArray:judgeListArray];
                }else{
                    [shopPositiveJudgementDataArray addObjectsFromArray:judgeListArray];
                }
            }
            
            currentShopJudgementDataArray = [NSMutableArray arrayWithArray:shopPositiveJudgementDataArray];
            currentJudgePositivePageIndex = index;
            shopJudgementTableView.tagControl = 1;
            [self shopJudgementsReloadTable];
            
            int totalNumber = [dataDic[@"total"] intValue];
            int posiNumber = [dataDic[@"positive"] intValue];
            int moderateNumber = [dataDic[@"moderate"] intValue];
            int negativeNumber = [dataDic[@"negative"] intValue];
            
            [self setJudgementButtonTitleWithTotalCount:totalNumber positiveCount:posiNumber moderateCount:moderateNumber negativeCount:negativeNumber];
        }else{
            [BYToastView showToastWithMessage:@"获取评价失败,请稍候再试.."];
        }
        [shopJudgementTableView endDownRefresh];
        [shopJudgementTableView endPullUpRefresh];
    }];
}

//获取店铺所有中评
-(void)getShopsModerateJudgeDataWithPageIndex:(int)index{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:@"moderate" forKey:@"type"];
    [paramsDic setObject:@(index) forKey:@"pageSize"];
    [paramsDic setObject:@"20" forKey:@"pageNumber"];
    
    [UNUrlConnection getShopJudgeWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *judgeListArray = dataDic[@"list"];
            
            if (judgeListArray && [judgeListArray isKindOfClass:[NSArray class]]) {
                if (index == 1) {
                    shopModerrateJudgementDataArray = [NSMutableArray arrayWithArray:judgeListArray];
                }else{
                    [shopModerrateJudgementDataArray addObjectsFromArray:judgeListArray];
                }
            }
            
            currentShopJudgementDataArray = [NSMutableArray arrayWithArray:shopModerrateJudgementDataArray];
            currentJudgeModerratePageIndex = index;
            shopJudgementTableView.tagControl = 2;
            [self shopJudgementsReloadTable];
            
            int totalNumber = [dataDic[@"total"] intValue];
            int posiNumber = [dataDic[@"positive"] intValue];
            int moderateNumber = [dataDic[@"moderate"] intValue];
            int negativeNumber = [dataDic[@"negative"] intValue];
            
            [self setJudgementButtonTitleWithTotalCount:totalNumber positiveCount:posiNumber moderateCount:moderateNumber negativeCount:negativeNumber];
        }else{
            [BYToastView showToastWithMessage:@"获取评价失败,请稍候再试.."];
        }
        [shopJudgementTableView endDownRefresh];
        [shopJudgementTableView endPullUpRefresh];
    }];
}

//获取店铺所有差评
-(void)getShopsNegativeJudgeDataWithPageIndex:(int)index{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:@"negative" forKey:@"type"];
    [paramsDic setObject:@(index) forKey:@"pageSize"];
    [paramsDic setObject:@"20" forKey:@"pageNumber"];
    
    [UNUrlConnection getShopJudgeWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *judgeListArray = dataDic[@"list"];
            
            if (judgeListArray && [judgeListArray isKindOfClass:[NSArray class]]) {
                if (index == 1) {
                    shopNegativeJudgementDataArray = [NSMutableArray arrayWithArray:judgeListArray];
                }else{
                    [shopNegativeJudgementDataArray addObjectsFromArray:judgeListArray];
                }
            }
            
            currentShopJudgementDataArray = [NSMutableArray arrayWithArray:shopNegativeJudgementDataArray];
            currentJudgeNegativePageIndex = index;
            shopJudgementTableView.tagControl = 3;
            [self shopJudgementsReloadTable];
            
            int totalNumber = [dataDic[@"total"] intValue];
            int posiNumber = [dataDic[@"positive"] intValue];
            int moderateNumber = [dataDic[@"moderate"] intValue];
            int negativeNumber = [dataDic[@"negative"] intValue];
            
            [self setJudgementButtonTitleWithTotalCount:totalNumber positiveCount:posiNumber moderateCount:moderateNumber negativeCount:negativeNumber];
        }else{
            [BYToastView showToastWithMessage:@"获取评价失败,请稍候再试.."];
        }
        [shopJudgementTableView endDownRefresh];
        [shopJudgementTableView endPullUpRefresh];
    }];
}

-(void)setJudgementButtonTitleWithTotalCount:(int)tnum positiveCount:(int)pcount moderateCount:(int)mCount negativeCount:(int)nCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        [(UIButton *)judgeTopHeadButtons[0] setTitle:[NSString stringWithFormat:@"全部(%d)",tnum] forState:UIControlStateNormal];
        [(UIButton *)judgeTopHeadButtons[1] setTitle:[NSString stringWithFormat:@"好评(%d)",pcount] forState:UIControlStateNormal];
        [(UIButton *)judgeTopHeadButtons[2] setTitle:[NSString stringWithFormat:@"中评(%d)",mCount] forState:UIControlStateNormal];
        [(UIButton *)judgeTopHeadButtons[3] setTitle:[NSString stringWithFormat:@"差评(%d)",nCount] forState:UIControlStateNormal];
    });
}

-(void)shopJudgementsReloadTable{
    //    NSMutableArray *shopJudgementArray = [NSMutableArray array];
    //    
    //    [shopJudgementArray addObject:@{@"score":@"4",
    //                                   @"member":@"1234566",
    //                                    @"headpic":@"",
    //                                   @"isAnonymous":@"1",
    //                                   @"detial":@"还可以还可以",
    //                                   @"time":@"1441550638",
    //                                   }];
    
    //    [shopJudgementArray addObject:@{@"rating":@"2",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"5",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"4",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"2",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"1",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"5",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"4",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    //    
    //    [shopJudgementArray addObject:@{@"rating":@"2",
    //                                    @"judgeUserName":@"1234566",
    //                                    @"isAnonymous":@"1",
    //                                    @"judgeContents":@"还可以还可以",
    //                                    @"timestamp":@"1441550638",
    //                                    }];
    
    //    currentShopJudgementDataArray = shopJudgementArray;
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        [shopJudgementTableView reloadData];
    });
}

#pragma mark - 商家简介
-(void)setUpShopIntroductionView{
    shopIntroductionTotalView = [[UIScrollView alloc] init];
    shopIntroductionTotalView.backgroundColor = RGBColor(240, 240, 240);
    shopIntroductionTotalView.frame = (CGRect){WIDTH(shopContentScroll)*2,0,WIDTH(shopContentScroll),HEIGHT(shopContentScroll)};
    shopIntroductionTotalView.contentSize = (CGSize){WIDTH(shopIntroductionTotalView),1000};
    shopIntroductionTotalView.showsHorizontalScrollIndicator = NO;
    shopIntroductionTotalView.showsVerticalScrollIndicator = NO;
    [shopContentScroll addSubview:shopIntroductionTotalView];
    
    UIView *shopIntroductionView1 = [[UIView alloc] init];
    shopIntroductionView1.frame = (CGRect){0,0,WIDTH(shopIntroductionTotalView),85};
    shopIntroductionView1.backgroundColor = [UIColor whiteColor];
    [shopIntroductionTotalView addSubview:shopIntroductionView1];
    
    shopIntroImage = [[UIImageView alloc] init];
    shopIntroImage.frame = (CGRect){10,10,65,65};
    //    shopIntroImage.backgroundColor = [UIColor redColor];
    [shopIntroductionView1 addSubview:shopIntroImage];
    
    [shopIntroImage setImageWithURL:[NSURL URLWithString:self.shopInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
    
    shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.text = self.shopInfo.name;
    shopNameLabel.textAlignment = NSTextAlignmentLeft;
    shopNameLabel.textColor = RGBColor(50, 50, 50);
    shopNameLabel.font = Font(15);
    shopNameLabel.frame = (CGRect){RIGHT(shopIntroImage)+10,TOP(shopIntroImage),WIDTH(shopIntroductionView1)-(RIGHT(shopIntroImage)+10)-10,15};
    [shopIntroductionView1 addSubview:shopNameLabel];
    
    shopIntroRatingView = [[RatingView alloc] init];
    [shopIntroRatingView setImagesDeselected:@"star" partlySelected:@"star_on" fullSelected:@"star_on"];
    shopIntroRatingView.frame = (CGRect){LEFT(shopNameLabel),BOTTOM(shopNameLabel)+8,65,15};
    [shopIntroductionView1 addSubview:shopIntroRatingView];
    [shopIntroRatingView displayRating:self.shopInfo.starJudge];
    
    shopMonthSaleNumberLabel = [[UILabel alloc] init];
    shopMonthSaleNumberLabel.text = [NSString stringWithFormat:@"月销量 %d",self.shopInfo.monthSaleNumber];
    shopMonthSaleNumberLabel.textAlignment = NSTextAlignmentLeft;
    shopMonthSaleNumberLabel.textColor = RGBColor(140, 140, 140);
    shopMonthSaleNumberLabel.font = Font(12);
    shopMonthSaleNumberLabel.frame = (CGRect){RIGHT(shopIntroRatingView)+10,TOP(shopIntroRatingView),WIDTH(shopIntroductionView1)-LEFT(shopIntroRatingView)-10,15};
    [shopIntroductionView1 addSubview:shopMonthSaleNumberLabel];
    
    businessStateLabel = [[UILabel alloc] init];
    businessStateLabel.frame = (CGRect){LEFT(shopIntroRatingView),BOTTOM(shopIntroRatingView)+8,68,17};
    businessStateLabel.layer.cornerRadius = 2.f;
    businessStateLabel.layer.masksToBounds = YES;
    businessStateLabel.textColor = [UIColor whiteColor];
    businessStateLabel.font = Font(13);
    businessStateLabel.textAlignment = NSTextAlignmentCenter;
    [shopIntroductionView1 addSubview:businessStateLabel];
    
    if (self.shopInfo.businessState == ShopInfoBusinessStateOpen) {
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = UN_GreenColor;
        businessStateLabel.text = @"商家营业中";
    }else if(self.shopInfo.businessState == ShopInfoBusinessStateBreak){
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = RGBColor(200, 200, 200);
        businessStateLabel.text = @"商家休息中";
    }else{
        businessStateLabel.hidden = YES;
    }
    
    UIView *lineSepLineView = [[UIView alloc] init];
    lineSepLineView.frame = (CGRect){0,HEIGHT(shopIntroductionView1)-0.5,WIDTH(shopIntroductionView1),0.5};
    lineSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroductionView1 addSubview:lineSepLineView];
    
    UIView *shopIntroductionView2 = [[UIView alloc] init];
    shopIntroductionView2.frame = (CGRect){0,BOTTOM(shopIntroductionView1),WIDTH(shopIntroductionView1),65};
    [shopIntroductionTotalView addSubview:shopIntroductionView2];
    shopIntroductionView2.backgroundColor = shopIntroductionView1.backgroundColor;
    
    UIView *shopIntroDeliveryTimeView = [[UIView alloc] init];
    shopIntroDeliveryTimeView.frame = (CGRect){0,0,WIDTH(shopIntroductionView2)/3,HEIGHT(shopIntroductionView2)};
    [shopIntroductionView2 addSubview:shopIntroDeliveryTimeView];
    
    shopIntroDeliveryTimeLabel = [[UILabel alloc] init];
    shopIntroDeliveryTimeLabel.frame = (CGRect){0,15,WIDTH(shopIntroDeliveryTimeView),17};
    shopIntroDeliveryTimeLabel.text = [NSString stringWithFormat:@"%@分钟",self.shopInfo.deliveryAverage];
    shopIntroDeliveryTimeLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroDeliveryTimeLabel.textColor = RGBColor(50, 50, 50);
    shopIntroDeliveryTimeLabel.font = Font(16);
    [shopIntroDeliveryTimeView addSubview:shopIntroDeliveryTimeLabel];
    
    UILabel *shopIntroDeliveryTimeNoteLabel = [[UILabel alloc] init];
    shopIntroDeliveryTimeNoteLabel.frame = (CGRect){0,BOTTOM(shopIntroDeliveryTimeLabel)+3,WIDTH(shopIntroDeliveryTimeView),15};
    shopIntroDeliveryTimeNoteLabel.text = @"平均送达时间";
    shopIntroDeliveryTimeNoteLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroDeliveryTimeNoteLabel.textColor = RGBColor(140, 140, 140);
    shopIntroDeliveryTimeNoteLabel.font = Font(13);
    [shopIntroDeliveryTimeView addSubview:shopIntroDeliveryTimeNoteLabel];
    
    UIView *sepLine1View = [[UIView alloc] init];
    sepLine1View.frame = (CGRect){WIDTH(shopIntroDeliveryTimeView)-0.5,10,0.5,HEIGHT(shopIntroDeliveryTimeView)-20};
    sepLine1View.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroDeliveryTimeView addSubview:sepLine1View];
    
    UIView *shopIntroMinBuyNumberView = [[UIView alloc] init];
    shopIntroMinBuyNumberView.frame = (CGRect){WIDTH(shopIntroductionView2)/3,0,WIDTH(shopIntroductionView2)/3,HEIGHT(shopIntroductionView2)};
    [shopIntroductionView2 addSubview:shopIntroMinBuyNumberView];
    
    shopIntroMinBuyNumberLabel = [[UILabel alloc] init];
    shopIntroMinBuyNumberLabel.frame = (CGRect){0,15,WIDTH(shopIntroMinBuyNumberView),17};
    shopIntroMinBuyNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.shopInfo.minBuyNumber];
    shopIntroMinBuyNumberLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroMinBuyNumberLabel.textColor = RGBColor(50, 50, 50);
    shopIntroMinBuyNumberLabel.font = Font(16);
    [shopIntroMinBuyNumberView addSubview:shopIntroMinBuyNumberLabel];
    
    UILabel *shopIntroMinBuyNumberNoteLabel = [[UILabel alloc] init];
    shopIntroMinBuyNumberNoteLabel.frame = (CGRect){0,BOTTOM(shopIntroMinBuyNumberLabel)+3,WIDTH(shopIntroMinBuyNumberView),15};
    shopIntroMinBuyNumberNoteLabel.text = @"起送价";
    shopIntroMinBuyNumberNoteLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroMinBuyNumberNoteLabel.textColor = RGBColor(140, 140, 140);
    shopIntroMinBuyNumberNoteLabel.font = Font(13);
    [shopIntroMinBuyNumberView addSubview:shopIntroMinBuyNumberNoteLabel];
    
    UIView *sepLine2View = [[UIView alloc] init];
    sepLine2View.frame = (CGRect){WIDTH(shopIntroMinBuyNumberView)-0.5,10,0.5,HEIGHT(shopIntroMinBuyNumberView)-20};
    sepLine2View.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroMinBuyNumberView addSubview:sepLine2View];
    //
    UIView *shopIntroDeliveryNumberView = [[UIView alloc] init];
    shopIntroDeliveryNumberView.frame = (CGRect){WIDTH(shopIntroductionView2)*2/3,0,WIDTH(shopIntroductionView2)/3,HEIGHT(shopIntroductionView2)};
    [shopIntroductionView2 addSubview:shopIntroDeliveryNumberView];
    
    shopIntroDeliveryNumberLabel = [[UILabel alloc] init];
    shopIntroDeliveryNumberLabel.frame = (CGRect){0,15,WIDTH(shopIntroDeliveryNumberView),17};
    shopIntroDeliveryNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.shopInfo.deliveryNumber];
    shopIntroDeliveryNumberLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroDeliveryNumberLabel.textColor = RGBColor(50, 50, 50);
    shopIntroDeliveryNumberLabel.font = Font(16);
    [shopIntroDeliveryNumberView addSubview:shopIntroDeliveryNumberLabel];
    
    UILabel *shopIntroDeliveryTimeNumberLabel = [[UILabel alloc] init];
    shopIntroDeliveryTimeNumberLabel.frame = (CGRect){0,BOTTOM(shopIntroDeliveryNumberLabel)+3,WIDTH(shopIntroDeliveryNumberView),15};
    shopIntroDeliveryTimeNumberLabel.text = @"配送费";
    shopIntroDeliveryTimeNumberLabel.textAlignment = NSTextAlignmentCenter;
    shopIntroDeliveryTimeNumberLabel.textColor = RGBColor(140, 140, 140);
    shopIntroDeliveryTimeNumberLabel.font = Font(13);
    [shopIntroDeliveryNumberView addSubview:shopIntroDeliveryTimeNumberLabel];
    
    UIView *sepLine3View = [[UIView alloc] init];
    sepLine3View.frame = (CGRect){WIDTH(shopIntroDeliveryNumberView)-0.5,10,0.5,HEIGHT(shopIntroDeliveryNumberView)-20};
    sepLine3View.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroDeliveryNumberView addSubview:sepLine3View];
    
    UIView *lineSepLine2View = [[UIView alloc] init];
    lineSepLine2View.frame = (CGRect){0,HEIGHT(shopIntroductionView2)-0.5,WIDTH(shopIntroductionView2),0.5};
    lineSepLine2View.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroductionView2 addSubview:lineSepLine2View];
    
    UIButton *shopIntroAddressButton = [[UIButton alloc] init];
    shopIntroAddressButton.frame = (CGRect){0,BOTTOM(shopIntroductionView2)+5,WIDTH(shopIntroductionTotalView),40};
    shopIntroAddressButton.backgroundColor = [UIColor whiteColor];
    [shopIntroductionTotalView addSubview:shopIntroAddressButton];
    
    UIImageView *shopIntroAddressImage = [[UIImageView alloc] init];
    shopIntroAddressImage.frame = (CGRect){10,(HEIGHT(shopIntroAddressButton)-21)/2,19,21};
    shopIntroAddressImage.image = [UIImage imageNamed:@"location"];
    [shopIntroAddressButton addSubview:shopIntroAddressImage];
    
    shopIntroAddressLabel = [[UILabel alloc] init];
    shopIntroAddressLabel.frame = (CGRect){RIGHT(shopIntroAddressImage)+10,0,WIDTH(shopIntroAddressButton)-(RIGHT(shopIntroAddressImage)+10),HEIGHT(shopIntroAddressButton)};
    shopIntroAddressLabel.textColor = RGBColor(50, 50, 50);
    shopIntroAddressLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroAddressLabel.font = Font(14);
    shopIntroAddressLabel.text = @"商家地址:正在获取地址...";
    [shopIntroAddressButton addSubview:shopIntroAddressLabel];
    
    UIView *shopIntroAddressSepLine = [[UIView alloc] init];
    shopIntroAddressSepLine.frame = (CGRect){0,HEIGHT(shopIntroAddressButton)-0.5,WIDTH(shopIntroAddressButton),0.5};
    shopIntroAddressSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroAddressButton addSubview:shopIntroAddressSepLine];
    
    UIButton *shopIntroTimeButton = [[UIButton alloc] init];
    shopIntroTimeButton.frame = (CGRect){0,BOTTOM(shopIntroAddressButton),WIDTH(shopIntroductionTotalView),40};
    shopIntroTimeButton.backgroundColor = [UIColor whiteColor];
    [shopIntroductionTotalView addSubview:shopIntroTimeButton];
    
    UIImageView *shopIntroTimeImage = [[UIImageView alloc] init];
    shopIntroTimeImage.frame = (CGRect){10,(HEIGHT(shopIntroTimeButton)-21)/2,19,21};
    shopIntroTimeImage.image = [UIImage imageNamed:@"shop_bussinesstime"];
    [shopIntroTimeButton addSubview:shopIntroTimeImage];
    
    shopIntroTimeLabel = [[UILabel alloc] init];
    shopIntroTimeLabel.frame = (CGRect){RIGHT(shopIntroTimeImage)+10,0,WIDTH(shopIntroTimeButton)-(RIGHT(shopIntroTimeImage)+10),HEIGHT(shopIntroTimeButton)};
    shopIntroTimeLabel.textColor = RGBColor(50, 50, 50);
    shopIntroTimeLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroTimeLabel.font = Font(14);
    shopIntroTimeLabel.text = @"营业时间:正在获取营业时间...";
    [shopIntroTimeButton addSubview:shopIntroTimeLabel];
    
    shopIntroNotificationView = [[UIView alloc] init];
    shopIntroNotificationView.frame = (CGRect){0,BOTTOM(shopIntroTimeButton)+5,WIDTH(shopIntroductionTotalView),100};
    shopIntroNotificationView.backgroundColor = [UIColor whiteColor];
    [shopIntroductionTotalView addSubview:shopIntroNotificationView];
    
    shopIntroNotificationNoteLabel = [[UILabel alloc] init];
    shopIntroNotificationNoteLabel.frame = (CGRect){15,0,WIDTH(shopIntroNotificationView)-15*2,35};
    shopIntroNotificationNoteLabel.text = @"商家公告";
    shopIntroNotificationNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroNotificationNoteLabel.textColor = RGBColor(140, 140, 140);
    shopIntroNotificationNoteLabel.font = Font(13);
    [shopIntroNotificationView addSubview:shopIntroNotificationNoteLabel];
    
    UIView *shopIntroNotifacatioSeplineView = [[UIView alloc] init];
    shopIntroNotifacatioSeplineView.frame = (CGRect){0,HEIGHT(shopIntroNotificationNoteLabel)-0.5,WIDTH(shopIntroNotificationView),0.5};
    shopIntroNotifacatioSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroNotificationView addSubview:shopIntroNotifacatioSeplineView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:Font(13), NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    if (!self.shopInfo.shopNotification || [self.shopInfo.shopNotification isEqualToString:@""]) {
        self.shopInfo.shopNotification = @"暂无公告";
    }
    
    CGSize notificationSize = [self.shopInfo.shopNotification boundingRectWithSize:(CGSize){WIDTH(shopIntroNotificationView)-30,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    shopIntroNotificationLabel = [[UILabel alloc] init];
    shopIntroNotificationLabel.frame = (CGRect){15,BOTTOM(shopIntroNotificationNoteLabel)+8,WIDTH(shopIntroNotificationView)-15*2,notificationSize.height};
    shopIntroNotificationLabel.text = self.shopInfo.shopNotification;
    shopIntroNotificationLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroNotificationLabel.textColor = RGBColor(80, 80, 80);
    shopIntroNotificationLabel.font = Font(13);
    shopIntroNotificationLabel.numberOfLines = -1;
    [shopIntroNotificationView addSubview:shopIntroNotificationLabel];
    
    shopIntroNotificationView.frame = (CGRect){0,BOTTOM(shopIntroTimeButton)+5,WIDTH(shopIntroductionTotalView),HEIGHT(shopIntroNotificationNoteLabel)+8*2+notificationSize.height};
    
    shopIntroYouHuiView = [[UIView alloc] init];
    shopIntroYouHuiView.backgroundColor = [UIColor whiteColor];
    shopIntroYouHuiView.frame = (CGRect){0,BOTTOM(shopIntroNotificationView)+5,WIDTH(shopIntroductionTotalView),100};
    [shopIntroductionTotalView addSubview:shopIntroYouHuiView];
    
    UILabel *shopIntroYouHuiNoteLabel = [[UILabel alloc] init];
    shopIntroYouHuiNoteLabel.frame = (CGRect){15,0,WIDTH(shopIntroYouHuiView)-15*2,35};
    shopIntroYouHuiNoteLabel.text = @"优惠活动";
    shopIntroYouHuiNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroYouHuiNoteLabel.textColor = RGBColor(140, 140, 140);
    shopIntroYouHuiNoteLabel.font = Font(13);
    [shopIntroYouHuiView addSubview:shopIntroYouHuiNoteLabel];
    
    UIView *shopIntroYouHuiSeplineView = [[UIView alloc] init];
    shopIntroYouHuiSeplineView.frame = (CGRect){0,HEIGHT(shopIntroYouHuiNoteLabel)-0.5,WIDTH(shopIntroYouHuiView),0.5};
    shopIntroYouHuiSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroYouHuiView addSubview:shopIntroYouHuiSeplineView];
    
    __block float huodongOffset = HEIGHT(shopIntroYouHuiNoteLabel);
    [self.shopInfo.huodongDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSString *obj, BOOL *stop) {
        UIView *tmpView = [[UIView alloc] init];
        tmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
        [shopIntroYouHuiView addSubview:tmpView];
        
        UIColor *tagColor = UN_RedColor;
        if ([key isEqualToString:@"新"]) {
            tagColor = UN_FilterXin;
        }else if ([key isEqualToString:@"特"]){
            tagColor = UN_FilterTejia;
        }else if ([key isEqualToString:@"减"]){
            tagColor = UN_FilterJian;
        }else if ([key isEqualToString:@"预"]){
            tagColor = UN_FilterYu;
        }else if ([key isEqualToString:@"免"]){
            tagColor = UN_FilterMian;
        }else if ([key isEqualToString:@"劵"]){
            tagColor = UN_FilterQuan2;
        }
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.frame = (CGRect){15,(HEIGHT(tmpView)-20)/2,20,20};
        tagLabel.backgroundColor = tagColor;
        tagLabel.layer.cornerRadius = 10;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.text = key;
        tagLabel.layer.borderColor = tagColor.CGColor;
        tagLabel.layer.borderWidth = 1.f;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = Font(13);
        [tmpView addSubview:tagLabel];
        
        UILabel *tagDescirptionLabel = [[UILabel alloc] init];
        tagDescirptionLabel.frame = (CGRect){RIGHT(tagLabel)+5,0,WIDTH(tmpView)-RIGHT(tagLabel)-5-15,HEIGHT(tmpView)};
        tagDescirptionLabel.text = obj;
        tagDescirptionLabel.textAlignment = NSTextAlignmentLeft;
        tagDescirptionLabel.textColor = RGBColor(50, 50, 50);
        tagDescirptionLabel.font = Font(14);
        [tmpView addSubview:tagDescirptionLabel];
        
        UIView *lineSepline = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(tmpView)-0.5,WIDTH(tmpView)-15,0.5}];
        lineSepline.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [tmpView addSubview:lineSepline];
        
        huodongOffset += 40;
    }];
    
    //    if (self.shopInfo.juanEnabel) {
    //        UIView *juanEnabeltmpView = [[UIView alloc] init];
    //        juanEnabeltmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
    //        [shopIntroYouHuiView addSubview:juanEnabeltmpView];
    //        
    //        UILabel *juanLabel = [[UILabel alloc] init];
    //        [juanEnabeltmpView addSubview:juanLabel];
    //        juanLabel.layer.cornerRadius = 10;
    //        juanLabel.layer.masksToBounds = YES;
    //        juanLabel.layer.borderWidth = 1.f;
    //        juanLabel.layer.borderColor = UN_GreenColor_CGColor;
    //        juanLabel.textColor = UN_GreenColor;
    //        juanLabel.font = Font(13);
    //        juanLabel.textAlignment = NSTextAlignmentCenter;
    //        juanLabel.frame = (CGRect){15,(HEIGHT(juanEnabeltmpView)-20)/2,20,20};
    //        juanLabel.text = @"券";
    //        
    //        UILabel *juanDescirptionLabel = [[UILabel alloc] init];
    //        juanDescirptionLabel.frame = (CGRect){RIGHT(juanLabel)+5,0,WIDTH(juanEnabeltmpView)-RIGHT(juanLabel)-5-15,HEIGHT(juanEnabeltmpView)};
    //        juanDescirptionLabel.text = @"满200送100优惠券";
    //        juanDescirptionLabel.textAlignment = NSTextAlignmentLeft;
    //        juanDescirptionLabel.textColor = RGBColor(50, 50, 50);
    //        juanDescirptionLabel.font = Font(14);
    //        [juanEnabeltmpView addSubview:juanDescirptionLabel];
    //        
    //        UIView *lineSeplineTmp2 = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(juanEnabeltmpView)-0.5,WIDTH(juanEnabeltmpView)-15,0.5}];
    //        lineSeplineTmp2.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    //        [juanEnabeltmpView addSubview:lineSeplineTmp2];
    //        
    //        huodongOffset += 40;
    //    }
    if (self.shopInfo.piaoEnabel) {
        UIView *piaoEnabeltmpView = [[UIView alloc] init];
        piaoEnabeltmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
        [shopIntroYouHuiView addSubview:piaoEnabeltmpView];
        
        UILabel *piaoLabel = [[UILabel alloc] init];
        [piaoEnabeltmpView addSubview:piaoLabel];
        piaoLabel.layer.cornerRadius = 10;
        piaoLabel.layer.masksToBounds = YES;
        piaoLabel.layer.borderWidth = 1.f;
        piaoLabel.layer.borderColor = UN_GreenColor_CGColor;
        piaoLabel.textColor = UN_GreenColor;
        piaoLabel.font = Font(13);
        piaoLabel.textAlignment = NSTextAlignmentCenter;
        piaoLabel.frame = (CGRect){15,(HEIGHT(piaoEnabeltmpView)-20)/2,20,20};
        piaoLabel.text = @"票";
        
        UILabel *fuDescirptionLabel = [[UILabel alloc] init];
        fuDescirptionLabel.frame = (CGRect){RIGHT(piaoLabel)+5,0,WIDTH(piaoEnabeltmpView)-RIGHT(piaoLabel)-5-15,HEIGHT(piaoEnabeltmpView)};
        fuDescirptionLabel.text = @"可开发票";
        fuDescirptionLabel.textAlignment = NSTextAlignmentLeft;
        fuDescirptionLabel.textColor = RGBColor(50, 50, 50);
        fuDescirptionLabel.font = Font(14);
        [piaoEnabeltmpView addSubview:fuDescirptionLabel];
        
        UIView *lineSeplineTmp1 = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(piaoEnabeltmpView)-0.5,WIDTH(piaoEnabeltmpView)-15,0.5}];
        lineSeplineTmp1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [piaoEnabeltmpView addSubview:lineSeplineTmp1];
        
        huodongOffset += 40;
    }
    if (self.shopInfo.fuEnabel) {
        UIView *fuEnabeltmpView = [[UIView alloc] init];
        fuEnabeltmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
        [shopIntroYouHuiView addSubview:fuEnabeltmpView];
        
        UILabel *fuLabel = [[UILabel alloc] init];
        [fuEnabeltmpView addSubview:fuLabel];
        fuLabel.layer.cornerRadius = 10;
        fuLabel.layer.masksToBounds = YES;
        fuLabel.layer.borderWidth = 1.f;
        fuLabel.layer.borderColor = UN_GreenColor_CGColor;
        fuLabel.textColor = UN_GreenColor;
        fuLabel.font = Font(13);
        fuLabel.textAlignment = NSTextAlignmentCenter;
        fuLabel.frame = (CGRect){15,(HEIGHT(fuEnabeltmpView)-20)/2,20,20};
        fuLabel.text = @"付";
        
        UILabel *fuDescirptionLabel = [[UILabel alloc] init];
        fuDescirptionLabel.frame = (CGRect){RIGHT(fuLabel)+5,0,WIDTH(fuEnabeltmpView)-RIGHT(fuLabel)-5-15,HEIGHT(fuEnabeltmpView)};
        fuDescirptionLabel.text = @"支持在线支付";
        fuDescirptionLabel.textAlignment = NSTextAlignmentLeft;
        fuDescirptionLabel.textColor = RGBColor(50, 50, 50);
        fuDescirptionLabel.font = Font(14);
        [fuEnabeltmpView addSubview:fuDescirptionLabel];
        
        UIView *lineSeplineTmp1 = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(fuEnabeltmpView)-0.5,WIDTH(fuEnabeltmpView)-15,0.5}];
        lineSeplineTmp1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [fuEnabeltmpView addSubview:lineSeplineTmp1];
        
        huodongOffset += 40;
    }
    if (self.shopInfo.peiEnabel) {
        UIView *peiEnabeltmpView = [[UIView alloc] init];
        peiEnabeltmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
        [shopIntroYouHuiView addSubview:peiEnabeltmpView];
        
        UILabel *fuLabel = [[UILabel alloc] init];
        [peiEnabeltmpView addSubview:fuLabel];
        fuLabel.layer.cornerRadius = 10;
        fuLabel.layer.masksToBounds = YES;
        fuLabel.layer.borderWidth = 1.f;
        fuLabel.layer.borderColor = UN_GreenColor_CGColor;
        fuLabel.textColor = UN_GreenColor;
        fuLabel.font = Font(13);
        fuLabel.textAlignment = NSTextAlignmentCenter;
        fuLabel.frame = (CGRect){15,(HEIGHT(peiEnabeltmpView)-20)/2,20,20};
        fuLabel.text = @"赔";
        
        UILabel *fuDescirptionLabel = [[UILabel alloc] init];
        fuDescirptionLabel.frame = (CGRect){RIGHT(fuLabel)+5,0,WIDTH(peiEnabeltmpView)-RIGHT(fuLabel)-5-15,HEIGHT(peiEnabeltmpView)};
        fuDescirptionLabel.text = @"超过30分钟享受5折优惠,恶劣天气除外";
        fuDescirptionLabel.textAlignment = NSTextAlignmentLeft;
        fuDescirptionLabel.textColor = RGBColor(50, 50, 50);
        fuDescirptionLabel.font = Font(14);
        [peiEnabeltmpView addSubview:fuDescirptionLabel];
        
        UIView *lineSeplineTmp1 = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(peiEnabeltmpView)-0.5,WIDTH(peiEnabeltmpView)-15,0.5}];
        lineSeplineTmp1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [peiEnabeltmpView addSubview:lineSeplineTmp1];
        
        huodongOffset += 40;
    }
    if (self.shopInfo.isSelfDelivery) {
        UIView *ttttmpView = [[UIView alloc] init];
        ttttmpView.frame = (CGRect){0,huodongOffset,WIDTH(shopIntroYouHuiView),40};
        [shopIntroYouHuiView addSubview:ttttmpView];
        
        UIView *imageOUTTERView = [[UIView alloc] init];
        imageOUTTERView.frame = (CGRect){15,(HEIGHT(ttttmpView)-20)/2,20,20};
        imageOUTTERView.layer.cornerRadius = 10;
        imageOUTTERView.layer.masksToBounds = YES;
        imageOUTTERView.layer.borderWidth = 1.f;
        imageOUTTERView.layer.borderColor = UN_GreenColor_CGColor;
        [ttttmpView addSubview:imageOUTTERView];
        
        UIImageView *selfDeliveryImage = [[UIImageView alloc] init];
        selfDeliveryImage.image = [UIImage imageNamed:@"shop_selfdelivery"];
        selfDeliveryImage.frame = (CGRect){2,3,16,14};
        [imageOUTTERView addSubview:selfDeliveryImage];
        
        UILabel *fuDescirptionLabel = [[UILabel alloc] init];
        fuDescirptionLabel.frame = (CGRect){RIGHT(imageOUTTERView)+5,0,WIDTH(ttttmpView)-RIGHT(imageOUTTERView)-5-15,HEIGHT(ttttmpView)};
        fuDescirptionLabel.text = @"联合配送";
        fuDescirptionLabel.textAlignment = NSTextAlignmentLeft;
        fuDescirptionLabel.textColor = RGBColor(50, 50, 50);
        fuDescirptionLabel.font = Font(14);
        [ttttmpView addSubview:fuDescirptionLabel];
        
        UIView *lineSeplineTmp1 = [[UIView alloc] initWithFrame:(CGRect){15,HEIGHT(ttttmpView)-0.5,WIDTH(ttttmpView)-15,0.5}];
        lineSeplineTmp1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [ttttmpView addSubview:lineSeplineTmp1];
        
        huodongOffset += 40;
    }
    shopIntroYouHuiView.frame = (CGRect){0,BOTTOM(shopIntroNotificationView)+5,WIDTH(shopIntroductionTotalView),huodongOffset};
    
    shopIntroductionShortView = [[UIView alloc] init];
    shopIntroductionShortView.frame = (CGRect){0,BOTTOM(shopIntroYouHuiView)+5,WIDTH(shopIntroductionTotalView),100};
    shopIntroductionShortView.backgroundColor = [UIColor whiteColor];
    [shopIntroductionTotalView addSubview:shopIntroductionShortView];
    
    shopIntroductionShortNoteLabel = [[UILabel alloc] init];
    shopIntroductionShortNoteLabel.frame = (CGRect){15,0,WIDTH(shopIntroductionShortView)-15*2,35};
    shopIntroductionShortNoteLabel.text = @"商家简介";
    shopIntroductionShortNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroductionShortNoteLabel.textColor = RGBColor(140, 140, 140);
    shopIntroductionShortNoteLabel.font = Font(13);
    [shopIntroductionShortView addSubview:shopIntroductionShortNoteLabel];
    
    UIView *shopIntroductionShortSeplineView = [[UIView alloc] init];
    shopIntroductionShortSeplineView.frame = (CGRect){0,HEIGHT(shopIntroductionShortNoteLabel)-0.5,WIDTH(shopIntroductionShortView),0.5};
    shopIntroductionShortSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopIntroductionShortView addSubview:shopIntroductionShortSeplineView];
    
    if (!self.shopInfo.shopIndtroduction || [self.shopInfo.shopIndtroduction isEqualToString:@""]) {
        self.shopInfo.shopIndtroduction = @"暂无简介";
    }
    
    CGSize shortIntroductionSizr = [UNTools getSizeWithString:self.shopInfo.shopIndtroduction andSize:(CGSize){WIDTH(shopIntroductionShortView)-30,MAXFLOAT} andFont:Font(13)];
    
    shopIntroductionShortLabel = [[UILabel alloc] init];
    shopIntroductionShortLabel.frame = (CGRect){15,BOTTOM(shopIntroductionShortNoteLabel)+8,WIDTH(shopIntroductionShortView)-15*2,shortIntroductionSizr.height};
    shopIntroductionShortLabel.text = self.shopInfo.shopIndtroduction;
    shopIntroductionShortLabel.textAlignment = NSTextAlignmentLeft;
    shopIntroductionShortLabel.textColor = RGBColor(80, 80, 80);
    shopIntroductionShortLabel.font = Font(13);
    shopIntroductionShortLabel.numberOfLines = -1;
    [shopIntroductionShortView addSubview:shopIntroductionShortLabel];
    
    shopIntroductionShortView.frame = (CGRect){0,BOTTOM(shopIntroYouHuiView)+5,WIDTH(shopIntroductionTotalView),HEIGHT(shopIntroductionShortNoteLabel)+8*2+shortIntroductionSizr.height};
    
    shopIntroductionTotalView.contentSize = (CGSize){WIDTH(shopIntroductionTotalView),MAX(HEIGHT(shopIntroductionTotalView)+1, BOTTOM(shopIntroductionShortView))};
    
}

-(void)resetShopIntrduceView{
    [shopIntroImage setImageWithURL:[NSURL URLWithString:self.shopInfo.imageUrl]  placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
    shopNameLabel.text = self.shopInfo.name;
    [shopIntroRatingView displayRating:self.shopInfo.starJudge];
    shopMonthSaleNumberLabel.text = [NSString stringWithFormat:@"月销量 %d",self.shopInfo.monthSaleNumber];
    shopIntroMinBuyNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.shopInfo.minBuyNumber];
    shopIntroDeliveryNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.shopInfo.deliveryNumber];
    shopIntroDeliveryTimeLabel.text = [NSString stringWithFormat:@"%@分钟",self.shopInfo.deliveryAverage];
    
    if (!self.shopInfo.beginTime || !self.shopInfo.endTime ||
        [self.shopInfo.beginTime isKindOfClass:[NSNull class]] ||
        [self.shopInfo.endTime isKindOfClass:[NSNull class]]) {
        shopIntroTimeLabel.text = @"营业时间: 未填写";
    }else{
        shopIntroTimeLabel.text = [NSString stringWithFormat:@"营业时间: %@-%@",self.shopInfo.beginTime,self.shopInfo.endTime];
    }
    if (self.shopInfo.address && ![self.shopInfo.address isKindOfClass:[NSNull class]]) {
        shopIntroAddressLabel.text = [NSString stringWithFormat:@"商家地址: %@",self.shopInfo.address];
    }else{
        shopIntroAddressLabel.text = @"商家地址: 未填写";
    }
    
    if (!self.shopInfo.shopIndtroduction ||
        [self.shopInfo.shopIndtroduction isKindOfClass:[NSNull class]] ||
        ![self.shopInfo.shopIndtroduction isKindOfClass:[NSString class]] ||
        [self.shopInfo.shopIndtroduction isEqualToString:@""]) {
        self.shopInfo.shopIndtroduction = @"暂无简介";
    }
    if (!self.shopInfo.shopNotification ||
        [self.shopInfo.shopNotification isKindOfClass:[NSNull class]] ||
        ![self.shopInfo.shopNotification isKindOfClass:[NSString class]] ||
        [self.shopInfo.shopNotification isEqualToString:@""]) {
        self.shopInfo.shopNotification = @"暂无公告";
    }
    
    //    self.shopInfo.shopIndtroduction = @"1993年，真维斯进军中国内地市场，在上海开设了第一间JEANSWEST真维斯专卖店。多年来，真维斯以“名牌大众化”的经营理念，“物超所值”的市场策略，稳占休闲装市场的领袖地位。现今，真维斯已在国内20多个省市开设了2000多间专卖店，拥有现时中国最大的休闲服饰销售网络。 <br />\n真维斯的经营理念是“名牌大众化”——少数人拥有的物品，令大众都能拥有；市场策略是“物超所值”——高价值的物品，低价钱销售。<br />\n真维斯服装是为广大年轻人设计的，将每季最新的潮流元素融入服装当中，以易穿易搭配的款式来吸引顾客。多年来，真维斯以大众潮流的休闲风格，深受年轻人的喜爱，已经成为年轻一代的时尚必需品。<br />";
    self.shopInfo.shopIndtroduction = [self.shopInfo.shopIndtroduction stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.shopInfo.shopIndtroduction = [self.shopInfo.shopIndtroduction stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    self.shopInfo.shopIndtroduction = [self.shopInfo.shopIndtroduction stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    self.shopInfo.shopIndtroduction = [NSString stringWithFormat:@"%@",self.shopInfo.shopIndtroduction];
    shopIntroNotificationLabel.text = self.shopInfo.shopNotification;
    shopIntroductionShortLabel.text = self.shopInfo.shopIndtroduction;
    //    shopIntroductionShortLabel.backgroundColor = [UIColor redColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:Font(13), NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize notificationSize = [self.shopInfo.shopNotification boundingRectWithSize:(CGSize){WIDTH(shopIntroNotificationView)-30,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGRect notiLabelFrame = shopIntroNotificationLabel.frame;
    shopIntroNotificationLabel.frame = (CGRect){notiLabelFrame.origin.x,notiLabelFrame.origin.y,notiLabelFrame.size.width,notificationSize.height};
    
    CGRect notiViewFrame = shopIntroNotificationView.frame;
    shopIntroNotificationView.frame = (CGRect){notiViewFrame.origin.x,notiViewFrame.origin.y,notiViewFrame.size.width,HEIGHT(shopIntroNotificationNoteLabel)+8*2+notificationSize.height};
    
    CGRect youhuiFrame = shopIntroYouHuiView.frame;
    shopIntroYouHuiView.frame = (CGRect){youhuiFrame.origin.x,BOTTOM(shopIntroNotificationView)+5,youhuiFrame.size.width,youhuiFrame.size.height};
    
    CGSize shortIntroductionSize = [UNTools getSizeWithString:self.shopInfo.shopIndtroduction andSize:(CGSize){WIDTH(shopIntroductionShortView)-30,MAXFLOAT} andFont:shopIntroductionShortLabel.font];
    
    CGRect introShortViewFrame = shopIntroductionShortView.frame;
    
    shopIntroductionShortLabel.frame = (CGRect){15,BOTTOM(shopIntroductionShortNoteLabel)+8,WIDTH(shopIntroductionShortView)-15*2,shortIntroductionSize.height};
    
    shopIntroductionShortView.frame = (CGRect){introShortViewFrame.origin.x,BOTTOM(shopIntroYouHuiView)+5,introShortViewFrame.size.width,HEIGHT(shopIntroductionShortNoteLabel)+8*2+shortIntroductionSize.height};
    
    shopIntroductionTotalView.contentSize = (CGSize){WIDTH(shopIntroductionTotalView),MAX(HEIGHT(shopIntroductionTotalView)+1, BOTTOM(shopIntroductionShortView))};
    
    if (self.shopInfo.businessState == ShopInfoBusinessStateOpen) {
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = UN_GreenColor;
        businessStateLabel.text = @"商家营业中";
    }else if(self.shopInfo.businessState == ShopInfoBusinessStateBreak){
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = RGBColor(200, 200, 200);
        businessStateLabel.text = @"商家休息中";
    }else{
        businessStateLabel.hidden = YES;
    }
}

#pragma mark - 商品详情展示页面
-(void)createShopDetailItemInfoView{
    if (!shopItemTotalScrollView) {
        shopItemTotalScrollView = [[UIScrollView alloc] init];
        shopItemTotalScrollView.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT-bottomBuyCarViewHeight};
        shopItemTotalScrollView.contentSize = (CGSize){WIDTH(shopItemTotalScrollView)*totalShopItemsCount,HEIGHT(shopItemTotalScrollView)};
        shopItemTotalScrollView.bounces = NO;
        shopItemTotalScrollView.alpha = 0;
        shopItemTotalScrollView.delegate = self;
        shopItemTotalScrollView.pagingEnabled = YES;
        shopItemTotalScrollView.showsHorizontalScrollIndicator = NO;
        shopItemTotalScrollView.showsVerticalScrollIndicator = NO;
        shopItemTotalScrollView.backgroundColor = RGBColor(250, 250, 250);
        [MainWindow addSubview:shopItemTotalScrollView];
        
        shopItemTotalCloseButton = [[UIButton alloc] init];
        shopItemTotalCloseButton.frame = (CGRect){15,25,36,36};
        shopItemTotalCloseButton.alpha = 0;
        [shopItemTotalCloseButton setImage:[UIImage imageNamed:@"shop_itemdetailclose"] forState:UIControlStateNormal];
        [shopItemTotalCloseButton addTarget:self action:@selector(shopItemTotalCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [MainWindow addSubview:shopItemTotalCloseButton];
    }
    [shopItemTotalScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block int offsetTmp = 0;
    shopItemDetailScrollViewArray = [NSMutableArray array];
    [shopItemTotalArray enumerateObjectsUsingBlock:^(ShopItem *item, NSUInteger idx, BOOL *stop) {
        UIScrollView *itemDetailScrollView = [[UIScrollView alloc] initWithFrame:(CGRect){
            offsetTmp*WIDTH(shopItemTotalScrollView),
            0,
            WIDTH(shopItemTotalScrollView),
            HEIGHT(shopItemTotalScrollView)}];
        itemDetailScrollView.contentSize = (CGSize){WIDTH(itemDetailScrollView),HEIGHT(itemDetailScrollView)+1};
        itemDetailScrollView.backgroundColor = shopItemTotalScrollView.backgroundColor;
        itemDetailScrollView.bounces = YES;
        itemDetailScrollView.pagingEnabled = NO;
        itemDetailScrollView.tag = offsetTmp;
        itemDetailScrollView.showsHorizontalScrollIndicator = NO;
        itemDetailScrollView.showsVerticalScrollIndicator = NO;
        [shopItemTotalScrollView addSubview:itemDetailScrollView];
        [shopItemDetailScrollViewArray addObject:itemDetailScrollView];
        
        UIImageView *itemBigImage = [[UIImageView alloc] init];
        itemBigImage.frame = (CGRect){0,0,WIDTH(itemDetailScrollView),WIDTH(itemDetailScrollView)*3/4};
        [itemBigImage setImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        itemBigImage.tag = 192;
        [itemDetailScrollView addSubview:itemBigImage];
        
        UILabel *itemNameLabel = [[UILabel alloc] init];
        itemNameLabel.frame = (CGRect){15,BOTTOM(itemBigImage)+20,WIDTH(itemDetailScrollView)-30,20};
        //                itemNameLabel.text = @"芝加哥风情重磅比萨套餐";
        itemNameLabel.text = item.itemName;
        itemNameLabel.textColor = RGBColor(50, 50, 50);
        itemNameLabel.textAlignment = NSTextAlignmentLeft;
        itemNameLabel.font = Font(18);
        [itemDetailScrollView addSubview:itemNameLabel];
        
        UILabel *itemDetailSoldNumLabel = [[UILabel alloc] init];
        itemDetailSoldNumLabel.text = [NSString stringWithFormat:@"已售%d份",item.soldNum];
        itemDetailSoldNumLabel.textColor = RGBColor(120, 120, 120);
        itemDetailSoldNumLabel.frame = (CGRect){LEFT(itemNameLabel),BOTTOM(itemNameLabel)+8,WIDTH(itemNameLabel),15};
        itemDetailSoldNumLabel.font = Font(13);
        [itemDetailScrollView addSubview:itemDetailSoldNumLabel];
        
        UILabel *itemDetailPriceLabel = [[UILabel alloc] init];
        itemDetailPriceLabel.frame = (CGRect){LEFT(itemNameLabel),BOTTOM(itemDetailSoldNumLabel)+30,75,30};
        itemDetailPriceLabel.textColor = UN_RedColor;
        itemDetailPriceLabel.textAlignment = NSTextAlignmentLeft;
        itemDetailPriceLabel.numberOfLines = 1;
        itemDetailPriceLabel.font = Font(20);
        [itemDetailScrollView addSubview:itemDetailPriceLabel];
        
        float price = item.price;
        if ((price*10)-((int)price)*10 == 0) {
            itemDetailPriceLabel.text = [NSString stringWithFormat:@"￥ %d",(int)price];
        }else{
            itemDetailPriceLabel.text = [NSString stringWithFormat:@"￥ %.1f",price];
        }
        CGSize priceLabelSize = [UNTools getSizeWithString:itemDetailPriceLabel.text andSize:(CGSize){HUGE_VALL,30} andFont:itemDetailPriceLabel.font];
        itemDetailPriceLabel.frame = (CGRect){LEFT(itemNameLabel),BOTTOM(itemDetailSoldNumLabel)+30,priceLabelSize.width,30};
        
        float originprice = item.originPrice;
        
        UILabel *itemDetailOriginPriceLabel = [[UILabel alloc] init];
        itemDetailOriginPriceLabel.frame = (CGRect){RIGHT(itemDetailPriceLabel)+10,TOP(itemDetailPriceLabel),75,30};
        itemDetailOriginPriceLabel.textColor = RGBColor(120, 120, 120);
        itemDetailOriginPriceLabel.textAlignment = NSTextAlignmentLeft;
        itemDetailOriginPriceLabel.numberOfLines = 1;
        itemDetailOriginPriceLabel.font = Font(15);
        itemDetailOriginPriceLabel.tag = 104;
        [itemDetailScrollView addSubview:itemDetailOriginPriceLabel];
        
        NSString *originPriceString;
        if ((originprice*10)-((int)originprice)*10 == 0) {
            originPriceString = [NSString stringWithFormat:@"￥%d",(int)originprice];
        }else{
            originPriceString = [NSString stringWithFormat:@"￥%.1f",originprice];
        }
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:originPriceString attributes:attribtDic];
        
        itemDetailOriginPriceLabel.attributedText = attribtStr;
        
        //        CGSize originPriceLabelSize = [UNTools getSizeWithString:itemDetailOriginPriceLabel.text andSize:(CGSize){HUGE_VALL,30} andFont:itemDetailOriginPriceLabel.font];
        //        itemDetailOriginPriceLabel.frame = (CGRect){RIGHT(itemDetailPriceLabel)+10,TOP(itemDetailPriceLabel),originPriceLabelSize.width,30};
        
        //        UIView *itemDetailOriginPriceLabelLineView = [[UIView alloc] init];
        //        itemDetailOriginPriceLabelLineView.frame = (CGRect){
        //                LEFT(itemDetailOriginPriceLabel),
        //                TOP(itemDetailOriginPriceLabel)+HEIGHT(itemDetailOriginPriceLabel)/2,
        //                WIDTH(itemDetailOriginPriceLabel),
        //                0.5};
        //        itemDetailOriginPriceLabelLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        //        [itemDetailScrollView addSubview:itemDetailOriginPriceLabelLineView];
        
        UIButton *itemDetailAddButton = [[UIButton alloc] init];
        itemDetailAddButton.frame = (CGRect){WIDTH(itemDetailScrollView)-15-30,TOP(itemDetailPriceLabel),30,30};
        [itemDetailAddButton setImage:[UIImage imageNamed:@"item_add"] forState:UIControlStateNormal];
        [itemDetailAddButton addTarget:self action:@selector(itemDetailAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemDetailAddButton.tag = 101;
        itemDetailAddButton.tagControl = (int)idx;
        [itemDetailScrollView addSubview:itemDetailAddButton];
        
        UIButton *itemDetailMinusButton = [[UIButton alloc] init];
        itemDetailMinusButton.frame = (CGRect){WIDTH(itemDetailScrollView)-15-35-30-30,TOP(itemDetailPriceLabel),30,30};
        [itemDetailMinusButton setImage:[UIImage imageNamed:@"item_minus"] forState:UIControlStateNormal];
        [itemDetailMinusButton addTarget:self action:@selector(itemDetailMinusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemDetailMinusButton.tag = 102;
        itemDetailMinusButton.tagControl = (int)idx;
        [itemDetailScrollView addSubview:itemDetailMinusButton];
        
        UILabel *itemDetailCountLabel = [[UILabel alloc] init];
        itemDetailCountLabel.frame = (CGRect){WIDTH(itemDetailScrollView)-15-35-30,TOP(itemDetailPriceLabel),35,30};
        itemDetailCountLabel.textColor = RGBColor(100, 100, 100);
        itemDetailCountLabel.textAlignment = NSTextAlignmentCenter;
        itemDetailCountLabel.font = Font(13);
        itemDetailCountLabel.tag = 201;
        itemDetailCountLabel.text = [NSString stringWithFormat:@"%d",item.chooseCount];
        [itemDetailScrollView addSubview:itemDetailCountLabel];
        
        UIView *sepViewTmp = [[UIView alloc] init];
        sepViewTmp.frame = (CGRect){0,BOTTOM(itemDetailPriceLabel)+20,WIDTH(itemDetailScrollView),5};
        sepViewTmp.backgroundColor = RGBColor(225, 225, 225);
        [itemDetailScrollView addSubview:sepViewTmp];
        
        UILabel *itemDetailDescriptionNoteLabel = [[UILabel alloc] init];
        itemDetailDescriptionNoteLabel.backgroundColor = itemDetailScrollView.backgroundColor;
        itemDetailDescriptionNoteLabel.frame = (CGRect){15,BOTTOM(sepViewTmp),100,45};
        itemDetailDescriptionNoteLabel.text = @"菜品描述";
        itemDetailDescriptionNoteLabel.textColor = RGBColor(50, 50, 50);
        itemDetailDescriptionNoteLabel.textAlignment = NSTextAlignmentLeft;
        itemDetailDescriptionNoteLabel.font = Font(14);
        itemDetailDescriptionNoteLabel.tag = 222;
        [itemDetailScrollView addSubview:itemDetailDescriptionNoteLabel];
        
        UILabel *itemDetailDescriptionLabel = [[UILabel alloc] init];
        itemDetailDescriptionLabel.backgroundColor = itemDetailScrollView.backgroundColor;
        itemDetailDescriptionLabel.frame = (CGRect){20,BOTTOM(itemDetailDescriptionNoteLabel),WIDTH(itemDetailScrollView)-40,45};
        itemDetailDescriptionLabel.textColor = RGBColor(80, 80, 80);
        itemDetailDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        itemDetailDescriptionLabel.font = Font(14);
        itemDetailDescriptionLabel.numberOfLines = -1;
        itemDetailDescriptionLabel.tag = 301;
        [itemDetailScrollView addSubview:itemDetailDescriptionLabel];
        
        NSString *itemDescription = item.itemDescription;
        if (!itemDescription || [itemDescription isEqualToString:@""]) {
            itemDescription = @"暂无描述";
        }
        
        itemDetailDescriptionLabel.text = itemDescription;
        
        CGSize itemDescriptionSize = [UNTools getSizeWithString:itemDetailDescriptionLabel.text andSize:(CGSize){WIDTH(itemDetailDescriptionLabel),HUGE_VALL} andFont:itemDetailDescriptionLabel.font];
        
        itemDetailDescriptionLabel.frame = (CGRect){20,BOTTOM(itemDetailDescriptionNoteLabel),WIDTH(itemDetailScrollView)-40,itemDescriptionSize.height};
        
        itemDetailScrollView.contentSize = (CGSize){WIDTH(itemDetailScrollView),MAX(HEIGHT(itemDetailScrollView)+1,BOTTOM(itemDetailDescriptionLabel)+10)};
        
        offsetTmp += 1;
    }];
    currentDetailItemSelectionIndex = 0;
}

-(void)updateItemDetailContentWithCenterIndex:(int)index{
    int leftIndex = index-1;
    if (leftIndex >= 0) {
        UIScrollView *scrollLeft = shopItemDetailScrollViewArray[leftIndex];
        ShopItem *shopItemLeft = shopItemTotalArray[leftIndex];
        
        [self updateItemDetailContentInScroller:scrollLeft withItem:shopItemLeft];
    }
    int rightIndex = index + 1;
    if (rightIndex <= totalShopItemsCount-1) {
        UIScrollView *scrollRight = shopItemDetailScrollViewArray[rightIndex];
        ShopItem *shopItemRight = shopItemTotalArray[rightIndex];
        
        [self updateItemDetailContentInScroller:scrollRight withItem:shopItemRight];
    }
    UIScrollView *scrollCenter = shopItemDetailScrollViewArray[index];
    ShopItem *shopItemCenter = shopItemTotalArray[index];
    [self updateItemDetailContentInScroller:scrollCenter withItem:shopItemCenter];
}

-(void)updateItemDetailContentInScroller:(UIScrollView *)scroller withItem:(ShopItem *)shopItem{
    UIButton *addButton = [scroller viewWithTag:101];
    
    UIButton *minusButton = [scroller viewWithTag:102];
    
    UIImageView *bigImage = [scroller viewWithTag:192];
    
    UILabel *originLabel = [scroller viewWithTag:104];
    
    UILabel *countLabel = [scroller viewWithTag:201];
    
    UILabel *introductionNoteLabel = [scroller viewWithTag:222];
    UILabel *introductionLabel = [scroller viewWithTag:301];
    
    minusButton.enabled = YES;
    addButton.enabled = YES;
    
    if (shopItem.chooseCount <= 0) {
        minusButton.enabled = NO;
    }
    if (shopItem.chooseCount >= 999) {
        addButton.enabled = NO;
    }
    
    countLabel.text = [NSString stringWithFormat:@"%d",shopItem.chooseCount];
    
    if (shopItem.itemDescription && ![shopItem.itemDescription isEqualToString:@""]) {
        return;
    }
    [UNUrlConnection getItemDetailWithItemID:shopItem.itemID complete:^(NSDictionary *resultDic, NSString *errorString) {
        //        NSLog(@"%@,%@",resultDic,errorString);
        if (errorString) {
        }else{
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                NSDictionary *contentDic = resultDic[@"content"];
                NSString *introduction = contentDic[@"introduction"];
                if (!introduction || ![introduction isKindOfClass:[NSString class]] || [introduction isEqualToString:@"null"]) {
                    introduction = @"暂无商品描述";
                }
                float originPrice = [contentDic[@"marketPrice"] floatValue];
                
                shopItem.itemDescription = introduction;
                shopItem.originPrice = originPrice;
                
                NSArray *imagesArray = contentDic[@"productImages"];
                if (imagesArray) {
                    if ([imagesArray isKindOfClass:[NSArray class]] && imagesArray.count != 0) {
                        NSString *bigImageUrl = [imagesArray[0] objectForKey:@"large"];
                        bigImageUrl = [UNUrlConnection replaceUrl:bigImageUrl];
                        [bigImage setImageWithURL:[NSURL URLWithString:bigImageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
                    }
                }
                
                NSString *originPriceString;
                if ((originPrice*10)-((int)originPrice)*10 == 0) {
                    originPriceString = [NSString stringWithFormat:@"￥%d",(int)originPrice];
                }else{
                    originPriceString = [NSString stringWithFormat:@"￥%.1f",originPrice];
                }
                NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:originPriceString attributes:attribtDic];
                originLabel.attributedText = attribtStr;
                
                
                introductionLabel.text = introduction;
                
                CGSize itemDescriptionSize = [UNTools getSizeWithString:introductionLabel.text andSize:(CGSize){WIDTH(introductionLabel),HUGE_VALL} andFont:introductionLabel.font];
                
                introductionLabel.frame = (CGRect){20,BOTTOM(introductionNoteLabel),WIDTH(scroller)-40,itemDescriptionSize.height};
                
                scroller.contentSize = (CGSize){WIDTH(scroller),MAX(HEIGHT(scroller)+1,BOTTOM(introductionLabel)+10)};
            }
        }
        
    }];
}

-(void)itemDetailAddButtonClick:(UIButton *)button{
    ShopItem *shopItem = shopItemTotalArray[button.tagControl];
    if (shopItem.chooseCount >= 999) {
        shopItem.chooseCount = 999;
        [BYToastView showToastWithMessage:@"选择个数超出限制"];
        return;
    }
    shopItem.chooseCount += 1;
    if (shopItem.chooseCount >= 999) {
        button.enabled = NO;
    }
    UIButton *minusButton = [button.superview viewWithTag:102];
    minusButton.enabled = YES;
    
    UILabel *countLabel = [button.superview viewWithTag:201];
    countLabel.text = [NSString stringWithFormat:@"%d",shopItem.chooseCount];
    
    [self operateWithItem:shopItem typeIsAdd:YES compelte:nil];
    CGPoint po = [MainWindow convertPoint:button.frame.origin fromWindow:nil];
    
    [self shopItemDetailButtonAnimationAtPoint:CGPointMake(button.frame.origin.x, po.y)];
}

-(void)itemDetailMinusButtonClick:(UIButton *)button{
    ShopItem *shopItem = shopItemTotalArray[button.tagControl];
    if (shopItem.chooseCount <= 0) {
        shopItem.chooseCount = 0;
        [BYToastView showToastWithMessage:@"选择个数超出限制"];
        return;
    }
    shopItem.chooseCount -= 1;
    if (shopItem.chooseCount <= 0) {
        button.enabled = NO;
    }
    UIButton *addButton = [button.superview viewWithTag:101];
    addButton.enabled = YES;
    
    UILabel *countLabel = [button.superview viewWithTag:201];
    countLabel.text = [NSString stringWithFormat:@"%d",shopItem.chooseCount];
    
    [self operateWithItem:shopItem typeIsAdd:NO compelte:nil];
}

-(void)shopItemDetailButtonAnimationAtPoint:(CGPoint)point{
    UIView *animationView = [[UIView alloc] init];
    animationView.frame = (CGRect){point.x,point.y,10,10};
    animationView.backgroundColor = UN_RedColor;
    animationView.layer.cornerRadius = 5;
    animationView.layer.masksToBounds = YES;
    [MainWindow addSubview:animationView];
    
    CGPoint startPoint = point;
    CGPoint endPoint = CGPointMake(bottomBuyCarViewHeight/2, HEIGHT(self.view)-bottomBuyCarViewHeight+10);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 130, startPoint.y-130, endPoint.x, endPoint.y);
    
    bounceAnimation.path = thePath;
    bounceAnimation.duration = 0.7;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.fillMode = kCAFillModeRemoved;
    bounceAnimation.delegate = self;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [bounceAnimation setValue:@"bounceAnimationMove" forKey:@"animationValue"];
    [bounceAnimation setValue:animationView forKey:@"view"];
    [animationView.layer addAnimation:bounceAnimation forKey:@"move"];
    
    [animationView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.699];
}

-(void)shopItemTotalCloseButtonClick{
    [self dismissShopItemDetailView];
}

-(void)dismissShopItemDetailView{
    [shopItemBuyCarView removeFromSuperview];
    shopItemBuyCarView.frame = (CGRect){0,HEIGHT(shopItemContentView)-bottomBuyCarViewHeight,WIDTH(shopItemContentView),bottomBuyCarViewHeight};
    [shopItemContentView addSubview:shopItemBuyCarView];
    
    [UIView animateWithDuration:0.3 animations:^{
        shopItemTotalScrollView.alpha = 0;
        shopItemTotalCloseButton.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showShopItemDetailView{
    [self updateItemDetailContentWithCenterIndex:currentDetailItemSelectionIndex];
    
    shopItemBuyCarView.frame = (CGRect){0,GLOBALHEIGHT-bottomBuyCarViewHeight,GLOBALWIDTH,bottomBuyCarViewHeight};
    [MainWindow addSubview:shopItemBuyCarView];
    
    [UIView animateWithDuration:0.3 animations:^{
        shopItemTotalScrollView.alpha = 1;
        shopItemTotalCloseButton.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showDetailItemInfoWithIndex:(int)index{
    if (index <0 || index >= totalShopItemsCount) {
        return;
    }
    currentDetailItemSelectionIndex = index;
    [shopItemTotalScrollView setContentOffset:(CGPoint){currentDetailItemSelectionIndex*WIDTH(shopItemTotalScrollView),0}];
    
    [self showShopItemDetailView];
}

-(void)showDetailItemInfoWithShopItemInfo:(ShopItem *)itemInfo{
    int index = -1;
    for (int i = 0; i < shopItemTotalArray.count; i ++) {
        ShopItem *item = shopItemTotalArray[i];
        if ([itemInfo isEqual:item]) {
            index = i;
            break;
        }
    }
    [self showDetailItemInfoWithIndex:index];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == shopContentScroll) {
        topSelectedView.frame = (CGRect){10+scrollView.contentOffset.x/3,topFunctionViewHeight-2,WIDTH(topFunctionButtoView)/3-10*2,2};
        
        int index = scrollView.contentOffset.x/WIDTH(scrollView);
        [self judgeTopClickedButtonWithIndex:index];
    }else if (scrollView == itemInfoTableView){
        if (isUserScrollActive) {
            NSArray *indexPathArray = [itemInfoTableView indexPathsForVisibleRows];
            if (indexPathArray && indexPathArray.count != 0) {
                NSIndexPath *indexPath = [indexPathArray firstObject];
                [itemMenuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

static bool isUserScrollActive = NO;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isUserScrollActive = YES;
    if (scrollView == shopItemTotalScrollView) {
        CGFloat floatOffset = scrollView.contentOffset.x;
        int index = floatOffset/WIDTH(shopItemTotalScrollView);
        
        [self updateItemDetailContentWithCenterIndex:index];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isUserScrollActive = NO;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == itemMenuTableView) {
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            return 1;
        }
    }else if (tableView == itemInfoTableView){
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            return currentShopItemDataArray.count;
        }
    }else if (tableView == shopJudgementTableView){
        if (currentShopJudgementDataArray && currentShopJudgementDataArray.count != 0) {
            return 1;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == itemMenuTableView) {
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            return nil;
        }
    }else if (tableView == itemInfoTableView) {
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            NSString *titleString = [currentShopItemDataArray[section] objectForKey:@"menu"];
            UIView *view = [[UIView alloc] init];
            view.frame = (CGRect){0,0,WIDTH(tableView),30};
            view.backgroundColor = RGBColor(240, 240, 240);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = titleString;
            titleLabel.frame = (CGRect){15,0,WIDTH(view)-15,HEIGHT(view)};
            titleLabel.textColor = RGBColor(120, 120, 120);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = Font(15);
            [view addSubview:titleLabel];
            return view;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == itemMenuTableView) {
        return 0;
    }else if (tableView == itemInfoTableView){
        return 30;
    }else if (tableView == shopJudgementTableView){
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == itemMenuTableView) {
        return ShopItemCategoryTableCellHeight;
    }else if (tableView == itemInfoTableView){
        return ShopItemDetailTableCellHeight;
    }else if (tableView == shopJudgementTableView){
        NSString *content = [[currentShopJudgementDataArray objectAtIndex:indexPath.row] objectForKey:@"judgeContents"];
        return [ShopJudgeDetailTableCell staticHeightWithJudgeContent:content];
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == itemMenuTableView) {
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            return currentShopItemDataArray.count;
        }
    }else if (tableView == itemInfoTableView){
        if (currentShopItemDataArray && currentShopItemDataArray.count != 0) {
            return [[currentShopItemDataArray[section] objectForKey:@"data"] count];
        }
    }else if (tableView == shopJudgementTableView) {
        if (currentShopJudgementDataArray && currentShopJudgementDataArray.count != 0) {
            return currentShopJudgementDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == itemMenuTableView) {
        static NSString *ShopItemCategoryTableCellIdentifier2211 = @"ShopItemCategoryTableCellIdentifier2211";
        ShopItemCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopItemCategoryTableCellIdentifier2211];
        if (!cell) {
            cell = [[ShopItemCategoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShopItemCategoryTableCellIdentifier2211];
            cell.textLabel.textColor = RGBColor(80, 80, 80);
            cell.textLabel.font = Font(15);
        }
        cell.textString = [currentShopItemDataArray[indexPath.row] objectForKey:@"menu"];
        return cell;
    }else if (tableView == itemInfoTableView){
        static NSString *ShopItemDetailTableCellIdentifier2212 = @"ShopItemDetailTableCellIdentifier2212";
        ShopItemDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopItemDetailTableCellIdentifier2212];
        if (!cell) {
            cell = [[ShopItemDetailTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ShopItemDetailTableCellIdentifier2212];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSDictionary *dic = [currentShopItemDataArray objectAtIndex:indexPath.section];
        NSArray *shopItemsArray = [dic objectForKey:@"data"];
        ShopItem *shopItem = shopItemsArray[indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:shopItem.itemImageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        cell.shopItem = shopItem;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }else if (tableView == shopJudgementTableView) {
        static NSString *ShopJudgementTableViewIdentifier2221 = @"ShopJudgementTableViewIdentifier2221";
        ShopJudgeDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopJudgementTableViewIdentifier2221];
        if (!cell) {
            cell = [[ShopJudgeDetailTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ShopJudgementTableViewIdentifier2221];
        }
        NSDictionary *dic = [currentShopJudgementDataArray objectAtIndex:indexPath.row];
        cell.headUrlString = dic[@"headpic"];
        cell.rating = [dic[@"score"] floatValue];
        cell.username = dic[@"member"];
        cell.judgeContent = dic[@"detial"];
        cell.timeStamp = [dic[@"time"] longLongValue]/1000;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == itemMenuTableView) {
        itemMenuTableView.delegate = nil;
        @try {
            [itemInfoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        itemMenuTableView.delegate = self;
    }else if (tableView == itemInfoTableView){
        NSDictionary *dic = [currentShopItemDataArray objectAtIndex:indexPath.section];
        NSArray *shopItemsArray = [dic objectForKey:@"data"];
        ShopItem *shopItem = shopItemsArray[indexPath.row];
        [self showDetailItemInfoWithShopItemInfo:shopItem];
    }
}

#pragma mark - ShopItemDetailTableCellDelegate
-(void)shopItemDetailCell:(ShopItemDetailTableCell *)itemCell didClickAddButton:(UIButton *)button atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [currentShopItemDataArray objectAtIndex:indexPath.section];
    NSArray *shopItemsArray = [dic objectForKey:@"data"];
    ShopItem *shopItem = shopItemsArray[indexPath.row];
    
    [self operateWithItem:shopItem typeIsAdd:YES compelte:nil];
    
    CGPoint po = [button convertPoint:button.frame.origin toView:self.view];
    [self cellButtonAnimationAtPoint:CGPointMake(button.frame.origin.x + WIDTH(shopContentScroll)/3, po.y-40)];
}

-(void)shopItemDetailCell:(ShopItemDetailTableCell *)itemCell didClickMinusAtButton:(UIButton *)button atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [currentShopItemDataArray objectAtIndex:indexPath.section];
    NSArray *shopItemsArray = [dic objectForKey:@"data"];
    ShopItem *shopItem = shopItemsArray[indexPath.row];
    
    [self operateWithItem:shopItem typeIsAdd:NO compelte:nil];
}

-(void)cellButtonAnimationAtPoint:(CGPoint)point{
    UIView *animationView = [[UIView alloc] init];
    animationView.frame = (CGRect){point.x,point.y,10,10};
    animationView.backgroundColor = UN_RedColor;
    animationView.layer.cornerRadius = 5;
    animationView.layer.masksToBounds = YES;
    [self.view addSubview:animationView];
    
    
    CGPoint startPoint = point;
    CGPoint endPoint = CGPointMake(bottomBuyCarViewHeight/2, HEIGHT(self.view)-bottomBuyCarViewHeight+10);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 130, startPoint.y-130, endPoint.x, endPoint.y);
    
    bounceAnimation.path = thePath;
    bounceAnimation.duration = 0.7;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.fillMode = kCAFillModeRemoved;
    bounceAnimation.delegate = self;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [bounceAnimation setValue:@"bounceAnimationMove" forKey:@"animationValue"];
    [bounceAnimation setValue:animationView forKey:@"view"];
    [animationView.layer addAnimation:bounceAnimation forKey:@"move"];
    
    [animationView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.699];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        NSString *animationType = [anim valueForKey:@"animationValue"];
        if ([animationType isEqualToString:@"bounceAnimationMove"]) {
            UIView *view = [anim valueForKey:@"view"];
            [view removeFromSuperview];
        }
    }
}


#pragma mark - Navigation
-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self setShopCollectState:NO];
}

-(void)leftItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    if (isShopCollect) {
        [self deleteFromCollect];
    }else{
        [self addToCollect];
    }
}

-(void)addToCollect{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"还未登录,请登录"];
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
        return;
    }
    [UNUrlConnection addCollectionShopWithShopID:self.shopInfo.shopID Complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            [BYToastView showToastWithMessage:@"收藏成功"];
            [self setShopCollectState:YES];
        }else{
            [BYToastView showToastWithMessage:messageDic[@"content"]];
        }
    }];
}

-(void)deleteFromCollect{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"还未登录,请登录"];
        [self.navigationController pushViewController:[UserLoginViewController new] animated:YES];
        return;
    }
    [BYToastView showToastWithMessage:@"正在收藏店铺..."];
    [UNUrlConnection deleteCollectionShopWithShopID:self.shopInfo.shopID Complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            [BYToastView showToastWithMessage:@"已取消收藏"];
            [self setShopCollectState:NO];
        }else{
            [BYToastView showToastWithMessage:messageDic[@"content"]];
        }
    }];
}

-(void)setShopCollectState:(BOOL)isCollect{
    if (isCollect) {
        rightCollectimage = [UIImage imageNamed:@"navi_collect_active"];
        isShopCollect = YES;
    }else{
        rightCollectimage = [UIImage imageNamed:@"navi_collect_normal"];
        isShopCollect = NO;
    }
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithImage:rightCollectimage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ShopItemCategoryTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.font = Font(13);
        self.textLabel.numberOfLines = 2;
        self.textLabel.textColor = RGBColor(100, 100, 100);
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){0,0,3,HEIGHT(self.contentView)};
    self.imageView.backgroundColor = UN_RedColor;
    self.imageView.hidden = YES;
    
    self.textLabel.frame = (CGRect){15,0,WIDTH(self.contentView)-15-10,HEIGHT(self.contentView)};
    
    [self.contentView bringSubviewToFront:self.imageView];
    
}

-(void)setTextString:(NSString *)textString{
    if (!textString) {
        textString = @"";
    }
    _textString = textString;
    self.textLabel.text = [NSString stringWithFormat:@"  %@",textString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.imageView.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.imageView.hidden = YES;
        self.backgroundColor = RGBColor(240, 240, 240);
    }
}

@end

@implementation ShopItemDetailTableCell{
    UILabel *priceLabel;
    
    UIButton *itemAddbutton;
    UIButton *itemMinusButton;
    
    UILabel *itemCountLabel;
    
    UIView *bottomView;
    
    float buttonHeight;
    float countLabelWidth;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(16);
        self.textLabel.textColor = RGBColor(80, 80, 80);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = Font(13);
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        
        priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = UN_RedColor;
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = Font(15);
        [self.contentView addSubview:priceLabel];
        
        itemAddbutton = [[UIButton alloc] init];
        [itemAddbutton setImage:[UIImage imageNamed:@"item_add"] forState:UIControlStateNormal];
        [itemAddbutton addTarget:self action:@selector(itemAddbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemAddbutton];
        
        itemMinusButton = [[UIButton alloc] init];
        [itemMinusButton setImage:[UIImage imageNamed:@"item_minus"] forState:UIControlStateNormal];
        [itemMinusButton addTarget:self action:@selector(itemMinusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemMinusButton];
        
        itemCountLabel = [[UILabel alloc] init];
        itemCountLabel.textColor = RGBColor(100, 100, 100);
        itemCountLabel.textAlignment = NSTextAlignmentCenter;
        itemCountLabel.font = Font(13);
        [self.contentView addSubview:itemCountLabel];
        
        if (Is3_5Inches() || Is4Inches()) {
            buttonHeight = 25;
            self.textLabel.font = Font(15);
            self.detailTextLabel.font = Font(11);
            priceLabel.font = Font(14);
            itemCountLabel.font = Font(12);
            countLabelWidth = 25;
        }else if (IS4_7Inches()){
            buttonHeight = 30;
            self.textLabel.font = Font(16);
            self.detailTextLabel.font = Font(12);
            priceLabel.font = Font(16);
            itemCountLabel.font = Font(13);
            countLabelWidth = 30;
        }else if (IS5_5Inches()){
            buttonHeight = 30;
            self.textLabel.font = Font(17);
            self.detailTextLabel.font = Font(13);
            priceLabel.font = Font(16);
            itemCountLabel.font = Font(15);
            countLabelWidth = 35;
        }
    }
    return self;
}

-(void)itemAddbuttonClick{
    [UIView animateWithDuration:0.1f animations:^{
        [itemAddbutton setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            [itemAddbutton setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
    }];
    if (self.shopItem.chooseCount == 999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能选择更多了" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.shopItem.chooseCount += 1;
    [self refreshContent];
    if ([self.delegate respondsToSelector:@selector(shopItemDetailCell:didClickAddButton:atIndexPath:)]) {
        [self.delegate shopItemDetailCell:self didClickAddButton:itemAddbutton atIndexPath:self.indexPath];
    }
}

-(void)itemMinusButtonClick{
    [UIView animateWithDuration:0.1f animations:^{
        [itemMinusButton setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            [itemMinusButton setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
    }];
    if (self.shopItem.chooseCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能减少更多了" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.shopItem.chooseCount -= 1;
    [self refreshContent];
    if ([self.delegate respondsToSelector:@selector(shopItemDetailCell:didClickMinusAtButton:atIndexPath:)]) {
        [self.delegate shopItemDetailCell:self didClickMinusAtButton:itemMinusButton atIndexPath:self.indexPath];
    }
}

-(void)refreshContent{
    if (self.shopItem.chooseCount <= 0) {
        self.shopItem.chooseCount = 0;
        itemCountLabel.alpha = 0;
        itemMinusButton.alpha = 0;
        itemCountLabel.text = @"0";
    }else{
        itemCountLabel.alpha = 1;
        itemMinusButton.alpha = 1;
        itemCountLabel.text = [NSString stringWithFormat:@"%d",self.shopItem.chooseCount];
    }
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){0,10,ShopItemDetailTableCellHeight-10*2,ShopItemDetailTableCellHeight-10*2};
    
    self.textLabel.frame = (CGRect){RIGHT(self.imageView)+10,TOP(self.imageView),WIDTH(self.contentView)-RIGHT(self.imageView)-10-10,16};
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+5,WIDTH(self.textLabel),13};
    
    priceLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.detailTextLabel)+7,70,16};
    
    itemAddbutton.frame = (CGRect){WIDTH(self.contentView)-10-buttonHeight,HEIGHT(self.contentView)-5-buttonHeight,buttonHeight,buttonHeight};
    
    itemMinusButton.frame = (CGRect){WIDTH(self.contentView)-10-buttonHeight-countLabelWidth-buttonHeight,
        TOP(itemAddbutton),buttonHeight,buttonHeight};
    
    itemCountLabel.frame = (CGRect){LEFT(itemAddbutton)-countLabelWidth,TOP(itemAddbutton),countLabelWidth,HEIGHT(itemAddbutton)};
    
    if (self.shopItem.chooseCount <= 0) {
        self.shopItem.chooseCount = 0;
        itemCountLabel.alpha = 0;
        itemMinusButton.alpha = 0;
        itemCountLabel.text = @"0";
    }else{
        itemCountLabel.alpha = 1;
        itemMinusButton.alpha = 1;
        itemCountLabel.text = [NSString stringWithFormat:@"%d",self.shopItem.chooseCount];
    }
    
    //    self.imageView.backgroundColor = [UIColor redColor];
    
}

-(void)setShopItem:(ShopItem *)shopItem{
    _shopItem = shopItem;
    NSString *itemName = shopItem.itemName;
    self.textLabel.text = itemName?itemName:@"";
    
    NSString *itemImageUrl = shopItem.itemImageUrl;
    if (itemImageUrl) {
        
    }else{
        
    }
    
    int soldNum = shopItem.soldNum;
    int recommendNum = shopItem.recommendNum;
    self.detailTextLabel.text = [NSString stringWithFormat:@"售出%d份 推荐%d",soldNum,recommendNum];
    
    float price = shopItem.price;
    
    if ((price*10)-((int)price)*10 == 0) {
        priceLabel.text = [NSString stringWithFormat:@"￥%d",(int)price];
    }else{
        priceLabel.text = [NSString stringWithFormat:@"￥%.1f",price];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = RGBColor(220, 220, 220);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

@implementation ShopJudgeDetailTableCell {
    RatingView *ratingView;
    
    UILabel *jusgeContentLabel;
    
    UIView *sepLineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ratingView = [[RatingView alloc] init];
        [ratingView setImagesDeselected:@"star" partlySelected:@"star_on" fullSelected:@"star_on"];
        ratingView.frame = (CGRect){10,0,75,15};
        [self.contentView addSubview:ratingView];
        
        jusgeContentLabel = [[UILabel alloc] init];
        jusgeContentLabel.textAlignment = NSTextAlignmentLeft;
        jusgeContentLabel.textColor = RGBColor(50, 50, 50);
        jusgeContentLabel.font = Font(14);
        jusgeContentLabel.numberOfLines = -1;
        [self.contentView addSubview:jusgeContentLabel];
        
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.textColor = RGBColor(200, 200, 200);
        self.textLabel.font = Font(12);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(200, 200, 200);
        self.detailTextLabel.font = Font(11);
        
        sepLineView = [[UIView alloc] init];
        sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView];
    }
    return self;
}

-(void)layoutSubviews{
    //    self.imageView.hidden = YES;
    //    shop_judge_userheadimg_default
    ratingView.frame = (CGRect){10,10,75,15};
    [ratingView displayRating:self.rating];
    
    self.textLabel.frame = (CGRect){RIGHT(ratingView)+10,TOP(ratingView),WIDTH(self.contentView)-(RIGHT(ratingView)+10)-10-15-5,15};
    
    self.imageView.frame = (CGRect){WIDTH(self.contentView)-10-15,TOP(ratingView),15,15};
    
    float judgeContentLabelWidth = WIDTH(self.contentView)-2*LEFT(ratingView);
    
    CGSize size = [UNTools getSizeWithString:self.judgeContent andSize:(CGSize){judgeContentLabelWidth,MAXFLOAT} andFont:jusgeContentLabel.font];
    
    jusgeContentLabel.frame = (CGRect){LEFT(ratingView),BOTTOM(ratingView)+10,WIDTH(self.contentView)-2*LEFT(ratingView),MAX(size.height, 15)};
    
    self.detailTextLabel.frame = (CGRect){LEFT(ratingView),BOTTOM(jusgeContentLabel)+10,110,14};
    
    float height = [ShopJudgeDetailTableCell staticHeightWithJudgeContent:self.judgeContent];
    sepLineView.frame = (CGRect){0,height-0.5,WIDTH(self.contentView),0.5};
}

+(CGFloat)staticHeightWithJudgeContent:(NSString *)content{
    CGSize size = [UNTools getSizeWithString:content andSize:(CGSize){GLOBALWIDTH-20,MAXFLOAT} andFont:Font(14)];
    return 70+MAX(size.height, 15);
}

-(void)setHeadUrlString:(NSString *)headUrlString{
    _headUrlString = headUrlString;
    [self.imageView setImageWithURL:[NSURL URLWithString:headUrlString] placeholderImage:[UIImage imageNamed:@"shop_judge_userheadimg_default"]];
}

-(void)setRating:(float)rating{
    _rating = rating;
    [ratingView displayRating:rating];
}

-(void)setUsername:(NSString *)username{
    _username = username;
    if (username) {
        self.textLabel.text = username;
    }else{
        self.textLabel.text = @"";
    }
}

-(void)setTimeStamp:(long long)timeStamp{
    _timeStamp = timeStamp;
    if (timeStamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        if (destDateString) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"%@",destDateString];
        }
    }
}

-(void)setJudgeContent:(NSString *)judgeContent{
    _judgeContent = judgeContent;
    if (judgeContent) {
        jusgeContentLabel.text = judgeContent;
    }else{
        jusgeContentLabel.text = @"";
    }
}

@end
