//
//  OrderDetailViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/4.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderMoreStateViewController.h"
#import "ShopDetailViewController.h"
#import "OrderJudgeViewController.h"
#import "UNUrlConnection.h"
#import "XYW8IndicatorView.h"
#import "AppDelegate.h"


@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController{
    UIScrollView *contentView;
    
    UILabel *orderStateLabel;
    
    XYW8IndicatorView *indicatorView;
    id<NSObject> payClientBackNotificationInOrderDetail;
}

@synthesize orderInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (orderInfo.shopName) {
        self.navigationItem.title = orderInfo.shopName;
    }else{
        self.navigationItem.title = @"订单详情";
    }
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(235, 235, 235);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    __block float offset = 0;
    
    UIView *orderStateView = [[UIView alloc] init];
    orderStateView.frame = (CGRect){0,0,WIDTH(contentView),50};
    [contentView addSubview:orderStateView];
    orderStateView.backgroundColor = RGBColor(90, 90, 90);
    
    UIButton *orderStateMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderStateMoreButton.frame = (CGRect){WIDTH(orderStateView)-10-70,0,70,HEIGHT(orderStateView)};
    [orderStateMoreButton setTitleColor:RGBColor(250, 250, 250) forState:UIControlStateNormal];
    [orderStateMoreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    orderStateMoreButton.titleLabel.font = Font(14);
    [orderStateMoreButton setTitle:@"更多状态" forState:UIControlStateNormal];
    [orderStateMoreButton addTarget:self action:@selector(orderStateMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [orderStateView addSubview:orderStateMoreButton];
    
    orderStateLabel = [[UILabel alloc] init];
    orderStateLabel.frame = (CGRect){10,0,LEFT(orderStateMoreButton)-10-5,HEIGHT(orderStateView)};
    orderStateLabel.textColor = RGBColor(250, 250, 250);
    orderStateLabel.textAlignment = NSTextAlignmentLeft;
    orderStateLabel.font = Font(17);
    [orderStateView addSubview:orderStateLabel];
    
    [self setOrderStateLabelWithState:orderInfo.orderState];
    
    offset += BOTTOM(orderStateView);
    
    UIView *orderDetailHeadView = [[UIView alloc] init];
    orderDetailHeadView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderDetailHeadView.backgroundColor = RGBColor(240, 240, 240);
    [contentView addSubview:orderDetailHeadView];
    
    UILabel *orderDetailNoteLabel = [[UILabel alloc] init];
    orderDetailNoteLabel.frame = (CGRect){10,0,WIDTH(orderDetailHeadView)-20,HEIGHT(orderDetailHeadView)};
    orderDetailNoteLabel.textColor = RGBColor(80,80,80);
    orderDetailNoteLabel.textAlignment = NSTextAlignmentLeft;
    orderDetailNoteLabel.font = Font(15);
    orderDetailNoteLabel.text = @"订单明细";
    [orderDetailHeadView addSubview:orderDetailNoteLabel];
    
    UIView *orderDetailBottomSepLineView = [[UIView alloc] init];
    orderDetailBottomSepLineView.frame = (CGRect){0,HEIGHT(orderDetailHeadView)-0.5,WIDTH(orderDetailHeadView),0.5};
    orderDetailBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderDetailHeadView addSubview:orderDetailBottomSepLineView];
    
    offset += HEIGHT(orderDetailHeadView);
    
    UIView *orderShopNameView = [[UIView alloc] init];
    orderShopNameView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderShopNameView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderShopNameView];
    
    UILabel *orderShopNameLabel = [[UILabel alloc] init];
    orderShopNameLabel.frame = (CGRect){10,0,WIDTH(orderShopNameView)-150-10-10,HEIGHT(orderShopNameView)};
    orderShopNameLabel.textColor = RGBColor(31,58,150);
    orderShopNameLabel.textAlignment = NSTextAlignmentLeft;
    orderShopNameLabel.font = Font(16);
    orderShopNameLabel.text = orderInfo.shopName ? orderInfo.shopName:@"";
    [orderShopNameView addSubview:orderShopNameLabel];
    
    UILabel *orderShopDeliveryLabel = [[UILabel alloc] init];
    orderShopDeliveryLabel.frame = (CGRect){WIDTH(orderShopNameView)-10-150+5,0,145,HEIGHT(orderDetailHeadView)};
    orderShopDeliveryLabel.textColor = RGBColor(100,100,100);
    orderShopDeliveryLabel.textAlignment = NSTextAlignmentRight;
    orderShopDeliveryLabel.font = Font(14);
    orderShopDeliveryLabel.text = self.orderInfo.isSelfDelivery?@"联合配送":@"商家配送";
    [orderShopNameView addSubview:orderShopDeliveryLabel];
    
    UIView *orderShopDeliveryBottomSepLineView = [[UIView alloc] init];
    orderShopDeliveryBottomSepLineView.frame = (CGRect){0,HEIGHT(orderShopNameView)-0.5,WIDTH(orderShopNameView),0.5};
    orderShopDeliveryBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderShopNameView addSubview:orderShopDeliveryBottomSepLineView];
    
    offset += HEIGHT(orderShopNameView);
    
    /**
     *  添加菜单
     */
    
    NSArray *detailArray  = orderInfo.orderMenuDetail;
    if (detailArray && detailArray.count != 0) {
        [detailArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
            UIView *outterAddView = [[UIView alloc] init];
            outterAddView.frame = (CGRect){0,offset,WIDTH(contentView),45};
            outterAddView.backgroundColor = RGBColor(250, 250, 250);
            [contentView addSubview:outterAddView];
            
            offset += HEIGHT(outterAddView);
            
            UILabel *orderItemNameLabel = [[UILabel alloc] init];
            orderItemNameLabel.frame = (CGRect){10,0,WIDTH(outterAddView)-110-10,HEIGHT(outterAddView)};
            orderItemNameLabel.textColor = RGBColor(80,80,80);
            orderItemNameLabel.textAlignment = NSTextAlignmentLeft;
            orderItemNameLabel.font = Font(16);
            orderItemNameLabel.text = menuInfo[@"name"];
            [outterAddView addSubview:orderItemNameLabel];
            
            UILabel *orderItemCountLabel = [[UILabel alloc] init];
            orderItemCountLabel.frame = (CGRect){WIDTH(outterAddView)-115,0,45,HEIGHT(outterAddView)};
            orderItemCountLabel.textColor = RGBColor(80,80,80);
            orderItemCountLabel.textAlignment = NSTextAlignmentCenter;
            orderItemCountLabel.font = Font(13);
            orderItemCountLabel.text = [NSString stringWithFormat:@"X%@",menuInfo[@"number"]];
            [outterAddView addSubview:orderItemCountLabel];
            
            UILabel *orderItemPriceLabel = [[UILabel alloc] init];
            orderItemPriceLabel.frame = (CGRect){WIDTH(outterAddView)-60-10,0,60,HEIGHT(outterAddView)};
            orderItemPriceLabel.textColor = RGBColor(80,80,80);
            orderItemPriceLabel.textAlignment = NSTextAlignmentCenter;
            orderItemPriceLabel.font = Font(13);
            [outterAddView addSubview:orderItemPriceLabel];
            
            float priceUnit = [menuInfo[@"unitprice"] floatValue];
            NSString *priceUnitString;
            int unitDotNum = (int)(priceUnit*10) - ((int)priceUnit)*10;
            if (unitDotNum == 0) {
                priceUnitString = [NSString stringWithFormat:@"%d",(int)priceUnit];
            }else{
                priceUnitString = [NSString stringWithFormat:@"%.1f",priceUnit];
            }
            orderItemPriceLabel.text = [NSString stringWithFormat:@"￥%@",priceUnitString];
            
            UIView *orderItemSepLineView = [[UIView alloc] init];
            orderItemSepLineView.frame = (CGRect){0,HEIGHT(outterAddView)-0.5,WIDTH(outterAddView),0.5};
            orderItemSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [outterAddView addSubview:orderItemSepLineView];
        }];
    }
    
    //    添加配送费视图
    UIView *orderShopDeliveryView = [[UIView alloc] init];
    orderShopDeliveryView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderShopDeliveryView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderShopDeliveryView];
    
    UILabel *orderShopShopDeliveryNoteLabel = [[UILabel alloc] init];
    orderShopShopDeliveryNoteLabel.frame = (CGRect){10,0,WIDTH(orderShopDeliveryView)-150-10-10,HEIGHT(orderDetailHeadView)};
    orderShopShopDeliveryNoteLabel.textColor = RGBColor(80, 80, 80);
    orderShopShopDeliveryNoteLabel.textAlignment = NSTextAlignmentLeft;
    orderShopShopDeliveryNoteLabel.font = Font(16);
    orderShopShopDeliveryNoteLabel.text = @"配送费";
    [orderShopDeliveryView addSubview:orderShopShopDeliveryNoteLabel];
    
    UILabel *orderShopDeliveryNumberLabel = [[UILabel alloc] init];
    orderShopDeliveryNumberLabel.frame = (CGRect){WIDTH(orderShopDeliveryView)-10-150+5,0,145,HEIGHT(orderShopDeliveryView)};
    orderShopDeliveryNumberLabel.textColor = RGBColor(80,80,80);
    orderShopDeliveryNumberLabel.textAlignment = NSTextAlignmentRight;
    orderShopDeliveryNumberLabel.font = Font(14);
    orderShopDeliveryNumberLabel.text = [NSString stringWithFormat:@"￥%d",orderInfo.deliveryNumber];
    [orderShopDeliveryView addSubview:orderShopDeliveryNumberLabel];
    
    UIView *orderShopDeliveryViewSepLineView = [[UIView alloc] init];
    orderShopDeliveryViewSepLineView.frame = (CGRect){0,HEIGHT(orderShopDeliveryView)-0.5,WIDTH(orderShopDeliveryView),0.5};
    orderShopDeliveryViewSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderShopDeliveryView addSubview:orderShopDeliveryViewSepLineView];
    
    offset += HEIGHT(orderShopDeliveryView);
    
    //    //添加合计视图
    UIView *orderTotalCountView = [[UIView alloc] init];
    orderTotalCountView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderTotalCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderTotalCountView];
    
    UILabel *orderTotalCountNumberLabel = [[UILabel alloc] init];
    orderTotalCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderTotalCountView)-20,HEIGHT(orderTotalCountView)};
    orderTotalCountNumberLabel.textColor = RGBColor(80,80,80);
    orderTotalCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderTotalCountNumberLabel.font = Font(14);
    [orderTotalCountView addSubview:orderTotalCountNumberLabel];
    
    NSString *totalOrderMoneyTmpString;
    float orderTotalNumValue = self.orderInfo.orderNumber + self.orderInfo.deliveryNumber;
    int totalMoneyTmpNum = (int)(orderTotalNumValue*10) - ((int)orderTotalNumValue)*10;
    if (totalMoneyTmpNum == 0) {
        totalOrderMoneyTmpString = [NSString stringWithFormat:@"%d",(int)orderTotalNumValue];
    }else{
        totalOrderMoneyTmpString = [NSString stringWithFormat:@"%.1f",orderTotalNumValue];
    }
    orderTotalCountNumberLabel.text = [NSString stringWithFormat:@"合计金额：￥%@",totalOrderMoneyTmpString];
    
    UIView *orderTotalCountNumberSepLineView = [[UIView alloc] init];
    orderTotalCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderTotalCountView)-0.5,WIDTH(orderTotalCountView),0.5};
    orderTotalCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderTotalCountView addSubview:orderTotalCountNumberSepLineView];
    
    offset += HEIGHT(orderTotalCountView);
    
    //添加服务器返回的优惠信息 进入视图中
    //    NSArray *youhuiTmpArray = @[@{@"name":@"减",
    //                                @"desciption":@"满20减10元",
    //                                @"value":@"10",
    //                                  }];
    //    if (youhuiTmpArray && youhuiTmpArray.count != 0) {
    //        [youhuiTmpArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
    //            UIView *youhuiAddView = [[UIView alloc] init];
    //            youhuiAddView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    //            youhuiAddView.backgroundColor = RGBColor(250, 250, 250);
    //            [contentView addSubview:youhuiAddView];
    //            
    //            offset += HEIGHT(youhuiAddView);
    //            
    //            NSString *youhuiItemKey = menuInfo[@"name"];
    //            UIColor *tagColor = UN_RedColor;
    //            if ([youhuiItemKey isEqualToString:@"新"]) {
    //                tagColor = UN_FilterXin;
    //            }else if ([youhuiItemKey isEqualToString:@"特"]){
    //                tagColor = UN_FilterTejia;
    //            }else if ([youhuiItemKey isEqualToString:@"减"]){
    //                tagColor = UN_FilterJian;
    //            }else if ([youhuiItemKey isEqualToString:@"预"]){
    //                tagColor = UN_FilterYu;
    //            }else if ([youhuiItemKey isEqualToString:@"免"]){
    //                tagColor = UN_FilterMian;
    //            }
    //            
    //            UILabel *youhuiItemNameLabel = [[UILabel alloc] init];
    //            youhuiItemNameLabel.frame = (CGRect){10,(HEIGHT(youhuiAddView)-20)/2,20,20};
    //            youhuiItemNameLabel.backgroundColor = tagColor;
    //            youhuiItemNameLabel.layer.cornerRadius = 10;
    //            youhuiItemNameLabel.layer.masksToBounds = YES;
    //            youhuiItemNameLabel.text = youhuiItemKey;
    //            youhuiItemNameLabel.layer.borderColor = tagColor.CGColor;
    //            youhuiItemNameLabel.layer.borderWidth = 1.f;
    //            youhuiItemNameLabel.textAlignment = NSTextAlignmentCenter;
    //            youhuiItemNameLabel.textColor = [UIColor whiteColor];
    //            youhuiItemNameLabel.font = Font(13);
    //            [youhuiAddView addSubview:youhuiItemNameLabel];
    //            
    //            NSString *youhuiItemDescption = menuInfo[@"desciption"];
    //            UILabel *youhuiItemDescptionLabel = [[UILabel alloc] init];
    //            youhuiItemDescptionLabel.frame = (CGRect){RIGHT(youhuiItemNameLabel)+10,0,WIDTH(youhuiAddView)-(RIGHT(youhuiItemNameLabel)+10)-10-50,HEIGHT(youhuiAddView)};
    //            youhuiItemDescptionLabel.textColor = RGBColor(80,80,80);
    //            youhuiItemDescptionLabel.textAlignment = NSTextAlignmentLeft;
    //            youhuiItemDescptionLabel.font = Font(13);
    //            youhuiItemDescptionLabel.text = youhuiItemDescption;
    //            [youhuiAddView addSubview:youhuiItemDescptionLabel];
    //            
    //            
    //            UILabel *youhuiItemValueLabel = [[UILabel alloc] init];
    //            youhuiItemValueLabel.frame = (CGRect){WIDTH(youhuiAddView)-50-10,0,50,HEIGHT(youhuiAddView)};
    //            youhuiItemValueLabel.textColor = RGBColor(80,80,80);
    //            youhuiItemValueLabel.textAlignment = NSTextAlignmentRight;
    //            youhuiItemValueLabel.font = Font(13);
    //            [youhuiAddView addSubview:youhuiItemValueLabel];
    //            
    //            NSString *youhuiItemValue = menuInfo[@"value"];
    //            youhuiItemValueLabel.text = [NSString stringWithFormat:@"-￥%@",youhuiItemValue];
    //            
    //            UIView *youhuiItemSepLineView = [[UIView alloc] init];
    //            youhuiItemSepLineView.frame = (CGRect){0,HEIGHT(youhuiAddView)-0.5,WIDTH(youhuiAddView),0.5};
    //            youhuiItemSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    //            [youhuiAddView addSubview:youhuiItemSepLineView];
    //            
    //            orderTotalNumValue -= [youhuiItemValue intValue];
    //        }];
    //    }
    
    
    //优惠总计
    UIView *orderYouhuiCountView = [[UIView alloc] init];
    orderYouhuiCountView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderYouhuiCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderYouhuiCountView];
    
    UILabel *orderYouhuiCountNumberLabel = [[UILabel alloc] init];
    orderYouhuiCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderYouhuiCountView)-20,HEIGHT(orderYouhuiCountView)};
    orderYouhuiCountNumberLabel.textColor = UN_RedColor;
    orderYouhuiCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderYouhuiCountNumberLabel.font = Font(14);
    [orderYouhuiCountView addSubview:orderYouhuiCountNumberLabel];
    
    NSString *youhuiMoneyTmpString;
    float youhuiTotalNum = self.orderInfo.youhuiDiscountNumber;
    int youhuiMoneyTmpNum = (int)(youhuiTotalNum*10) - ((int)youhuiTotalNum)*10;
    if (youhuiMoneyTmpNum == 0) {
        youhuiMoneyTmpString = [NSString stringWithFormat:@"%d",(int)youhuiTotalNum];
    }else{
        youhuiMoneyTmpString = [NSString stringWithFormat:@"%.1f",youhuiTotalNum];
    }
    orderYouhuiCountNumberLabel.text = [NSString stringWithFormat:@"促销优惠总计：-￥%@",youhuiMoneyTmpString];
    
    UIView *orderYouhuiCountNumberSepLineView = [[UIView alloc] init];
    orderYouhuiCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderYouhuiCountView)-0.5,WIDTH(orderYouhuiCountView),0.5};
    orderYouhuiCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderYouhuiCountView addSubview:orderYouhuiCountNumberSepLineView];
    
    offset += HEIGHT(orderYouhuiCountView);
    
    //添加订单总计视图
    UIView *orderFinallyCountView = [[UIView alloc] init];
    orderFinallyCountView.frame = (CGRect){0,offset,WIDTH(contentView),45};
    orderFinallyCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderFinallyCountView];
    
    UILabel *orderFinallyCountNumberLabel = [[UILabel alloc] init];
    orderFinallyCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderFinallyCountView)-20,HEIGHT(orderFinallyCountView)};
    orderFinallyCountNumberLabel.textColor = UN_RedColor;
    orderFinallyCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderFinallyCountNumberLabel.font = Font(14);
    [orderFinallyCountView addSubview:orderFinallyCountNumberLabel];
    
    NSString *finnalyMoneyTmpString;
    float orderPayAmountNumValue = self.orderInfo.payNumber;
    int finnalyMoneyTmpNum = (int)(orderPayAmountNumValue*10) - ((int)orderPayAmountNumValue)*10;
    if (finnalyMoneyTmpNum == 0) {
        finnalyMoneyTmpString = [NSString stringWithFormat:@"%d",(int)orderPayAmountNumValue];
    }else{
        finnalyMoneyTmpString = [NSString stringWithFormat:@"%.1f",orderPayAmountNumValue];
    }
    orderFinallyCountNumberLabel.text = [NSString stringWithFormat:@"合计金额：￥%@",finnalyMoneyTmpString];
    
    UIView *orderFinallyCountNumberSepLineView = [[UIView alloc] init];
    orderFinallyCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderFinallyCountView)-0.5,WIDTH(orderFinallyCountView),0.5};
    orderFinallyCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderFinallyCountView addSubview:orderFinallyCountNumberSepLineView];
    
    offset += HEIGHT(orderFinallyCountView);
    
    /**
     *  添加其它信息的视图
     */
    
    UIView *orderOtherInfoView = [[UIView alloc] init];
    orderOtherInfoView.frame = (CGRect){0,offset,WIDTH(contentView),35};
    orderOtherInfoView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:orderOtherInfoView];
    
    UILabel *orderOtherInfoNoteLabel = [[UILabel alloc] init];
    orderOtherInfoNoteLabel.frame = (CGRect){10,0,WIDTH(orderOtherInfoView)-20,HEIGHT(orderOtherInfoView)};
    orderOtherInfoNoteLabel.textColor = RGBColor(50, 50, 50);
    orderOtherInfoNoteLabel.text = @"其它信息";
    orderOtherInfoNoteLabel.textAlignment = NSTextAlignmentLeft;
    orderOtherInfoNoteLabel.font = Font(13);
    [orderOtherInfoView addSubview:orderOtherInfoNoteLabel];
    
    UIView *orderOtherInfoSepLineView = [[UIView alloc] init];
    orderOtherInfoSepLineView.frame = (CGRect){0,HEIGHT(orderOtherInfoView)-0.5,WIDTH(orderOtherInfoView),0.5};
    orderOtherInfoSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderOtherInfoView addSubview:orderOtherInfoSepLineView];
    
    offset += HEIGHT(orderOtherInfoView);
    
    //配送信息
    UIView *view1 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"配送信息：" rightLabelString:@"商家配送"];
    [contentView addSubview:view1];
    offset += HEIGHT(view1);
    
    //订单号
    UIView *view2 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"订单流水：" rightLabelString:self.orderInfo.orderSN];
    [contentView addSubview:view2];
    offset += HEIGHT(view2);
    //配送时间
    UIView *view3 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"配送时间：" rightLabelString:self.orderInfo.deliveryTime];
    [contentView addSubview:view3];
    offset += HEIGHT(view3);
    //收货人信息
    
    UIView *view4 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"收货信息：" rightLabelString:[NSString stringWithFormat:@"%@ %@",self.orderInfo.orderContactor,self.orderInfo.orderConsigneePhone]];
    [contentView addSubview:view4];
    offset += HEIGHT(view4);
    //收货地址
    UIView *view5 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"收货地址：" rightLabelString:self.orderInfo.orderAddress];
    [contentView addSubview:view5];
    offset += HEIGHT(view5);
    //支付方式
    NSString *paymentString;
    if (self.orderInfo.payMentType == OrderPaymentTypeAli) {
        paymentString = @"支付宝";
    }else if (self.orderInfo.payMentType == OrderPaymentTypeWechat){
        paymentString = @"微信支付";
    }else if (self.orderInfo.payMentType == OrderPaymentTypeNone){
        paymentString = @"不须另外支付";
    }
    
    UIView *view6 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"支付方式：" rightLabelString:paymentString];
    [contentView addSubview:view6];
    offset += HEIGHT(view6);
    //备注信息
    NSString *noteInfo = self.orderInfo.deliveryNote;
    if (noteInfo || [noteInfo isKindOfClass:[NSNull class]]) {
        noteInfo = @"无";
    }else if ([noteInfo isKindOfClass:[NSString class]] && [noteInfo isEqualToString:@""]){
        noteInfo = @"无";
    }
    
    UIView *view7 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"备注信息：" rightLabelString:noteInfo];
    [contentView addSubview:view7];
    offset += HEIGHT(view7);
    //发票信息
    NSString *fapiaoInfo = @"需要发票";
    if (self.orderInfo.isFapiaoNeed) {
        NSString *fapiaoTitle = self.orderInfo.faPiaoTitle;
        if (fapiaoTitle && ![fapiaoTitle isKindOfClass:[NSNull class]]) {
            if ([fapiaoTitle isKindOfClass:[NSString class]]) {
                if (![fapiaoTitle isEqualToString:@""]) {
                    fapiaoInfo = fapiaoTitle;
                }
            }
        }
    }else{
        fapiaoInfo = @"不需发票";
    }
    UIView *view8 = [self createOtherDetailViewAlighOffset:offset leftLabelString:@"发票信息：" rightLabelString:fapiaoInfo];
    [contentView addSubview:view8];
    offset += HEIGHT(view8);
    
    
    /**
     *  根据订单状态  按钮用不同的文字
     */
    // 继续支付 退款 再来一单  评价
    NSString *functionTitle;
    if (orderInfo.orderState == OrderInfoOrderStateSubmitSuccess){
        if (orderInfo.paymentStatus == OrderInfoOrderPaymentStateUnPaid) {
            functionTitle = @"继续支付";
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStatePaid){
            functionTitle = @"退款";
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStatePartialPayment){
            functionTitle = @"继续支付";
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStateRefunded){
            functionTitle = @"再来一单";
        }
    }else if (orderInfo.orderState == OrderInfoOrderStateShopAccept){
        functionTitle = @"退款";
    }else if (orderInfo.orderState == OrderInfoOrderStateComplete){
        if (orderInfo.isJudged) {
            functionTitle = @"再来一单";
        }else{
            functionTitle = @"评价";
        }
    }else if (orderInfo.orderState == OrderInfoOrderStateCancel){
        functionTitle = @"再来一单";
    }
    
    if (orderInfo.isRefunded) {
        functionTitle = @"再来一单";
    }
    
    
    offset += 10;
    UIButton *functionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    functionButton.frame = (CGRect){20,offset,WIDTH(contentView)-20*2,40};
    functionButton.backgroundColor = RGBColor(250, 250, 250);
    functionButton.layer.borderColor = UN_RedColor.CGColor;
    functionButton.layer.borderWidth = 0.5f;
    [functionButton setTitle:functionTitle forState:UIControlStateNormal];
    [functionButton setTitleColor:UN_RedColor forState:UIControlStateNormal];
    functionButton.titleLabel.font = Font(13);
    [contentView addSubview:functionButton];
    [functionButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += 10+HEIGHT(functionButton);
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, offset)};
}

