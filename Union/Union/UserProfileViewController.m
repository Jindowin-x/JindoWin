//
//  UserProfileViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PhotoLibraryChooseView.h"
#import "TOCropViewController.h"
#import "LoginForgetSecondViewController.h"

#import "UIImage+Scale.h"
#import "UserViewController.h"
#import "UNUrlConnection.h"
#import "UNUserDefaults.h"

@interface UserProfileViewController () <PhotoLibraryChooseViewDelegate,TOCropViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,strong) UIImageView *headSetImage;

@property (nonatomic,strong) UILabel *phoneNumberLabel;

@end

@implementation UserProfileViewController{
    PhotoLibraryChooseView *chooseView;
}

@synthesize contentView,phoneNumberLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    
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
    float buttonHeight= 50.f;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line1.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line1];
    
    UIButton *headImageButton = [[UIButton alloc] init];
    headImageButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    headImageButton.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:headImageButton];
    headImageButton.tag = 0;
    [headImageButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *headImageLabel = [[UILabel alloc] init];
    headImageLabel.frame = (CGRect){15,0,WIDTH(headImageButton)-15-7-45-10,HEIGHT(headImageButton)};
    headImageLabel.text = @"头像";
    headImageLabel.textColor = RGBColor(80, 80, 80);
    headImageLabel.textAlignment = NSTextAlignmentLeft;
    headImageLabel.font = Font(15);
    [headImageButton addSubview:headImageLabel];
    
    self.headSetImage = [[UIImageView alloc] init];
    self.headSetImage.frame = (CGRect){WIDTH(headImageButton)-15-11-10-40,5,40,40};
    self.headSetImage.layer.cornerRadius = WIDTH(self.headSetImage)/2;
    self.headSetImage.layer.masksToBounds = YES;
    [headImageButton addSubview:self.headSetImage];
    
    UIImageView *moreImage = [[UIImageView alloc] init];
    moreImage.image = [UIImage imageNamed:@"more"];
    moreImage.frame = (CGRect){WIDTH(headImageButton)-15-7,(HEIGHT(headImageButton)-11)/2,7,11};
    [headImageButton addSubview:moreImage];

    offset += buttonHeight;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line2.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line2];
    
    offset += 5;
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line3.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line3];
    
    UIButton *phoneNumberButton = [[UIButton alloc] init];
    phoneNumberButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    phoneNumberButton.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:phoneNumberButton];
    phoneNumberButton.tag = 1;
    [phoneNumberButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *phoneNumberNoteLabel = [[UILabel alloc] init];
    phoneNumberNoteLabel.frame = (CGRect){15,0,100,HEIGHT(phoneNumberButton)};
    phoneNumberNoteLabel.text = @"手机号";
    phoneNumberNoteLabel.textColor = RGBColor(80, 80, 80);
    phoneNumberNoteLabel.textAlignment = NSTextAlignmentLeft;
    phoneNumberNoteLabel.font = Font(15);
    [phoneNumberButton addSubview:phoneNumberNoteLabel];
    
    phoneNumberLabel = [[UILabel alloc] init];
    phoneNumberLabel.frame = (CGRect){15+WIDTH(phoneNumberNoteLabel),0,WIDTH(phoneNumberButton)-15-15-100,HEIGHT(phoneNumberButton)};
    phoneNumberLabel.textAlignment = NSTextAlignmentRight;
    phoneNumberLabel.textColor = RGBColor(80, 80, 80);
    phoneNumberLabel.font = Font(15);
    [phoneNumberButton addSubview:phoneNumberLabel];
    
    
//    UIImageView *phoneNumberMoreImage = [[UIImageView alloc] init];
//    phoneNumberMoreImage.image = [UIImage imageNamed:@"more"];
//    phoneNumberMoreImage.frame = (CGRect){WIDTH(phoneNumberButton)-15-7,(HEIGHT(phoneNumberButton)-11)/2,7,11};
//    [phoneNumberButton addSubview:phoneNumberMoreImage];
    
    offset += buttonHeight;
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line4.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line4];
    
    offset += 5;
    
    UIView *line5 = [[UIView alloc] init];
    line5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line5.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line5];
    
    UIButton *passwordButton = [[UIButton alloc] init];
    passwordButton.frame = (CGRect){0,offset,WIDTH(contentView),buttonHeight};
    passwordButton.backgroundColor = RGBColor(255, 255, 255);
    [contentView addSubview:passwordButton];
    passwordButton.tag = 2;
    [passwordButton addTarget:self action:@selector(scrollerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.frame = (CGRect){15,0,WIDTH(passwordButton)-15-15-100,HEIGHT(passwordButton)};
    passwordLabel.text = @"修改密码";
    passwordLabel.textAlignment = NSTextAlignmentRight;
    passwordLabel.textColor = RGBColor(80, 80, 80);
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.font = Font(15);
    [passwordButton addSubview:passwordLabel];
    
    UIImageView *passwordMoreImage = [[UIImageView alloc] init];
    passwordMoreImage.image = [UIImage imageNamed:@"more"];
    passwordMoreImage.frame = (CGRect){WIDTH(passwordButton)-15-7,(HEIGHT(passwordButton)-11)/2,7,11};
    [passwordButton addSubview:passwordMoreImage];
    
    offset += buttonHeight;
    
    UIView *line6 = [[UIView alloc] init];
    line6.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    line6.frame = (CGRect){0,offset-0.5,WIDTH(contentView),0.5};
    [contentView addSubview:line6];
    
    offset += 5;
    
    
    [self updateView];
}

-(void)scrollerButtonClick:(UIButton *)button{
    switch (button.tag) {
        case 0:{
            chooseView = [PhotoLibraryChooseView viewWithPhotoLibraryInViewController:self];
            chooseView.delegate = self;
            [self.navigationController.view addSubview:chooseView];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            LoginForgetSecondViewController *lfsVC = [[LoginForgetSecondViewController alloc] init];
            lfsVC.type = LoginForgetTypeChangePassword;
            [self.navigationController pushViewController:lfsVC animated:YES];
        }
            break;
        default:
            break;
    }
}





#pragma mark - PhotoLibraryChooseViewDelegate
-(void)photoLibraryChooseView:(PhotoLibraryChooseView *)chooseView didFinishChoosingImage:(UIImage *)image{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
    cropController.delegate = self;
    cropController.aspectRadio = (CGSize){1,1};
    [self presentViewController:cropController animated:YES completion:nil];
}

#pragma mark - TOCropViewControllerDelegate
/**
 *  裁剪完成后调用的代理
 *
 *  @param cropViewController
 *  @param image              裁剪后的图片
 *  @param cropRect           裁剪后对比于原图中的相对尺寸
 *  @param angle              角度
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    cropViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.userImage = [image scaleWithSize:(CGSize){40,40}];
    
    [BYToastView showToastWithMessage:@"正在上传头像..."];
    [UNUrlConnection uploadUserHeadImage:self.userImage finish:^(NSString *imageUrl, NSString *errorString) {
        runInMainThread(^{
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }else{
                [BYToastView showToastWithMessage:@"上传成功"];
                [UNUserDefaults setUserHeadImage:self.userImage];
                [UNUserDefaults setUserHeadImageUrl:imageUrl];
                [self updateView];
            }
        });
    }];
}

// 点击取消或从外部应用调回时触发的代理  如果canceled为yes 标识 可以认为是用户手动点击了取消按钮
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
    if (cancelled) {
        cropViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)updateView{
    if (self.phoneNumber && ![[self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        phoneNumberLabel.text = self.phoneNumber;
    }else{
        phoneNumberLabel.text = @"";
    }
    if (self.userImage) {
        self.headSetImage.image = self.userImage;
    }else{
        self.headSetImage.image = [UIImage imageNamed:@"user_headimg"];
    }
    if(chooseView){
        [chooseView removeFromSuperview];
        chooseView = nil;
    }
    if (self.userViewController) {
        self.userViewController.headImage = self.headSetImage.image;
        self.userViewController.phoneString = self.phoneNumberLabel.text;
        [self.userViewController updateView];
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
    if (self.userViewController) {
        self.userViewController.headImage = self.headSetImage.image;
        self.userViewController.phoneString = self.phoneNumberLabel.text;
        [self.userViewController updateView];
    }
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
