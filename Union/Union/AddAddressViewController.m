//
//  AddAddressViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AddAddressViewController.h"

#import "BYToastView.h"
#import "MapAddressViewController.h"
#import "UNUrlConnection.h"

@interface AddAddressViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *contentView;

@end

@implementation AddAddressViewController{
    UIButton *maleButton;
    UIImageView *maleSelectedImage;
    UIButton *femaleButton;
    UIImageView *femaleSelectedImage;
    
    UITextField *mapAddressField;
    UITextField *detailAddressField;
    UITextField *userInfoField;
    UITextField *phoneField;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.addressInfo) {
        NSLog(@"%d",self.addressInfo.sex);
        self.navigationItem.title = @"修改送餐地址";
    }else{
        self.navigationItem.title = @"添加送餐地址";
        self.addressInfo = [[AdressInfo alloc] init];
    }
    
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    UITapGestureRecognizer *contentTapGestue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapGestue)];
    [contentView addGestureRecognizer:contentTapGestue];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    float offset = 20;
    float viewHeight= 45.f;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line1.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line1];
    
    UIView *mapAddressView = [[UIView alloc] init];
    mapAddressView.frame = (CGRect){0,offset,WIDTH(contentView),viewHeight};
    mapAddressView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:mapAddressView];
    
    UILabel *mapAddressLabel = [[UILabel alloc] initWithFrame:(CGRect){10,0,70,HEIGHT(mapAddressView)}];
    mapAddressLabel.text = @"收餐地址";
    mapAddressLabel.textColor = RGBColor(50, 50, 50);
    mapAddressLabel.font = Font(16);
    [mapAddressView addSubview:mapAddressLabel];
    
    UIImageView *locationImage = [[UIImageView alloc] init];
    locationImage.image = [UIImage imageNamed:@"location"];
    locationImage.frame = (CGRect){80+4,(HEIGHT(mapAddressView)-16)/2,12,16};
    [mapAddressView addSubview:locationImage];
    
    mapAddressField = [[UITextField alloc] init];
    mapAddressField.frame = (CGRect){80+20,0,(WIDTH(mapAddressView)-80-10-20-17),HEIGHT(mapAddressView)};
    mapAddressField.textColor = RGBColor(100, 100, 100);
    mapAddressField.font = Font(15);
    mapAddressField.tag = 100;
    mapAddressField.delegate = self;
    mapAddressField.returnKeyType = UIReturnKeyDone;
    [mapAddressField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mapAddressField setAutocorrectionType:UITextAutocorrectionTypeNo];
    mapAddressField.placeholder = @"请选择小区,大厦或学校";
    [mapAddressView addSubview:mapAddressField];
    
    
    UIImageView *mapAddressImage = [[UIImageView alloc] init];
    mapAddressImage.image = [UIImage imageNamed:@"more"];
    mapAddressImage.frame = (CGRect){WIDTH(mapAddressView)-10-7,(HEIGHT(mapAddressView)-11)/2,7,11};
    [mapAddressView addSubview:mapAddressImage];
    
    UIButton *mapAddressButton = [[UIButton alloc] init];
    mapAddressButton.frame = (CGRect){80,0,WIDTH(mapAddressView)-80,HEIGHT(mapAddressView)};
    [mapAddressView addSubview:mapAddressButton];
    [mapAddressButton addTarget:self action:@selector(mapAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    offset += viewHeight;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line2.frame = (CGRect){10,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line2];
    
    UIView *detailAddressView = [[UIView alloc] init];
    detailAddressView.frame = (CGRect){0,offset,WIDTH(contentView),viewHeight};
    detailAddressView.backgroundColor = RGBColor(255, 255, 255);;
    [contentView addSubview:detailAddressView];
    
    UILabel *detailAddressLabel = [[UILabel alloc] initWithFrame:(CGRect){10,0,70,HEIGHT(detailAddressView)}];
//    detailAddressLabel.backgroundColor = [UIColor redColor];
    detailAddressLabel.text = @"门牌号";
    detailAddressLabel.textColor = RGBColor(50, 50, 50);
    detailAddressLabel.font = Font(16);
    [detailAddressView addSubview:detailAddressLabel];
    
    detailAddressField = [[UITextField alloc] init];
    detailAddressField.frame = (CGRect){80,0,(WIDTH(detailAddressView)-80-10),HEIGHT(detailAddressView)};
    detailAddressField.textColor = RGBColor(100, 100, 100);
    detailAddressField.font = Font(15);
    detailAddressField.tag = 100;
    detailAddressField.delegate = self;
    detailAddressField.returnKeyType = UIReturnKeyDone;
    detailAddressField.placeholder = @"请输入门牌号等详细信息";
    [detailAddressField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [detailAddressField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [detailAddressView addSubview:detailAddressField];
    
    offset += viewHeight;
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line3.frame = (CGRect){10,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line3];
    
    UIView *userInfoView = [[UIView alloc] init];
    userInfoView.frame = (CGRect){0,offset,WIDTH(contentView),viewHeight};
    userInfoView.backgroundColor = RGBColor(255, 255, 255);;
    [contentView addSubview:userInfoView];
    
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:(CGRect){10,0,70,HEIGHT(userInfoView)}];
//    userInfoLabel.backgroundColor = [UIColor redColor];
    userInfoLabel.text = @"联系人";
    userInfoLabel.textColor = RGBColor(50, 50, 50);
    userInfoLabel.font = Font(16);
    [userInfoView addSubview:userInfoLabel];
    
    userInfoField = [[UITextField alloc] init];
    userInfoField.frame = (CGRect){80,0,(WIDTH(userInfoView)-80-10),HEIGHT(userInfoView)};
    userInfoField.textColor = RGBColor(100, 100, 100);
    userInfoField.font = Font(15);
    userInfoField.tag = 100;
    userInfoField.delegate = self;
    userInfoField.returnKeyType = UIReturnKeyDone;
    userInfoField.placeholder = @"您的姓名";
    [userInfoField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [userInfoField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userInfoView addSubview:userInfoField];
    
    offset += viewHeight;
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line4.frame = (CGRect){80,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line4];
    
    UIView *sexView = [[UIView alloc] init];
    sexView.frame = (CGRect){0,offset,WIDTH(contentView),viewHeight};
    sexView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:sexView];
    
    UIView *sexUnderView = [[UIView alloc] init];
    sexUnderView.frame = (CGRect){80,0,WIDTH(sexView)-80,viewHeight};
    [sexView addSubview:sexUnderView];
    
    maleButton = [[UIButton alloc] init];
    maleButton.tag = 0;
    maleButton.frame = (CGRect){0,0,WIDTH(sexUnderView)/2,HEIGHT(sexUnderView)};
    [sexUnderView addSubview:maleButton];
    [maleButton addTarget:self action:@selector(maleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    maleSelectedImage = [[UIImageView alloc] init];
    maleSelectedImage.frame = (CGRect){0,(HEIGHT(maleButton)-22)/2,22,22};
    maleSelectedImage.image = [UIImage imageNamed:@"unselected"];
    [maleButton addSubview:maleSelectedImage];
    
    UILabel *maleLabel = [[UILabel alloc] init];
    maleLabel.frame = (CGRect){RIGHT(maleSelectedImage)+10,0,WIDTH(maleButton)-(RIGHT(maleSelectedImage)+10)-10,HEIGHT(maleButton)};
    maleLabel.text = @"先生";
    maleLabel.textAlignment = NSTextAlignmentLeft;
    maleLabel.textColor = RGBColor(80, 80, 80);
    maleLabel.font = Font(15);
    [maleButton addSubview:maleLabel];
    
    femaleButton = [[UIButton alloc] init];
    femaleButton.tag = 0;
    femaleButton.frame = (CGRect){WIDTH(sexUnderView)/2,0,WIDTH(sexUnderView)/2,HEIGHT(sexUnderView)};
    [sexUnderView addSubview:femaleButton];
    [femaleButton addTarget:self action:@selector(femaleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    femaleSelectedImage = [[UIImageView alloc] init];
    femaleSelectedImage.frame = (CGRect){0,(HEIGHT(femaleButton)-22)/2,22,22};
    femaleSelectedImage.image = [UIImage imageNamed:@"unselected"];
    [femaleButton addSubview:femaleSelectedImage];
    
    UILabel *femaleLabel = [[UILabel alloc] init];
    femaleLabel.frame = (CGRect){RIGHT(femaleSelectedImage)+10,0,WIDTH(femaleButton)-(RIGHT(femaleSelectedImage)+10)-10,HEIGHT(femaleButton)};
    femaleLabel.text = @"女士";
    femaleLabel.textAlignment = NSTextAlignmentLeft;
    femaleLabel.textColor = RGBColor(80, 80, 80);
    femaleLabel.font = Font(15);
    [femaleButton addSubview:femaleLabel];
    
    offset += viewHeight;
    
    UIView *line5 = [[UIView alloc] init];
    line5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line5.frame = (CGRect){10,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line5];
    
    UIView *phoneView = [[UIView alloc] init];
    phoneView.frame = (CGRect){0,offset,WIDTH(contentView),viewHeight};
    phoneView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:(CGRect){10,0,70,HEIGHT(phoneView)}];
//    phoneLabel.backgroundColor = [UIColor redColor];
    phoneLabel.text = @"电话";
    phoneLabel.textColor = RGBColor(50, 50, 50);
    phoneLabel.font = Font(16);
    [phoneView addSubview:phoneLabel];
    
    phoneField = [[UITextField alloc] init];
    phoneField.frame = (CGRect){80,0,(WIDTH(phoneView)-80-10),HEIGHT(phoneView)};
    phoneField.textColor = RGBColor(100, 100, 100);
    phoneField.font = Font(15);
    phoneField.tag = 100;
    phoneField.delegate = self;
    phoneField.returnKeyType = UIReturnKeyDone;
    phoneField.placeholder = @"配送员联系您的方式";
    [phoneField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [phoneField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [phoneView addSubview:phoneField];
    
    offset += viewHeight;
    
    UIView *line6 = [[UIView alloc] init];
    line6.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line6.frame = (CGRect){0,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line6];
    
    if (self.addressInfo) {
        if (self.addressInfo.mapAdress) {
            mapAddressField.text = self.addressInfo.mapAdress;
        }
        
        if (self.addressInfo.detailAdress) {
            detailAddressField.text = self.addressInfo.detailAdress;
        }
        
        if (self.addressInfo.name) {
            userInfoField.text = self.addressInfo.name;
        }
        
        if (self.addressInfo.sex == 0) {
            [self maleButtonClick];
        }
        
        if (self.addressInfo.phone) {
            phoneField.text = self.addressInfo.phone;
        }
    }else{
        [self maleButtonClick];
    }
}

-(void)resignAllTextFild{
    [mapAddressField resignFirstResponder];
    [detailAddressField resignFirstResponder];
    [userInfoField resignFirstResponder];
    [phoneField resignFirstResponder];
}

-(void)contentTapGestue{
    [self resignAllTextFild];
}

-(void)mapAddressButtonClick{
    [self resignAllTextFild];
    MapAddressViewController *mapAVC = [[MapAddressViewController alloc] init];
    weak(weakself, self);
    mapAVC.resultBlock = ^(NSString *name,NSString *address,float latitude,float longitude){
        weakself.addressInfo.mapAdress = name;
        weakself.addressInfo.detailAdress = address;
        weakself.addressInfo.mapLatitude = latitude;
        weakself.addressInfo.mapLongitude = longitude;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateViews];
        });
    };
    [self.navigationController pushViewController:mapAVC animated:YES];
}

-(void)maleButtonClick{
    if (maleButton.tag == 0) {
        maleSelectedImage.image = [UIImage imageNamed:@"selected"];
        femaleSelectedImage.image = [UIImage imageNamed:@"unselected"];
        maleButton.tag = 1;
        femaleButton.tag = 0;
        
        self.addressInfo.sex = 0;
    }else{
        maleSelectedImage.image = [UIImage imageNamed:@"unselected"];
        maleButton.tag = 0;
        
        self.addressInfo.sex = -1;
    }
}

-(void)femaleButtonClick{
    if (femaleButton.tag == 0) {
        femaleSelectedImage.image = [UIImage imageNamed:@"selected"];
        maleSelectedImage.image = [UIImage imageNamed:@"unselected"];
        femaleButton.tag = 1;
        maleButton.tag = 0;
        
        self.addressInfo.sex = 1;
    }else{
        femaleSelectedImage.image = [UIImage imageNamed:@"unselected"];
        femaleButton.tag = 0;
        
        self.addressInfo.sex = -1;
    }
}

-(void)updateViews{
    if (self.addressInfo) {
        if (self.addressInfo.mapAdress) {
            mapAddressField.text = self.addressInfo.mapAdress;
        }
        
        if (self.addressInfo.detailAdress) {
            detailAddressField.text = self.addressInfo.detailAdress;
        }
        
        if (self.addressInfo.name) {
            userInfoField.text = self.addressInfo.name;
        }
        
        if (self.addressInfo.sex == 0) {
            maleButton.tag = 0;
            [self maleButtonClick];
        }else{
            femaleButton.tag = 0;
            [self femaleButtonClick];
        }
        
        if (self.addressInfo.phone) {
            phoneField.text = self.addressInfo.phone;
        }
    }else{
        [self maleButtonClick];
    }
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

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,32,20};
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
    [self resignAllTextFild];
    
    self.addressInfo.detailAdress = detailAddressField.text;
    self.addressInfo.name = userInfoField.text;
    self.addressInfo.phone = phoneField.text;
    
    NSString *mapAddressTmp = self.addressInfo.mapAdress;
    NSString *detailAddressTmp = self.addressInfo.detailAdress;
    NSString *nameTmp = self.addressInfo.name;
    NSString *phoneTmp = self.addressInfo.phone;
    
    if (!mapAddressTmp || [[mapAddressTmp stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"收餐地址不能为空"];
        return;
    }
    if (!nameTmp || [[nameTmp stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人姓名不能为空"];
        return;
    }
    if (!phoneTmp || [[phoneTmp stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人电话不能为空"];
        return;
    }
    if (self.addressInfo.sex == -1) {
        [BYToastView showToastWithMessage:@"联系人性别未选择"];
        return;
    }
    if (![self checkString:mapAddressTmp]) {
        [BYToastView showToastWithMessage:@"收餐地址不能包含非法字符"];
        return;
    }
    if (![self checkString:detailAddressTmp]) {
        [BYToastView showToastWithMessage:@"门牌号不能包含非法字符"];
        return;
    }
    if (![self checkString:nameTmp]) {
        [BYToastView showToastWithMessage:@"联系人姓名不能包含非法字符"];
        return;
    }
    if (![self checkString:phoneTmp]) {
        [BYToastView showToastWithMessage:@"联系人电话不能包含非法字符"];
        return;
    }
    
//    [UNUserDefaults saveAdressInfo:self.addressInfo];
    
    if ([self.navigationItem.title isEqualToString:@"添加送餐地址"]) {
        
        NSLog(@"%d",self.addressInfo.sex);
        
        [BYToastView showToastWithMessage:@"正在添加收货地址..."];
        [UNUrlConnection addReceiveAddressWithAddressInfo:self.addressInfo complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:@"添加失败,请稍候重试"];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *type = [messageDic objectForKey:@"type"];
            if (type && [type isKindOfClass:[NSString class]] && [type isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"添加收货地址成功"];
                runInMainThread(^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }
        }];
    }else{
        
        NSLog(@"%d",self.addressInfo.sex);
        
        if (!self.addressInfo.addressID || [self.addressInfo.addressID isEqualToString:@""]) {
            [BYToastView showToastWithMessage:@"收货地址错误,请退出重试"];
            return;
        }
        [BYToastView showToastWithMessage:@"正在修改收货地址..."];
        [UNUrlConnection editReceiveAddressWithAddressInfo:self.addressInfo complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *type = [messageDic objectForKey:@"type"];
            if (type && [type isKindOfClass:[NSString class]] && [type isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"修改收货地址成功"];
                runInMainThread(^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    [self updateViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
