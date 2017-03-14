//
//  UserViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UserViewController.h"

#import "UserLoginViewController.h"
#import "UserProfileViewController.h"
#import "MyCashViewController.h"
#import "VoucherViewController.h"
#import "MyRefundViewController.h"
#import "MyAdressViewController.h"
#import "InfomationViewController.h"
#import "CollectViewController.h"
#import "AllJugdeViewController.h"
#import "FastQAViewController.h"
#import "AddShopViewController.h"
#import "MyPostsViewController.h"
#import "SettingViewController.h"

#import "BYToastView.h"
#import "UNUrlConnection.h"

@interface UserViewController () <UINavigationControllerDelegate>

@property (nonatomic,strong) UIImageView *userBackImage;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,strong) UILabel *userAccountLabel;
@property (nonatomic,strong) UIImageView *userHeadImage;
@end

@implementation UserViewController{
    NSString *callnumber;
}

@synthesize userBackImage,userHeadImage,userAccountLabel;

@synthesize mainScroller;

static float UserBackImageHeight = 160;
-(void)viewDidLoad{
    
    
    self.view.backgroundColor = UN_WhiteColor;
    
    callnumber = @"400-999-9999";
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,0,WIDTH(self.view),HEIGHT(self.view)};
    contentView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:contentView];
    
    UIButton *userBackButton = [[UIButton alloc] init];
    userBackButton.frame = (CGRect){0,0,WIDTH(self.view),UserBackImageHeight+20};
    [contentView addSubview:userBackButton];
    [userBackButton addTarget:self action:@selector(backImageTapGesture) forControlEvents:UIControlEventTouchUpInside];
    
    userBackImage = [[UIImageView alloc] init];
    userBackImage.image = [UIImage imageNamed:@"bg_person"];
    userBackImage.frame = (CGRect){0,0,WIDTH(self.view),HEIGHT(userBackButton)};
    [userBackButton addSubview:userBackImage];
    
    UIImageView *userBackImage2 = [[UIImageView alloc] init];
    userBackImage2.image = [UIImage imageNamed:@"bg_person"];
    userBackImage2.frame = (CGRect){0,UserBackImageHeight,WIDTH(self.view),UserBackImageHeight};
    [contentView addSubview:userBackImage2];
    
    //79
    userHeadImage = [[UIImageView alloc] init];
    userHeadImage.image = [UIImage imageNamed:@"user_headimg"];
    userHeadImage.frame = (CGRect){(WIDTH(userBackImage)-80)/2,30,80,80};
    userHeadImage.layer.cornerRadius = 40;
    userHeadImage.layer.masksToBounds = YES;
    [userBackImage addSubview:userHeadImage];
    
    userAccountLabel = [[UILabel alloc] init];
    userAccountLabel.text = @"13646464637";
    userAccountLabel.textColor = [UIColor whiteColor];
    userAccountLabel.frame = (CGRect){(WIDTH(userBackImage)-200)/2,BOTTOM(userHeadImage)+10,200,25};
    userAccountLabel.textAlignment = NSTextAlignmentCenter;
    userAccountLabel.font = Font(15);
    [userBackImage addSubview:userAccountLabel];
    
    UIView *functionAreaView = [[UIView alloc] init];
    functionAreaView.frame = (CGRect){0,UserBackImageHeight,WIDTH(self.view),75};
    functionAreaView.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:functionAreaView];
    
    int everyButtonWidth = (int)lroundf(WIDTH(functionAreaView)/3);
    //我的余额
    UIButton *yuebutton = [[UIButton alloc] init];
    yuebutton.frame = (CGRect){0,0,everyButtonWidth,HEIGHT(functionAreaView)};
    [functionAreaView addSubview:yuebutton];
    [yuebutton addTarget:self action:@selector(yueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *yueImage = [[UIImageView alloc] init];
    yueImage.image = [UIImage imageNamed:@"user_yue"];
    yueImage.frame = (CGRect){(WIDTH(yuebutton)-25)/2,15,25,25};
    [yuebutton addSubview:yueImage];
    
    
    UILabel *yueLable = [[UILabel alloc] init];
    yueLable.frame = (CGRect){0,BOTTOM(yueImage)+5,WIDTH(yuebutton),15};
    yueLable.text = @"我的余额";
    yueLable.textColor = RGBColor(140, 140, 140);
    yueLable.textAlignment = NSTextAlignmentCenter;
    yueLable.font = Font(11);
    [yuebutton addSubview:yueLable];
    
    
    UIView *yueSepline = [[UIView alloc] init];
    yueSepline.frame = (CGRect){RIGHT(yuebutton)-0.5,0,0.5,HEIGHT(yuebutton)};
    yueSepline.backgroundColor = UN_LineSeperateColor;
    [functionAreaView addSubview:yueSepline];
    
    //我的代金券
    UIButton *daijinquanbutton = [[UIButton alloc] init];
    daijinquanbutton.frame = (CGRect){everyButtonWidth,0,everyButtonWidth,HEIGHT(functionAreaView)};
    [functionAreaView addSubview:daijinquanbutton];
    [daijinquanbutton addTarget:self action:@selector(daijinquanbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *daijinquanImage = [[UIImageView alloc] init];
    daijinquanImage.image = [UIImage imageNamed:@"uiser_daijinquan"];
    daijinquanImage.frame = (CGRect){(WIDTH(daijinquanbutton)-25)/2,15,25,25};
    [daijinquanbutton addSubview:daijinquanImage];
    
    
    UILabel *daijinquanLable = [[UILabel alloc] init];
    daijinquanLable.frame = (CGRect){0,BOTTOM(daijinquanImage)+5,WIDTH(daijinquanbutton),15};
    daijinquanLable.text = @"我的代金券";
    daijinquanLable.textColor = RGBColor(140, 140, 140);
    daijinquanLable.textAlignment = NSTextAlignmentCenter;
    daijinquanLable.font = Font(11);
    [daijinquanbutton addSubview:daijinquanLable];
    
    UIView *daijinquanSepline = [[UIView alloc] init];
    daijinquanSepline.frame = (CGRect){RIGHT(daijinquanbutton)-0.5,0,0.5,HEIGHT(daijinquanbutton)};
    daijinquanSepline.backgroundColor = UN_LineSeperateColor;
    [functionAreaView addSubview:daijinquanSepline];
    
    //我的代金券
    UIButton *tuikuanbutton = [[UIButton alloc] init];
    tuikuanbutton.frame = (CGRect){RIGHT(daijinquanbutton),0,WIDTH(functionAreaView)-everyButtonWidth*2,HEIGHT(functionAreaView)};
    [functionAreaView addSubview:tuikuanbutton];
    [tuikuanbutton addTarget:self action:@selector(tuikuanbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *tuikuanImage = [[UIImageView alloc] init];
    tuikuanImage.image = [UIImage imageNamed:@"user_tuikuan"];
    tuikuanImage.frame = (CGRect){(WIDTH(tuikuanbutton)-25)/2,15,25,25};
    [tuikuanbutton addSubview:tuikuanImage];
    
    UILabel *tuikuanLable = [[UILabel alloc] init];
    tuikuanLable.frame = (CGRect){0,BOTTOM(tuikuanImage)+5,WIDTH(tuikuanbutton),15};
    tuikuanLable.text = @"我的退款";
    tuikuanLable.textColor = RGBColor(140, 140, 140);
    tuikuanLable.textAlignment = NSTextAlignmentCenter;
    tuikuanLable.font = Font(11);
    [tuikuanbutton addSubview:tuikuanLable];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(functionAreaView)-0.5,WIDTH(functionAreaView),0.5};
    sepLine.backgroundColor = UN_CellLineSeperateColor;
    [functionAreaView addSubview:sepLine];
    
    mainScroller = [[UIScrollView alloc] init];
    mainScroller.frame = (CGRect){0,BOTTOM(functionAreaView),WIDTH(self.view),HEIGHT(self.view)-UserBackImageHeight-HEIGHT(functionAreaView)};
    mainScroller.contentSize = (CGSize){WIDTH(contentView),10000};
    mainScroller.backgroundColor = RGBColor(245, 245, 245);
    mainScroller.showsHorizontalScrollIndicator = NO;
    mainScroller.showsVerticalScrollIndicator = NO;
    [contentView addSubview:mainScroller];
    
    [self setupScrollerContents];
}

-(void)yueButtonClick:(UIButton *)button{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
        [self pushToLogin];
        return;
    }
    MyCashViewController *cashVC = [[MyCashViewController alloc] init];
    [self pushToViewController:cashVC];
}

-(void)daijinquanbuttonClick:(UIButton *)button{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
        [self pushToLogin];
        return;
    }
    VoucherViewController *vvc = [[VoucherViewController alloc] init];
    [self pushToViewController:vvc];
}

-(void)tuikuanbuttonClick:(UIButton *)button{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
        [self pushToLogin];
        return;
    }
    MyRefundViewController *revc = [[MyRefundViewController alloc] init];
    [self pushToViewController:revc];
}

-(void)backImageTapGesture{
    [self pushToUserProfileViewController];
}

-(void)pushToUserProfileViewController{
    if ([UNUserDefaults getIsLogin]) {
        UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
        upvc.phoneNumber = userAccountLabel.text;
        upvc.userImage = userHeadImage.image;
        upvc.userViewController = self;
        [self pushToViewController:upvc];
    }else{
        [self pushToLogin];
    }
}

-(void)pushToLogin{
    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:[UserLoginViewController new]];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
    [loginNavi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    if ([loginNavi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = loginNavi.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *ar = imageView.subviews;
                [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                imageView.hidden=YES;
            }
        }
    }
    loginNavi.view.backgroundColor = UN_RedColor;
    loginNavi.navigationBar.barTintColor = UN_RedColor;
    loginNavi.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:loginNavi animated:YES completion:nil];
}

