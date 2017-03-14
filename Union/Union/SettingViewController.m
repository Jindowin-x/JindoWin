//
//  SettingViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "SettingViewController.h"
#import "PostSuggestViewController.h"
#import "LabelShowedViewController.h"
#import "UNUserDefaults.h"

@interface SettingViewController () <UIAlertViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;

@end

@implementation SettingViewController

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    float offset = 20;
    float buttonHeight= 45.f;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line1.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line1];
    
    UIButton *ideaReportButton = [[UIButton alloc] init];
    ideaReportButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    ideaReportButton.backgroundColor = RGBColor(255, 255, 255);;
    [contentView addSubview:ideaReportButton];
    ideaReportButton.tag = 0;
    [ideaReportButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonHeight;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line2.frame = (CGRect){20,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line2];
    
    UIButton *tiaokuanButton = [[UIButton alloc] init];
    tiaokuanButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    tiaokuanButton.backgroundColor = RGBColor(255, 255, 255);;
    [contentView addSubview:tiaokuanButton];
    tiaokuanButton.tag = 1;
    [tiaokuanButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonHeight;
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line3.frame = (CGRect){20,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line3];
    
    //    UIButton *gengxinButton = [[UIButton alloc] init];
    //    gengxinButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    //    gengxinButton.backgroundColor = RGBColor(255, 255, 255);;
    //    [contentView addSubview:gengxinButton];
    //    gengxinButton.tag = 2;
    //    [gengxinButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    
    //    offset += buttonHeight;
    //    
    //    UIView *line4 = [[UIView alloc] init];
    //    line4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    //    line4.frame = (CGRect){20,offset-0.5,WIDTH(line1),0.5};
    //    [contentView addSubview:line4];
    
    UIButton *aboutButton = [[UIButton alloc] init];
    aboutButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    aboutButton.backgroundColor = RGBColor(255, 255, 255);;
    [contentView addSubview:aboutButton];
    aboutButton.tag = 3;
    [aboutButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonHeight;
    
    UIView *line5 = [[UIView alloc] init];
    line5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line5.frame = (CGRect){0,offset-0.5,WIDTH(line1),0.5};
    [contentView addSubview:line5];
    
    [self settingButtonSetupInButton:ideaReportButton text:@"意见反馈"];
    [self settingButtonSetupInButton:tiaokuanButton text:@"服务条款"];
    //    [self settingButtonSetupInButton:gengxinButton text:@"检查更新"];
    [self settingButtonSetupInButton:aboutButton text:@"关于我们"];
    
    UIButton *zhuxiaoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zhuxiaoButton.frame = (CGRect){20,offset+20,WIDTH(contentView)-20*2,40};
    zhuxiaoButton.backgroundColor = UN_RedColor;
    [zhuxiaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhuxiaoButton.titleLabel.font = Font(16);
    [zhuxiaoButton setTitle:@"退出当前账户" forState:UIControlStateNormal];
    [zhuxiaoButton addTarget:self action:@selector(zhuxiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    zhuxiaoButton.layer.cornerRadius = 2.f;
    zhuxiaoButton.layer.masksToBounds = YES;
    [contentView addSubview:zhuxiaoButton];
    
}

-(void)settingButtonSetupInButton:(UIButton *)button text:(NSString *)text{
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){20,0,WIDTH(button)-60,HEIGHT(button)}];
    label.text = text;
    label.textColor = RGBColor(50, 50, 50);
    label.font = Font(14);
    [button addSubview:label];
    
    //11
    UIImageView *moreImage = [[UIImageView alloc] init];
    moreImage.image = [UIImage imageNamed:@"more"];
    moreImage.frame = (CGRect){WIDTH(button)-30,(HEIGHT(button)-11)/2,7,11};
    [button addSubview:moreImage];
}

-(void)scrollerButtonClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            //意见反馈
            PostSuggestViewController *psVC = [[PostSuggestViewController alloc] init];
            [self.navigationController pushViewController:psVC animated:YES];
        }
            break;
        case 1:{
            //服务条款
            LabelShowedViewController *lsVC = [[LabelShowedViewController alloc] init];
            lsVC.type = LabelShowedTypeService;
            [self.navigationController pushViewController:lsVC animated:YES];
        }
            break;
        case 2:{
            //检查更新
        }
            break;
        case 3:{
            //关于我们
            LabelShowedViewController *lsVC = [[LabelShowedViewController alloc] init];
            lsVC.type = LabelShowedTypeAbloutUs;
            [self.navigationController pushViewController:lsVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)zhuxiaoButtonClick:(UIButton *)button{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销吗" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"注销", nil];
    alert.tag = 404;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 404) {
        if (buttonIndex == 1) {
            [UNUserDefaults resetLoginStatus];
            [BYToastView showToastWithMessage:@"注销成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

@end