-(UIView *)createOtherDetailViewAlighOffset:(float)offset leftLabelString:(NSString *)leftString rightLabelString:(NSString *)rightString{
    if (!leftString) {
        leftString = @"";
    }
    if (!rightString) {
        rightString = @"";
    }
    
    UIView *returnView = [[UIView alloc] init];
    returnView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    returnView.backgroundColor = RGBColor(250, 250, 250);
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = (CGRect){10,0,65,HEIGHT(returnView)};
    leftLabel.textColor = RGBColor(100, 100, 100);
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = Font(13);
    leftLabel.text = leftString;
    [returnView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.frame = (CGRect){75,0,WIDTH(returnView)-80-10,HEIGHT(returnView)};
    rightLabel.textColor = RGBColor(80, 80, 80);
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = Font(13);
    rightLabel.text = rightString;
    [returnView addSubview:rightLabel];
    return returnView;
}

-(void)functionButtonClick:(UIButton *)button{
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"继续支付"]) {
        [BYToastView showToastWithMessage:@"获取支付信息...."];
        [UNUrlConnection getOrderPaymentInfoWithOrderSN:self.orderInfo.orderSN orderPayType:self.orderInfo.payMentType complete:^(NSDictionary *resultDic, NSString *errorString) {
            
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                NSDictionary *contentDictionary = resultDic[@"content"];
                //                NSString *requestCharset = contentDictionary[@"requestCharset"];
                //                NSString *requestMethod = contentDictionary[@"requestMethod"];
                //                NSString *requestUrl = contentDictionary[@"requestUrl"];
                
                NSDictionary *payParamsDic = contentDictionary[@"payParameter"];
                
                __block float totalFee = [payParamsDic[@"total_fee"] floatValue];
                
                NSString *trade_no = payParamsDic[@"out_trade_no"];
                
                //                NSString *notifyUrl = payParamsDic[@"notify_url"];
                
                //初始化提示框；
                NSString *messageString;
                if ((totalFee*10)-((int)totalFee)*10 == 0) {
                    messageString = [NSString stringWithFormat:@"还需支付￥%d",(int)totalFee];
                }else{
                    messageString = [NSString stringWithFormat:@"还需支付¥%.1f",totalFee];
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSString *paymethod = [payParamsDic objectForKey:@"paymethod"];
                    if (!paymethod) {
                        [BYToastView showToastWithMessage:@"支付失败,未知的支付类型"];
                        return;
                    }
                    indicatorView = [XYW8IndicatorView new];
                    indicatorView.frame = (CGRect){0,0,WIDTH(MainWindow),HEIGHT(MainWindow)};
                    [MainWindow addSubview:indicatorView];
                    indicatorView.dotColor = [UIColor whiteColor];
                    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                    indicatorView.loadingLabel.text = @"获取订单信息";
                    [indicatorView startAnimating];
                    
                    //todo 不知道directPay 代表什么 暂时作为支付宝处理
                    if ([paymethod isEqualToString:@"directPay"]) {
                        payClientBackNotificationInOrderDetail = [[NSNotificationCenter defaultCenter] addObserverForName:UN_OrderDidSendToPayClientBackNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                            if ([[note object] boolValue]) {
                                [self getSelfOrderDetailWithPaymentSN:trade_no success:^{
                                    self.orderInfo.paymentStatus = OrderInfoOrderPaymentStatePaid;
                                    [button setTitle:@"退款" forState:UIControlStateNormal];
                                    self.orderInfo.orderState = OrderInfoOrderStateSubmitSuccess;
                                    [self setOrderStateLabelWithState:OrderInfoOrderStateSubmitSuccess];
                                }];
                            }else{
                                [BYToastView showToastWithMessage:@"支付失败,请稍候再试"];
                            }
                            [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotificationInOrderDetail];
                        }];
                        //todo test
                        totalFee = 0.01;
                        [UNUrlConnection alipayPayWithMoneyYuan:totalFee orderSN:trade_no complete:^(NSDictionary *result) {
                            [(AppDelegate *)[UIApplication sharedApplication].delegate handleAliPayCallBackWithResult:result];
                        }];
                        return;
                    }else{
                        //todo 需要添加微信支付
                        //todo test
                        totalFee = 1;
                        [BYToastView showToastWithMessage:@"支付失败,未知的支付类型"];
                        [indicatorView stopAnimating:YES];
                        return;
                    }
                    
                    //                    [UNUrlConnection orderPayWithPayTradeSN:trade_no complete:^(NSString *stateString) {
                    //                        [BYToastView showToastWithMessage:stateString];
                    //                        if ([stateString isEqualToString:@"支付成功"]) {
                    //                            dispatch_async(dispatch_get_main_queue(), ^{
                    //                                self.orderInfo.paymentStatus = OrderInfoOrderPaymentStatePaid;
                    //                                [button setTitle:@"退款" forState:UIControlStateNormal];
                    //                                self.orderInfo.orderState = OrderInfoOrderStateSubmitSuccess;
                    //                                [self setOrderStateLabelWithState:OrderInfoOrderStateSubmitSuccess];
                    //                            });
                    //                            return;
                    //                        }
                    //                    }];
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }else{
                NSString *contentString = messageDic[@"content"];
                if (!contentString) {
                    contentString = @"获取支付信息失败,请稍候再试";
                }
                [BYToastView showToastWithMessage:@"获取支付信息失败,请稍候再试"];
            }
        }];
    }else if ([title isEqualToString:@"再来一单"]){
        ShopInfo *shopInfo = [[ShopInfo alloc] init];
        shopInfo.shopID = self.orderInfo.shopID;
        shopInfo.name = self.orderInfo.shopName;
        ShopDetailViewController *sdVC = [[ShopDetailViewController alloc] init];
        sdVC.shopInfo = shopInfo;
        [self.navigationController pushViewController:sdVC animated:YES];
    }else if ([title isEqualToString:@"退款"]){
        [BYToastView showToastWithMessage:@"正在提交退款申请..."];
        
        [UNUrlConnection orderRefundWithOrderSN:self.orderInfo.orderSN complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"退款申请已提交"];
                [button setTitle:@"再来一单" forState:UIControlStateNormal];
                self.orderInfo.orderState = OrderInfoOrderStateCancel;
                [self setOrderStateLabelWithState:OrderInfoOrderStateCancel];
                return;
            }
            NSString *contentString = messageDic[@"content"];
            if (!contentString) {
                contentString = @"退款申请失败";
            }
            [BYToastView showToastWithMessage:contentString];
        }];
    }else if ([title isEqualToString:@"评价"]){
        OrderJudgeViewController *ordeJudgeVC = [[OrderJudgeViewController alloc] init];
        ordeJudgeVC.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:ordeJudgeVC animated:YES];
    }
}

