//
//  OrderMoreStateViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/8.
//  Copyright © 2015年 _companyname_. All rights reserved.
//
#import "OrderMoreStateViewController.h"
#import "OrderJudgeViewController.h"
#import "OrderSueViewController.h"
#import "ShopDetailViewController.h"

#import "UNUrlConnection.h"

#import "ShopInfo.h"

@interface OrderMoreStateViewController ()

@end

@implementation OrderMoreStateViewController{
    UIScrollView *contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"订单状态";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-45};
    contentView.backgroundColor = RGBColor(240, 240, 240);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    bottomView.backgroundColor = RGBColor(250, 250, 250);
    [self.view addSubview:bottomView];
    
    UIButton *bottomComeAnotherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomComeAnotherButton.frame = (CGRect){0,0,WIDTH(bottomView)/3,HEIGHT(bottomView)};
    [bottomComeAnotherButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    [bottomComeAnotherButton setTitle:@"再来一单" forState:UIControlStateNormal];
    bottomComeAnotherButton.titleLabel.font = Font(16);
    [bottomView addSubview:bottomComeAnotherButton];
    
    UIView *sepLineView1 = [[UIView alloc] init];
    sepLineView1.frame = (CGRect){RIGHT(bottomComeAnotherButton)-0.5,5,0.5,HEIGHT(bottomView)-10};
    sepLineView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [bottomView addSubview:sepLineView1];
    
    UIButton *bottomSBButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomSBButton.frame = (CGRect){WIDTH(bottomView)/3,0,WIDTH(bottomView)/3,HEIGHT(bottomView)};
    [bottomSBButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    [bottomSBButton setTitle:@"投诉" forState:UIControlStateNormal];
    bottomSBButton.titleLabel.font = Font(16);
    [bottomView addSubview:bottomSBButton];
    
    UIView *sepLineView2 = [[UIView alloc] init];
    sepLineView2.frame = (CGRect){RIGHT(bottomSBButton)-0.5,5,0.5,HEIGHT(bottomView)-10};
    sepLineView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [bottomView addSubview:sepLineView2];
    
    UIButton *bottomJudgeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomJudgeButton.frame = (CGRect){WIDTH(bottomView)*2/3,0,WIDTH(bottomView)/3,HEIGHT(bottomView)};
    [bottomJudgeButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    [bottomJudgeButton setTitle:@"评价" forState:UIControlStateNormal];
    bottomJudgeButton.titleLabel.font = Font(16);
    [bottomView addSubview:bottomJudgeButton];
    
    [bottomComeAnotherButton addTarget:self action:@selector(bottomComeAnotherButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomSBButton addTarget:self action:@selector(bottomSBButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomJudgeButton addTarget:self action:@selector(bottomJudgeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     * 需要判断状态 如果已经评价  那么 投诉 和 评价这两个按钮将要做处理
     */
    OrderInfoOrderState orderState = self.orderInfo.orderState;
    OrderInfoOrderPaymentState patmentState = self.orderInfo.paymentStatus;
    
    bottomJudgeButton.enabled = NO;
    bottomSBButton.enabled = NO;
    [bottomJudgeButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    [bottomSBButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
    
    if (orderState == OrderInfoOrderStateSubmitSuccess) {
        
    }else if (orderState == OrderInfoOrderStateShopAccept){
        
    }else if (orderState == OrderInfoOrderStateComplete){
        if (self.orderInfo.isJudged) {
            bottomJudgeButton.enabled = NO;
            [bottomJudgeButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
        }else{
            bottomJudgeButton.enabled = YES;
            [bottomJudgeButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
        }
        bottomSBButton.enabled = YES;
        [bottomSBButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    }else if (orderState == OrderInfoOrderStateCancel){
        bottomJudgeButton.enabled = NO;
        bottomSBButton.enabled = YES;
        [bottomJudgeButton setTitleColor:RGBColor(200, 200, 200) forState:UIControlStateNormal];
        [bottomSBButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    }
    
    //中间订单视图页面的加载
    __block float offset = 0;
    
    NSArray *logArray = self.orderInfo.orderLogDetail;
    [logArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        long long time = [obj[@"time"] longLongValue]/1000;
        NSString *type = obj[@"type"];
        NSString *contentString = obj[@"content"];
        
        if (type && [type isKindOfClass:[NSString class]] && ![type isEqualToString:@""]) {
            NSString *note;
            NSString *typeString;
            NSString *imageName;
            if ([type isEqualToString:@"create"]) {
                note = @"订单创建";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"modify"]){
                note = @"订单修改";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"confirm"]){
                note = @"订单确认";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"payment"]){
                note = @"订单支付";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"refunds"]){
                note = @"订单退款";
                imageName = @"orderstate_success";
            }else if ([type isEqualToString:@"shipping"]){
                note = @"订单配送";
                imageName = @"orderstate_success";
            }else if ([type isEqualToString:@"returns"]){
                note = @"订单退款";
                imageName = @"orderstate_success";
            }else if ([type isEqualToString:@"complete"]){
                note = @"订单完成";
                imageName = @"orderstate_success";
            }else if ([type isEqualToString:@"cancel"]){
                note = @"订单取消";
                imageName = @"orderstate_success";
            }else if ([type isEqualToString:@"other"]){
                note = @"其它";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"applyrefunds"]){
                note = @"用户提交退款";
                imageName = @"orderstate_shop";
            }else if ([type isEqualToString:@"agreerefunds"]){
                note = @"同意退款";
                imageName = @"orderstate_shop";
            }else{
                note = @"";
                imageName = @"orderstate_shop";
            }
            contentString = note;
            typeString = note;
            if (contentString){
                if ([contentString isKindOfClass:[NSString class]] && ![contentString isEqualToString:@""]) {
                    
                }
            }
            UIView *view = [self addOrderStateViewAlighOffset:offset withImageName:imageName state:typeString detailString:contentString timeStamp:time];
            [contentView addSubview:view];
            offset += HEIGHT(view);
        }
        
    }];
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, offset)};
}

-(void)bottomComeAnotherButtonClick{
    ShopInfo *shopInfo = [[ShopInfo alloc] init];
    shopInfo.shopID = self.orderInfo.shopID;
    shopInfo.name = self.orderInfo.shopName;
    ShopDetailViewController *sdVC = [[ShopDetailViewController alloc] init];
    sdVC.shopInfo = shopInfo;
    [self.navigationController pushViewController:sdVC animated:YES];
}

-(void)bottomSBButtonClick{
    OrderSueViewController *osVC = [[OrderSueViewController alloc] init];
    osVC.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:osVC animated:YES];
}

-(void)bottomJudgeButtonClick{
    OrderJudgeViewController *orderJVC = [[OrderJudgeViewController alloc] init];
    orderJVC.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:orderJVC animated:YES];
}

-(UIView *)addOrderStateViewAlighOffset:(float)offset withImageName:(NSString *)imageName state:(NSString *)string detailString:(NSString *)detailString timeStamp:(long long)timeStamp{
    UIView *returnView = [[UIView alloc] init];
    returnView.frame = (CGRect){0,offset,WIDTH(contentView),90};
    
    UIView *topAlighedView = [[UIView alloc] init];
    topAlighedView.frame = (CGRect){0,0,WIDTH(returnView),20};
    [returnView addSubview:topAlighedView];
    
    UIImage *headImage = [UIImage imageNamed:imageName];
    if (!headImage) {
        headImage = [UIImage imageNamed:@"orderstate_user"];
    }
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = headImage;
    headImageView.frame = (CGRect){15,(HEIGHT(returnView)-BOTTOM(topAlighedView)-30)/2+BOTTOM(topAlighedView),30,30};
    [returnView addSubview:headImageView];
    
    UIImageView *backInfoImageView = [[UIImageView alloc] init];
    backInfoImageView.image = [UIImage imageNamed:@"orderstate_dhk"];
    backInfoImageView.frame = (CGRect){50,BOTTOM(topAlighedView),WIDTH(returnView)-50-10,HEIGHT(returnView)-BOTTOM(topAlighedView)};
    [returnView addSubview:backInfoImageView];
    
    if (!string) {
        string = @"";
    }
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.frame = (CGRect){20,13,WIDTH(backInfoImageView)-20-10-45,18};
    stateLabel.textColor = RGBColor(80, 80, 80);
    stateLabel.text = string;
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.font = IS5_5Inches()?Font(18):Font(16);
    [backInfoImageView addSubview:stateLabel];
    
    NSString *destDateString;
    if (timeStamp == 0) {
        destDateString = @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    destDateString = [dateFormatter stringFromDate:date];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = (CGRect){WIDTH(backInfoImageView)-10-45,13,45,18};
    timeLabel.textColor = RGBColor(140, 140, 140);
    timeLabel.text = destDateString;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = IS5_5Inches()?Font(14):Font(12);
    [backInfoImageView addSubview:timeLabel];
    
    if (!detailString) {
        detailString = @"";
    }
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = (CGRect){20,42,WIDTH(backInfoImageView)-20-10,15};
    detailLabel.textColor = RGBColor(140, 140, 140);
    detailLabel.text = detailString;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = IS5_5Inches()?Font(15):Font(13);
    [backInfoImageView addSubview:detailLabel];
    
    
    return returnView;
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *rightimage = [UIImage imageNamed:@"navi_callout"];
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithImage:rightimage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    if (callPhone) {
        [self showAlertViewWithPhone:callPhone];
    }else{
        [self getShopInfoNeedCall:YES];
    }
}

static NSString *callPhone;
-(void)getShopInfoNeedCall:(BOOL)needCall{
    [UNUrlConnection getShopInfoDetailWithShopID:self.orderInfo.shopID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *contentDic = resultDic[@"content"];
        if (contentDic) {
            ShopInfo *shopInfo = [ShopInfo shopInfoWithNetWorkDictionary:contentDic];
            callPhone = shopInfo.contactPhone;
            
            if (needCall) {
                [self showAlertViewWithPhone:callPhone];
            }
        }
    }];
}

-(void)showAlertViewWithPhone:(NSString *)phone{
    if (!phone || ![phone isKindOfClass:[NSString class]] || [phone isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"未获取到电话信息,请稍候再试"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨号确认" message:[NSString stringWithFormat:@"确定拨打电话给%@吗？",phone] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[phone stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
