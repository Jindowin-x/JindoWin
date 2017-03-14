//
//  VoucherViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//


#import "VoucherViewController.h"
#import "VoucherTableViewCell.h"

#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

@interface VoucherViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,strong) UITableView *unUsedTableView;

@property (nonatomic,strong) UITableView *usedTableView;

@property (nonatomic,strong) UITableView *expiredTableView;

@property (nonatomic,strong) NSMutableArray *unUsedDataArray;

@property (nonatomic,strong) NSMutableArray *usedDataArray;

@property (nonatomic,strong) NSMutableArray *expiredDataArray;

@end

@implementation VoucherViewController{
    UIView *selectedView;
    
    UIButton *addDaijinquandismissButton;
    UITextField *addVoucherTextField;
    
    UIView *noUnUsedVoucherView;
    UIView *noUsedVoucherView;
    UIView *noExpiredVoucherView;
}

@synthesize contentView,mainScroller,unUsedDataArray,usedTableView,expiredTableView;

@synthesize usedDataArray,unUsedTableView,expiredDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的代金券";
    
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
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = (CGRect){0,0,WIDTH(contentView),40};
    headView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:headView];
    
    UIButton *unUsedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [unUsedButton setTitle:@"未使用" forState:UIControlStateNormal];
    [unUsedButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    unUsedButton.titleLabel.font = Font(15);
    unUsedButton.frame = (CGRect){0,0,WIDTH(headView)/3,HEIGHT(headView)};
    unUsedButton.tag = 0;
    [unUsedButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:unUsedButton];
    
    UIView *lineSepView1 = [[UIView alloc] init];
    lineSepView1.frame = (CGRect){WIDTH(headView)/3-0.5,10,0.5,HEIGHT(headView)-20};
    lineSepView1.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [headView addSubview:lineSepView1];
    
    UIButton *usedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [usedButton setTitle:@"已使用" forState:UIControlStateNormal];
    [usedButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    usedButton.titleLabel.font = Font(15);
    usedButton.frame = (CGRect){WIDTH(headView)/3,0,WIDTH(headView)/3,HEIGHT(headView)};
    usedButton.tag = 1;
    [usedButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:usedButton];
    
    UIView *lineSepView2 = [[UIView alloc] init];
    lineSepView2.frame = (CGRect){WIDTH(headView)*2/3-0.5,10,0.5,HEIGHT(headView)-20};
    lineSepView2.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [headView addSubview:lineSepView2];
    
    UIButton *expiredButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [expiredButton setTitle:@"已失效" forState:UIControlStateNormal];
    [expiredButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    expiredButton.titleLabel.font = Font(15);
    expiredButton.frame = (CGRect){WIDTH(headView)*2/3,0,WIDTH(headView)/3,HEIGHT(headView)};
    expiredButton.tag = 2;
    [expiredButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:expiredButton];
    
    UIView *lineSep = [[UIView alloc] init];
    lineSep.frame = (CGRect){0,HEIGHT(headView)-0.5,WIDTH(headView),0.5};
    lineSep.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [headView addSubview:lineSep];
    
    selectedView = [[UIView alloc] init];
    selectedView.frame = (CGRect){0,HEIGHT(headView)-2,WIDTH(headView)/3,2};
    selectedView.backgroundColor = UN_RedColor;
    [headView addSubview:selectedView];
    
    mainScroller = [[UIScrollView alloc] init];
    mainScroller.frame = (CGRect){0,BOTTOM(headView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(headView)};
    mainScroller.contentSize = (CGSize){WIDTH(mainScroller)*3,HEIGHT(mainScroller)};
    mainScroller.showsHorizontalScrollIndicator = NO;
    mainScroller.showsVerticalScrollIndicator = NO;
    mainScroller.backgroundColor = contentView.backgroundColor;
    mainScroller.pagingEnabled = YES;
    mainScroller.delegate = self;
    [contentView addSubview:mainScroller];
    
    weak(weakself, self);
    
    noUnUsedVoucherView = [[UIView alloc] init];
    noUnUsedVoucherView.tag = 0;
    noUnUsedVoucherView.alpha = 0.f;
    noUnUsedVoucherView.frame = (CGRect){0,0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    noUnUsedVoucherView.backgroundColor = mainScroller.backgroundColor;
    [mainScroller addSubview:noUnUsedVoucherView];
    
    [noUnUsedVoucherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voucherViewTapGestureTriggle:)]];
    
    
    UILabel *noUnUsedVoucherLabel = [[UILabel alloc] init];
    noUnUsedVoucherLabel.text = @"您还没有未使用的代金券哦";
    noUnUsedVoucherLabel.frame = (CGRect){0,HEIGHT(noUnUsedVoucherView)*2/7,WIDTH(noUnUsedVoucherView),30};
    noUnUsedVoucherLabel.textColor = RGBColor(180, 180, 180);
    noUnUsedVoucherLabel.textAlignment = NSTextAlignmentCenter;
    noUnUsedVoucherLabel.font = Font(15);
    [noUnUsedVoucherView addSubview:noUnUsedVoucherLabel];
    
    
    unUsedTableView = [[UITableView alloc] init];
    unUsedTableView.frame = (CGRect){0,0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    [mainScroller addSubview:unUsedTableView];
    unUsedTableView.tag = 6201;
    unUsedTableView.alpha = 0.f;
    unUsedTableView.delegate = self;
    unUsedTableView.dataSource = self;
    unUsedTableView.showsHorizontalScrollIndicator = NO;
    unUsedTableView.showsVerticalScrollIndicator = NO;
    unUsedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    unUsedTableView.backgroundColor = mainScroller.backgroundColor;
    [unUsedTableView initDownRefresh];
    
    [unUsedTableView setDownRefreshBlock:^(id refreshView){
        [weakself getAllUnusedVoucherList];
    }];
    
    noUsedVoucherView = [[UIView alloc] init];
    noUsedVoucherView.tag = 1;
    noUsedVoucherView.alpha = 0.f;
    noUsedVoucherView.frame = (CGRect){WIDTH(mainScroller),0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    noUsedVoucherView.backgroundColor = mainScroller.backgroundColor;
    [mainScroller addSubview:noUsedVoucherView];
    
    [noUsedVoucherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voucherViewTapGestureTriggle:)]];
    
    UILabel *noUsedVoucherLabel = [[UILabel alloc] init];
    noUsedVoucherLabel.text = @"您还没有已经使用的代金券哦";
    noUsedVoucherLabel.frame = (CGRect){0,HEIGHT(noUsedVoucherView)*2/7,WIDTH(noUsedVoucherView),30};
    noUsedVoucherLabel.textColor = RGBColor(180, 180, 180);
    noUsedVoucherLabel.textAlignment = NSTextAlignmentCenter;
    noUsedVoucherLabel.font = Font(15);
    [noUsedVoucherView addSubview:noUsedVoucherLabel];
    
    usedTableView = [[UITableView alloc] init];
    usedTableView.alpha = 0.f;
    usedTableView.frame = (CGRect){WIDTH(mainScroller),0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    [mainScroller addSubview:usedTableView];
    usedTableView.tag = 6202;
    usedTableView.delegate = self;
    usedTableView.dataSource = self;
    usedTableView.showsHorizontalScrollIndicator = NO;
    usedTableView.showsVerticalScrollIndicator = NO;
    usedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    usedTableView.backgroundColor = mainScroller.backgroundColor;
    [usedTableView initDownRefresh];
    
    [usedTableView setDownRefreshBlock:^(id refreshView){
        [weakself getAllUsedVoucherList];
    }];
    
    noExpiredVoucherView = [[UIView alloc] init];
    noExpiredVoucherView.tag = 2;
    noExpiredVoucherView.alpha = 0.f;
    noExpiredVoucherView.frame = (CGRect){WIDTH(mainScroller)*2,0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    noExpiredVoucherView.backgroundColor = mainScroller.backgroundColor;
    [mainScroller addSubview:noExpiredVoucherView];
    
    [noExpiredVoucherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voucherViewTapGestureTriggle:)]];
    
    UILabel *noExpiredVoucherLabel = [[UILabel alloc] init];
    noExpiredVoucherLabel.text = @"您还没有已经过期的代金券哦";
    noExpiredVoucherLabel.frame = (CGRect){0,HEIGHT(noExpiredVoucherView)*2/7,WIDTH(noExpiredVoucherView),30};
    noExpiredVoucherLabel.textColor = RGBColor(180, 180, 180);
    noExpiredVoucherLabel.textAlignment = NSTextAlignmentCenter;
    noExpiredVoucherLabel.font = Font(15);
    [noExpiredVoucherView addSubview:noExpiredVoucherLabel];
    
    
    expiredTableView = [[UITableView alloc] init];
    expiredTableView.alpha = 0.f;
    expiredTableView.frame = (CGRect){WIDTH(mainScroller)*2,0,WIDTH(mainScroller),HEIGHT(mainScroller)};
    [mainScroller addSubview:expiredTableView];
    expiredTableView.tag = 6203;
    expiredTableView.delegate = self;
    expiredTableView.dataSource = self;
    expiredTableView.showsHorizontalScrollIndicator = NO;
    expiredTableView.showsVerticalScrollIndicator = NO;
    expiredTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    expiredTableView.backgroundColor = mainScroller.backgroundColor;
    [expiredTableView initDownRefresh];
    
    [expiredTableView setDownRefreshBlock:^(id refreshView){
        [weakself getAllExpiredVoucherList];
    }];
    
    [self getVoucherAndReload];
}

-(void)voucherViewTapGestureTriggle:(UITapGestureRecognizer *)tap{
    UIView *vew = tap.view;
    NSString *toastString;
    switch (vew.tag) {
        case 0:{
            toastString = @"正在获取未使用的优惠券";
            [BYToastView showToastWithMessage:toastString];
            [self performSelector:@selector(getAllUnusedVoucherList) withObject:nil afterDelay:1.f];
        }
            break;
        case 1:{
            toastString = @"正在获取已经使用的优惠券";
            [BYToastView showToastWithMessage:toastString];
            [self performSelector:@selector(getAllUsedVoucherList) withObject:nil afterDelay:1.f];
        }
            break;
        case 2:{
            toastString = @"正在获取已经过期使用的优惠券";
            [BYToastView showToastWithMessage:toastString];
            [self performSelector:@selector(getAllExpiredVoucherList) withObject:nil afterDelay:1.f];
        }
            break;
            
        default:
            break;
    }
}

-(void)getVoucherAndReload{
    //    unUsedDataArray = [NSMutableArray array];
    //    [unUsedDataArray addObject:@{@"number":@"10",
    //                                 @"source":@"百度外卖",
    //                                 @"expired":@"1448598334",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    [unUsedDataArray addObject:@{@"number":@"20",
    //                                 @"source":@"百度外卖",
    //                                 @"expired":@"1448611134",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    [unUsedDataArray addObject:@{@"number":@"100",
    //                                 @"source":@"联合外卖",
    //                                 @"expired":@"1449590004",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    unUsedTableView.alpha = 1.f;
    //    [unUsedTableView reloadData];
    //    
    //    
    //    usedDataArray = [NSMutableArray array];
    //    [usedDataArray addObject:@{@"number":@"10",
    //                                 @"source":@"百度外卖",
    //                                 @"expired":@"1445598334",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    [usedDataArray addObject:@{@"number":@"20",
    //                                 @"source":@"百度外卖",
    //                                 @"expired":@"1443611134",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    [usedDataArray addObject:@{@"number":@"100",
    //                                 @"source":@"联合外卖",
    //                                 @"expired":@"1441590004",
    //                                 @"seril":@"BUYT9098",
    //                                 }];
    //    usedTableView.alpha = 1.f;
    //    [usedTableView reloadData];
    //    
    //    
    //    
    //    expiredDataArray = [NSMutableArray array];
    //    [expiredDataArray addObject:@{@"number":@"10",
    //                               @"source":@"百度外卖",
    //                               @"expired":@"1441598334",
    //                               @"seril":@"BUYT9098",
    //                               }];
    //    [expiredDataArray addObject:@{@"number":@"20",
    //                               @"source":@"百度外卖",
    //                               @"expired":@"1442611134",
    //                               @"seril":@"BUYT9098",
    //                               }];
    //    [expiredDataArray addObject:@{@"number":@"100",
    //                               @"source":@"联合外卖",
    //                               @"expired":@"1443590004",
    //                               @"seril":@"BUYT9098",
    //                               }];
    //    expiredTableView.alpha = 1.f;
    //    [expiredTableView reloadData];
    
    
    [self getAllUnusedVoucherList];
    [self getAllUsedVoucherList];
    [self getAllExpiredVoucherList];
}

-(void)reloadUnusedTableView{
    if (!unUsedDataArray ||unUsedDataArray.count == 0) {
        unUsedTableView.alpha = 0.f;
        noUnUsedVoucherView.alpha = 1.f;
    }else{
        unUsedTableView.alpha = 1.f;
        noUnUsedVoucherView.alpha = 0.f;
        [unUsedTableView reloadData];
    }
}

-(void)reloadUsedTableView{
    if (!usedDataArray ||usedDataArray.count == 0) {
        usedTableView.alpha = 0.f;
        noUsedVoucherView.alpha = 1.f;
    }else{
        usedTableView.alpha = 1.f;
        noUsedVoucherView.alpha = 0.f;
        [usedTableView reloadData];
    }
}

-(void)reloadExpiredTableView{
    if (!expiredDataArray ||expiredDataArray.count == 0) {
        expiredTableView.alpha = 0.f;
        noExpiredVoucherView.alpha = 1.f;
    }else{
        expiredTableView.alpha = 1.f;
        noExpiredVoucherView.alpha = 0.f;
        [expiredTableView reloadData];
    }
}

//获取所有未使用的优惠券
-(void)getAllUnusedVoucherList{
    __block NSMutableArray *allUnUnsedArrayTmp = [NSMutableArray array];
    [UNUrlConnection getAllUnusedVoucherListComlete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:@"获取未使用的代金券失败,请稍候再试"];
            unUsedDataArray = allUnUnsedArrayTmp;
            [self reloadUnusedTableView];
            return;
        }
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isEqualToString:@"success"]) {
            NSArray *listArray = resultDic[@"list"];
            unUsedDataArray = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                if (obj && obj.count >= 3) {
                    NSString *timeStamp = [NSString stringWithFormat:@"%lld",[obj[0] longLongValue]/1000];
                    NSString *priceString = obj[1];
                    NSString *numTmp = [priceString stringByReplacingOccurrencesOfString:@"元代金券" withString:@""];
                    NSString *voucherID = obj[2];
                    if (timeStamp && numTmp && voucherID) {
                        [allUnUnsedArrayTmp addObject:@{@"number":numTmp,
                                                        @"source":@"联合外卖",
                                                        @"expired":timeStamp,
                                                        @"seril":voucherID,
                                                        }];
                    }
                }
            }];
            if (allUnUnsedArrayTmp.count == 0) {
                [BYToastView showToastWithMessage:@"无数据"];
            }
            unUsedDataArray = allUnUnsedArrayTmp;
            [self reloadUnusedTableView];
            [unUsedTableView endDownRefresh];
        }else{
            [BYToastView showToastWithMessage:@"获取未使用的代金券失败,请稍候再试"];
            unUsedDataArray = allUnUnsedArrayTmp;
            [self reloadUnusedTableView];
            [unUsedTableView endDownRefresh];
            return;
        }
    }];
}