-(void)getSelfOrderDetailWithPaymentSN:(NSString *)paymentSN success:(void (^)(void))success{
    if (!paymentSN || [paymentSN isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"订单错误,请稍候再试"];
        [indicatorView stopAnimating:YES];
        return;
    }
    dispatch_async(dispatch_queue_create("getSelfOrderDetail", nil), ^{
        sleep(3);
        [UNUrlConnection getOrderDetailWithOrderSN:paymentSN complete:^(NSDictionary *resultDic, NSString *errorString) {
            [indicatorView stopAnimating:YES];
            NSLog(@"getOrderDetailWithOrderSN:%@ \n,result:%@,\nerror:%@",paymentSN,resultDic,errorString);
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *contentsDic = resultDic[@"content"];
            
            if (contentsDic && [contentsDic isKindOfClass:[NSDictionary class]] && contentsDic.count > 0) {
                
                OrderInfo *orderInfoTmp = [OrderInfo orderInfoWithNetworkDictionary:contentsDic];
                
                /**
                 OrderInfoOrderPaymentStateUnPaid,           //未支付
                 OrderInfoOrderPaymentStatePartialPayment,   //部分支付
                 OrderInfoOrderPaymentStatePaid,             //已支付
                 OrderInfoOrderPaymentStatePartialRefunds,   //部分退款
                 OrderInfoOrderPaymentStateRefunded,         //已退款
                 */
                //remove自己
                [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotificationInOrderDetail];
                
                if (orderInfoTmp.paymentStatus == OrderInfoOrderPaymentStatePaid) {
                    [BYToastView showToastWithMessage:@"支付成功"];
                    success();
                }else{
                    [BYToastView showToastWithMessage:@"支付失败或未完成,请稍候再试"];
                }
            }
        }];
    });
}

