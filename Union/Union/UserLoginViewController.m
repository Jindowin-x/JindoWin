//
//  UserLoginViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/28.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UserLoginViewController.h"

#import "LoginForgetFirstViewController.h"
#import "UNUserDefaults.h"
#import "UNUrlConnection.h"
#import "BYToastView.h"

@interface UserLoginViewController () <UITextFieldDelegate>

@end

@implementation UserLoginViewController{
    UITextField *userPhoneTextfiled;
    UITextField *userPasswordfiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登录";
    
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
    userPhoneTextfiled.delegate = self;
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
    
    userPasswordfiled = [[UITextField alloc] init];
    userPasswordfiled.backgroundColor = [UIColor whiteColor];
    userPasswordfiled.frame = (CGRect){15,BOTTOM(userPhoneTextfiled)+15,(WIDTH(contentView)-15*2),45};
    userPasswordfiled.textColor = RGBColor(100, 100, 100);
    userPasswordfiled.font = Font(15);
    userPasswordfiled.tag = 10101;
    userPasswordfiled.keyboardType = UIKeyboardTypeDefault;
    userPasswordfiled.secureTextEntry = YES;
    userPasswordfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userPasswordfiled.autocorrectionType = UITextAutocorrectionTypeNo;
    userPasswordfiled.delegate = self;
    userPasswordfiled.returnKeyType = UIReturnKeyDone;
    userPasswordfiled.placeholder = @"请输入密码";
    userPasswordfiled.layer.borderWidth = 0.5;
    userPasswordfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    userPasswordfiled.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    [contentView addSubview:userPasswordfiled];
    
    UIView *userpasswoedLeftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(userPasswordfiled)}];
    userpasswoedLeftView.backgroundColor = [UIColor whiteColor];
    userPasswordfiled.leftView = userpasswoedLeftView;
    userPasswordfiled.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = (CGRect){15,BOTTOM(userPasswordfiled)+15,WIDTH(contentView)-15*2,40};
    loginButton.backgroundColor = UN_RedColor;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = Font(15);
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:loginButton];
    
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetPasswordButton.frame = (CGRect){15,BOTTOM(loginButton)+15,100,20};
    [forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = Font(15);
    forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:forgetPasswordButton];
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registButton.frame = (CGRect){WIDTH(contentView)-15-60,BOTTOM(loginButton)+15,60,20};
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    registButton.titleLabel.font = Font(15);
    registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registButton];
    
    [self updateView];
}

#pragma mark - login
-(void)login{
    [self resignAllInputs];
    NSString *phoneString = userPhoneTextfiled.text;
    if (!phoneString || [phoneString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"手机号码不能为空"];
        return;
    }
    if (![self checkString:phoneString]) {
        [BYToastView showToastWithMessage:@"输入的手机号码不能包含特殊字符"];
        return;
    }
    
    NSString *passwordString = userPasswordfiled.text;
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"密码不能为空"];
        return;
    }
    if (![self checkString:passwordString]) {
        [BYToastView showToastWithMessage:@"输入的密码不能包含特殊字符"];
        return;
    }
    
    [UNUrlConnection loginUserName:phoneString password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        runInMainThread(^{
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                /*
                 0：表示登录成功
                 1：手机号错误
                 2：密码错误
                 */
                if (resultDic) {
                    int result = [resultDic[@"result"] intValue];
                    if (result == 0) {
                        NSString *token = resultDic[@"token"];
                        NSString *uid = [NSString stringWithFormat:@"%ld",[resultDic[@"uid"]longValue]];
                        
                        [UNUserDefaults setIsLogin:YES];
                        [UNUserDefaults setUserID:uid];
                        [UNUserDefaults setUserPhone:phoneString];
                        [UNUserDefaults setUserPassword: passwordString];
                        [UNUserDefaults setUserToken:token];
                        [BYToastView showToastWithMessage:@"登录成功"];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        [BYToastView showToastWithMessage:@"用户名或密码错误"];
                    }
                }else{
                    NSLog(@"error: loginUserName");
                    [BYToastView showToastWithMessage:@"服务器错误"];
                }
            }
        });
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

#pragma mark - ButtonClick
-(void)loginButtonClick{
    [self login];
}

-(void)forgetPasswordButtonClick{
    LoginForgetFirstViewController *lffVC = [LoginForgetFirstViewController new];
    lffVC.type = LoginForgetTypeSettingPassword;
    [self.navigationController pushViewController:lffVC animated:YES];
}

-(void)registButtonClick{
    LoginForgetFirstViewController *lffVC = [LoginForgetFirstViewController new];
    lffVC.type = LoginForgetTypeRegist;
    [self.navigationController pushViewController:lffVC animated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == userPhoneTextfiled) {
        [userPasswordfiled becomeFirstResponder];
    }else if (textField == userPasswordfiled){
        [self login];
    }
    return YES;
}

-(void)resignAllInputs{
    [userPhoneTextfiled resignFirstResponder];
    [userPasswordfiled resignFirstResponder];
}

-(void)contentViewTapTriggle{
    [self resignAllInputs];
}

-(void)updateView{
    if (userPhoneTextfiled) {
        userPhoneTextfiled.text = [UNUserDefaults getUserPhone];
    }
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightItemClick{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
