//
//  OrderComfirmViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderComfirmViewController.h"
#import "MyAdressViewController.h"
#import "OrderNoteMessageViewController.h"

#import "OrderDetailViewController.h"

#import "UNUrlConnection.h"
#import "UNUserDefaults.h"

#import "WXApi.h"
#import "UNTools.h"
#import "DataMD5.h"
#import "XYW8IndicatorView.h"
#import "AppDelegate.h"


@interface OrderComfirmViewController (){
    AdressInfo *orderAddress;
    
    UILabel *bottomOrderNeedToPayNumLabel;
    
    UIView *deliveryTimeChooseWholeView;
    UIImageView *deliveryTimeChooseImageView;
    
    
    UIView *voucherChooseWholeView;
    UIImageView *voucherChooseImageView;
    
    /**
     *  订单相关参数
     */
    NSArray *allUnUsedVoucherArray;
    BOOL isUnionPayChoosed;//是否使用联合余额支付
    NSString *voucherPayCode;//优惠券的代码
    BOOL isFaPiaoNeed;//是否需要发票
    NSString *faPiaoTitle;//发票抬头
    
    BOOL isOrderNeedToPay;
    BOOL isCalcOrderInfo;//正在请求更新订单金额信息
    
    UILabel *orderVoncherCountNumberLabel;//优惠券的label
    UILabel *orderUnionYUECountNumberLabel;//余额显示的label
    
    BOOL isOrederCreated;
    
    id<NSObject> payClientBackNotification;
    
    XYW8IndicatorView *indicatorView;
}

@end

@implementation OrderComfirmViewController{
    UIScrollView *contentView;
    
    UILabel *noAddressNameLabel;
    
    UILabel *addressNameLabel,*addressPhoneLabel,*addressAddressLabel;
    UIImageView *addressSelectImage;
    
    
    UIImageView *unionPaymentSelectImageView;
    UIImageView *aliPaymentSelectImageView;
    UIImageView *wechatPaymentSelectImageView;
    UIImageView *voucherPaymentSelectImageView;
    
    OrderPaymentType payType;
    
    UILabel *orderDeliveryTimeLabel;
    UILabel *orderDeliveryNoteLabel;
    UILabel *orderShopDeliveryLabel;
}