-(void)setOrderStateLabelWithState:(OrderInfoOrderState)state{
    NSString *stateString;
    switch (state) {
        case OrderInfoOrderStateSubmitSuccess:
            stateString = @"订单提交中";
            break;
        case OrderInfoOrderStateShopAccept:
            stateString = @"商家接受订单";
            break;
        case OrderInfoOrderStateComplete:
            stateString = @"订单已完成";
            break;
        case OrderInfoOrderStateCancel:
            stateString = @"订单已取消";
            break;
            //        case OrderInfoOrderStateRefundingUpload:
            //            stateString = @"退款申请提交";
            //            break;
            //        case OrderInfoOrderStateRefundingShop:
            //            stateString = @"等待商户处理";
            //            break;
            //        case OrderInfoOrderStateRefundingSuccess:
            //            stateString = @"退款完成";
            //            break;
        default:
            break;
    }
    if (orderInfo.isRefunded) {
        stateString = @"订单已取消";
    }
    if (stateString) {
        orderStateLabel.text = stateString;
    }
}

-(void)orderStateMoreButtonClick{
    OrderMoreStateViewController *omsVC = [[OrderMoreStateViewController alloc] init];
    omsVC.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:omsVC animated:YES];
}

#pragma mark - Navigation
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

-(void)rightItemClick{
}


-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