-(void)setupScrollerContents{
    float offset = 15.f;
    float buttonheight = 40.f;
    
    UIView *sepline1 = [[UIView alloc] init];
    sepline1.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline1.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline1];
    
    UIButton *shuohuobutton = [[UIButton alloc] init];
    shuohuobutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    shuohuobutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:shuohuobutton];
    shuohuobutton.tag = 1;
    [shuohuobutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline2 = [[UIView alloc] init];
    sepline2.frame = (CGRect){30,offset-0.5,WIDTH(mainScroller),0.5};
    sepline2.backgroundColor = UN_LineSeperateColor;
    [mainScroller addSubview:sepline2];
    
    UIButton *xiaoxibutton = [[UIButton alloc] init];
    xiaoxibutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    xiaoxibutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:xiaoxibutton];
    xiaoxibutton.tag = 2;
    [xiaoxibutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline3 = [[UIView alloc] init];
    sepline3.frame = (CGRect){30,offset-0.5,WIDTH(mainScroller),0.5};
    sepline3.backgroundColor = UN_LineSeperateColor;
    [mainScroller addSubview:sepline3];
    
    UIButton *shoucangbutton = [[UIButton alloc] init];
    shoucangbutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    shoucangbutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:shoucangbutton];
    shoucangbutton.tag = 3;
    [shoucangbutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline4 = [[UIView alloc] init];
    sepline4.frame = (CGRect){30,offset-0.5,WIDTH(mainScroller),0.5};
    sepline4.backgroundColor = UN_LineSeperateColor;
    [mainScroller addSubview:sepline4];
    
    UIButton *pinglunbutton = [[UIButton alloc] init];
    pinglunbutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    pinglunbutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:pinglunbutton];
    pinglunbutton.tag = 4;
    [pinglunbutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline5 = [[UIView alloc] init];
    sepline5.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline5.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline5];
    
    offset += 10;
    
    UIView *sepline6 = [[UIView alloc] init];
    sepline6.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline6.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline6];
    
    UIButton *wentibutton = [[UIButton alloc] init];
    wentibutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    wentibutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:wentibutton];
    wentibutton.tag = 5;
    [wentibutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline7 = [[UIView alloc] init];
    sepline7.frame = (CGRect){30,offset-0.5,WIDTH(mainScroller),0.5};
    sepline7.backgroundColor = UN_LineSeperateColor;
    [mainScroller addSubview:sepline7];
    
    UIButton *shopbutton = [[UIButton alloc] init];
    shopbutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    shopbutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:shopbutton];
    shopbutton.tag = 6;
    [shopbutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline8 = [[UIView alloc] init];
    sepline8.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline8.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline8];
    
    offset += 10;
    
    UIView *sepline9 = [[UIView alloc] init];
    sepline9.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline9.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline9];
    
    UIButton *fabubutton = [[UIButton alloc] init];
    fabubutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    fabubutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:fabubutton];
    fabubutton.tag = 7;
    [fabubutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline10 = [[UIView alloc] init];
    sepline10.frame = (CGRect){30,offset-0.5,WIDTH(mainScroller),0.5};
    sepline10.backgroundColor = UN_LineSeperateColor;
    [mainScroller addSubview:sepline10];
    
    UIButton *settingbutton = [[UIButton alloc] init];
    settingbutton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    settingbutton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:settingbutton];
    settingbutton.tag = 8;
    [settingbutton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    offset += buttonheight;
    
    UIView *sepline11 = [[UIView alloc] init];
    sepline11.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline11.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline11];
    
    [self bottomButtonSetupInButton:shuohuobutton imagename:@"user_adrress" text:@"收货地址管理"];
    [self bottomButtonSetupInButton:xiaoxibutton imagename:@"user_chat" text:@"我的消息"];
    [self bottomButtonSetupInButton:shoucangbutton imagename:@"user_collect" text:@"我的收藏"];
    [self bottomButtonSetupInButton:pinglunbutton imagename:@"user_judgement" text:@"我的评论"];
    [self bottomButtonSetupInButton:wentibutton imagename:@"user_question" text:@"常见问题"];
    [self bottomButtonSetupInButton:shopbutton imagename:@"user_shop" text:@"我是商家"];
    [self bottomButtonSetupInButton:fabubutton imagename:@"user_agreement" text:@"我发布的信息"];
    [self bottomButtonSetupInButton:settingbutton imagename:@"user_setting" text:@"设置"];
    
    offset += 10;
    
    UIView *sepline12 = [[UIView alloc] init];
    sepline12.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline12.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline12];
    
    UIButton *callButton = [[UIButton alloc] init];
    callButton.frame = (CGRect){0,offset,WIDTH(mainScroller),buttonheight};
    callButton.backgroundColor = RGBColor(255, 255, 255);;
    [mainScroller addSubview:callButton];
    callButton.tag = 9;
    [callButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *callImage = [[UIImageView alloc] init];
    callImage.image = [UIImage imageNamed:@"user_call"];
    callImage.frame = (CGRect){(WIDTH(mainScroller)-170)/2,(HEIGHT(callButton)-21)/2,21,21};
    [callButton addSubview:callImage];
    
    UILabel *callLabel = [[UILabel alloc] init];
    callLabel.frame = (CGRect){RIGHT(callImage)+4,0,150,HEIGHT(callButton)};
    callLabel.text = [NSString stringWithFormat:@"客服: %@",callnumber];
    callLabel.textColor = UN_RedColor;
    callLabel.font = Font(15);
    [callButton addSubview:callLabel];
    
    offset += buttonheight;
    
    UIView *sepline13 = [[UIView alloc] init];
    sepline13.frame = (CGRect){0,offset-0.5,WIDTH(mainScroller),0.5};
    sepline13.backgroundColor = UN_CellLineSeperateColor;
    [mainScroller addSubview:sepline13];
    
    mainScroller.contentSize = (CGSize){WIDTH(mainScroller),offset+UN_TabbarHeight+20};
}