static float BottomAreaHeight = 45.f;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"提交订单";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-BottomAreaHeight};
    contentView.backgroundColor = RGBColor(253, 253, 253);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1000};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIView *bottomAreaView = [[UIView alloc] init];
    bottomAreaView.frame = (CGRect){0,HEIGHT(self.view)-BottomAreaHeight,WIDTH(self.view),BottomAreaHeight};
    bottomAreaView.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:bottomAreaView];
    
    bottomOrderNeedToPayNumLabel = [[UILabel alloc] init];
    bottomOrderNeedToPayNumLabel.frame = (CGRect){10,0,WIDTH(bottomAreaView)-140-10,HEIGHT(bottomAreaView)};
    bottomOrderNeedToPayNumLabel.backgroundColor = bottomAreaView.backgroundColor;
    bottomOrderNeedToPayNumLabel.textColor = RGBColor(50, 50, 50);
    bottomOrderNeedToPayNumLabel.font = Font(16);
    bottomOrderNeedToPayNumLabel.textAlignment = NSTextAlignmentLeft;
    [bottomAreaView addSubview:bottomOrderNeedToPayNumLabel];
    
    UIButton *orderComfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderComfirmButton.frame = (CGRect){WIDTH(bottomAreaView)-140,0,140,HEIGHT(bottomAreaView)};
    [orderComfirmButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [orderComfirmButton setTitleColor:RGBColor(250, 250, 250) forState:UIControlStateNormal];
    orderComfirmButton.backgroundColor = UN_RedColor;
    [bottomAreaView addSubview:orderComfirmButton];
    [orderComfirmButton addTarget:self action:@selector(orderComfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    __block float contentoffset = 0.f;
    float noteLabelHeight = 35;
    
    UIView *noAddressAreaView = [[UIView alloc] init];
    noAddressAreaView.frame = (CGRect){0,contentoffset,WIDTH(contentView),noteLabelHeight+70};
    noAddressAreaView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:noAddressAreaView];
    
    UIView *addressAreaView = [[UIView alloc] init];
    addressAreaView.frame = (CGRect){0,contentoffset,WIDTH(contentView),noteLabelHeight+70};
    addressAreaView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:addressAreaView];
    
    UILabel *addressNoteLabel = [[UILabel alloc] init];
    addressNoteLabel.frame = (CGRect){0,0,WIDTH(contentView),noteLabelHeight};
    addressNoteLabel.backgroundColor = RGBColor(235, 235, 235);
    addressNoteLabel.text = @"   收餐地址";
    addressNoteLabel.textColor = RGBColor(50, 50, 50);
    addressNoteLabel.font = Font(15);
    [addressAreaView addSubview:addressNoteLabel];
    
    UIButton *addressInfoButton = [[UIButton alloc] init];
    addressInfoButton.frame = (CGRect){0,noteLabelHeight,WIDTH(addressAreaView),HEIGHT(addressAreaView)-noteLabelHeight};
    addressInfoButton.backgroundColor = addressAreaView.backgroundColor;
    [addressAreaView addSubview:addressInfoButton];
    [addressInfoButton addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    noAddressNameLabel = [[UILabel alloc] init];
    noAddressNameLabel.frame = (CGRect){15,25,160,15};
    noAddressNameLabel.textColor = RGBColor(140, 140, 140);
    noAddressNameLabel.textAlignment = NSTextAlignmentLeft;
    noAddressNameLabel.font = Font(16);
    noAddressNameLabel.text = @"点击选择送餐地址";
    [addressInfoButton addSubview:noAddressNameLabel];
    
    addressNameLabel = [[UILabel alloc] init];
    addressNameLabel.frame = (CGRect){15,15,110,15};
    addressNameLabel.textColor = RGBColor(50, 50, 50);
    addressNameLabel.textAlignment = NSTextAlignmentLeft;
    addressNameLabel.font = Font(16);
    //    addressNameLabel.text = @"欧阳高广 先生";
    [addressInfoButton addSubview:addressNameLabel];
    
    addressPhoneLabel = [[UILabel alloc] init];
    addressPhoneLabel.frame = (CGRect){140,TOP(addressNameLabel),120,HEIGHT(addressNameLabel)};
    addressPhoneLabel.textColor = RGBColor(50, 50, 50);
    addressPhoneLabel.textAlignment = NSTextAlignmentLeft;
    addressPhoneLabel.font = Font(16);
    //    addressPhoneLabel.text = @"13333111131";
    [addressInfoButton addSubview:addressPhoneLabel];
    
    addressAddressLabel = [[UILabel alloc] init];
    addressAddressLabel.frame = (CGRect){15,BOTTOM(addressNameLabel)+10,WIDTH(addressInfoButton)-10-10-30,14};
    addressAddressLabel.textColor = RGBColor(100, 100, 100);
    addressAddressLabel.textAlignment = NSTextAlignmentLeft;
    addressAddressLabel.font = Font(12);
    //    addressAddressLabel.text = @"北京市长安街特一号 中南海办公室1楼101";
    [addressInfoButton addSubview:addressAddressLabel];
    
    addressSelectImage = [[UIImageView alloc] init];
    addressSelectImage.image = [UIImage imageNamed:@"selected"];
    addressSelectImage.frame = (CGRect){WIDTH(addressInfoButton)-22-10,(HEIGHT(addressInfoButton)-22)/2,22,22};
    [addressInfoButton addSubview:addressSelectImage];
    
    contentoffset += HEIGHT(addressAreaView);
    
    UIView *paymentView = [[UIView alloc] init];
    paymentView.frame = (CGRect){0,contentoffset,WIDTH(contentView),noteLabelHeight+40*4};
    paymentView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:paymentView];
    
    UILabel *paymentNoteLabel = [[UILabel alloc] init];
    paymentNoteLabel.frame = (CGRect){0,0,WIDTH(paymentView),noteLabelHeight};
    paymentNoteLabel.backgroundColor = RGBColor(235, 235, 235);
    paymentNoteLabel.text = @"   选择支付方式";
    paymentNoteLabel.textColor = RGBColor(50, 50, 50);
    paymentNoteLabel.font = Font(15);
    [paymentView addSubview:paymentNoteLabel];
    
    UIButton *unionPayButton = [[UIButton alloc] init];
    unionPayButton.frame = (CGRect){0,noteLabelHeight,WIDTH(paymentView),40};
    unionPayButton.backgroundColor = paymentView.backgroundColor;
    unionPayButton.tag = 0;
    [paymentView addSubview:unionPayButton];
    [unionPayButton addTarget:self action:@selector(paymentGatewayChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    unionPaymentSelectImageView = [[UIImageView alloc] init];
    unionPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
    unionPaymentSelectImageView.tag = 0;
    unionPaymentSelectImageView.frame = (CGRect){15,(HEIGHT(unionPayButton)-22)/2,22,22};
    [unionPayButton addSubview:unionPaymentSelectImageView];
    
    UILabel *unionPaymentLabel = [[UILabel alloc] init];
    unionPaymentLabel.frame = (CGRect){47,0,WIDTH(unionPayButton)-10-52,HEIGHT(unionPayButton)};
    unionPaymentLabel.textColor = RGBColor(100, 100, 100);
    unionPaymentLabel.textAlignment = NSTextAlignmentLeft;
    unionPaymentLabel.font = Font(14);
    unionPaymentLabel.text = @"联合余额支付";
    [unionPayButton addSubview:unionPaymentLabel];
    
    UIView *unionPaymentSepLineView = [[UIView alloc] init];
    unionPaymentSepLineView.frame = (CGRect){0,HEIGHT(unionPayButton)-0.5,WIDTH(unionPayButton),0.5};
    unionPaymentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [unionPayButton addSubview:unionPaymentSepLineView];
    
    UIButton *voucherPayButton = [[UIButton alloc] init];
    voucherPayButton.frame = (CGRect){0,noteLabelHeight+40*1,WIDTH(paymentView),40};
    voucherPayButton.backgroundColor = paymentView.backgroundColor;
    voucherPayButton.tag = 1;
    [paymentView addSubview:voucherPayButton];
    [voucherPayButton addTarget:self action:@selector(paymentGatewayChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    voucherPaymentSelectImageView = [[UIImageView alloc] init];
    voucherPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
    voucherPaymentSelectImageView.frame = (CGRect){15,(HEIGHT(voucherPayButton)-22)/2,22,22};
    voucherPaymentSelectImageView.tag = 192;
    [voucherPayButton addSubview:voucherPaymentSelectImageView];
    
    UILabel *voucherPaymentLabel = [[UILabel alloc] init];
    voucherPaymentLabel.frame = (CGRect){47,0,WIDTH(voucherPayButton)-10-52,HEIGHT(voucherPayButton)};
    voucherPaymentLabel.textColor = RGBColor(100, 100, 100);
    voucherPaymentLabel.textAlignment = NSTextAlignmentLeft;
    voucherPaymentLabel.font = Font(14);
    voucherPaymentLabel.text = @"使用代金券";
    [voucherPayButton addSubview:voucherPaymentLabel];
    
    UIView *vouchermentSepLineView = [[UIView alloc] init];
    vouchermentSepLineView.frame = (CGRect){0,HEIGHT(voucherPayButton)-0.5,WIDTH(voucherPayButton),0.5};
    vouchermentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [voucherPayButton addSubview:vouchermentSepLineView];
    
    UIButton *aliPayButton = [[UIButton alloc] init];
    aliPayButton.frame = (CGRect){0,noteLabelHeight+40*2,WIDTH(paymentView),40};
    aliPayButton.backgroundColor = paymentView.backgroundColor;
    aliPayButton.tag = 2;
    [paymentView addSubview:aliPayButton];
    [aliPayButton addTarget:self action:@selector(paymentGatewayChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    aliPaymentSelectImageView = [[UIImageView alloc] init];
    aliPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
    aliPaymentSelectImageView.frame = (CGRect){15,(HEIGHT(aliPayButton)-22)/2,22,22};
    aliPaymentSelectImageView.tag = 192;
    [aliPayButton addSubview:aliPaymentSelectImageView];
    
    UILabel *aliPaymentLabel = [[UILabel alloc] init];
    aliPaymentLabel.frame = (CGRect){47,0,WIDTH(aliPayButton)-10-52,HEIGHT(aliPayButton)};
    aliPaymentLabel.textColor = RGBColor(100, 100, 100);
    aliPaymentLabel.textAlignment = NSTextAlignmentLeft;
    aliPaymentLabel.font = Font(14);
    aliPaymentLabel.text = @"支付宝支付";
    [aliPayButton addSubview:aliPaymentLabel];
    
    UIView *aliPaymentSepLineView = [[UIView alloc] init];
    aliPaymentSepLineView.frame = (CGRect){0,HEIGHT(aliPayButton)-0.5,WIDTH(aliPayButton),0.5};
    aliPaymentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [aliPayButton addSubview:aliPaymentSepLineView];
    
    UIButton *wechatPayButton = [[UIButton alloc] init];
    wechatPayButton.frame = (CGRect){0,noteLabelHeight+40*3,WIDTH(paymentView),40};
    wechatPayButton.backgroundColor = paymentView.backgroundColor;
    wechatPayButton.tag = 3;
    [paymentView addSubview:wechatPayButton];
    [wechatPayButton addTarget:self action:@selector(paymentGatewayChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    wechatPaymentSelectImageView = [[UIImageView alloc] init];
    wechatPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
    wechatPaymentSelectImageView.frame = (CGRect){15,(HEIGHT(wechatPayButton)-22)/2,22,22};
    wechatPaymentSelectImageView.tag = 192;
    [wechatPayButton addSubview:wechatPaymentSelectImageView];
    
    UILabel *wechatPaymentLabel = [[UILabel alloc] init];
    wechatPaymentLabel.frame = (CGRect){47,0,WIDTH(wechatPayButton)-10-52,HEIGHT(wechatPayButton)};
    wechatPaymentLabel.textColor = RGBColor(100, 100, 100);
    wechatPaymentLabel.textAlignment = NSTextAlignmentLeft;
    wechatPaymentLabel.font = Font(14);
    wechatPaymentLabel.text = @"微信支付";
    [wechatPayButton addSubview:wechatPaymentLabel];
    
    UIView *wechatmentSepLineView = [[UIView alloc] init];
    wechatmentSepLineView.frame = (CGRect){0,HEIGHT(wechatPayButton)-0.5,WIDTH(wechatPayButton),0.5};
    wechatmentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [wechatPayButton addSubview:wechatmentSepLineView];
    
    contentoffset += HEIGHT(paymentView);
    
    UIView *sepLineHorView1 = [[UIView alloc] init];
    sepLineHorView1.frame = (CGRect){0,contentoffset,WIDTH(contentView),10};
    sepLineHorView1.backgroundColor = RGBColor(235, 235, 235);
    [contentView addSubview:sepLineHorView1];
    
    UIView *sepLineTmp = [[UIView alloc] init];
    sepLineTmp.frame = (CGRect){0,HEIGHT(sepLineHorView1)-0.5,WIDTH(sepLineHorView1),0.5};
    sepLineTmp.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [sepLineHorView1 addSubview:sepLineTmp];
    
    contentoffset += HEIGHT(sepLineHorView1);
    
    UIButton *orderDeliveryTimeButton = [[UIButton alloc] init];
    orderDeliveryTimeButton.frame = (CGRect){0,contentoffset,WIDTH(contentView),40};
    orderDeliveryTimeButton.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:orderDeliveryTimeButton];
    [orderDeliveryTimeButton addTarget:self action:@selector(orderDeliveryTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *orderDeliveryTimeNoteLabel = [[UILabel alloc] init];
    orderDeliveryTimeNoteLabel.frame = (CGRect){15,0,70,HEIGHT(orderDeliveryTimeButton)};
    orderDeliveryTimeNoteLabel.textColor = RGBColor(80, 80, 80);
    orderDeliveryTimeNoteLabel.textAlignment = NSTextAlignmentLeft;
    orderDeliveryTimeNoteLabel.font = Font(14);
    orderDeliveryTimeNoteLabel.text = @"配送时间";
    [orderDeliveryTimeButton addSubview:orderDeliveryTimeNoteLabel];
    
    orderDeliveryTimeLabel = [[UILabel alloc] init];
    orderDeliveryTimeLabel.frame = (CGRect){90,0,WIDTH(orderDeliveryTimeButton)-90-10-15,HEIGHT(orderDeliveryTimeButton)};
    orderDeliveryTimeLabel.textColor = RGBColor(80, 80, 80);
    orderDeliveryTimeLabel.textAlignment = NSTextAlignmentRight;
    orderDeliveryTimeLabel.font = Font(14);
    orderDeliveryTimeLabel.text = @"请选择";
    [orderDeliveryTimeButton addSubview:orderDeliveryTimeLabel];
    
    UIImageView *orderDeliveryTimeMoreImage = [[UIImageView alloc] init];
    orderDeliveryTimeMoreImage.image = [UIImage imageNamed:@"more"];
    orderDeliveryTimeMoreImage.frame = (CGRect){WIDTH(orderDeliveryTimeButton)-10-7,(HEIGHT(orderDeliveryTimeButton)-11)/2,7,11};
    [orderDeliveryTimeButton addSubview:orderDeliveryTimeMoreImage];
    
    UIView *orderDeliveryTimeSepLineView = [[UIView alloc] init];
    orderDeliveryTimeSepLineView.frame = (CGRect){0,HEIGHT(orderDeliveryTimeButton)-0.5,WIDTH(orderDeliveryTimeButton),0.5};
    orderDeliveryTimeSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderDeliveryTimeButton addSubview:orderDeliveryTimeSepLineView];
    
    contentoffset += HEIGHT(orderDeliveryTimeButton);
    
    UIButton *orderDeliveryNoteButton = [[UIButton alloc] init];
    orderDeliveryNoteButton.frame = (CGRect){0,contentoffset,WIDTH(contentView),40};
    orderDeliveryNoteButton.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:orderDeliveryNoteButton];
    [orderDeliveryNoteButton addTarget:self action:@selector(orderDeliveryNoteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *orderDeliveryNoteNoteLabel = [[UILabel alloc] init];
    orderDeliveryNoteNoteLabel.frame = (CGRect){15,0,70,HEIGHT(orderDeliveryNoteButton)};
    orderDeliveryNoteNoteLabel.textColor = RGBColor(80, 80, 80);
    orderDeliveryNoteNoteLabel.textAlignment = NSTextAlignmentLeft;
    orderDeliveryNoteNoteLabel.font = Font(14);
    orderDeliveryNoteNoteLabel.text = @"配送备注";
    [orderDeliveryNoteButton addSubview:orderDeliveryNoteNoteLabel];
    
    orderDeliveryNoteLabel = [[UILabel alloc] init];
    orderDeliveryNoteLabel.frame = (CGRect){90,0,WIDTH(orderDeliveryNoteButton)-90-10-15,HEIGHT(orderDeliveryNoteButton)};
    orderDeliveryNoteLabel.textColor = RGBColor(80, 80, 80);
    orderDeliveryNoteLabel.textAlignment = NSTextAlignmentRight;
    orderDeliveryNoteLabel.font = Font(14);
    orderDeliveryNoteLabel.text = @"请输入";
    [orderDeliveryNoteButton addSubview:orderDeliveryNoteLabel];
    
    UIImageView *orderDeliveryNoteMoreImage = [[UIImageView alloc] init];
    orderDeliveryNoteMoreImage.image = [UIImage imageNamed:@"more"];
    orderDeliveryNoteMoreImage.frame = (CGRect){WIDTH(orderDeliveryNoteButton)-10-7,(HEIGHT(orderDeliveryNoteButton)-11)/2,7,11};
    [orderDeliveryNoteButton addSubview:orderDeliveryNoteMoreImage];
    
    UIView *orderDeliveryNoteSepLineView = [[UIView alloc] init];
    orderDeliveryNoteSepLineView.frame = (CGRect){0,HEIGHT(orderDeliveryNoteButton)-0.5,WIDTH(orderDeliveryNoteButton),0.5};
    orderDeliveryNoteSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderDeliveryNoteButton addSubview:orderDeliveryNoteSepLineView];
    
    contentoffset += HEIGHT(orderDeliveryNoteButton);
    
    //    UIView *sepLineHorView2 = [[UIView alloc] init];
    //    sepLineHorView2.frame = (CGRect){0,contentoffset,WIDTH(contentView),10};
    //    sepLineHorView2.backgroundColor = RGBColor(235, 235, 235);
    //    [contentView addSubview:sepLineHorView2];
    //    
    //    UIView *sepLineTmp2 = [[UIView alloc] init];
    //    sepLineTmp2.frame = (CGRect){0,HEIGHT(sepLineHorView2)-0.5,WIDTH(sepLineHorView2),0.5};
    //    sepLineTmp2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    //    [sepLineHorView2 addSubview:sepLineTmp2];
    //    
    //    contentoffset += HEIGHT(sepLineHorView2);
    
    UILabel *orderInfoItemNoteLabel = [[UILabel alloc] init];
    orderInfoItemNoteLabel.frame = (CGRect){0,contentoffset,WIDTH(paymentView),noteLabelHeight};
    orderInfoItemNoteLabel.backgroundColor = RGBColor(235, 235, 235);
    orderInfoItemNoteLabel.text = @"   订单信息";
    orderInfoItemNoteLabel.textColor = RGBColor(50, 50, 50);
    orderInfoItemNoteLabel.font = Font(15);
    [contentView addSubview:orderInfoItemNoteLabel];
    
    contentoffset += HEIGHT(orderInfoItemNoteLabel);
    
    //22 56 140
    UIView *orderShopNameView = [[UIView alloc] init];
    orderShopNameView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderShopNameView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderShopNameView];
    
    UILabel *orderShopNameLabel = [[UILabel alloc] init];
    orderShopNameLabel.frame = (CGRect){10,0,WIDTH(orderShopNameView)-150-10-10,HEIGHT(orderShopNameView)};
    orderShopNameLabel.textColor = RGBColor(22, 56, 140);
    orderShopNameLabel.textAlignment = NSTextAlignmentLeft;
    orderShopNameLabel.font = Font(16);
    orderShopNameLabel.text = self.orderInfo.shopName ? self.orderInfo.shopName:@"商家";
    [orderShopNameView addSubview:orderShopNameLabel];
    
    orderShopDeliveryLabel = [[UILabel alloc] init];
    orderShopDeliveryLabel.frame = (CGRect){WIDTH(orderShopNameView)-10-150+5,0,145,HEIGHT(orderShopNameLabel)};
    orderShopDeliveryLabel.textColor = RGBColor(100,100,100);
    orderShopDeliveryLabel.textAlignment = NSTextAlignmentRight;
    orderShopDeliveryLabel.font = Font(14);
    orderShopDeliveryLabel.text = self.orderInfo.isSelfDelivery?@"联合配送":@"商家配送";
    [orderShopNameView addSubview:orderShopDeliveryLabel];
    
    UIView *orderShopDeliveryBottomSepLineView = [[UIView alloc] init];
    orderShopDeliveryBottomSepLineView.frame = (CGRect){0,HEIGHT(orderShopNameView)-0.5,WIDTH(orderShopNameView),0.5};
    orderShopDeliveryBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderShopNameView addSubview:orderShopDeliveryBottomSepLineView];
    
    contentoffset += HEIGHT(orderShopNameView);
    
    /**
     *  添加菜单
     */
    
    NSArray *detailArray  = self.orderInfo.orderMenuDetail;
    if (detailArray && detailArray.count != 0) {
        [detailArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
            UIView *outterAddView = [[UIView alloc] init];
            outterAddView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
            outterAddView.backgroundColor = RGBColor(250, 250, 250);
            [contentView addSubview:outterAddView];
            
            contentoffset += HEIGHT(outterAddView);
            
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
    orderShopDeliveryView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderShopDeliveryView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderShopDeliveryView];
    
    UILabel *orderShopShopDeliveryNoteLabel = [[UILabel alloc] init];
    orderShopShopDeliveryNoteLabel.frame = (CGRect){10,0,WIDTH(orderShopDeliveryView)-150-10-10,HEIGHT(orderShopNameLabel)};
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
    orderShopDeliveryNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.orderInfo.deliveryNumber];
    [orderShopDeliveryView addSubview:orderShopDeliveryNumberLabel];
    
    UIView *orderShopDeliveryViewSepLineView = [[UIView alloc] init];
    orderShopDeliveryViewSepLineView.frame = (CGRect){0,HEIGHT(orderShopDeliveryView)-0.5,WIDTH(orderShopDeliveryView),0.5};
    orderShopDeliveryViewSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderShopDeliveryView addSubview:orderShopDeliveryViewSepLineView];
    
    contentoffset += HEIGHT(orderShopDeliveryView);
    
    //    //添加合计视图
    UIView *orderTotalCountView = [[UIView alloc] init];
    orderTotalCountView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderTotalCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderTotalCountView];
    
    UILabel *orderTotalCountNumberLabel = [[UILabel alloc] init];
    orderTotalCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderTotalCountView)-20,HEIGHT(orderTotalCountView)};
    orderTotalCountNumberLabel.textColor = RGBColor(80,80,80);
    orderTotalCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderTotalCountNumberLabel.font = Font(14);
    [orderTotalCountView addSubview:orderTotalCountNumberLabel];
    
    NSString *totalItemMoneyTmpString;
    float orderItemTotalNumValue = self.orderInfo.originNumber + self.orderInfo.deliveryNumber;
    int totalMoneyTmpNum = (int)(orderItemTotalNumValue*10) - ((int)orderItemTotalNumValue)*10;
    if (totalMoneyTmpNum == 0) {
        totalItemMoneyTmpString = [NSString stringWithFormat:@"%d",(int)orderItemTotalNumValue];
    }else{
        totalItemMoneyTmpString = [NSString stringWithFormat:@"%.1f",orderItemTotalNumValue];
    }
    orderTotalCountNumberLabel.text = [NSString stringWithFormat:@"合计金额：￥%@",totalItemMoneyTmpString];
    
    UIView *orderTotalCountNumberSepLineView = [[UIView alloc] init];
    orderTotalCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderTotalCountView)-0.5,WIDTH(orderTotalCountView),0.5};
    orderTotalCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderTotalCountView addSubview:orderTotalCountNumberSepLineView];
    
    contentoffset += HEIGHT(orderTotalCountView);
    
    NSArray *youhuiTmpArray = self.orderInfo.youhuiDetail;
    __block float youhuiTotalNum = 0;
    if (youhuiTmpArray && youhuiTmpArray.count != 0) {
        [youhuiTmpArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
            UIView *youhuiAddView = [[UIView alloc] init];
            youhuiAddView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
            youhuiAddView.backgroundColor = RGBColor(250, 250, 250);
            [contentView addSubview:youhuiAddView];
            
            contentoffset += HEIGHT(youhuiAddView);
            NSString *youhuiItemKey = menuInfo[@"type"];
            NSString *youhuiShowKey;
            UIColor *tagColor = UN_RedColor;
            if ([youhuiItemKey isEqualToString:@"preferential1"]) {
                youhuiShowKey = @"新";
                tagColor = UN_FilterXin;
            }else if ([youhuiItemKey isEqualToString:@"preferential2"]){
                youhuiShowKey = @"特";
                tagColor = UN_FilterTejia;
            }else if ([youhuiItemKey isEqualToString:@"preferential3"]){
                youhuiShowKey = @"减";
                tagColor = UN_FilterJian;
            }else if ([youhuiItemKey isEqualToString:@"preferential4"]){
                youhuiShowKey = @"预";
                tagColor = UN_FilterYu;
            }else if ([youhuiItemKey isEqualToString:@"preferential5"]){
                youhuiShowKey = @"免";
                tagColor = UN_FilterMian;
            }else if ([youhuiItemKey isEqualToString:@"preferential6"]){
                youhuiShowKey = @"送";
                tagColor = UN_FilterMian;
            }else{
                youhuiShowKey = @"惠";
                tagColor = UN_RedColor;
            }
            
            UILabel *youhuiItemNameLabel = [[UILabel alloc] init];
            youhuiItemNameLabel.frame = (CGRect){10,(HEIGHT(youhuiAddView)-20)/2,20,20};
            youhuiItemNameLabel.backgroundColor = tagColor;
            youhuiItemNameLabel.layer.cornerRadius = 10;
            youhuiItemNameLabel.layer.masksToBounds = YES;
            youhuiItemNameLabel.text = youhuiShowKey;
            youhuiItemNameLabel.layer.borderColor = tagColor.CGColor;
            youhuiItemNameLabel.layer.borderWidth = 1.f;
            youhuiItemNameLabel.textAlignment = NSTextAlignmentCenter;
            youhuiItemNameLabel.textColor = [UIColor whiteColor];
            youhuiItemNameLabel.font = Font(13);
            [youhuiAddView addSubview:youhuiItemNameLabel];
            
            NSString *youhuiItemDescption = menuInfo[@"desciption"];
            UILabel *youhuiItemDescptionLabel = [[UILabel alloc] init];
            youhuiItemDescptionLabel.frame = (CGRect){RIGHT(youhuiItemNameLabel)+10,0,WIDTH(youhuiAddView)-(RIGHT(youhuiItemNameLabel)+10)-10-50,HEIGHT(youhuiAddView)};
            youhuiItemDescptionLabel.textColor = RGBColor(80,80,80);
            youhuiItemDescptionLabel.textAlignment = NSTextAlignmentLeft;
            youhuiItemDescptionLabel.font = Font(13);
            youhuiItemDescptionLabel.text = youhuiItemDescption;
            [youhuiAddView addSubview:youhuiItemDescptionLabel];
            
            UILabel *youhuiItemValueLabel = [[UILabel alloc] init];
            youhuiItemValueLabel.frame = (CGRect){WIDTH(youhuiAddView)-50-10,0,50,HEIGHT(youhuiAddView)};
            youhuiItemValueLabel.textColor = RGBColor(80,80,80);
            youhuiItemValueLabel.textAlignment = NSTextAlignmentRight;
            youhuiItemValueLabel.font = Font(13);
            [youhuiAddView addSubview:youhuiItemValueLabel];
            
            NSString *youhuiItemValue = menuInfo[@"number"];
            youhuiItemValueLabel.text = [NSString stringWithFormat:@"-￥%@",youhuiItemValue];
            
            UIView *youhuiItemSepLineView = [[UIView alloc] init];
            youhuiItemSepLineView.frame = (CGRect){0,HEIGHT(youhuiAddView)-0.5,WIDTH(youhuiAddView),0.5};
            youhuiItemSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [youhuiAddView addSubview:youhuiItemSepLineView];
            
            youhuiTotalNum += [youhuiItemValue intValue];
        }];
    }
    
    //优惠总计
    UIView *orderYouhuiCountView = [[UIView alloc] init];
    orderYouhuiCountView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderYouhuiCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderYouhuiCountView];
    
    UILabel *orderYouhuiCountNumberLabel = [[UILabel alloc] init];
    orderYouhuiCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderYouhuiCountView)-20,HEIGHT(orderYouhuiCountView)};
    orderYouhuiCountNumberLabel.textColor = UN_RedColor;
    orderYouhuiCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderYouhuiCountNumberLabel.font = Font(14);
    [orderYouhuiCountView addSubview:orderYouhuiCountNumberLabel];
    
    NSString *youhuiMoneyTmpString;
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
    
    contentoffset += HEIGHT(orderYouhuiCountView);
    
    //添加订单总计视图
    UIView *orderFinallyCountView = [[UIView alloc] init];
    orderFinallyCountView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderFinallyCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderFinallyCountView];
    
    UILabel *orderFinallyCountNumberLabel = [[UILabel alloc] init];
    orderFinallyCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderFinallyCountView)-20,HEIGHT(orderFinallyCountView)};
    orderFinallyCountNumberLabel.textColor = UN_RedColor;
    orderFinallyCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderFinallyCountNumberLabel.font = Font(14);
    [orderFinallyCountView addSubview:orderFinallyCountNumberLabel];
    
    NSString *finnalyMoneyTmpString;
    float orderTotalNumValue = self.orderInfo.originNumber+self.orderInfo.deliveryNumber - youhuiTotalNum;
    int finnalyMoneyTmpNum = (int)(orderTotalNumValue*10) - ((int)orderTotalNumValue)*10;
    if (orderTotalNumValue < 0) {
        orderTotalNumValue = 0;
    }
    if (finnalyMoneyTmpNum == 0) {
        finnalyMoneyTmpString = [NSString stringWithFormat:@"%d",(int)orderTotalNumValue];
    }else{
        finnalyMoneyTmpString = [NSString stringWithFormat:@"%.1f",orderTotalNumValue];
    }
    orderFinallyCountNumberLabel.text = [NSString stringWithFormat:@"订单总计：￥%@",finnalyMoneyTmpString];
    
    UIView *orderFinallyCountNumberSepLineView = [[UIView alloc] init];
    orderFinallyCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderFinallyCountView)-0.5,WIDTH(orderFinallyCountView),0.5};
    orderFinallyCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderFinallyCountView addSubview:orderFinallyCountNumberSepLineView];
    
    contentoffset += HEIGHT(orderFinallyCountView);
    
    //代金券总计
    UIView *orderVoncherCountView = [[UIView alloc] init];
    orderVoncherCountView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderVoncherCountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderVoncherCountView];
    
    orderVoncherCountNumberLabel = [[UILabel alloc] init];
    orderVoncherCountNumberLabel.frame = (CGRect){10,0,WIDTH(orderVoncherCountView)-20,HEIGHT(orderVoncherCountView)};
    orderVoncherCountNumberLabel.textColor = UN_RedColor;
    orderVoncherCountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderVoncherCountNumberLabel.font = Font(14);
    [orderVoncherCountView addSubview:orderVoncherCountNumberLabel];
    
    //    NSString *voncherMoneyTmpString;
    //    int voncherMoneyTmpNum = (int)(voncherTotalNum*10) - ((int)voncherTotalNum)*10;
    //    if (voncherMoneyTmpNum == 0) {
    //        voncherMoneyTmpString = [NSString stringWithFormat:@"%d",(int)voncherTotalNum];
    //    }else{
    //        voncherMoneyTmpString = [NSString stringWithFormat:@"%.1f",voncherTotalNum];
    //    }
    orderVoncherCountNumberLabel.text = [NSString stringWithFormat:@"代金券总计：-￥%d",0];
    
    UIView *orderVoncherCountNumberSepLineView = [[UIView alloc] init];
    orderVoncherCountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderVoncherCountView)-0.5,WIDTH(orderVoncherCountView),0.5};
    orderVoncherCountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderVoncherCountView addSubview:orderVoncherCountNumberSepLineView];
    
    contentoffset += HEIGHT(orderVoncherCountView);
    
    UIView *orderUnionYUECountView = [[UIView alloc] init];
    orderUnionYUECountView.frame = (CGRect){0,contentoffset,WIDTH(contentView),45};
    orderUnionYUECountView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:orderUnionYUECountView];
    
    orderUnionYUECountNumberLabel = [[UILabel alloc] init];
    orderUnionYUECountNumberLabel.frame = (CGRect){10,0,WIDTH(orderUnionYUECountView)-20,HEIGHT(orderUnionYUECountView)};
    orderUnionYUECountNumberLabel.textColor = UN_RedColor;
    orderUnionYUECountNumberLabel.textAlignment = NSTextAlignmentRight;
    orderUnionYUECountNumberLabel.font = Font(14);
    [orderUnionYUECountView addSubview:orderUnionYUECountNumberLabel];
    
    //    NSString *voncherMoneyTmpString;
    //    int voncherMoneyTmpNum = (int)(voncherTotalNum*10) - ((int)voncherTotalNum)*10;
    //    if (voncherMoneyTmpNum == 0) {
    //        voncherMoneyTmpString = [NSString stringWithFormat:@"%d",(int)voncherTotalNum];
    //    }else{
    //        voncherMoneyTmpString = [NSString stringWithFormat:@"%.1f",voncherTotalNum];
    //    }
    orderUnionYUECountNumberLabel.text = [NSString stringWithFormat:@"余额抵扣：-￥%d",0];
    
    UIView *orderUnionYUECountNumberSepLineView = [[UIView alloc] init];
    orderUnionYUECountNumberSepLineView.frame = (CGRect){0,HEIGHT(orderUnionYUECountView)-0.5,WIDTH(orderUnionYUECountView),0.5};
    orderUnionYUECountNumberSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [orderUnionYUECountView addSubview:orderUnionYUECountNumberSepLineView];
    
    contentoffset += HEIGHT(orderUnionYUECountView);
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, contentoffset+1)};
    
    payType = OrderPaymentTypeNone;
    
    if (!orderAddress) {
        [self setDefaultAddressInfo];
    }
    [self setOrderAddress:orderAddress];
    
    [self setOrderNeedToPayNum:0];
    
    [self getAllUsefulVoucherList];
    
    [self reCalcOrderInfo];
}

