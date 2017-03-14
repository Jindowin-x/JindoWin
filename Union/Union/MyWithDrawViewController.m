//
//  MyWithDrawViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/27.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyWithDrawViewController.h"
#import "UNTools.h"
#import "UNUrlConnection.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface MyWithDrawViewController ()

@end

@implementation MyWithDrawViewController{
    TPKeyboardAvoidingScrollView *contentView;
    
    UITextField *withDrawNumTextField;
    UILabel *canWithDrawNumLabel;
    
    UITextField *bankNameTextField;
    UITextField *bankCardNumTextField;
    UITextField *bankCardUserTextField;
    UITextField *bankCardPhoneTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提现";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    float offset = 20.f;
    
    UILabel *canWithDrawNumNoteLabel = [[UILabel alloc] init];
    canWithDrawNumNoteLabel.frame = (CGRect){20,offset,90,15};
    canWithDrawNumNoteLabel.text = @"可提现金额为:";
    canWithDrawNumNoteLabel.font = Font(14);
    canWithDrawNumNoteLabel.textColor = RGBColor(80, 80, 80);
    canWithDrawNumNoteLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:canWithDrawNumNoteLabel];
    
    canWithDrawNumLabel = [[UILabel alloc] init];
    canWithDrawNumLabel.frame = (CGRect){RIGHT(canWithDrawNumNoteLabel)+5,offset-1,190,15+2};
    
    canWithDrawNumLabel.font = Font(15);
    canWithDrawNumLabel.textColor = UN_RedColor;
    canWithDrawNumLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:canWithDrawNumLabel];
    
    NSString *yueLabelString;
    if ((self.cashRemain*10)-((int)self.cashRemain)*10 == 0) {
        yueLabelString = [NSString stringWithFormat:@"￥%d",(int)self.cashRemain];
    }else{
        yueLabelString = [NSString stringWithFormat:@"￥%.1f",self.cashRemain];
    }
    canWithDrawNumLabel.text = yueLabelString;
    
    offset += HEIGHT(canWithDrawNumNoteLabel);
    
    offset += 20;
    
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
    chargeNumNoteLabel.text = @"提现金额:";
    chargeNumNoteLabel.font = Font(14);
    chargeNumNoteLabel.textColor = RGBColor(80, 80, 80);
    chargeNumNoteLabel.textAlignment = NSTextAlignmentLeft;
    [chargeNumberView addSubview:chargeNumNoteLabel];
    
    withDrawNumTextField = [[UITextField alloc] init];
    withDrawNumTextField.frame = (CGRect){95,0,(WIDTH(chargeNumberView)-95-10),HEIGHT(chargeNumberView)};
    withDrawNumTextField.textColor = RGBColor(100, 100, 100);
    withDrawNumTextField.font = Font(15);
    withDrawNumTextField.tag = 100;
    withDrawNumTextField.returnKeyType = UIReturnKeyDone;
    [withDrawNumTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawNumTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    withDrawNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    withDrawNumTextField.placeholder = @"请输入提现金额";
    [chargeNumberView addSubview:withDrawNumTextField];
    
    offset += HEIGHT(chargeNumberView);
    
    UIView *lineSepHorView2 = [[UIView alloc] init];
    lineSepHorView2.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    lineSepHorView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView2];
    
    float noteLabelHeight = 20;
    
    UIView *withDrawCardView = [[UIView alloc] init];
    withDrawCardView.frame = (CGRect){0,offset,WIDTH(contentView),noteLabelHeight+40*2};
    withDrawCardView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:withDrawCardView];
    
    UILabel *withDrawNoteLabel = [[UILabel alloc] init];
    withDrawNoteLabel.frame = (CGRect){0,0,WIDTH(withDrawCardView),noteLabelHeight};
    withDrawNoteLabel.backgroundColor = RGBColor(235, 235, 235);
    withDrawNoteLabel.text = @"   提现信息";
    withDrawNoteLabel.textColor = RGBColor(50, 50, 50);
    withDrawNoteLabel.font = Font(12);
    [withDrawCardView addSubview:withDrawNoteLabel];
    
    offset += HEIGHT(withDrawNoteLabel);
    
    UIView *lineSepHorView3 = [[UIView alloc] init];
    lineSepHorView3.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    lineSepHorView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView3];
    
    UIView *bankNameView = [[UIView alloc] init];
    bankNameView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    bankNameView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:bankNameView];
    
    UILabel *bankNumNoteLabel = [[UILabel alloc] init];
    bankNumNoteLabel.frame = (CGRect){20,0,70,HEIGHT(bankNameView)};
    bankNumNoteLabel.text = @"开户银行:";
    bankNumNoteLabel.font = Font(14);
    bankNumNoteLabel.textColor = RGBColor(80, 80, 80);
    bankNumNoteLabel.textAlignment = NSTextAlignmentLeft;
    [bankNameView addSubview:bankNumNoteLabel];
    
    bankNameTextField = [[UITextField alloc] init];
    bankNameTextField.frame = (CGRect){95,0,(WIDTH(bankNameView)-95-10),HEIGHT(bankNameView)};
    bankNameTextField.textColor = RGBColor(100, 100, 100);
    bankNameTextField.font = Font(15);
    bankNameTextField.tag = 101;
    bankNameTextField.returnKeyType = UIReturnKeyDone;
    [bankNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [bankNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    bankNameTextField.keyboardType = UIKeyboardTypeDefault;
    bankNameTextField.placeholder = @"银行全称,如:中国农业银行";
    [bankNameView addSubview:bankNameTextField];
    
    offset += HEIGHT(bankNameView);
    
    UIView *lineSepHorView4 = [[UIView alloc] init];
    lineSepHorView4.frame = (CGRect){20,offset-0.5,WIDTH(contentView)-20,0.5};
    lineSepHorView4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView4];
    
    UIView *bankCardNumView = [[UIView alloc] init];
    bankCardNumView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    bankCardNumView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:bankCardNumView];
    
    UILabel *bankCardNumNoteLabel = [[UILabel alloc] init];
    bankCardNumNoteLabel.frame = (CGRect){20,0,70,HEIGHT(bankCardNumView)};
    bankCardNumNoteLabel.text = @"银行卡号:";
    bankCardNumNoteLabel.font = Font(14);
    bankCardNumNoteLabel.textColor = RGBColor(80, 80, 80);
    bankCardNumNoteLabel.textAlignment = NSTextAlignmentLeft;
    [bankCardNumView addSubview:bankCardNumNoteLabel];
    
    bankCardNumTextField = [[UITextField alloc] init];
    bankCardNumTextField.frame = (CGRect){95,0,(WIDTH(bankCardNumView)-95-10),HEIGHT(bankCardNumView)};
    bankCardNumTextField.textColor = RGBColor(100, 100, 100);
    bankCardNumTextField.font = Font(15);
    bankCardNumTextField.tag = 102;
    bankCardNumTextField.returnKeyType = UIReturnKeyDone;
    [bankCardNumTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [bankCardNumTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    bankCardNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    bankCardNumTextField.placeholder = @"银行卡号,可以使用空格";
    [bankCardNumView addSubview:bankCardNumTextField];
    
    offset += HEIGHT(bankCardNumView);
    
    UIView *lineSepHorView5 = [[UIView alloc] init];
    lineSepHorView5.frame = (CGRect){20,offset-0.5,WIDTH(contentView)-20,0.5};
    lineSepHorView5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView5];
    
    
    UIView *bankCardUserView = [[UIView alloc] init];
    bankCardUserView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    bankCardUserView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:bankCardUserView];
    
    UILabel *bankCardUserNoteLabel = [[UILabel alloc] init];
    bankCardUserNoteLabel.frame = (CGRect){20,0,70,HEIGHT(bankCardUserView)};
    bankCardUserNoteLabel.text = @"持卡人名:";
    bankCardUserNoteLabel.font = Font(14);
    bankCardUserNoteLabel.textColor = RGBColor(80, 80, 80);
    bankCardUserNoteLabel.textAlignment = NSTextAlignmentLeft;
    [bankCardUserView addSubview:bankCardUserNoteLabel];
    
    bankCardUserTextField = [[UITextField alloc] init];
    bankCardUserTextField.frame = (CGRect){95,0,(WIDTH(bankCardUserView)-95-10),HEIGHT(bankCardUserView)};
    bankCardUserTextField.textColor = RGBColor(100, 100, 100);
    bankCardUserTextField.font = Font(15);
    bankCardUserTextField.tag = 103;
    bankCardUserTextField.returnKeyType = UIReturnKeyDone;
    [bankCardUserTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [bankCardUserTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    bankCardUserTextField.keyboardType = UIKeyboardTypeDefault;
    bankCardUserTextField.placeholder = @"持卡人姓名";
    [bankCardUserView addSubview:bankCardUserTextField];
    
    offset += HEIGHT(bankCardUserView);
    
    UIView *lineSepHorView6 = [[UIView alloc] init];
    lineSepHorView6.frame = (CGRect){20,offset-0.5,WIDTH(contentView)-20,0.5};
    lineSepHorView6.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView6];
    
    UIView *bankCardPhoneView = [[UIView alloc] init];
    bankCardPhoneView.frame = (CGRect){0,offset,WIDTH(contentView),40};
    bankCardPhoneView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:bankCardPhoneView];
    
    UILabel *bankCardPhoneNoteLabel = [[UILabel alloc] init];
    bankCardPhoneNoteLabel.frame = (CGRect){20,0,70,HEIGHT(bankCardPhoneView)};
    bankCardPhoneNoteLabel.text = @"预留号码:";
    bankCardPhoneNoteLabel.font = Font(14);
    bankCardPhoneNoteLabel.textColor = RGBColor(80, 80, 80);
    bankCardPhoneNoteLabel.textAlignment = NSTextAlignmentLeft;
    [bankCardPhoneView addSubview:bankCardPhoneNoteLabel];
    
    bankCardPhoneTextField = [[UITextField alloc] init];
    bankCardPhoneTextField.frame = (CGRect){95,0,(WIDTH(bankCardPhoneView)-95-10),HEIGHT(bankCardPhoneView)};
    bankCardPhoneTextField.textColor = RGBColor(100, 100, 100);
    bankCardPhoneTextField.font = Font(15);
    bankCardPhoneTextField.tag = 104;
    bankCardPhoneTextField.returnKeyType = UIReturnKeyDone;
    [bankCardPhoneTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [bankCardPhoneTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    bankCardPhoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    bankCardPhoneTextField.placeholder = @"银行预留手机号码";
    [bankCardPhoneView addSubview:bankCardPhoneTextField];
    
    offset += HEIGHT(bankCardPhoneView);
    
    UIView *lineSepHorView7 = [[UIView alloc] init];
    lineSepHorView7.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    lineSepHorView7.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepHorView7];
    
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    comfirmButton.frame = (CGRect){20,offset+30,WIDTH(contentView)-20*2,40};
    comfirmButton.backgroundColor = UN_RedColor;
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = Font(16);
    [comfirmButton setTitle:@"提现" forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    comfirmButton.layer.cornerRadius = 2.f;
    comfirmButton.layer.masksToBounds = YES;
    [contentView addSubview:comfirmButton];
    
    
    //    if (self.cashRemain == 0.f) {
    //        [BYToastView showToastWithMessage:@"余额为0,不能提现"];
    //        withDrawNumTextField.enabled = NO;
    //        bankNameTextField.enabled = NO;
    //        bankCardNumTextField.enabled = NO;
    //        bankCardUserTextField.enabled = NO;
    //        bankCardPhoneTextField.enabled = NO;
    //    }else
    //    {
    //        
    //    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        UITextField *tf = [note object];
        if (tf.tag == 100) {
            float value = [tf.text floatValue];
            if (value > self.cashRemain) {
                [BYToastView showToastWithMessage:@"不能超过最大提现余额"];
                tf.text = [NSString stringWithFormat:@"%d",(int)self.cashRemain];
            }
        }
    }];
}