//获取所有已经使用的优惠券
-(void)getAllUsedVoucherList{
    __block NSMutableArray *allUnsedArrayTmp = [NSMutableArray array];
    [UNUrlConnection getAllUsedVoucherListComlete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:@"获取已使用的代金券失败,请稍候再试"];
            usedDataArray = allUnsedArrayTmp;
            [self reloadUsedTableView];
            return;
        }
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isEqualToString:@"success"]) {
            NSArray *listArray = resultDic[@"list"];
            
            [listArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                if (obj && obj.count >= 3) {
                    NSString *timeStamp = [NSString stringWithFormat:@"%lld",[obj[0] longLongValue]/1000];
                    NSString *priceString = obj[1];
                    NSString *numTmp = [priceString stringByReplacingOccurrencesOfString:@"元代金券" withString:@""];
                    NSString *voucherID = obj[2];
                    if (timeStamp && numTmp && voucherID) {
                        [allUnsedArrayTmp addObject:@{@"number":numTmp,
                                                      @"source":@"联合外卖",
                                                      @"expired":timeStamp,
                                                      @"seril":voucherID,
                                                      }];
                    }
                }
            }];
            if (allUnsedArrayTmp.count == 0) {
                [BYToastView showToastWithMessage:@"无数据"];
            }
            usedDataArray = allUnsedArrayTmp;
            [self reloadUsedTableView];
            [usedTableView endDownRefresh];
        }else{
            [BYToastView showToastWithMessage:@"获取已使用的代金券失败,请稍候再试"];
            usedDataArray = allUnsedArrayTmp;
            [self reloadUsedTableView];
            [usedTableView endDownRefresh];
            return;
        }
    }];
}