-(void)getAllUsefulVoucherList{
    [UNUrlConnection getAllUnusedVoucherListComlete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:@"获取未使用的代金券失败,请稍候再试"];
            //            [unUsedTableView endDownRefresh];
            return;
        }
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isEqualToString:@"success"]) {
            NSArray *listArray = resultDic[@"list"];
            NSMutableArray *unUsedDataArrayTmp = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                if (obj && obj.count >= 3) {
                    NSString *timeStamp = [NSString stringWithFormat:@"%lld",[obj[0] longLongValue]/1000];
                    NSString *priceString = obj[1];
                    NSString *numTmp = [priceString stringByReplacingOccurrencesOfString:@"元代金券" withString:@""];
                    NSString *voucherID = obj[2];
                    if (timeStamp && numTmp && voucherID) {
                        [unUsedDataArrayTmp addObject:@{@"number":numTmp,
                                                        @"source":@"联合外卖",
                                                        @"expired":timeStamp,
                                                        @"seril":voucherID,
                                                        }];
                    }
                }
            }];
            allUnUsedVoucherArray = unUsedDataArrayTmp;
            //            [unUsedTableView endDownRefresh];
        }else{
            [BYToastView showToastWithMessage:@"获取未使用的代金券失败,请稍候再试"];
            //            [unUsedTableView endDownRefresh];
            return;
        }
    }];
}

