//
//  ShopAskForViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/18.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopAskForViewController.h"

#import "ProvinceChooseViewController.h"
#import "ShopTypeChooseViewController.h"
#import "MapAddressViewController.h"
#import "ShopBusinessAreaViewController.h"

#import "UNUrlConnection.h"
#import "XYW8IndicatorView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ShopAskForViewController () <UITextFieldDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *contentView;

@end

@implementation ShopAskForViewController{
    
    UITextField *shopNameTextFiled;
    UITextField *shopTypeTextFiled;
    UITextField *shopBussinessAreaTextFiled;
    UITextField *shopCityTextFiled;
    UITextField *shopMapAddressTextFiled;
    UITextField *shopDetailAddressTextFiled;
    UITextField *shopContactorTextFiled;
    UITextField *shopContactorPhoneTextFiled;
    UITextField *shopOtherTextFiled;
    
    UIButton *haveLicenseButton,*nonLicenseButton;
    UIImageView *haveLicenseSelectedImage,*nonLicenseSelectedImage;
    
    long areaID;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商户入驻申请";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:(CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-45}];
    contentView.backgroundColor = RGBColor(235, 235, 235);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapGesture)];
    [contentView addGestureRecognizer:contentViewTapGesture];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIButton *submitShopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitShopButton.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    submitShopButton.backgroundColor = UN_RedColor;
    [submitShopButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitShopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitShopButton addTarget:self action:@selector(submitShopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitShopButton];
    
    UIView *topNoteView = [[UIView alloc] init];
    topNoteView.backgroundColor = RGBColor(235, 235, 235);
    topNoteView.frame = (CGRect){0,0,WIDTH(contentView),20};
    [contentView addSubview:topNoteView];
    
    UILabel *topNoteLabel = [[UILabel alloc] init];
    topNoteLabel.frame = (CGRect){10,0,WIDTH(topNoteView)-20,HEIGHT(topNoteView)};
    topNoteLabel.textColor = UN_RedColor;
    topNoteLabel.textAlignment = NSTextAlignmentLeft;
    topNoteLabel.text = @"* 为必填项";
    topNoteLabel.font = Font(12);
    [topNoteView addSubview:topNoteLabel];
    
    UIView *topLineView = [[UIView alloc] init];
    topAlighView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    topLineView.frame = (CGRect){0,0,WIDTH(topNoteView),0.5};
    [topNoteView addSubview:topLineView];
    
    UIView *lineSepView1 = [[UIView alloc] init];
    lineSepView1.frame = (CGRect){0,BOTTOM(topNoteView)-0.5,WIDTH(topNoteView),0.5};
    lineSepView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [topNoteView addSubview:lineSepView1];
    
    
    float viewHeight = IS5_5Inches()?50:40;
    UIFont *font = IS5_5Inches()?Font(17):Font(15);
    float viewOffset = BOTTOM(topNoteView);
    
    UIView *shopNameView = [[UIView alloc] init];
    shopNameView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    shopNameView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:shopNameView];
    
    UILabel *shopNameNoteLabel = [[UILabel alloc] init];
    shopNameNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopNameView)};
    shopNameNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopNameNoteLabel.font = font;
    shopNameNoteLabel.attributedText = [self attributedStringWithString:@"* 商户名称"];
    [shopNameView addSubview:shopNameNoteLabel];
    
    shopNameTextFiled = [[UITextField alloc] init];
    shopNameTextFiled.frame = (CGRect){10+WIDTH(shopNameNoteLabel)+10,0,WIDTH(shopNameView)-(10+WIDTH(shopNameNoteLabel)+10)-10-11-5,HEIGHT(shopNameView)};
    shopNameTextFiled.textColor = RGBColor(100, 100, 100);
    shopNameTextFiled.font = font;
    shopNameTextFiled.tag = 101;
    shopNameTextFiled.textAlignment = NSTextAlignmentRight;
    shopNameTextFiled.delegate = self;
    shopNameTextFiled.returnKeyType = UIReturnKeyDone;
    shopNameTextFiled.placeholder = @"";
    [shopNameTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopNameTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopNameView addSubview:shopNameTextFiled];
    
    UIView *lineSepView2 = [[UIView alloc] init];
    lineSepView2.frame = (CGRect){0,HEIGHT(shopNameView)-0.5,WIDTH(shopNameView),0.5};
    lineSepView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopNameView addSubview:lineSepView2];
    
    viewOffset += viewHeight;
    
    UIView *shopTypeView = [[UIView alloc] init];
    shopTypeView.backgroundColor = [UIColor whiteColor];
    shopTypeView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopTypeView];
    
    UILabel *shopTypeNoteLabel = [[UILabel alloc] init];
    shopTypeNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopTypeView)};
    shopTypeNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopTypeNoteLabel.font = font;
    shopTypeNoteLabel.attributedText = [self attributedStringWithString:@"* 商户类型"];
    [shopTypeView addSubview:shopTypeNoteLabel];
    
    
    shopTypeTextFiled = [[UITextField alloc] init];
    shopTypeTextFiled.frame = (CGRect){10+WIDTH(shopTypeNoteLabel)+10,0,WIDTH(shopTypeView)-(10+WIDTH(shopTypeNoteLabel)+10)-10-11-5,HEIGHT(shopTypeView)};
    shopTypeTextFiled.textColor = RGBColor(100, 100, 100);
    shopTypeTextFiled.font = font;
    shopTypeTextFiled.tag = 102;
    shopTypeTextFiled.textAlignment = NSTextAlignmentRight;
    shopTypeTextFiled.delegate = self;
    shopTypeTextFiled.returnKeyType = UIReturnKeyDone;
    shopTypeTextFiled.placeholder = @"请选择";
    [shopTypeTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopTypeTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopTypeView addSubview:shopTypeTextFiled];
    
    UIButton *shopTypePushButton = [[UIButton alloc] init];
    shopTypePushButton.frame = (CGRect){10+WIDTH(shopTypeNoteLabel)+10,0,WIDTH(shopTypeView)-(10+WIDTH(shopTypeNoteLabel)+10)-10-11-5,HEIGHT(shopTypeView)};
    [shopTypeView addSubview:shopTypePushButton];
    shopTypePushButton.tag = 102;
    [shopTypePushButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *shopTypeMoreImage = [[UIImageView alloc]init];
    shopTypeMoreImage.image = [UIImage imageNamed:@"more"];
    shopTypeMoreImage.frame = (CGRect){WIDTH(shopTypeView)-10-7,(HEIGHT(shopTypeView)-11)/2,7,11};
    [shopTypeView addSubview:shopTypeMoreImage];
    
    UIView *lineSepView3 = [[UIView alloc] init];
    lineSepView3.frame = (CGRect){0,HEIGHT(shopTypeView)-0.5,WIDTH(shopTypeView),0.5};
    lineSepView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopTypeView addSubview:lineSepView3];
    
    viewOffset += viewHeight;
    
    UIView *shopBussinessAreaView = [[UIView alloc] init];
    shopBussinessAreaView.backgroundColor = [UIColor whiteColor];
    shopBussinessAreaView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopBussinessAreaView];
    
    UILabel *shopBussinessAreaNoteLabel = [[UILabel alloc] init];
    shopBussinessAreaNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopBussinessAreaView)};
    shopBussinessAreaNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopBussinessAreaNoteLabel.font = font;
    shopBussinessAreaNoteLabel.attributedText = [self attributedStringWithString:@"* 经营范围"];
    [shopBussinessAreaView addSubview:shopBussinessAreaNoteLabel];
    
    
    shopBussinessAreaTextFiled = [[UITextField alloc] init];
    shopBussinessAreaTextFiled.frame = (CGRect){10+WIDTH(shopBussinessAreaNoteLabel)+10,0,WIDTH(shopBussinessAreaView)-(10+WIDTH(shopBussinessAreaNoteLabel)+10)-10-11-5,HEIGHT(shopBussinessAreaView)};
    shopBussinessAreaTextFiled.textColor = RGBColor(100, 100, 100);
    shopBussinessAreaTextFiled.font = font;
    shopBussinessAreaTextFiled.tag = 103;
    shopBussinessAreaTextFiled.textAlignment = NSTextAlignmentRight;
    shopBussinessAreaTextFiled.delegate = self;
    shopBussinessAreaTextFiled.returnKeyType = UIReturnKeyDone;
    shopBussinessAreaTextFiled.placeholder = @"请选择";
    [shopBussinessAreaTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopBussinessAreaTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopBussinessAreaView addSubview:shopBussinessAreaTextFiled];
    
    UIButton *shopBussinessAreaPushButton = [[UIButton alloc] init];
    shopBussinessAreaPushButton.frame = (CGRect){10+WIDTH(shopBussinessAreaNoteLabel)+10,0,WIDTH(shopBussinessAreaView)-(10+WIDTH(shopBussinessAreaNoteLabel)+10)-10-11-5,HEIGHT(shopBussinessAreaView)};
    [shopBussinessAreaView addSubview:shopBussinessAreaPushButton];
    shopBussinessAreaPushButton.tag = 103;
    [shopBussinessAreaPushButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *shopBussinessAreaMoreImage = [[UIImageView alloc]init];
    shopBussinessAreaMoreImage.image = [UIImage imageNamed:@"more"];
    shopBussinessAreaMoreImage.frame = (CGRect){WIDTH(shopBussinessAreaView)-10-7,(HEIGHT(shopBussinessAreaView)-11)/2,7,11};
    [shopBussinessAreaView addSubview:shopBussinessAreaMoreImage];
    
    UIView *lineSepView4 = [[UIView alloc] init];
    lineSepView4.frame = (CGRect){0,HEIGHT(shopBussinessAreaView)-0.5,WIDTH(shopBussinessAreaView),0.5};
    lineSepView4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopBussinessAreaView addSubview:lineSepView4];
    
    viewOffset += viewHeight;
    
    viewOffset += 15;
    
    UIView *lineSepView5 = [[UIView alloc] init];
    lineSepView5.frame = (CGRect){0,viewOffset-0.5,WIDTH(contentView),0.5};
    lineSepView5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepView5];
    
    UIView *shopCityView = [[UIView alloc] init];
    shopCityView.backgroundColor = [UIColor whiteColor];
    shopCityView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopCityView];
    
    UILabel *shopCityNoteLabel = [[UILabel alloc] init];
    shopCityNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopCityView)};
    shopCityNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopCityNoteLabel.font = font;
    shopCityNoteLabel.attributedText = [self attributedStringWithString:@"* 所在城市"];
    [shopCityView addSubview:shopCityNoteLabel];
    
    
    shopCityTextFiled = [[UITextField alloc] init];
    shopCityTextFiled.frame = (CGRect){10+WIDTH(shopCityNoteLabel)+10,0,WIDTH(shopCityView)-(10+WIDTH(shopCityNoteLabel)+10)-10-11-5,HEIGHT(shopCityView)};
    shopCityTextFiled.textColor = RGBColor(100, 100, 100);
    shopCityTextFiled.font = font;
    shopCityTextFiled.tag = 104;
    shopCityTextFiled.textAlignment = NSTextAlignmentRight;
    shopCityTextFiled.delegate = self;
    shopCityTextFiled.returnKeyType = UIReturnKeyDone;
    shopCityTextFiled.placeholder = @"请选择";
    [shopCityTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopCityTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopCityView addSubview:shopCityTextFiled];
    
    UIButton *shopCityButton = [[UIButton alloc] init];
    shopCityButton.frame = (CGRect){10+WIDTH(shopCityNoteLabel)+10,0,WIDTH(shopCityView)-(10+WIDTH(shopCityNoteLabel)+10)-10-11-5,HEIGHT(shopCityView)};
    shopCityButton.tag = 104;
    [shopCityButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shopCityView addSubview:shopCityButton];
    
    UIImageView *shopCityMoreImage = [[UIImageView alloc]init];
    shopCityMoreImage.image = [UIImage imageNamed:@"more"];
    shopCityMoreImage.frame = (CGRect){WIDTH(shopCityView)-10-7,(HEIGHT(shopCityView)-11)/2,7,11};
    [shopCityView addSubview:shopCityMoreImage];
    
    UIView *lineSepView6 = [[UIView alloc] init];
    lineSepView6.frame = (CGRect){0,HEIGHT(shopCityView)-0.5,WIDTH(shopCityView),0.5};
    lineSepView6.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopCityView addSubview:lineSepView6];
    
    viewOffset += viewHeight;
    
    UIView *shopMapAddressView = [[UIView alloc] init];
    shopMapAddressView.backgroundColor = [UIColor whiteColor];
    shopMapAddressView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopMapAddressView];
    
    UILabel *shopMapAddressNoteLabel = [[UILabel alloc] init];
    shopMapAddressNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopMapAddressView)};
    shopMapAddressNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopMapAddressNoteLabel.font = font;
    shopMapAddressNoteLabel.attributedText = [self attributedStringWithString:@"* 位置"];
    [shopMapAddressView addSubview:shopMapAddressNoteLabel];
    
    shopMapAddressTextFiled = [[UITextField alloc] init];
    shopMapAddressTextFiled.frame = (CGRect){10+WIDTH(shopMapAddressNoteLabel)+10,0,WIDTH(shopMapAddressView)-(10+WIDTH(shopMapAddressNoteLabel)+10)-10-11-5,HEIGHT(shopMapAddressView)};
    shopMapAddressTextFiled.textColor = RGBColor(100, 100, 100);
    shopMapAddressTextFiled.font = font;
    shopMapAddressTextFiled.tag = 105;
    shopMapAddressTextFiled.textAlignment = NSTextAlignmentRight;
    shopMapAddressTextFiled.delegate = self;
    shopMapAddressTextFiled.returnKeyType = UIReturnKeyDone;
    shopMapAddressTextFiled.placeholder = @"请选择";
    [shopMapAddressTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopMapAddressTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopMapAddressView addSubview:shopMapAddressTextFiled];
    
    UIButton *shopMapAddressButton = [[UIButton alloc] init];
    shopMapAddressButton.frame = (CGRect){10+WIDTH(shopMapAddressNoteLabel)+10,0,WIDTH(shopMapAddressView)-(10+WIDTH(shopMapAddressNoteLabel)+10)-10-11-5,HEIGHT(shopMapAddressView)};
    shopMapAddressButton.tag = 105;
    [shopMapAddressButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shopMapAddressView addSubview:shopMapAddressButton];
    
    UIImageView *shopMapAddressMoreImage = [[UIImageView alloc]init];
    shopMapAddressMoreImage.image = [UIImage imageNamed:@"more"];
    shopMapAddressMoreImage.frame = (CGRect){WIDTH(shopMapAddressView)-10-7,(HEIGHT(shopMapAddressView)-11)/2,7,11};
    [shopMapAddressView addSubview:shopMapAddressMoreImage];
    
    UIView *lineSepView7 = [[UIView alloc] init];
    lineSepView7.frame = (CGRect){0,HEIGHT(shopMapAddressView)-0.5,WIDTH(shopMapAddressView),0.5};
    lineSepView7.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopMapAddressView addSubview:lineSepView7];
    
    
    viewOffset += viewHeight;
    
    UIView *shopDetailAddressView = [[UIView alloc] init];
    shopDetailAddressView.backgroundColor = [UIColor whiteColor];
    shopDetailAddressView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopDetailAddressView];
    
    UILabel *shopDetailAddressNoteLabel = [[UILabel alloc] init];
    shopDetailAddressNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopDetailAddressView)};
    shopDetailAddressNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopDetailAddressNoteLabel.font = font;
    shopDetailAddressNoteLabel.attributedText = [self attributedStringWithString:@"* 详细地址"];
    [shopDetailAddressView addSubview:shopDetailAddressNoteLabel];
    
    shopDetailAddressTextFiled = [[UITextField alloc] init];
    shopDetailAddressTextFiled.frame = (CGRect){10+WIDTH(shopDetailAddressNoteLabel)+10,0,WIDTH(shopDetailAddressView)-(10+WIDTH(shopDetailAddressNoteLabel)+10)-10-11-5,HEIGHT(shopDetailAddressView)};
    shopDetailAddressTextFiled.textColor = RGBColor(100, 100, 100);
    shopDetailAddressTextFiled.font = font;
    shopDetailAddressTextFiled.tag = 106;
    shopDetailAddressTextFiled.textAlignment = NSTextAlignmentRight;
    shopDetailAddressTextFiled.delegate = self;
    shopDetailAddressTextFiled.returnKeyType = UIReturnKeyDone;
    shopDetailAddressTextFiled.placeholder = @"请输入";
    [shopDetailAddressTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopDetailAddressTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopDetailAddressView addSubview:shopDetailAddressTextFiled];
    
    UIView *lineSepView8 = [[UIView alloc] init];
    lineSepView8.frame = (CGRect){0,HEIGHT(shopDetailAddressView)-0.5,WIDTH(shopDetailAddressView),0.5};
    lineSepView8.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopDetailAddressView addSubview:lineSepView8];
    
    viewOffset += viewHeight;
    
    UIView *shopContactorView = [[UIView alloc] init];
    shopContactorView.backgroundColor = [UIColor whiteColor];
    shopContactorView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopContactorView];
    
    UILabel *shopContactorNoteLabel = [[UILabel alloc] init];
    shopContactorNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopContactorView)};
    shopContactorNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopContactorNoteLabel.font = font;
    shopContactorNoteLabel.attributedText = [self attributedStringWithString:@"* 联系人"];
    [shopContactorView addSubview:shopContactorNoteLabel];
    
    
    shopContactorTextFiled = [[UITextField alloc] init];
    shopContactorTextFiled.frame = (CGRect){10+WIDTH(shopContactorNoteLabel)+10,0,WIDTH(shopContactorView)-(10+WIDTH(shopContactorNoteLabel)+10)-10-11-5,HEIGHT(shopContactorView)};
    shopContactorTextFiled.textColor = RGBColor(100, 100, 100);
    shopContactorTextFiled.font = font;
    shopContactorTextFiled.tag = 107;
    shopContactorTextFiled.textAlignment = NSTextAlignmentRight;
    shopContactorTextFiled.delegate = self;
    shopContactorTextFiled.returnKeyType = UIReturnKeyDone;
    shopContactorTextFiled.placeholder = @"联系人姓名";
    [shopContactorTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopContactorTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopContactorView addSubview:shopContactorTextFiled];
    
    UIView *lineSepView9 = [[UIView alloc] init];
    lineSepView9.frame = (CGRect){0,HEIGHT(shopContactorView)-0.5,WIDTH(shopContactorView),0.5};
    lineSepView9.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopContactorView addSubview:lineSepView9];
    
    viewOffset += viewHeight;
    
    UIView *shopContactorPhoneView = [[UIView alloc] init];
    shopContactorPhoneView.backgroundColor = [UIColor whiteColor];
    shopContactorPhoneView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopContactorPhoneView];
    
    UILabel *shopContactorPhoneNoteLabel = [[UILabel alloc] init];
    shopContactorPhoneNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopContactorPhoneView)};
    shopContactorPhoneNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopContactorPhoneNoteLabel.font = font;
    shopContactorPhoneNoteLabel.attributedText = [self attributedStringWithString:@"* 联系电话"];
    [shopContactorPhoneView addSubview:shopContactorPhoneNoteLabel];
    
    
    shopContactorPhoneTextFiled = [[UITextField alloc] init];
    shopContactorPhoneTextFiled.frame = (CGRect){10+WIDTH(shopContactorPhoneNoteLabel)+10,0,WIDTH(shopContactorPhoneView)-(10+WIDTH(shopContactorPhoneNoteLabel)+10)-10-11-5,HEIGHT(shopContactorPhoneView)};
    shopContactorPhoneTextFiled.textColor = RGBColor(100, 100, 100);
    shopContactorPhoneTextFiled.font = font;
    shopContactorPhoneTextFiled.tag = 108;
    shopContactorPhoneTextFiled.textAlignment = NSTextAlignmentRight;
    shopContactorPhoneTextFiled.delegate = self;
    shopContactorPhoneTextFiled.returnKeyType = UIReturnKeyDone;
    shopContactorPhoneTextFiled.placeholder = @"联系人电话";
    [shopContactorPhoneTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopContactorPhoneTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopContactorPhoneView addSubview:shopContactorPhoneTextFiled];
    
    UIView *lineSepView10 = [[UIView alloc] init];
    lineSepView10.frame = (CGRect){0,HEIGHT(shopContactorPhoneView)-0.5,WIDTH(shopContactorPhoneView),0.5};
    lineSepView10.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopContactorPhoneView addSubview:lineSepView10];
    
    viewOffset += viewHeight;
    
    viewOffset += 15;
    
    UIView *lineSepView11 = [[UIView alloc] init];
    lineSepView11.frame = (CGRect){0,viewOffset-0.5,WIDTH(contentView),0.5};
    lineSepView11.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:lineSepView11];
    
    UIView *shopLicenseView = [[UIView alloc] init];
    shopLicenseView.backgroundColor = [UIColor whiteColor];
    shopLicenseView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopLicenseView];
    
    UILabel *shopLicenseNoteLabel = [[UILabel alloc] init];
    shopLicenseNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopLicenseView)};
    shopLicenseNoteLabel.textColor = UN_RedColor;
    shopLicenseNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopLicenseNoteLabel.font = font;
    shopLicenseNoteLabel.attributedText = [self attributedStringWithString:@"* 营业执照"];
    [shopLicenseView addSubview:shopLicenseNoteLabel];
    
    haveLicenseButton = [[UIButton alloc] init];
    haveLicenseButton.tag = 0;
    haveLicenseButton.frame = (CGRect){10+WIDTH(shopLicenseNoteLabel)+10,0,(WIDTH(shopLicenseView)-(10+WIDTH(shopLicenseNoteLabel)+10))/2,HEIGHT(shopLicenseView)};
    [shopLicenseView addSubview:haveLicenseButton];
    [haveLicenseButton addTarget:self action:@selector(haveLicenseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    haveLicenseSelectedImage = [[UIImageView alloc] init];
    haveLicenseSelectedImage.frame = (CGRect){0,(HEIGHT(haveLicenseButton)-22)/2,22,22};
    haveLicenseSelectedImage.image = [UIImage imageNamed:@"unselected"];
    [haveLicenseButton addSubview:haveLicenseSelectedImage];
    
    UILabel *haveLicenseLabel = [[UILabel alloc] init];
    haveLicenseLabel.frame = (CGRect){RIGHT(haveLicenseSelectedImage)+10,0,WIDTH(haveLicenseButton)-(RIGHT(haveLicenseSelectedImage)+10)-10,HEIGHT(haveLicenseButton)};
    haveLicenseLabel.text = @"有";
    haveLicenseLabel.textAlignment = NSTextAlignmentLeft;
    haveLicenseLabel.textColor = RGBColor(80, 80, 80);
    haveLicenseLabel.font = Font(15);
    [haveLicenseButton addSubview:haveLicenseLabel];
    
    nonLicenseButton = [[UIButton alloc] init];
    nonLicenseButton.tag = 1;
    nonLicenseButton.frame = (CGRect){RIGHT(haveLicenseButton),0,(WIDTH(shopLicenseView)-(10+WIDTH(shopLicenseNoteLabel)+10))/2,HEIGHT(shopLicenseView)};
    [shopLicenseView addSubview:nonLicenseButton];
    [nonLicenseButton addTarget:self action:@selector(nonLicenseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    nonLicenseSelectedImage = [[UIImageView alloc] init];
    nonLicenseSelectedImage.frame = (CGRect){0,(HEIGHT( nonLicenseButton)-22)/2,22,22};
    nonLicenseSelectedImage.image = [UIImage imageNamed:@"selected"];
    [nonLicenseButton addSubview: nonLicenseSelectedImage];
    
    UILabel *nonLicenseLabel = [[UILabel alloc] init];
    nonLicenseLabel.frame = (CGRect){RIGHT( nonLicenseSelectedImage)+10,0,WIDTH( nonLicenseButton)-(RIGHT( nonLicenseSelectedImage)+10)-10,HEIGHT( nonLicenseButton)};
    nonLicenseLabel.text = @"无";
    nonLicenseLabel.textAlignment = NSTextAlignmentLeft;
    nonLicenseLabel.textColor = RGBColor(80, 80, 80);
    nonLicenseLabel.font = Font(15);
    [nonLicenseButton addSubview: nonLicenseLabel];
    
    
    UIView *lineSepView12 = [[UIView alloc] init];
    lineSepView12.frame = (CGRect){0,HEIGHT(shopLicenseView)-0.5,WIDTH(shopLicenseView),0.5};
    lineSepView12.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopLicenseView addSubview:lineSepView12];
    
    
    viewOffset += viewHeight;
    
    UIView *shopOtherView = [[UIView alloc] init];
    shopOtherView.backgroundColor = [UIColor whiteColor];
    shopOtherView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    [contentView addSubview:shopOtherView];
    
    UILabel *shopOtherNoteLabel = [[UILabel alloc] init];
    shopOtherNoteLabel.frame = (CGRect){10,0,90,HEIGHT(shopOtherView)};
    shopOtherNoteLabel.textColor = RGBColor(80, 80, 80);
    shopOtherNoteLabel.textAlignment = NSTextAlignmentLeft;
    shopOtherNoteLabel.font = font;
    shopOtherNoteLabel.text = @"其它平台链接";
    [shopOtherView addSubview:shopOtherNoteLabel];
    
    
    shopOtherTextFiled = [[UITextField alloc] init];
    shopOtherTextFiled.frame = (CGRect){10+WIDTH(shopOtherNoteLabel)+10,0,WIDTH(shopOtherView)-(10+WIDTH(shopOtherNoteLabel)+10)-10-11-5,HEIGHT(shopOtherView)};
    shopOtherTextFiled.textColor = RGBColor(100, 100, 100);
    shopOtherTextFiled.font = font;
    shopOtherTextFiled.tag = 110;
    shopOtherTextFiled.textAlignment = NSTextAlignmentRight;
    shopOtherTextFiled.delegate = self;
    shopOtherTextFiled.returnKeyType = UIReturnKeyDone;
    shopOtherTextFiled.placeholder = @"填写店铺链接";
    [shopOtherTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [shopOtherTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [shopOtherView addSubview:shopOtherTextFiled];
    
    UIView *lineSepView13 = [[UIView alloc] init];
    lineSepView13.frame = (CGRect){0,HEIGHT(shopOtherView)-0.5,WIDTH(shopOtherView),0.5};
    lineSepView13.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [shopOtherView addSubview:lineSepView13];
    
    viewOffset += viewHeight;
    
    contentView.contentSize = (CGSize){WIDTH(contentView),viewOffset>HEIGHT(contentView)?viewOffset:HEIGHT(contentView)+1};
    
    areaID = 0;
}

-(NSMutableAttributedString *)attributedStringWithString:(NSString *)string{
    if (!string) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *attriString;
    attriString = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *red = UN_RedColor;
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:(id)red.CGColor
                        range:NSMakeRange(0, 1)];
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:(id)[UIColor colorWithRed:80.f/255 green:80.f/255 blue:80.f/255 alpha:1].CGColor
                        range:NSMakeRange(1, attriString.length-1)];
    return attriString;
}

-(void)resignAllInput{
    [shopNameTextFiled resignFirstResponder];
    [shopTypeTextFiled resignFirstResponder];
    [shopBussinessAreaTextFiled resignFirstResponder];
    [shopCityTextFiled resignFirstResponder];
    [shopMapAddressTextFiled resignFirstResponder];
    [shopDetailAddressTextFiled resignFirstResponder];
    [shopContactorTextFiled resignFirstResponder];
    [shopContactorPhoneTextFiled resignFirstResponder];
    [shopOtherTextFiled resignFirstResponder];
}

-(void)contentViewTapGesture{
    [self resignAllInput];
}

-(void)haveLicenseButtonClick{
    [self resignAllInput];
    if (haveLicenseButton.tag == 0) {
        haveLicenseButton.tag = 1;
        nonLicenseButton.tag = 0;
        
        haveLicenseSelectedImage.image = [UIImage imageNamed:@"selected"];
        nonLicenseSelectedImage.image = [UIImage imageNamed:@"unselected"];
    }else{
        haveLicenseButton.tag = 0;
        
        haveLicenseSelectedImage.image = [UIImage imageNamed:@"unselected"];
    }
}

-(void)nonLicenseButtonClick{
    [self resignAllInput];
    if (nonLicenseButton.tag == 0) {
        nonLicenseButton.tag = 1;
        haveLicenseButton.tag = 0;
        
        haveLicenseSelectedImage.image = [UIImage imageNamed:@"unselected"];
        nonLicenseSelectedImage.image = [UIImage imageNamed:@"selected"];
        
    }else{
        nonLicenseButton.tag = 0;
        nonLicenseSelectedImage.image = [UIImage imageNamed:@"unselected"];
    }
}

-(void)pushButtonClick:(UIButton *)button{
    [self resignAllInput];
    switch (button.tag) {
        case 102:{
            ShopTypeChooseViewController *stcVC = [[ShopTypeChooseViewController alloc] init];
            stcVC.shopVC = self;
            [self.navigationController pushViewController:stcVC animated:YES];
        }
            break;
        case 103:{
            ShopBusinessAreaViewController *sbVC = [[ShopBusinessAreaViewController alloc] init];
            sbVC.shopVC = self;
            [self.navigationController pushViewController:sbVC animated:YES];
        }
            break;
        case 104:{
            ProvinceChooseViewController *pcVC = [[ProvinceChooseViewController alloc] init];
            pcVC.stopType = ChooseStopTypeCity;
            [pcVC setResultBlock:^(NSDictionary *resultDic){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.shopCity = resultDic[@"name"];
                    areaID = [resultDic[@"id"] longValue];
                });
            }];
            
            UINavigationController *areaChooseNavi = [[UINavigationController alloc] initWithRootViewController:pcVC];
            
            NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
            [areaChooseNavi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
            
            if ([areaChooseNavi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                NSArray *list = areaChooseNavi.navigationBar.subviews;
                for (id obj in list) {
                    if ([obj isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView=(UIImageView *)obj;
                        NSArray *ar = imageView.subviews;
                        [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                        imageView.hidden=YES;
                    }
                }
            }
            areaChooseNavi.view.backgroundColor = UN_RedColor;
            areaChooseNavi.navigationBar.barTintColor = UN_RedColor;
            areaChooseNavi.navigationBar.barStyle = UIBarStyleBlack;
            [self presentViewController:areaChooseNavi animated:YES completion:nil];
            
        }
            break;
        case 105:{
            NSLog(@"位置");
            MapAddressViewController *mapAVC = [[MapAddressViewController alloc] init];
            weak(weakself, self);
            mapAVC.resultBlock = ^(NSString *name,NSString *address,float latitude,float longitude){
                weakself.shopMapAddress = name;
                weakself.shopDetailAddress = address;
                weakself.shopMapLatitude = latitude;
                weakself.shopMapLongitude = longitude;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateView];
                });
            };
            [self.navigationController pushViewController:mapAVC animated:YES];
        }
            break;
        default:
            break;
    }
}


-(void)submitShopButtonClick{
    [self resignAllInput];
    NSString *shopNameTmp = shopNameTextFiled.text;
    if ([shopNameTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"商户名称不能包含空格"];
        return;
    }
    if (![self checkString:shopNameTmp]) {
        [self showAlertWithMessage:@"商户名称不能包含特殊字符"];
        return;
    }
    
    NSString *shopTypeTmp = shopTypeTextFiled.text;
    
    if ([shopTypeTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"商户类型不能包含空格"];
        return;
    }
    if (![self checkString:shopTypeTmp]) {
        [self showAlertWithMessage:@"商户类型不能包含特殊字符"];
        return;
    }
    
    NSString *shopBussinessAreaTmp = shopBussinessAreaTextFiled.text;
    if ([shopBussinessAreaTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"经营范围不能包含空格"];
        return;
    }
    if (![self checkString:shopBussinessAreaTmp]) {
        [self showAlertWithMessage:@"经营范围不能包含特殊字符"];
        return;
    }
    
    NSString *shopCityTmp = shopCityTextFiled.text;
    
    if ([shopCityTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"商户地区不能包含空格"];
        return;
    }
    if (![self checkString:shopCityTmp]) {
        [self showAlertWithMessage:@"商户地区不能包含特殊字符"];
        return;
    }
    
    NSString *shopMapAddressTmp = shopMapAddressTextFiled.text;
    if ([shopMapAddressTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"商户地址不能包含空格"];
        return;
    }
    if (![self checkString:shopMapAddressTmp]) {
        [self showAlertWithMessage:@"商户地址不能包含特殊字符"];
        return;
    }
    
    NSString *shopDetailTmp = shopDetailAddressTextFiled.text;
    
    if ([shopDetailTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"详细地址不能包含空格"];
        return;
    }
    if (![self checkString:shopDetailTmp]) {
        [self showAlertWithMessage:@"详细地址不能包含特殊字符"];
        return;
    }
    
    NSString *shopConnectorTmp = shopContactorTextFiled.text;
    if ([shopConnectorTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"联系人不能包含空格"];
        return;
    }
    if (![self checkString:shopConnectorTmp]) {
        [self showAlertWithMessage:@"联系人不能包含特殊字符"];
        return;
    }
    
    NSString *shopConnectorPhoneTmp = shopContactorPhoneTextFiled.text;
    
    if ([shopConnectorPhoneTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"联系电话不能包含空格"];
        return;
    }
    if (![self checkString:shopConnectorPhoneTmp]) {
        [self showAlertWithMessage:@"联系电话不能包含特殊字符"];
        return;
    }
    
    NSString *shopOtherTmp = shopOtherTextFiled.text;
    if ([shopOtherTmp rangeOfString:@" "].length != 0) {
        [self showAlertWithMessage:@"链接不能包含空格"];
        return;
    }
    
    BOOL hasLicense = NO;
    if (haveLicenseButton.tag == 0 && nonLicenseButton.tag == 0) {
        [self showAlertWithMessage:@"营业执照为必填项"];
        return;
    }else if (haveLicenseButton.tag == 1 && nonLicenseButton.tag == 1) {
        [self showAlertWithMessage:@"营业执照为单一选择项"];
        return;
    }else{
        if (haveLicenseButton.tag == 1) {
            hasLicense = YES;
        }
    }
    NSMutableDictionary *uploadParams = [NSMutableDictionary dictionary];
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        [BYToastView showToastWithMessage:@"未登录"];
        return;
    }
    [uploadParams setObject:token forKey:@"token"];
    [uploadParams setObject:uid forKey:@"uid"];
    [uploadParams setObject:shopNameTmp forKey:@"name"];
    NSString *shopLeibieUploadString = self.shopTypeDic[@"dbname"];
    if (!shopLeibieUploadString) {
        NSLog(@"商户类别 为空");
        return;
    }
    [uploadParams setObject:shopLeibieUploadString forKey:@"shop_type"];//商户类别
    NSString *shopAreaUploadString = self.shopBussinessAreaDic[@"dbname"];
    if (!shopAreaUploadString) {
        NSLog(@"商户经营范围 为空");
        return;
    }
    [uploadParams setObject:shopAreaUploadString forKey:@"scope_of_business"];//商户经营范围
    
    [uploadParams setObject:shopCityTmp forKey:@"city"];//所在城市
    [uploadParams setObject:@(areaID) forKey:@"areaId"];//所在城市ID
    [uploadParams setObject:shopMapAddressTmp forKey:@"poi_name"];//位置
    [uploadParams setObject:shopDetailTmp forKey:@"address"];//详细地址
    [uploadParams setObject:@((float)(self.shopMapLatitude)) forKey:@"latitude"];//经度
    [uploadParams setObject:@((float)(self.shopMapLongitude)) forKey:@"longitude"];//纬度
    [uploadParams setObject:shopConnectorTmp forKey:@"contacts"];//联系人
    [uploadParams setObject:shopConnectorPhoneTmp forKey:@"contact_number"];//联系电话
    if (hasLicense) {
        [uploadParams setObject:@"true" forKey:@"business_license"];//营业执照
    }else{
        [uploadParams setObject:@"false" forKey:@"business_license"];//营业执照
    }
    if (![shopOtherTmp isEqualToString:@""]) {
        [uploadParams setObject:shopOtherTmp forKey:@"other_shop_url"];//其它店铺连接
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    __block XYW8IndicatorView *indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor blackColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    indicatorView.loadingLabel.text = @"正在请求入驻...";
    [indicatorView startAnimating];
    
    long long timestart = [[NSDate date] timeIntervalSince1970];
    
    [UNUrlConnection addShopPostWithParams:uploadParams complete:^(NSDictionary *resultDic, NSString *errorString) {
        long long timeend = [[NSDate date] timeIntervalSince1970];
        
        float delay = timeend-timestart >7?0.2:7-(timeend-timestart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            NSDictionary *messDic = resultDic[@"message"];
            NSString *typeString = messDic[@"type"];
            if (typeString && [typeString isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"商户入驻成功,欢迎您加入"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSString *contentString = messDic[@"content"];
                if (contentString) {
                    [BYToastView showToastWithMessage:contentString];
                }else{
                    [BYToastView showToastWithMessage:@"入驻失败"];
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

-(void)showAlertWithMessage:(NSString *)string{
    [self resignAllInput];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil] show];
}

-(void)updateView{
    [self resignAllInput];
    //    if (self.shopName) {
    //        shopNameTextFiled.text = self.shopName;
    //    }else{
    //        shopNameTextFiled.text = @"";
    //    }
    if (self.shopTypeDic) {
        shopTypeTextFiled.text = [self.shopTypeDic objectForKey:@"name"];
    }else{
        shopTypeTextFiled.text = @"";
    }
    if (self.shopBussinessAreaDic) {
        shopBussinessAreaTextFiled.text = [self.shopBussinessAreaDic objectForKey:@"name"];
    }else{
        shopBussinessAreaTextFiled.text = @"";
    }
    if (self.shopCity) {
        shopCityTextFiled.text = self.shopCity;
    }else{
        shopCityTextFiled.text = @"";
    }
    if (self.shopMapAddress) {
        shopMapAddressTextFiled.text = self.shopMapAddress;
    }else{
        shopMapAddressTextFiled.text = @"";
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self resignAllInput];
    [self.navigationController popViewControllerAnimated:YES];
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