-(void)bottomButtonSetupInButton:(UIButton *)button imagename:(NSString *)imagename text:(NSString *)text{
    int imageheight = 21;
    
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:imagename];
    image.frame = (CGRect){10,(HEIGHT(button)-imageheight)/2,imageheight,imageheight};
    [button addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){40,0,WIDTH(button)-60,HEIGHT(button)}];
    label.text = text;
    label.textColor = RGBColor(50, 50, 50);
    label.font = Font(13);
    [button addSubview:label];
    
    //11
    UIImageView *moreImage = [[UIImageView alloc] init];
    moreImage.image = [UIImage imageNamed:@"more"];
    moreImage.frame = (CGRect){WIDTH(button)-30,(HEIGHT(button)-11)/2,7,11};
    [button addSubview:moreImage];
}

-(void)scrollerButtonClick:(UIButton *)button{
    int butTag = (int)button.tag;
    switch (butTag) {
        case 1:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我的收货地址
            MyAdressViewController *advc = [[MyAdressViewController alloc] init];
            [self pushToViewController:advc];
        }
            break;
        case 2:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我的消息
            InfomationViewController *vc = [[InfomationViewController alloc] init];
            [self pushToViewController:vc];
        }
            break;
        case 3:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我的收藏
            CollectViewController *cvc = [[CollectViewController alloc] init];
            [self pushToViewController:cvc];
            
        }
            break;
        case 4:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我的评论
            AllJugdeViewController *avc = [[AllJugdeViewController alloc] init];
            [self pushToViewController:avc];
        }
            break;
        case 5:{
            //常见问题
            FastQAViewController *fqaVC = [[FastQAViewController alloc] init];
            [self pushToViewController:fqaVC];
        }
            break;
        case 6:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我是商家
            AddShopViewController *asVC = [[AddShopViewController alloc] init];
            [self pushToViewController:asVC];
        }
            break;
        case 7:{
            if (![UNUserDefaults getIsLogin]) {
                [BYToastView showToastWithMessage:@"您还未登录,请先登录"];
                [self pushToLogin];
                return;
            }
            //我发布的信息
            MyPostsViewController *mpVC = [[MyPostsViewController alloc] init];
            [self pushToViewController:mpVC];
        }
            break;
        case 8:{
            //设置
            SettingViewController *sevc = [[SettingViewController alloc] init];
            [self pushToViewController:sevc];
        }
            break;
        default:
            break;
    }
}