-(void)setDefaultAddressInfo{
    AdressInfo *defaultAddress = [UNUserDefaults getDefaultAddressInfo];
    orderAddress = defaultAddress;
}

-(void)setOrderAddress:(AdressInfo *)addressInfo{
    if (addressInfo) {
        orderAddress = addressInfo;
        noAddressNameLabel.alpha = 0;
        
        addressNameLabel.alpha = 1;
        addressPhoneLabel.alpha = 1;
        addressAddressLabel.alpha = 1;
        addressSelectImage.alpha = 1;
        
        addressNameLabel.text = [NSString stringWithFormat:@"%@ %@",addressInfo.name,addressInfo.sex==0?@"先生":@"女士"];
        
        if (addressInfo.mapAdress) {
            addressAddressLabel.text = [NSString stringWithFormat:@"%@ %@",addressInfo.mapAdress,addressInfo.detailAdress?addressInfo.detailAdress:@""];
        }else{
            addressAddressLabel.text = [NSString stringWithFormat:@"%@",addressInfo.detailAdress?addressInfo.detailAdress:@""];
        }
        addressPhoneLabel.text = addressInfo.phone?addressInfo.phone:@"";
    }else{
        noAddressNameLabel.alpha = 1;
        
        addressNameLabel.alpha = 0;
        addressPhoneLabel.alpha = 0;
        addressAddressLabel.alpha = 0;
        addressSelectImage.alpha = 0;
    }
    
    
}