//获取所有已经过期的优惠券
-(void)getAllExpiredVoucherList{
    __block NSMutableArray *allExpiredArrayTmp = [NSMutableArray array];
    [UNUrlConnection getAllExpiredVoucherListComlete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:@"获取已过期的代金券失败,请稍候再试"];
            expiredDataArray = allExpiredArrayTmp;
            [self reloadExpiredTableView];
            return;
        }
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isEqualToString:@"success"]) {
            NSArray *listArray = resultDic[@"list"];
            expiredDataArray = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                if (obj && obj.count >= 3) {
                    NSString *timeStamp = [NSString stringWithFormat:@"%lld",[obj[0] longLongValue]/1000];
                    NSString *priceString = obj[1];
                    NSString *numTmp = [priceString stringByReplacingOccurrencesOfString:@"元代金券" withString:@""];
                    NSString *voucherID = obj[2];
                    if (timeStamp && numTmp && voucherID) {
                        [allExpiredArrayTmp addObject:@{@"number":numTmp,
                                                        @"source":@"联合外卖",
                                                        @"expired":timeStamp,
                                                        @"seril":voucherID,
                                                        }];
                    }
                }
            }];
            if (allExpiredArrayTmp.count == 0) {
                [BYToastView showToastWithMessage:@"无数据"];
            }
            expiredDataArray = allExpiredArrayTmp;
            [self reloadExpiredTableView];
            [expiredTableView endDownRefresh];
        }else{
            [BYToastView showToastWithMessage:@"获取已过期的代金券失败,请稍候再试"];
            expiredDataArray = allExpiredArrayTmp;
            [self reloadExpiredTableView];
            [expiredTableView endDownRefresh];
            return;
        }
    }];
}

