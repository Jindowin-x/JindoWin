//
//  MyChargeViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/27.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyChargeViewController.h"
#import "UNUrlConnection.h"
#import "UNTools.h"

@interface MyChargeViewController ()

@end

@implementation MyChargeViewController{
    UIScrollView *contentView;
    
    UITextField *chargeNumTextField;
    
    UIImageView *aliPaymentSelectImageView;
    UIImageView *wechatPaymentSelectImageView;
    
    OrderPaymentType payType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"充值";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    float offset = 20.f;
    
    UIView *lineSepHorView1 = [[UIView alloc] init];
    lineSepHorView1.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    lineSepHorView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView1];
    
    UIView *chargeNumberView = [[UIView alloc] init];
    chargeNumberView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    chargeNumberView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:chargeNumberView];
    
    UILabel *chargeNumNoteLabel = [[UILabel alloc] init];
    chargeNumNoteLabel.frame = (CGRect){20,0,70,HEIGHT(chargeNumberView)};
    chargeNumNoteLabel.text = @"充值金额:";
    chargeNumNoteLabel.font = Font(14);
    chargeNumNoteLabel.textColor = RGBColor(80, 80, 80);
    chargeNumNoteLabel.textAlignment = NSTextAlignmentLeft;
    [chargeNumberView addSubview:chargeNumNoteLabel];
    
    chargeNumTextField = [[UITextField alloc] init];
    chargeNumTextField.frame = (CGRect){100,0,(WIDTH(chargeNumberView)-100-10),HEIGHT(chargeNumberView)};
    chargeNumTextField.textColor = RGBColor(100, 100, 100);
    chargeNumTextField.font = Font(15);
    chargeNumTextField.tag = 100;
    chargeNumTextField.returnKeyType = UIReturnKeyDone;
    [chargeNumTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [chargeNumTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    chargeNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    chargeNumTextField.placeholder = @"请输入充值金额";
    [chargeNumberView addSubview:chargeNumTextField];
    
    offset += HEIGHT(chargeNumberView);
    
    UIView *lineSepHorView2 = [[UIView alloc] init];
    lineSepHorView2.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    lineSepHorView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView2];
    
    
    offset += 20;
    
    float noteLabelHeight = 20;
    
    UIView *paymentView = [[UIView alloc] init];
    paymentView.frame = (CGRect){0,offset,WIDTH(contentView),noteLabelHeight+40*2};
    paymentView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:paymentView];
    
    UILabel *paymentNoteLabel = [[UILabel alloc] init];
    paymentNoteLabel.frame = (CGRect){0,0,WIDTH(paymentView),noteLabelHeight};
    paymentNoteLabel.backgroundColor = RGBColor(235, 235, 235);
    paymentNoteLabel.text = @"   选择支付方式";
    paymentNoteLabel.textColor = RGBColor(50, 50, 50);
    paymentNoteLabel.font = Font(12);
    [paymentView addSubview:paymentNoteLabel];
    
    UIButton *aliPayButton = [[UIButton alloc] init];
    aliPayButton.frame = (CGRect){0,noteLabelHeight+40*0,WIDTH(paymentView),40};
    aliPayButton.backgroundColor = RGBColor(253, 253, 253);
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
    aliPaymentLabel.text = @"支付宝充值";
    [aliPayButton addSubview:aliPaymentLabel];
    
    UIView *aliPaymentSepLineView = [[UIView alloc] init];
    aliPaymentSepLineView.frame = (CGRect){0,HEIGHT(aliPayButton)-0.5,WIDTH(aliPayButton),0.5};
    aliPaymentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [aliPayButton addSubview:aliPaymentSepLineView];
    
    UIButton *wechatPayButton = [[UIButton alloc] init];
    wechatPayButton.frame = (CGRect){0,noteLabelHeight+40*1,WIDTH(paymentView),40};
    wechatPayButton.backgroundColor = RGBColor(253, 253, 253);
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
    wechatPaymentLabel.text = @"微信充值";
    [wechatPayButton addSubview:wechatPaymentLabel];
    
    UIView *wechatmentSepLineView = [[UIView alloc] init];
    wechatmentSepLineView.frame = (CGRect){0,HEIGHT(wechatPayButton)-0.5,WIDTH(wechatPayButton),0.5};
    wechatmentSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [wechatPayButton addSubview:wechatmentSepLineView];
    
    offset += HEIGHT(paymentView);
    
    payType = OrderPaymentTypeNone;
    
    
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    comfirmButton.frame = (CGRect){20,offset+30,WIDTH(contentView)-20*2,40};
    comfirmButton.backgroundColor = UN_RedColor;
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = Font(16);
    [comfirmButton setTitle:@"充值" forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    comfirmButton.layer.cornerRadius = 2.f;
    comfirmButton.layer.masksToBounds = YES;
    [contentView addSubview:comfirmButton];
}

-(void)paymentGatewayChanged:(UIButton *)button{
    int tag = (int)button.tag;
    if (tag == 2) {
        aliPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
        wechatPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
        
        payType = OrderPaymentTypeAli;
    }else if (tag == 3){
        aliPaymentSelectImageView.image = [UIImage imageNamed:@"unselected"];
        wechatPaymentSelectImageView.image = [UIImage imageNamed:@"selected"];
        
        payType = OrderPaymentTypeWechat;
    }
}

-(void)comfirmButtonClick{
    [chargeNumTextField resignFirstResponder];
    
    NSString *numberString = chargeNumTextField.text;
    if ([[numberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"不能输入非数字的字符"];
        return;
    }
    if (![UNTools isNotZeroMoneyNumber:numberString]) {
        [BYToastView showToastWithMessage:@"充值金额必须是非0的正整数"];
        return;
    }
    
    if (payType ==OrderPaymentTypeNone) {
        [BYToastView showToastWithMessage:@"必须选择一种充值方式"];
        return;
    }
    
    NSString *payString;
    if (payType == OrderPaymentTypeAli) {
        payString = @"支付宝充值";
    }else if (payType == OrderPaymentTypeWechat){
        payString = @"微信充值";
    }
    if(!payString){
        [BYToastView showToastWithMessage:@"未知的支付方式"];
        return;
    }
    int number = [numberString intValue];
    if (number <= 0) {
        [BYToastView showToastWithMessage:@"充值金额必须是非0的正整数"];
        return;
    }
    
    NSString *alertMessage = [NSString stringWithFormat:@"确定使用%@ ¥%d元吗?",payString,number];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值确认" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 90010;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 90010) {
        if (buttonIndex == 1) {
            [self chargeNoQuestion];
        }
    }
}

-(void)chargeNoQuestion{
    int number = [chargeNumTextField.text intValue];
    if (number <= 0) {
        [BYToastView showToastWithMessage:@"充值金额必须是非0的正整数"];
        return;
    }
    NSString *paymentPluginName;
    if (payType == OrderPaymentTypeAli) {
        paymentPluginName = @"alipayDirectPlugin";
    }else if (payType == OrderPaymentTypeWechat){
        paymentPluginName = @"wxpayPlugin";
    }else{
        [BYToastView showToastWithMessage:@"未知的充值方式"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(number) forKey:@"amount"];
    [params setObject:paymentPluginName forKey:@"paymentPluginId"];
    
    [UNUrlConnection chargeWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        /**
         *  todo 接入支付宝 和微信
         */
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