-(void)chooseAddress{
    MyAdressViewController *maVC = [[MyAdressViewController alloc] init];
    maVC.resultBlock = ^(AdressInfo *address){
        if (address) {
            orderAddress = address;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setOrderAddress:orderAddress];
            });
        }
    };
    [self.navigationController pushViewController:maVC animated:YES];
}

- (void)paymentGatewayChanged:(UIButton *)button{
    int buttonTag = (int)button.tag;
    switch (buttonTag) {
        case 0:{
            if (unionPaymentSelectImageView.tag == 0) {
                [self setUnionChooseState:YES];
            }else{
                [self setUnionChooseState:NO];
            }
            [self reCalcOrderInfo];
        }
            break;
        case 1:{
            [self showVoucherChooseWholeView];
        }
            break;
        case 2:{
            aliPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
            wechatPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
            payType = OrderPaymentTypeAli;
        }
            break;
        case 3:{
            wechatPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
            aliPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
            payType = OrderPaymentTypeWechat;
        }
            break;
        default:
            break;
    }
}

-(void)setUnionChooseState:(BOOL)toState{
    if (toState) {
        unionPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
        unionPaymentSelectImageView.tag = 1;
        isUnionPayChoosed = YES;
    }else{
        unionPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
        unionPaymentSelectImageView.tag = 0;
        isUnionPayChoosed = NO;
    }
}

-(void)orderDeliveryTimeButtonClick{
    [self showdeliveryTimeChooseWholeView];
}

-(void)orderDeliveryNoteButtonClick{
    OrderNoteMessageViewController *noteMessageVC = [[OrderNoteMessageViewController alloc] init];
    noteMessageVC.orderVC = self;
    [self.navigationController pushViewController:noteMessageVC animated:YES];
}

#pragma mark - 重新计算订单的价格
-(void)reCalcOrderInfo{
    isCalcOrderInfo = NO;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.orderInfo.orderID forKey:@"cart_id"];
    [paramsDic setObject:self.shopInfo.shopID forKey:@"brand_id"];
    [paramsDic setObject:orderDeliveryNoteLabel.text forKey:@"memo"];
    [paramsDic setObject:@(isFaPiaoNeed) forKey:@"isInvoice"];
    if (!faPiaoTitle) {
        faPiaoTitle = @"";
    }
    [paramsDic setObject:faPiaoTitle forKey:@"invoiceTitle"];
    [paramsDic setObject:@(isUnionPayChoosed) forKey:@"useBalance"];
    if (voucherPayCode) {
        [paramsDic setObject:voucherPayCode forKey:@"code"];
    }
    
    [UNUrlConnection reCalcOrderWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messDic = resultDic[@"message"];
        NSString *typeString = messDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *contentDic = resultDic[@"content"];
            
            //            float feeNum = [contentDic[@"fee"] floatValue];
            float yueNum = [contentDic[@"balance"] floatValue];
            //            float orderPriceNum = [contentDic[@"price"] floatValue];
            //            float promotionDiscountNum = [contentDic[@"promotionDiscount"] floatValue];
            float couponDiscountNum = [contentDic[@"couponDiscount"] floatValue];
            float amountPayableNum = [contentDic[@"amountPayable"] floatValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setOrderYUELabelNum:yueNum];
                [self setOrderVoncherLabelNum:couponDiscountNum];
                [self setOrderNeedToPayNum:amountPayableNum];
                
                if (amountPayableNum <= 0) {
                    isOrderNeedToPay = NO;
                    aliPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
                    wechatPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
                    payType = OrderPaymentTypeNone;
                }else{
                    isOrderNeedToPay = YES;
                }
            });
            isCalcOrderInfo = YES;
        }else{
            [BYToastView showToastWithMessage:@"订单计算失败,请稍候再试.."];
        }
    }];
}