//+(void)getAllUnusedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//
//+(void)getAllUsedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//
//+(void)getAllExpiredVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


-(void)headButtonClick:(UIButton *)button{
    if (button.tag < 0 || button.tag > 2) {
        return;
    }
    [mainScroller setContentOffset:(CGPoint){WIDTH(mainScroller)*button.tag,0} animated:YES];
}


#pragma mark - scrollerview Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == mainScroller) {
        selectedView.frame = (CGRect){scrollView.contentOffset.x/3,selectedView.frame.origin.y,selectedView.frame.size.width,selectedView.frame.size.height};
    }
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == unUsedTableView) {
        if (unUsedDataArray && unUsedDataArray.count != 0) {
            return [VoucherTableViewCell staticCellHieght];
        }
    }else if (tableView == usedTableView){
        if (usedDataArray && usedDataArray.count != 0) {
            return [VoucherTableViewCell staticCellHieght];
        }
    }else if (tableView == expiredTableView) {
        if (expiredDataArray && expiredDataArray.count != 0) {
            return [VoucherTableViewCell staticCellHieght];
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == unUsedTableView) {
        if (unUsedDataArray && unUsedDataArray.count != 0) {
            return unUsedDataArray.count;
        }
    }else if (tableView == usedTableView){
        if (usedDataArray && usedDataArray.count != 0) {
            return usedDataArray.count;
        }
    }else if (tableView == expiredTableView) {
        if (expiredDataArray && expiredDataArray.count != 0) {
            return expiredDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == unUsedTableView) {
        static NSString *VoucherTableViewCellIdentifier6201 = @"VoucherTableViewCellIdentifier6201";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VoucherTableViewCellIdentifier6201];
        if (!cell) {
            cell = [[VoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:VoucherTableViewCellIdentifier6201];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.voucherType = VoucherTypeUnUsed;
        cell.voucherNum = [unUsedDataArray[indexPath.row][@"number"] intValue];
        cell.voucherSource = unUsedDataArray[indexPath.row][@"source"];
        cell.voucherSerilNumber = unUsedDataArray[indexPath.row][@"seril"];
        cell.voucherExpredTimeStamp = [unUsedDataArray[indexPath.row][@"expired"] longLongValue];
        return cell;
    }else if (tableView == usedTableView){
        static NSString *VoucherTableViewCellIdentifier6202 = @"VoucherTableViewCellIdentifier6202";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VoucherTableViewCellIdentifier6202];
        if (!cell) {
            cell = [[VoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:VoucherTableViewCellIdentifier6202];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.voucherType = VoucherTypeUsed;
        cell.voucherNum = [unUsedDataArray[indexPath.row][@"number"] intValue];
        cell.voucherSource = unUsedDataArray[indexPath.row][@"source"];
        cell.voucherSerilNumber = unUsedDataArray[indexPath.row][@"seril"];
        cell.voucherExpredTimeStamp = [unUsedDataArray[indexPath.row][@"expired"] longLongValue];
        return cell;
    }else if (tableView == expiredTableView) {
        static NSString *VoucherTableViewCellIdentifier6203 = @"VoucherTableViewCellIdentifier6203";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VoucherTableViewCellIdentifier6203];
        if (!cell) {
            cell = [[VoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:VoucherTableViewCellIdentifier6203];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.voucherType = VoucherTypeExpired;
        cell.voucherNum = [unUsedDataArray[indexPath.row][@"number"] intValue];
        cell.voucherSource = unUsedDataArray[indexPath.row][@"source"];
        cell.voucherSerilNumber = unUsedDataArray[indexPath.row][@"seril"];
        cell.voucherExpredTimeStamp = [unUsedDataArray[indexPath.row][@"expired"] longLongValue];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"新增" forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,30,20};
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
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    addDaijinquandismissButton = [[UIButton alloc] init];
    addDaijinquandismissButton.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    addDaijinquandismissButton.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    [keyWindow addSubview:addDaijinquandismissButton];
    [addDaijinquandismissButton addTarget:self action:@selector(dismissAddVoucherView) forControlEvents:UIControlEventTouchUpInside];
    addDaijinquandismissButton.alpha = 0;
    
    [addDaijinquandismissButton.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float alighY = 110;
    //    float totalHeight = 130;
    if (Is4Inches()) {
        alighY = 120;
    }else if (IS4_7Inches()){
        alighY = 210;
    }else if (IS5_5Inches()){
        alighY = 230;
    }
    
    UIView *addVoucherView = [[UIView alloc] init];
    addVoucherView.frame = (CGRect){(WIDTH(keyWindow)-280)/2,alighY+100,280 ,125};
    addVoucherView.backgroundColor = [UIColor whiteColor];
    addVoucherView.layer.cornerRadius = 2.f;
    addVoucherView.layer.masksToBounds = YES;
    [addDaijinquandismissButton addSubview:addVoucherView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = (CGRect){0,0,WIDTH(addVoucherView),45};
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGBColor(80, 80, 80);
    titleLabel.font = Font(17);
    titleLabel.text = @"添加代金券";
    [addVoucherView addSubview:titleLabel];
    
    UIView *lineSep1 = [[UIView alloc] init];
    lineSep1.frame = (CGRect){0,BOTTOM(titleLabel)-0.5,WIDTH(addVoucherView),0.5};
    lineSep1.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [addVoucherView addSubview:lineSep1];
    
    addVoucherTextField = [[UITextField alloc] init];
    addVoucherTextField.frame = (CGRect){20,BOTTOM(titleLabel)+3,(WIDTH(addVoucherView)-20*2),35};
    addVoucherTextField.textColor = RGBColor(100, 100, 100);
    addVoucherTextField.font = Font(15);
    addVoucherTextField.tag = 100;
    addVoucherTextField.delegate = self;
    addVoucherTextField.returnKeyType = UIReturnKeyDone;
    addVoucherTextField.placeholder = @"输入代金券号码";
    [addVoucherTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [addVoucherTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [addVoucherView addSubview:addVoucherTextField];
    
    UIView *lineSep2 = [[UIView alloc] init];
    lineSep2.frame = (CGRect){0,BOTTOM(addVoucherTextField)+2-0.5,WIDTH(addVoucherView),0.5};
    lineSep2.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [addVoucherView addSubview:lineSep2];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = (CGRect){0,BOTTOM(lineSep2),WIDTH(addVoucherView)/2,40};
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = Font(15);
    [addVoucherView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(dismissAddVoucherView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmButton.frame = (CGRect){RIGHT(cancelButton),BOTTOM(lineSep2),WIDTH(addVoucherView)/2,40};
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UN_RedColor forState:UIControlStateNormal];
    confirmButton.titleLabel.font = Font(15);
    [addVoucherView addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(addVoucherDone) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineSep3 = [[UIView alloc] init];
    lineSep3.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    lineSep3.frame = (CGRect){WIDTH(addVoucherView)/2-0.5,BOTTOM(lineSep2),1,40};
    [addVoucherView addSubview:lineSep3];
    
    [UIView animateWithDuration:0.2f animations:^{
        addDaijinquandismissButton.alpha = 1;
        addVoucherView.frame = (CGRect){(WIDTH(keyWindow)-280)/2,alighY,280 ,125};
    }];
    [addVoucherTextField becomeFirstResponder];
}

-(void)dismissAddVoucherView{
    [addVoucherTextField resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        addDaijinquandismissButton.alpha = 0;
    }completion:^(BOOL finished) {
        [addDaijinquandismissButton removeFromSuperview];
    }];
    
}

-(void)addVoucherDone{
    NSString *voucherText = addVoucherTextField.text;
    if (!voucherText || [voucherText isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"代金券号码不能为空"];
        return;
    }else{
        if ([voucherText rangeOfString:@" "].length != 0) {
            [BYToastView showToastWithMessage:@"代金券号码不能包含空格"];
            return;
        }
        if (![self checkString:voucherText]) {
            [BYToastView showToastWithMessage:@"代金券号码不能包含特殊字符"];
            return;
        }
    }
    
    [self dismissAddVoucherView];
    [BYToastView showToastWithMessage:@"正在添加优惠券..."];
    [UNUrlConnection addVoucherWithCode:voucherText comlete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }else{
            NSDictionary *messDic = resultDic[@"message"];
            NSString *typeString = [messDic objectForKey:@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                NSLog(@"添加优惠券  返回:%@",resultDic);
                [BYToastView showToastWithMessage:@"添加成功"];
                [self getVoucherAndReload];
            }else{
                NSString *content = messDic[@"content"];
                if (!content) {
                    content = @"添加优惠券失败";
                }
                [BYToastView showToastWithMessage:content];
            }
        }
    }];
}

-(BOOL)checkString:(NSString *)string{
    if ([string rangeOfString:@" "].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"*"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"&"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"%"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"/"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"\\"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"="].length != 0) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == addVoucherTextField) {
        [self addVoucherDone];
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    //    if (contentTableView) {
    //        [self reloadContentDataTableView];
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
