//
//  LoginForgetSecondViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/28.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LoginForgetSecondViewController.h"
#import "BYToastView.h"
#import "UNUrlConnection.h"
#import "UserLoginViewController.h"

@interface LoginForgetSecondViewController () <UITextFieldDelegate>

@end

@implementation LoginForgetSecondViewController{
    UITextField *userOriginPasswordfiled;
    UITextField *userPasswordfiled;
    UITextField *userrepeatPasswordfiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == LoginForgetTypeChangePassword) {
        self.navigationItem.title = @"修改密码";
    }else{
        self.navigationItem.title = @"设置密码";
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
    
    CGFloat offset = 15;
    if (self.type == LoginForgetTypeChangePassword) {
        userOriginPasswordfiled = [[UITextField alloc] init];
        userOriginPasswordfiled.backgroundColor = [UIColor whiteColor];
        userOriginPasswordfiled.frame = (CGRect){15,15,(WIDTH(contentView)-15*2),45};
        userOriginPasswordfiled.textColor = RGBColor(100, 100, 100);
        userOriginPasswordfiled.font = Font(15);
        userOriginPasswordfiled.tag = 10301;
        userOriginPasswordfiled.keyboardType = UIKeyboardTypeDefault;
        userOriginPasswordfiled.secureTextEntry = YES;
        userOriginPasswordfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userOriginPasswordfiled.autocorrectionType = UITextAutocorrectionTypeNo;
        userOriginPasswordfiled.delegate = self;
        userOriginPasswordfiled.returnKeyType = UIReturnKeyDone;
        userOriginPasswordfiled.placeholder = @"请输入原密码";
        userOriginPasswordfiled.layer.borderWidth = 0.5;
        userOriginPasswordfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        userOriginPasswordfiled.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
        [contentView addSubview:userOriginPasswordfiled];
        
        UIView *userOriginpasswoedLeftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(userOriginPasswordfiled)}];
        userOriginpasswoedLeftView.backgroundColor = [UIColor whiteColor];
        userOriginPasswordfiled.leftView = userOriginpasswoedLeftView;
        userOriginPasswordfiled.leftViewMode = UITextFieldViewModeAlways;
        
        offset += HEIGHT(userOriginPasswordfiled);
        offset += 15;
    }
    
    userPasswordfiled = [[UITextField alloc] init];
    userPasswordfiled.backgroundColor = [UIColor whiteColor];
    userPasswordfiled.frame = (CGRect){15,offset,(WIDTH(contentView)-15*2),45};
    userPasswordfiled.textColor = RGBColor(100, 100, 100);
    userPasswordfiled.font = Font(15);
    userPasswordfiled.tag = 10301;
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
    
    offset += HEIGHT(userPasswordfiled);
    offset += 15;
    
    userrepeatPasswordfiled = [[UITextField alloc] init];
    userrepeatPasswordfiled.backgroundColor = [UIColor whiteColor];
    userrepeatPasswordfiled.frame = (CGRect){15,offset,(WIDTH(contentView)-15*2),45};
    userrepeatPasswordfiled.textColor = RGBColor(100, 100, 100);
    userrepeatPasswordfiled.font = Font(15);
    userrepeatPasswordfiled.tag = 10302;
    userrepeatPasswordfiled.keyboardType = UIKeyboardTypeDefault;
    userrepeatPasswordfiled.secureTextEntry = YES;
    userrepeatPasswordfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userrepeatPasswordfiled.autocorrectionType = UITextAutocorrectionTypeNo;
    userrepeatPasswordfiled.delegate = self;
    userrepeatPasswordfiled.returnKeyType = UIReturnKeyDone;
    userrepeatPasswordfiled.placeholder = @"重复密码";
    userrepeatPasswordfiled.layer.borderWidth = 0.5;
    userrepeatPasswordfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    userrepeatPasswordfiled.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    [contentView addSubview:userrepeatPasswordfiled];
    
    UIView *userrepeatpasswoedLeftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(userrepeatPasswordfiled)}];
    userrepeatpasswoedLeftView.backgroundColor = [UIColor whiteColor];
    userrepeatPasswordfiled.leftView = userrepeatpasswoedLeftView;
    userrepeatPasswordfiled.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *nextMoveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextMoveButton.frame = (CGRect){15,BOTTOM(userrepeatPasswordfiled)+15,WIDTH(contentView)-15*2,40};
    nextMoveButton.backgroundColor = UN_RedColor;
    [nextMoveButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextMoveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextMoveButton.titleLabel.font = Font(15);
    [nextMoveButton addTarget:self action:@selector(nextMoveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextMoveButton];
}

-(void)contentViewTapTriggle{
    [self resignAllInput];
}

-(void)nextMoveButtonClick{
    if (self.type == LoginForgetTypeRegist) {
        [self regist];
    }else if (self.type == LoginForgetTypeSettingPassword){
        [self settingPassword];
    }else if (self.type == LoginForgetTypeChangePassword){
        [self changePassword];
    }
}

-(void)regist{
    [self resignAllInput];
    
    NSString *passwordString = userPasswordfiled.text;
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"设置的密码不能为空"];
        return;
    }
    if (![self checkString:passwordString]) {
        [BYToastView showToastWithMessage:@"设置的密码不能包含特殊字符"];
        return;
    }
    
    NSString *repeatPasswordString = userrepeatPasswordfiled.text;
    if (!repeatPasswordString || [repeatPasswordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"重复的密码不能为空"];
        return;
    }
    if (![self checkString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"重复的密码不能包含特殊字符"];
        return;
    }
    
    if (![passwordString isEqualToString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"两次输入的密码不一致"];
        return;
    }
    
    [UNUrlConnection registUser:self.loginName password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
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
                        NSString *token = resultDic[@"token"];
                        long uidtmp = [resultDic[@"uid"] longValue];
                        
                        
                        [UNUserDefaults setIsLogin:YES];
                        [UNUserDefaults setUserID:[NSString stringWithFormat:@"%ld",uidtmp]];
                        [UNUserDefaults setUserPhone:self.loginName];
                        [UNUserDefaults setUserPassword: passwordString];
                        [UNUserDefaults setUserToken:token];
                        [BYToastView showToastWithMessage:@"注册成功"];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else if (result == 1){
                        [BYToastView showToastWithMessage:@"手机号码不能为空"];
                    }else if (result == 2){
                        [BYToastView showToastWithMessage:@"密码不能为空"];
                    }else if (result == 4){
                        [BYToastView showToastWithMessage:@"该手机号码已注册"];
                    }else {
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

-(void)settingPassword{
    [self resignAllInput];
    
    NSString *passwordString = userPasswordfiled.text;
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"设置的密码不能为空"];
        return;
    }
    if (![self checkString:passwordString]) {
        [BYToastView showToastWithMessage:@"设置的密码不能包含特殊字符"];
        return;
    }
    
    NSString *repeatPasswordString = userrepeatPasswordfiled.text;
    if (!repeatPasswordString || [repeatPasswordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"重复的密码不能为空"];
        return;
    }
    if (![self checkString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"重复的密码不能包含特殊字符"];
        return;
    }
    
    if (![passwordString isEqualToString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"两次输入的密码不一致"];
        return;
    }
    
    [UNUrlConnection forgetPassword:self.loginName password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            [BYToastView showToastWithMessage:@"密码更新成功,请重新登录"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        [BYToastView showToastWithMessage:@"密码更新失败,请重试"];
        return;
    }];
}