#pragma mark - 展示配送时间选择视图
-(void)showdeliveryTimeChooseWholeView{
    if (!deliveryTimeChooseWholeView) {
        deliveryTimeChooseWholeView = [[UIView alloc] init];
        deliveryTimeChooseWholeView.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT};
        deliveryTimeChooseWholeView.backgroundColor = RGBAColor(50, 50, 50, 0.5);
        
        UITapGestureRecognizer *deliveryTimeChooseWholeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deliveryTimeChooseWholeViewTap)];
        [deliveryTimeChooseWholeView addGestureRecognizer:deliveryTimeChooseWholeViewTap];
        
        float deliveryTimeChooseViewEveryButtonHeight = 40;
        if (IS4_7Inches()) {
            deliveryTimeChooseViewEveryButtonHeight = 45;
        }else if (IS5_5Inches()){
            deliveryTimeChooseViewEveryButtonHeight = 45;
        }
        
        UIView *deliveryTimeChooseView = [[UIView alloc] init];
        deliveryTimeChooseView.frame = (CGRect){20,(HEIGHT(deliveryTimeChooseWholeView)-deliveryTimeChooseViewEveryButtonHeight*8)/2,(WIDTH(deliveryTimeChooseWholeView)-40),deliveryTimeChooseViewEveryButtonHeight*8};
        deliveryTimeChooseView.backgroundColor = RGBColor(253, 253, 253);
        deliveryTimeChooseView.layer.cornerRadius = 4.f;
        deliveryTimeChooseView.layer.masksToBounds = YES;
        [deliveryTimeChooseWholeView addSubview:deliveryTimeChooseView];
        
        UILabel *deliveryTimeChooseTitleLabel = [[UILabel alloc] init];
        deliveryTimeChooseTitleLabel.frame = (CGRect){0,0,WIDTH(deliveryTimeChooseView),deliveryTimeChooseViewEveryButtonHeight};
        deliveryTimeChooseTitleLabel.backgroundColor = RGBColor(210, 210, 210);
        deliveryTimeChooseTitleLabel.text = @"请选择送餐时间";
        deliveryTimeChooseTitleLabel.textColor = RGBColor(50, 50, 50);
        deliveryTimeChooseTitleLabel.textAlignment = NSTextAlignmentCenter;
        deliveryTimeChooseTitleLabel.userInteractionEnabled = YES;
        [deliveryTimeChooseView addSubview:deliveryTimeChooseTitleLabel];
        
        UIView *deliveryTimeChooseTitleSepline = [[UIView alloc] init];
        deliveryTimeChooseTitleSepline.frame = (CGRect){0,HEIGHT(deliveryTimeChooseTitleLabel)-0.5,WIDTH(deliveryTimeChooseTitleLabel),0.5};
        deliveryTimeChooseTitleSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [deliveryTimeChooseTitleLabel addSubview:deliveryTimeChooseTitleSepline];
        
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        
        for (int i = 0; i < 7; i++) {
            NSTimeInterval tiTmp = nowInterval +(i+1)*15*60;
            NSString *timeStringTmp = [self timeStringWithTimeInterval:tiTmp];
            
            UIButton *timeSelectButton = [[UIButton alloc] init];
            timeSelectButton.frame = (CGRect){0,(i+1)*deliveryTimeChooseViewEveryButtonHeight,WIDTH(deliveryTimeChooseView),deliveryTimeChooseViewEveryButtonHeight};
            timeSelectButton.tag = i;
            [timeSelectButton setTitle:timeStringTmp forState:UIControlStateNormal];
            [timeSelectButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
            timeSelectButton.titleLabel.font = Font(16);
            [timeSelectButton addTarget:self action:@selector(deliveryTimeChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [deliveryTimeChooseView addSubview:timeSelectButton];
            
            UIView *deliveryTimeChooseButtonSepline = [[UIView alloc] init];
            deliveryTimeChooseButtonSepline.frame = (CGRect){0,HEIGHT(timeSelectButton)-0.5,WIDTH(timeSelectButton),0.5};
            deliveryTimeChooseButtonSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [timeSelectButton addSubview:deliveryTimeChooseButtonSepline];
        }
        
        deliveryTimeChooseImageView = [[UIImageView alloc] init];
        deliveryTimeChooseImageView.image = [UIImage imageNamed:@"selected"];
        [deliveryTimeChooseView addSubview:deliveryTimeChooseImageView];
    }
    deliveryTimeChooseWholeView.alpha = 0;
    [MainWindow addSubview:deliveryTimeChooseWholeView];
    [UIView animateWithDuration:0.3 animations:^{
        deliveryTimeChooseWholeView.alpha = 1;
    }];
}

-(NSString *)timeStringWithTimeInterval:(NSTimeInterval)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(void)deliveryTimeChooseButtonClick:(UIButton *)button{
    int buttonTag = (int)button.tag;
    deliveryTimeChooseImageView.frame = (CGRect){WIDTH(button)-20-22,(buttonTag+1)*HEIGHT(button)+(HEIGHT(button)-22)/2,22,22};
    
    NSString *timeString = button.titleLabel.text;
    orderDeliveryTimeLabel.text = timeString;
    self.orderInfo.deliveryTime = timeString;
    
    [self dismissdeliveryTimeChooseWholeView];
}

-(void)dismissdeliveryTimeChooseWholeView{
    [UIView animateWithDuration:0.3 animations:^{
        deliveryTimeChooseWholeView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [deliveryTimeChooseWholeView removeFromSuperview];
    }];
}

-(void)deliveryTimeChooseWholeViewTap{
    [self dismissdeliveryTimeChooseWholeView];
}

#pragma mark - 优惠券信息展示视图
-(void)showVoucherChooseWholeView{
    if (!voucherChooseWholeView) {
        voucherChooseWholeView = [[UIView alloc] init];
        voucherChooseWholeView.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT};
        voucherChooseWholeView.backgroundColor = RGBAColor(50, 50, 50, 0.5);
        
        UITapGestureRecognizer *voucherChoosedWholeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voucherChooseWholeViewTap)];
        [voucherChooseWholeView addGestureRecognizer:voucherChoosedWholeViewTap];
        
        float voucherChooseWholeViewEveryButtonHeight = 40;
        if (IS4_7Inches()) {
            voucherChooseWholeViewEveryButtonHeight = 45;
        }else if (IS5_5Inches()){
            voucherChooseWholeViewEveryButtonHeight = 45;
        }
        
        UIView *voucherChooseView = [[UIView alloc] init];
        voucherChooseView.frame = (CGRect){20,(HEIGHT(voucherChooseWholeView)-voucherChooseWholeViewEveryButtonHeight*8)/2,(WIDTH(voucherChooseWholeView)-40),voucherChooseWholeViewEveryButtonHeight*8};
        voucherChooseView.backgroundColor = RGBColor(253, 253, 253);
        voucherChooseView.layer.cornerRadius = 4.f;
        voucherChooseView.layer.masksToBounds = YES;
        [voucherChooseWholeView addSubview:voucherChooseView];
        
        UILabel *voucherChooseTitleLabel = [[UILabel alloc] init];
        voucherChooseTitleLabel.frame = (CGRect){0,0,WIDTH(voucherChooseView),voucherChooseWholeViewEveryButtonHeight};
        voucherChooseTitleLabel.backgroundColor = RGBColor(210, 210, 210);
        voucherChooseTitleLabel.text = @"请选择代金券";
        voucherChooseTitleLabel.textColor = RGBColor(50, 50, 50);
        voucherChooseTitleLabel.textAlignment = NSTextAlignmentCenter;
        voucherChooseTitleLabel.userInteractionEnabled = YES;
        [voucherChooseView addSubview:voucherChooseTitleLabel];
        
        UIView *voucherChooseTitleSepline = [[UIView alloc] init];
        voucherChooseTitleSepline.frame = (CGRect){0,HEIGHT(voucherChooseTitleLabel)-0.5,WIDTH(voucherChooseTitleLabel),0.5};
        voucherChooseTitleSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [voucherChooseTitleLabel addSubview:voucherChooseTitleSepline];
        
        
        int line = (int)allUnUsedVoucherArray.count;
        if (line == 0) {
            UIButton *voncherSelectButton = [[UIButton alloc] init];
            voncherSelectButton.frame = (CGRect){0,voucherChooseWholeViewEveryButtonHeight,WIDTH(voucherChooseView),voucherChooseWholeViewEveryButtonHeight};
            [voncherSelectButton setTitle:@"暂无优惠券信息" forState:UIControlStateNormal];
            [voncherSelectButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
            voncherSelectButton.titleLabel.font = Font(16);
            
            [voucherChooseView addSubview:voncherSelectButton];
            
            UIView *deliveryTimeChooseButtonSepline = [[UIView alloc] init];
            deliveryTimeChooseButtonSepline.frame = (CGRect){0,HEIGHT(voncherSelectButton)-0.5,WIDTH(voncherSelectButton),0.5};
            deliveryTimeChooseButtonSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [voncherSelectButton addSubview:deliveryTimeChooseButtonSepline];
            voucherChooseImageView.alpha = 0.f;
        }else{
            UIButton *voncherNoSelectButton = [[UIButton alloc] init];
            voncherNoSelectButton.frame = (CGRect){0,voucherChooseWholeViewEveryButtonHeight,WIDTH(voucherChooseView),voucherChooseWholeViewEveryButtonHeight};
            [voncherNoSelectButton setTitle:@"不使用" forState:UIControlStateNormal];
            [voncherNoSelectButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
            voncherNoSelectButton.titleLabel.font = Font(16);
            voncherNoSelectButton.tag = 10000;
            [voucherChooseView addSubview:voncherNoSelectButton];
            [voncherNoSelectButton addTarget:self action:@selector(voncherSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *deliveryTimeChooseButtonSepline = [[UIView alloc] init];
            deliveryTimeChooseButtonSepline.frame = (CGRect){0,HEIGHT(voncherNoSelectButton)-0.5,WIDTH(voncherNoSelectButton),0.5};
            deliveryTimeChooseButtonSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [voncherNoSelectButton addSubview:deliveryTimeChooseButtonSepline];
            
            
            for (int i = 0; i < line; i++) {
                NSDictionary *voucherDic = allUnUsedVoucherArray[i];
                UIButton *voncherSelectButton = [[UIButton alloc] init];
                voncherSelectButton.frame = (CGRect){0,(i+2)*voucherChooseWholeViewEveryButtonHeight,WIDTH(voucherChooseView),voucherChooseWholeViewEveryButtonHeight};
                voncherSelectButton.tag = i+1;
                [voncherSelectButton setTitle:[NSString stringWithFormat:@"%d元代金券",[voucherDic[@"number"] intValue]] forState:UIControlStateNormal];
                [voncherSelectButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
                voncherSelectButton.titleLabel.font = Font(16);
                [voncherSelectButton addTarget:self action:@selector(voncherSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [voucherChooseView addSubview:voncherSelectButton];
                
                UIView *deliveryTimeChooseButtonSepline = [[UIView alloc] init];
                deliveryTimeChooseButtonSepline.frame = (CGRect){0,HEIGHT(voncherSelectButton)-0.5,WIDTH(voncherSelectButton),0.5};
                deliveryTimeChooseButtonSepline.backgroundColor = RGBAColor(200, 200, 200, 0.5);
                [voncherSelectButton addSubview:deliveryTimeChooseButtonSepline];
            }
            
            voucherChooseImageView = [[UIImageView alloc] init];
            voucherChooseImageView.alpha = 0.f;
            voucherChooseImageView.image = [UIImage imageNamed:@"selected"];
            [voucherChooseView addSubview:voucherChooseImageView];
        }
    }
    voucherChooseWholeView.alpha = 0;
    [MainWindow addSubview:voucherChooseWholeView];
    [UIView animateWithDuration:0.3 animations:^{
        voucherChooseWholeView.alpha = 1;
    }];
}

-(void)dismissVoucherChoosedWholeView{
    [UIView animateWithDuration:0.3 animations:^{
        voucherChooseWholeView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [voucherChooseWholeView removeFromSuperview];
    }];
}

-(void)voucherChooseWholeViewTap{
    [self dismissVoucherChoosedWholeView];
}

-(void)voncherSelectButtonClick:(UIButton *)button{
    int line = (int)allUnUsedVoucherArray.count;
    int buttonTag = (int)button.tag;
    if (line == 0 || buttonTag == 10000) {
        
        voucherChooseImageView.alpha = 0.f;
        voucherChooseImageView.image = [UIImage imageNamed:@"unselected"];
        voucherPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
        
        voucherPayCode = nil;
        
        [self reCalcOrderInfo];
        [self dismissVoucherChoosedWholeView];
    }else{
        
        voucherChooseImageView.frame = (CGRect){WIDTH(button)-20-22,(buttonTag+1)*HEIGHT(button)+(HEIGHT(button)-22)/2,22,22};
        
        NSDictionary *voucherSelectDic = allUnUsedVoucherArray[buttonTag-1];
        
        voucherChooseImageView.alpha = 1.f;
        voucherChooseImageView.image = [UIImage imageNamed:@"selected"];
        voucherPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
        
        voucherPayCode = voucherSelectDic[@"seril"];
        [self reCalcOrderInfo];
        [self dismissVoucherChoosedWholeView];
    }
}

#pragma mark - 订单重新计算价格
-(void)setOrderVoncherLabelNum:(float)num{
    NSString *voncherMoneyTmpString;
    int voncherMoneyTmpNum = (int)(num*10) - ((int)num)*10;
    if (voncherMoneyTmpNum == 0) {
        voncherMoneyTmpString = [NSString stringWithFormat:@"%d",(int)num];
    }else{
        voncherMoneyTmpString = [NSString stringWithFormat:@"%.1f",num];
    }
    orderVoncherCountNumberLabel.text = [NSString stringWithFormat:@"代金券总计：-￥%@",voncherMoneyTmpString];
}

-(void)setOrderYUELabelNum:(float)num{
    NSString *voncherMoneyTmpString;
    int voncherMoneyTmpNum = (int)(num*10) - ((int)num)*10;
    if (voncherMoneyTmpNum == 0) {
        voncherMoneyTmpString = [NSString stringWithFormat:@"%d",(int)num];
    }else{
        voncherMoneyTmpString = [NSString stringWithFormat:@"%.1f",num];
    }
    orderUnionYUECountNumberLabel.text = [NSString stringWithFormat:@"余额抵扣：-￥%@",voncherMoneyTmpString];
}

-(void)setOrderNeedToPayNum:(float)num{
    NSMutableAttributedString *attriString;
    if ((num*10)-((int)num)*10 == 0) {
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付金额：￥%d",(int)num]];
    }else{
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付金额：￥%.1f",num]];
    }
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:80.f/255 green:80.f/255 blue:80.f/255 alpha:1]
                        range:NSMakeRange(0, 5)];
    UIColor *red = UN_RedColor;
    
    
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:red
                        range:NSMakeRange(5, attriString.length-5)];
    bottomOrderNeedToPayNumLabel.attributedText = attriString;
}

#pragma mark - 提交订单
-(void)orderComfirmButtonClick:(UIButton *)button{
    if (isOrderNeedToPay) {
        if (payType == OrderPaymentTypeNone) {
            [BYToastView showToastWithMessage:@"订单还需支付金额,请选择支付方式"];
            return;
        }
    }
    if (!isCalcOrderInfo) {
        [BYToastView showToastWithMessage:@"正在计算订单中,请稍候"];
        return;
    }
    if (!self.orderInfo.deliveryTime || [[self.orderInfo.deliveryTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"订单配送时间未选择"];
        return;
    }
    if (!orderAddress) {
        [BYToastView showToastWithMessage:@"订单配送地址不能为空"];
        return;
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:orderAddress.addressID forKey:@"receiver_id"];
    [paramsDic setObject:self.orderInfo.orderID forKey:@"cart_id"];
    [paramsDic setObject:self.orderInfo.shopID forKey:@"brand_id"];
    if (!self.orderInfo.deliveryNote) {
        self.orderInfo.deliveryNote = @"";
    }
    [paramsDic setObject:self.orderInfo.deliveryNote forKey:@"memo"];
    
    [paramsDic setObject:self.orderInfo.deliveryTime forKey:@"delivery_time"];
    if (payType == OrderPaymentTypeAli) {
        [paramsDic setObject:@"alipayDirectPlugin" forKey:@"paymentPluginId"];
    }else if(payType == OrderPaymentTypeWechat){
        [paramsDic setObject:@"wxpayPlugin" forKey:@"paymentPluginId"];
    }else{
        [BYToastView showToastWithMessage:@"未知的支付方式"];
        return;
    }
    
    [paramsDic setObject:@(isFaPiaoNeed) forKey:@"isInvoice"];
    if (faPiaoTitle) {
        [paramsDic setObject:faPiaoTitle forKey:@"invoiceTitle"];
    }
    [paramsDic setObject:@(isUnionPayChoosed) forKey:@"useBalance"];
    if (voucherPayCode) {
        [paramsDic setObject:voucherPayCode forKey:@"code"];
    }
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(MainWindow),HEIGHT(MainWindow)};
    [MainWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"获取订单信息";
    [indicatorView startAnimating];
    
    [UNUrlConnection submitOrderWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [indicatorView stopAnimating:YES];
            [BYToastView showToastWithMessage:errorString];
            if (isOrederCreated) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重复创建订单" message:@"订单重复创建,请返回我的列表支付!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去支付", nil];
                alert.tag = 100010;
                [alert show];
                return;
            }
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            isOrederCreated = YES;
            NSDictionary *contentDictionary = resultDic[@"content"];
            //            NSString *requestCharset = contentDictionary[@"requestCharset"];
            //            NSString *requestMethod = contentDictionary[@"requestMethod"];
            //            NSString *requestUrl = contentDictionary[@"requestUrl"];
            NSString *sn = contentDictionary[@"sn"];
            if (!sn) {
                [BYToastView showToastWithMessage:@"订单支付号错误,请稍候再试"];
                [indicatorView stopAnimating:YES];
                return;
            }
            
            self.orderInfo.orderSN = sn;
            
            NSDictionary *payParamsDic = contentDictionary[@"payParameter"];
            
            float totalFee = [payParamsDic[@"total_fee"] floatValue];
            //totalFee 是以元为单位的 在alipay中不需要转换 在微信中是以分为单位的 需要转换
            
            
            
            //            NSString *trade_no = payParamsDic[@"out_trade_no"];
            //            NSString *notifyUrl = payParamsDic[@"notify_url"];
            //            NSString *nonceStr2 = payParamsDic[@"nonce_str"];
            
            payClientBackNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UN_OrderDidSendToPayClientBackNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                if ([[note object] boolValue]) {
                    [self getSelfOrderDetail];
                }else{
                    [BYToastView showToastWithMessage:@"支付失败,跳转订单列表"];
                    [self jumpToOrderList];
                }
                [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotification];
            }];
            
            if (payType == OrderPaymentTypeAli) {
                //ceshi  sn  @"20161877121"
                //todo test
                totalFee = 0.01;
                [UNUrlConnection alipayPayWithMoneyYuan:totalFee orderSN:sn complete:^(NSDictionary *result) {
                    
                    [(AppDelegate *)[UIApplication sharedApplication].delegate
                     handleAliPayCallBackWithResult:result];
                }];
                return;
            }else if (payType == OrderPaymentTypeWechat){
                /**
                 *  todo 替换成 微信支付
                 */
                //todo test
                totalFee = 1;
                
                [UNUrlConnection wechatPrePayWithMoneyFen:1 orderSN:self.orderInfo.orderSN complete:^(NSDictionary *resultDic, NSString *errorString) {
                    //todo  接入微信需要在流程控制中加入下一句
                    [indicatorView stopAnimating:YES];
                    if (errorString) {
                        [BYToastView showToastWithMessage:errorString];
                        return;
                    }
                    if (!resultDic) {
                        [BYToastView showToastWithMessage:@"服务器错误,支付失败"];
                        return;
                    }
                    NSString *appid = resultDic[@"appid"];
                    NSString *nonceStr = resultDic[@"nonceStr"];
                    NSString *prepay_id = resultDic[@"prepay_id"];
                    NSString *sign = resultDic[@"sign"];
                    int timeStamp = [resultDic[@"timeStamp"] intValue];
                    NSString *package = @"Sign=WXPay";
                    //商户id
                    NSString *mch_id = @"1299787201";
                    
                    if (!appid || [appid isEqualToString:@""] ||
                        !nonceStr || [nonceStr isEqualToString:@""] ||
                        !prepay_id || [prepay_id isEqualToString:@""] ||
                        !sign || [sign isEqualToString:@""]) {
                        [BYToastView showToastWithMessage:@"支付参数错误,支付失败"];
                        return;
                    }
                    //调起微信支付
                    PayReq* req = [[PayReq alloc] init];
                    req.partnerId = mch_id;
                    req.prepayId = prepay_id;
                    req.nonceStr = nonceStr;
                    req.timeStamp = timeStamp;
                    req.package = package;
                    //                    req.sign = sign;
                    
                    DataMD5 *md5 = [[DataMD5 alloc] init];
                    req.sign=[md5 createMD5SingForPay:@"wxf211b52729d06b91" partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    /**
                     *  todo 发起微信支付后只有一个确定按钮 
                     */
                }];
            }
            //测试支付接口
            //            [UNUrlConnection orderPayWithPayTradeSN:trade_no complete:^(NSString *stateString) {
            //                [BYToastView showToastWithMessage:stateString];
            //                [indicatorView stopAnimating:YES];
            //                if (stateString && [stateString isEqualToString:@"支付成功"]) {
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        [self.navigationController popToRootViewControllerAnimated:YES];
            //                        [[NSNotificationCenter defaultCenter] postNotificationName:UN_DidSelectTabControllernotification object:@(2)];
            //                    });
            //                }
            //            }];
        }else{
            [indicatorView stopAnimating:YES];
            isOrederCreated = NO;
            NSString *contentString = messageDic[@"content"];
            if (!contentString) {
                contentString = @"获取支付信息失败,请稍候再试";
            }
            [BYToastView showToastWithMessage:@"获取支付信息失败,请稍候再试"];
        }
    }];
}