-(void)comfirmButtonClick{
    [self resignAllInputs];
    float withDrawNum = [withDrawNumTextField.text floatValue];
    if (withDrawNum > self.cashRemain) {
        [BYToastView showToastWithMessage:@"不能超过最大提现余额"];
        withDrawNumTextField.text = [NSString stringWithFormat:@"%d",(int)self.cashRemain];
        return;
    }
    
    NSString *bankName = bankNameTextField.text;
    if (!bankName || [bankName rangeOfString:@"*"].length != 0 ||
        [bankName rangeOfString:@"|"].length != 0 ||
        [bankName rangeOfString:@" "].length != 0 ) {
        [BYToastView showToastWithMessage:@"开户银行名称不能包含特殊字符"];
        [bankNameTextField resignFirstResponder];
        return;
    }
    
    NSString *bankCardNumberString = bankCardNumTextField.text;
    bankCardNumberString = [bankCardNumberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([bankCardNumberString rangeOfString:@"."].length != 0) {
        [BYToastView showToastWithMessage:@"银行卡号不能包含特殊字符"];
        return;
    }
    if (![UNTools isNotZeroMoneyNumber:bankCardNumberString]) {
        [BYToastView showToastWithMessage:@"银行卡号格式错误"];
        return;
    }
    
    
    NSString *bankCardUser = bankCardUserTextField.text;
    if (!bankCardUser || [bankCardUser rangeOfString:@"*"].length != 0 ||
        [bankCardUser rangeOfString:@"|"].length != 0 ||
        [bankCardUser rangeOfString:@" "].length != 0 ) {
        [BYToastView showToastWithMessage:@"持卡人姓名不能包含特殊字符"];
        [bankCardUserTextField resignFirstResponder];
        return;
    }
    
    NSString *bankCardPhone = bankCardPhoneTextField.text;
    if ([bankCardPhone rangeOfString:@"."].length != 0) {
        [BYToastView showToastWithMessage:@"预留号码不能包含特殊字符"];
        return;
    }
    if (![UNTools isNotZeroMoneyNumber:bankCardPhone]) {
        [BYToastView showToastWithMessage:@"预留号码格式错误"];
        return;
    }
    
    NSString *alertMessage = [NSString stringWithFormat:@"确定提现 ¥%.1f元吗?",withDrawNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提现确认" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 90011;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 90011) {
        if (buttonIndex == 1) {
            [self resignAllInputs];
            [self withDrawNoQuestion];
        }
    }
}

-(void)withDrawNoQuestion{
    [self resignAllInputs];
    float withDrawNum = [withDrawNumTextField.text floatValue];
    NSString *bankName = bankNameTextField.text;
    NSString *bankCardNumberString = bankCardNumTextField.text;
    bankCardNumberString = [bankCardNumberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *bankCardUser = bankCardUserTextField.text;
    NSString *bankCardPhone = bankCardPhoneTextField.text;
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@(withDrawNum) forKey:@"amount"];
    [paramsDic setObject:bankName forKey:@"bank"];
    [paramsDic setObject:bankCardNumberString forKey:@"account"];
    [paramsDic setObject:bankCardUser forKey:@"name"];
    [paramsDic setObject:bankCardPhone forKey:@"phone"];
    
    [UNUrlConnection withDrawWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        [self resignAllInputs];
        if (errorString) {
            [BYToastView showToastWithMessage:@"提现失败,请稍候再试"];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            [BYToastView showToastWithMessage:@"申请提现成功"];
            [self leftItemClick];
        }else{
            NSString *content = messageDic[@"content"];
            if (!content) {
                content = @"提现失败,请稍后再试";
            }
            [BYToastView showToastWithMessage:content];
        }
    }];
}

-(void)resignAllInputs{
    [withDrawNumTextField resignFirstResponder];
    [bankNameTextField resignFirstResponder];
    [bankCardNumTextField resignFirstResponder];
    [bankCardUserTextField resignFirstResponder];
    [bankCardPhoneTextField resignFirstResponder];
}


-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