-(void)changePassword{
    [self resignAllInput];
    
    NSString *oldPass = userOriginPasswordfiled.text;
    if (!oldPass || [oldPass isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"原密码不能为空"];
        return;
    }
    if (![self checkString:oldPass]) {
        [BYToastView showToastWithMessage:@"原密码不能包含特殊字符"];
        return;
    }
    
    NSString *passwordString = userPasswordfiled.text;
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"设置的密码不能为空"];
        return;
    }
    if (![self checkString:passwordString]) {
        [BYToastView showToastWithMessage:@"设置的密码不能包含特殊字符"];
        return;
    }
    
    NSString *repeatPasswordString = userrepeatPasswordfiled.text;
    if (!repeatPasswordString || [repeatPasswordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"重复的密码不能为空"];
        return;
    }
    if (![self checkString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"重复的密码不能包含特殊字符"];
        return;
    }
    
    if (![passwordString isEqualToString:repeatPasswordString]) {
        [BYToastView showToastWithMessage:@"两次输入的密码不一致"];
        return;
    }
    
    if ([oldPass isEqualToString:passwordString]) {
        [BYToastView showToastWithMessage:@"修改的密码不能和原密码一致"];
        return;
    }
    
    [BYToastView showToastWithMessage:@"正在修改密码..."];
    [UNUrlConnection changePasswordWithOldPass:oldPass newPass:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        int resultInt = [[resultDic objectForKey:@"result"] intValue];
        if (resultInt == -1) {
            [BYToastView showToastWithMessage:@"用户验证失败"];
        }else if (resultInt == 0){
            [BYToastView showToastWithMessage:@"用户认证失败"];
        }else if (resultInt == 1){
            [BYToastView showToastWithMessage:@"密码验证错误,请重新输入"];
        }else if (resultInt == 2){
            [BYToastView showToastWithMessage:@"密码更新成功,请重新登录"];
            [UNUserDefaults resetLoginStatus];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [BYToastView showToastWithMessage:@"密码验证错误,请重新输入"];
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([userPasswordfiled.text isEqualToString:@""]) {
        [userPasswordfiled becomeFirstResponder];
    }else if ([userrepeatPasswordfiled.text isEqual:@""]){
        [userrepeatPasswordfiled becomeFirstResponder];
    }else{
        [self nextMoveButtonClick];
    }
    return YES;
}

-(void)resignAllInput{
    [userPasswordfiled resignFirstResponder];
    [userrepeatPasswordfiled resignFirstResponder];
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