-(void)getSelfOrderDetail{
    NSString *orderSn = self.orderInfo.orderSN;
    if (!orderSn || [orderSn isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"订单错误,请稍候再试"];
        [indicatorView stopAnimating:YES];
        return;
    }
    dispatch_async(dispatch_queue_create("getSelfOrderDetail", nil), ^{
        sleep(3);
        [UNUrlConnection getOrderDetailWithOrderSN:orderSn complete:^(NSDictionary *resultDic, NSString *errorString) {
            [indicatorView stopAnimating:YES];
            NSLog(@"getOrderDetailWithOrderSN:%@ \n,result:%@,\nerror:%@",orderSn,resultDic,errorString);
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *contentsDic = resultDic[@"content"];
            
            if (contentsDic && [contentsDic isKindOfClass:[NSDictionary class]] && contentsDic.count > 0) {
                
                OrderInfo *orderInfo = [OrderInfo orderInfoWithNetworkDictionary:contentsDic];
                
                self.orderInfo = orderInfo;
                /**
                 OrderInfoOrderPaymentStateUnPaid,           //未支付
                 OrderInfoOrderPaymentStatePartialPayment,   //部分支付
                 OrderInfoOrderPaymentStatePaid,             //已支付
                 OrderInfoOrderPaymentStatePartialRefunds,   //部分退款
                 OrderInfoOrderPaymentStateRefunded,         //已退款
                 */
                //remove自己
                [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotification];
                
                if (self.orderInfo.paymentStatus == OrderInfoOrderPaymentStatePaid) {
                    [BYToastView showToastWithMessage:@"支付成功"];
                    [self jumpToOrderDetail];
                }else{
                    [BYToastView showToastWithMessage:@"出现错误,跳转订单列表"];
                    [self jumpToOrderList];
                }
            }
        }];
    });
}

-(void)jumpToOrderDetail{
    [indicatorView stopAnimating:YES];
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [array removeObjectAtIndex:array.count-1];
    
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.orderInfo = self.orderInfo;
    [array addObject:orderDetailVC];
    [self.navigationController setViewControllers:array animated:YES];
    
}

-(void)jumpToOrderList{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicatorView stopAnimating:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_DidSelectTabControllernotification object:@(2)];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100010) {
        if (buttonIndex == 1) {
            [self jumpToOrderList];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - @property noteMessage
-(void)setNoteMessage:(NSString *)noteMessage{
    _noteMessage = noteMessage;
    if (!_noteMessage || [noteMessage isEqualToString:@""]) {
        orderDeliveryNoteLabel.text = @"请输入";
        self.orderInfo.deliveryNote = @"";
    }else{
        orderDeliveryNoteLabel.text = noteMessage;
        self.orderInfo.deliveryNote = noteMessage;
    }
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
    [super viewWillAppear:animated];
    [self setUpNavigation];
    if (!orderAddress) {
        [self setDefaultAddressInfo];
    }else{
        [self setOrderAddress:orderAddress];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
