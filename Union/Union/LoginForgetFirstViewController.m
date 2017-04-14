//
//  LoginForgetFirstViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/28.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LoginForgetFirstViewController.h"
#import "LoginForgetSecondViewController.h"

#import "BYToastView.h"
#import "UNUrlConnection.h"
#import "UNUserDefaults.h"

@interface LoginForgetFirstViewController ()

@end

@implementation LoginForgetFirstViewController{
    UITextField *userPhoneTextfiled;
    
    UITextField *userEnteryCodeTextfiled;
    
    UIButton *getCodeButton;
    
    int globalCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type == LoginForgetTypeRegist) {
        self.navigationItem.title = @"注册";
    }else if (self.type == LoginForgetTypeSettingPassword){
        self.navigationItem.title = @"忘记密码";
    }
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapTriggle)];
    [contentView addGestureRecognizer:tapGes];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    
    userPhoneTextfiled = [[UITextField alloc] init];
    userPhoneTextfiled.backgroundColor = [UIColor whiteColor];
    userPhoneTextfiled.frame = (CGRect){15,15,(WIDTH(contentView)-15*2),45};
    userPhoneTextfiled.textColor = RGBColor(100, 100, 100);
    userPhoneTextfiled.font = Font(15);
    userPhoneTextfiled.tag = 10100;
    userPhoneTextfiled.keyboardType = UIKeyboardTypePhonePad;
    userPhoneTextfiled.returnKeyType = UIReturnKeyNext;
    userPhoneTextfiled.placeholder = @"请输入手机号";
    userPhoneTextfiled.layer.borderWidth = 0.5;
    userPhoneTextfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userPhoneTextfiled.autocorrectionType = UITextAutocorrectionTypeNo;
    userPhoneTextfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    userPhoneTextfiled.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    [contentView addSubview:userPhoneTextfiled];
    
    UIView *userphoneLeftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(userPhoneTextfiled)}];
    userphoneLeftView.backgroundColor = [UIColor whiteColor];
    userPhoneTextfiled.leftView = userphoneLeftView;
    userPhoneTextfiled.leftViewMode = UITextFieldViewModeAlways;
    
    userEnteryCodeTextfiled = [[UITextField alloc] init];
    userEnteryCodeTextfiled.backgroundColor = [UIColor whiteColor];
    userEnteryCodeTextfiled.frame = (CGRect){15,BOTTOM(userPhoneTextfiled)+15,(WIDTH(contentView)-15*2-120-10),45};
    userEnteryCodeTextfiled.textColor = RGBColor(100, 100, 100);
    userEnteryCodeTextfiled.font = Font(15);
    userEnteryCodeTextfiled.tag = 10201;
    userEnteryCodeTextfiled.keyboardType = UIKeyboardTypePhonePad;
    userEnteryCodeTextfiled.returnKeyType = UIReturnKeyNext;
    userEnteryCodeTextfiled.placeholder = @"输入验证码";
    userEnteryCodeTextfiled.layer.borderWidth = 0.5;
    userEnteryCodeTextfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userEnteryCodeTextfiled.autocorrectionType = UITextAutocorrectionTypeNo;
    userEnteryCodeTextfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    userEnteryCodeTextfiled.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    [contentView addSubview:userEnteryCodeTextfiled];
    
    UIView *userEnteryCodeLeftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(userEnteryCodeTextfiled)}];
    userEnteryCodeLeftView.backgroundColor = [UIColor whiteColor];
    userEnteryCodeTextfiled.leftView = userEnteryCodeLeftView;
    userEnteryCodeTextfiled.leftViewMode = UITextFieldViewModeAlways;
    //    
    getCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getCodeButton.frame = (CGRect){WIDTH(contentView)-15-120,TOP(userEnteryCodeTextfiled)+2,120,41};;
    [getCodeButton setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    getCodeButton.backgroundColor = UN_RedColor;
    [getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCodeButton addTarget:self action:@selector(getCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:getCodeButton];
    
    UIButton *nextMoveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextMoveButton.frame = (CGRect){15,BOTTOM(userEnteryCodeTextfiled)+15,WIDTH(contentView)-15*2,40};
    nextMoveButton.backgroundColor = UN_RedColor;
    [nextMoveButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextMoveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextMoveButton.titleLabel.font = Font(15);
    [nextMoveButton addTarget:self action:@selector(nextMoveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextMoveButton];
    
    globalCode = 0;
}

-(void)contentViewTapTriggle{
    [self resignAllInput];
}

-(void)nextMoveButtonClick{
    [self resignAllInput];
    
    NSString *phoneString = userPhoneTextfiled.text;
    if (!phoneString || [phoneString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"手机号码不能为空"];
        return;
    }
    if (![self checkString:phoneString]) {
        [BYToastView showToastWithMessage:@"输入的手机号码不能包含特殊字符"];
        return;
    }
    
    NSString *codeString = userEnteryCodeTextfiled.text;
    if (!codeString || [codeString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"验证码不能为空"];
        return;
    }
    if (![self checkString:codeString]) {
        [BYToastView showToastWithMessage:@"验证码不能包含特殊字符"];
        return;
    }
    if ([codeString intValue] != globalCode) {
        [BYToastView showToastWithMessage:@"验证码不正确,请重试"];
        return;
    }
    
    [self judgePhone:phoneString complete:^(NSDictionary *resultDic, NSString *errorString) {
        runInMainThread(^{
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                /*
                 0:该手机号不存在，可用
                 1：参数为空
                 2：该手机号已经存在
                 */
                if (resultDic) {
                    int result = [resultDic[@"result"] intValue];
                    if (result == 0) {
                        LoginForgetSecondViewController *lfsVC = [LoginForgetSecondViewController new];
                        lfsVC.type = self.type;
                        lfsVC.loginName = phoneString;
                        [self.navigationController pushViewController:lfsVC animated:YES];
                    }else if (result == 1){
                        [BYToastView showToastWithMessage:@"手机号码不能为空"];
                    }else if (result == 2){
                        [BYToastView showToastWithMessage:@"该手机号码已注册"];
                    }else{
                        [BYToastView showToastWithMessage:@"服务器错误"];
                    }
                }else{
                    NSLog(@"error:getCodeButtonClick");
                    [BYToastView showToastWithMessage:@"服务器错误"];
                }
            }
        });
    }];
}

-(void)getCodeButtonClick{
    //网络请求
    [self resignAllInput];
    
    NSString *phoneString = userPhoneTextfiled.text;
    if (!phoneString || [phoneString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"手机号码不能为空"];
        return;
    }
    if (![self checkString:phoneString]) {
        [BYToastView showToastWithMessage:@"输入的手机号码不能包含特殊字符"];
        return;
    }
    globalCode = 0;
    [getCodeButton.titleLabel.text isEqualToString:@"正在发送验证码"];
    [self judgePhone:phoneString complete:^(NSDictionary *resultDic, NSString *errorString) {
        runInMainThread(^{
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                /*
                 0:该手机号不存在，可用
                 1：参数为空
                 2：该手机号已经存在
                 */
                if (resultDic) {
                    int result = [resultDic[@"result"] intValue];
                    if (result == 0) {
                        [UNUrlConnection getEntryCodeWithPhone:phoneString complete:^(NSDictionary *resultDic, NSString *errorString) {
                            runInMainThread(^{
                                if (errorString) {
                                    [BYToastView showToastWithMessage:@"验证码发送失败"];
                                    [getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"];
                                    return;
                                }else{
                                    NSDictionary *messageDic = resultDic[@"message"];
                                    NSString *typeString = messageDic[@"type"];
                                    if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                                        int codeResult = [resultDic[@"content"][@"code"] intValue];
                                        if (codeResult != 0) {
                                            globalCode = codeResult;
                                            [BYToastView showToastWithMessage:@"验证码发送成功"];
                                            [self codeButtonCountDownAnimated];
                                            NSLog(@"getEntryCodeComplete: %d",globalCode);
                                        }else{
                                            [BYToastView showToastWithMessage:@"验证码发送错误"];
                                            [getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"];
                                        }
                                        return;
                                    }
                                    [BYToastView showToastWithMessage:@"验证码发送错误"];
                                }
                            });
                        }];
                    }else if (result == 1){
                        [BYToastView showToastWithMessage:@"手机号码不能为空"];
                        [getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"];
                    }else if (result == 2){
                        [BYToastView showToastWithMessage:@"该手机号码已注册"];
                        [getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"];
                    }else{
                        [BYToastView showToastWithMessage:@"服务器错误"];
                        [getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"];
                    }
                }else{
                    NSLog(@"error:getCodeButtonClick");
                    [BYToastView showToastWithMessage:@"服务器错误"];
                }
            }
        });
    }];
}

static NSString *preString = @"已发送";
static int countDown = 0;
-(void)codeButtonCountDownAnimated{
    getCodeButton.enabled = NO;
    getCodeButton.userInteractionEnabled = NO;
    if ([getCodeButton.titleLabel.text isEqualToString:@"免费获取验证码"]
        ||[getCodeButton.titleLabel.text isEqualToString:@"重新发送"]
        || [getCodeButton.titleLabel.text isEqualToString:@"正在发送验证码"]) {
        countDown = 61;
    }
    if (countDown != 1) {
        [getCodeButton setTitleColor:RGBAColor(200, 200, 200, 1) forState:UIControlStateNormal];
        getCodeButton.titleLabel.text = [NSString stringWithFormat:@"%@ %02d",preString,countDown-1];
        [getCodeButton setTitle:[NSString stringWithFormat:@"%@ %02d",preString,countDown-1] forState:UIControlStateNormal];
        countDown = countDown - 1;
        [self performSelector:@selector(codeButtonCountDownAnimated) withObject:nil afterDelay:1.f];
    }else{
        [getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        getCodeButton.enabled = YES;
        getCodeButton.userInteractionEnabled = YES;
    }
}


-(void)judgePhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    [UNUrlConnection judgeUserPhoneUsefulWithPhone:phone complete:^(NSDictionary *resultDic, NSString *errorString) {
        complete(resultDic,errorString);
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

-(void)resignAllInput{
    [userPhoneTextfiled resignFirstResponder];
    [userEnteryCodeTextfiled resignFirstResponder];
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