-(void)pushToViewController:(UIViewController *)vc{
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

-(void)callButtonClick:(UIButton *)button{
    UIAlertView *callAlert  = [[UIAlertView alloc] initWithTitle:@"拨号确认" message:[NSString stringWithFormat:@"确定拨打电话给%@吗？",callnumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [callAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[callnumber stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
    }
}

-(void)updateView{
    if (userAccountLabel) {
        if ([UNUserDefaults getIsLogin]) {
            userAccountLabel.text = [UNUserDefaults getUserPhone];
            UIImage *headImage = [UNUserDefaults getUserHeadImage];
            NSString *headImageUrl = [UNUserDefaults getUserHeadImageUrl];
            if (headImage) {
                self.headImage = headImage;
            }
            if (userHeadImage && self.headImage) {
                userHeadImage.image = self.headImage;
            }else{
                userHeadImage.image = [UIImage imageNamed:@"user_headimg"];
            }
            [UNUrlConnection getUserHeadImageComplete:^(NSDictionary *resultDic, NSString *errorString) {
                if (errorString) {
                    [BYToastView showToastWithMessage:errorString];
                    return;
                }
                NSDictionary *messageDic = resultDic[@"message"];
                NSString *typeString = messageDic[@"type"];
                if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                    NSDictionary *contentDic = resultDic[@"content"];
                    if (contentDic && [contentDic isKindOfClass:[NSDictionary class]] && contentDic.count > 0) {
                        NSString *headPic = contentDic[@"headpic"];
                        if (headPic && [headPic isKindOfClass:[NSString class]] &&
                            ![headPic isEqualToString:@""] &&
                            ![headPic isEqualToString:@"nil"] &&
                            ![headPic isEqualToString:@"null"] &&
                            ![headPic isEqualToString:@"<null>"]) {
                            [UNUserDefaults setUserHeadImageUrl:headPic];
                            if (headPic) {
                                [userHeadImage setImageWithURL:[NSURL URLWithString:headPic]];
                            }
                        }
                    }
                }
            }];
            if (headImageUrl) {
                [userHeadImage setImageWithURL:[NSURL URLWithString:headImageUrl]];
            }
        }else{
            userAccountLabel.text = @"登录/注册";
            userHeadImage.image = [UIImage imageNamed:@"user_headimg"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    
    [self updateView];
}

-(void)setUpNavigation{
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
}

@end
