//
//  LifeHelperPostInfoDetailViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/3.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LifeHelperPostInfoDetailViewController.h"
#import "TPKeyboardAvoidingScrollView.h"


#import "UNUrlConnection.h"
#import "UNTools.h"

@interface LifeHelperPostInfoDetailViewController () <UIScrollViewDelegate>

@end

@implementation LifeHelperPostInfoDetailViewController{
    TPKeyboardAvoidingScrollView *contentScrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.navigationItem.title = @"详情";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    
    contentScrollerView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)-45}];
    contentScrollerView.backgroundColor = RGBColor(253, 253, 253);
    [contentView addSubview:contentScrollerView];
    contentScrollerView.delegate = self;
    contentScrollerView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentScrollerView)+1};
    contentScrollerView.showsHorizontalScrollIndicator = NO;
    contentScrollerView.showsVerticalScrollIndicator = NO;
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    contactButton.frame = (CGRect){0,HEIGHT(contentView)-45,WIDTH(contentView),45};
    [contactButton setTintColor:[UIColor whiteColor]];
    [contactButton setImage:[UIImage imageNamed:@"lifehelper_callout"] forState:UIControlStateNormal];
    contactButton.backgroundColor = UN_RedColor;
    [contactButton setTitle:@"联系我" forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contactButton.titleLabel.font = Font(17);
    contactButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [contentView addSubview:contactButton];
    [contactButton addTarget:self action:@selector(contactButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *headTitleView = [[UIView alloc] init];
    headTitleView.frame = (CGRect){0,0,WIDTH(contentScrollerView),65};
    headTitleView.backgroundColor = RGBColor(253, 253, 253);
    [contentScrollerView addSubview:headTitleView];
    
    UILabel *headTitleLabel = [[UILabel alloc] init];
    headTitleLabel.frame = (CGRect){10,10,WIDTH(headTitleView)-20,18};
    //    headTitleLabel.text = @"初中每晚辅导作业";
    headTitleLabel.textColor = RGBColor(80, 80, 80);
    headTitleLabel.textAlignment = NSTextAlignmentLeft;
    headTitleLabel.font = Font(15);
    [headTitleView addSubview:headTitleLabel];
    
    UILabel *headTitleTimeLabel = [[UILabel alloc] init];
    headTitleTimeLabel.frame = (CGRect){LEFT(headTitleLabel),BOTTOM(headTitleLabel)+10,200,15};
    //    headTitleTimeLabel.text = @"发布时间:2015-11-11";
    headTitleTimeLabel.textColor = RGBColor(140, 140, 140);
    headTitleTimeLabel.textAlignment = NSTextAlignmentLeft;
    headTitleTimeLabel.font = Font(12);
    [headTitleView addSubview:headTitleTimeLabel];
    
    UILabel *headTileTotalSeeLabel = [[UILabel alloc] init];
    headTileTotalSeeLabel.frame = (CGRect){WIDTH(headTitleView)-10-150,TOP(headTitleTimeLabel),150,15};
    //    headTileTotalSeeLabel.text = @"已有200人浏览";
    headTileTotalSeeLabel.textColor = RGBColor(140, 140, 140);
    headTileTotalSeeLabel.textAlignment = NSTextAlignmentRight;
    headTileTotalSeeLabel.font = Font(12);
    [headTitleView addSubview:headTileTotalSeeLabel];
    
    float offset = BOTTOM(headTitleView);
    
    UIView *headTitleSepLineView = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:headTitleSepLineView];
    offset += HEIGHT(headTitleSepLineView);
    
    UIView *contactInfoView = [[UIView alloc] init];
    contactInfoView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),40*3};
    contactInfoView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:contactInfoView];
    
    UILabel *contacterNameNoteLabel = [[UILabel alloc] init];
    contacterNameNoteLabel.frame = (CGRect){10,0,80,40};
    contacterNameNoteLabel.text = @"联  系  人：";
    contacterNameNoteLabel.textAlignment = NSTextAlignmentLeft;
    contacterNameNoteLabel.textColor = RGBColor(80, 80,80);
    contacterNameNoteLabel.font = Font(14);
    [contactInfoView addSubview:contacterNameNoteLabel];
    
    UILabel *contactorNameLabel = [[UILabel alloc] init];
    contactorNameLabel.frame = (CGRect){RIGHT(contacterNameNoteLabel),0,WIDTH(contactInfoView)-10-RIGHT(contacterNameNoteLabel),40};
    //    contactorNameLabel.text = @"刘老师";
    contactorNameLabel.textAlignment = NSTextAlignmentLeft;
    contactorNameLabel.textColor = RGBColor(80, 80,80);
    contactorNameLabel.font = Font(14);
    [contactInfoView addSubview:contactorNameLabel];
    
    UIView *contactorNameSepLineView = [[UIView alloc] init];
    contactorNameSepLineView.frame = (CGRect){10,HEIGHT(contactorNameLabel)-0.5,WIDTH(contactInfoView)-10,0.5};
    contactorNameSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contactInfoView addSubview:contactorNameSepLineView];
    
    UILabel *contacterPhoneNoteLabel = [[UILabel alloc] init];
    contacterPhoneNoteLabel.frame = (CGRect){10,40,80,40};
    contacterPhoneNoteLabel.text = @"联系电话：";
    contacterPhoneNoteLabel.textAlignment = NSTextAlignmentLeft;
    contacterPhoneNoteLabel.textColor = RGBColor(80, 80,80);
    contacterPhoneNoteLabel.font = Font(14);
    [contactInfoView addSubview:contacterPhoneNoteLabel];
    
    UILabel *contactorPhoneLabel = [[UILabel alloc] init];
    contactorPhoneLabel.frame = (CGRect){RIGHT(contacterPhoneNoteLabel),TOP(contacterPhoneNoteLabel),WIDTH(contactInfoView)-10-RIGHT(contacterPhoneNoteLabel),40};
    //    contactorPhoneLabel.text = @"1332121";
    contactorPhoneLabel.textAlignment = NSTextAlignmentLeft;
    contactorPhoneLabel.textColor = RGBColor(80, 80,80);
    contactorPhoneLabel.font = Font(14);
    [contactInfoView addSubview:contactorPhoneLabel];
    
    UIView *contactorPhoneSepLineView = [[UIView alloc] init];
    contactorPhoneSepLineView.frame = (CGRect){10,BOTTOM(contactorPhoneLabel)-0.5,WIDTH(contactInfoView)-10,0.5};
    contactorPhoneSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contactInfoView addSubview:contactorPhoneSepLineView];
    
    UILabel *contacterRegionNoteLabel = [[UILabel alloc] init];
    contacterRegionNoteLabel.frame = (CGRect){10,80,80,40};
    contacterRegionNoteLabel.text = @"地        区：";
    contacterRegionNoteLabel.textAlignment = NSTextAlignmentLeft;
    contacterRegionNoteLabel.textColor = RGBColor(80, 80,80);
    contacterRegionNoteLabel.font = Font(14);
    [contactInfoView addSubview:contacterRegionNoteLabel];
    
    UILabel *contactorRegionLabel = [[UILabel alloc] init];
    contactorRegionLabel.frame = (CGRect){RIGHT(contacterRegionNoteLabel),TOP(contacterRegionNoteLabel),WIDTH(contactInfoView)-10-RIGHT(contacterPhoneNoteLabel),40};
    //    contactorRegionLabel.text = @"北京海淀区";
    contactorRegionLabel.textAlignment = NSTextAlignmentLeft;
    contactorRegionLabel.textColor = RGBColor(80, 80,80);
    contactorRegionLabel.font = Font(14);
    [contactInfoView addSubview:contactorRegionLabel];
    
    offset += HEIGHT(contactInfoView);
    
    UIView *contactorViewSepLineView = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:contactorViewSepLineView];
    offset += HEIGHT(contactorViewSepLineView);
    
    //    UIView *detailInfoView;
    //    detailInfoView = [[UIView alloc] init];
    //    detailInfoView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),500};
    //    detailInfoView.backgroundColor = contentScrollerView.backgroundColor;
    //    [contentScrollerView addSubview:detailInfoView];
    //    
    UIView *detailInfoTagLineView = [[UIView alloc] init];
    detailInfoTagLineView.frame = (CGRect){7,offset+10,3,15};
    detailInfoTagLineView.backgroundColor = UN_RedColor;
    [contentScrollerView addSubview:detailInfoTagLineView];
    
    UILabel *detailInfoNoteLabel = [[UILabel alloc] init];
    detailInfoNoteLabel.frame = (CGRect){RIGHT(detailInfoTagLineView)+5,offset,100,35};
    detailInfoNoteLabel.text = @"详细信息";
    detailInfoNoteLabel.textAlignment = NSTextAlignmentLeft;
    detailInfoNoteLabel.textColor = RGBColor(150, 150, 150);
    detailInfoNoteLabel.font = Font(13);
    [contentScrollerView addSubview:detailInfoNoteLabel];
    
    UIView  *detailInfoSepLineView = [[UIView alloc] init];
    detailInfoSepLineView.frame = (CGRect){10,BOTTOM(detailInfoNoteLabel)-0.5,WIDTH(contentScrollerView)-10,0.5};
    detailInfoSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentScrollerView addSubview:detailInfoSepLineView];
    
    offset += HEIGHT(detailInfoNoteLabel);
    
    //    [resultArrayTmp addObject:@{@"image":image,
    //                                @"hits":@(hitsNumber),
    //                                @"lifeImages":lifeImagesArray,
    //                                @"title":title,
    //                                @"address":address,
    //                                @"content":contentString,
    //                                @"id":idString,
    //                                @"area":area,
    //                                @"lifeCategory_id":@(lifeGategroyID),
    //                                @"lifeCategory_name":lifeGategroyName,
    //                                @"linkman":linkman,
    //                                @"phone":phoneString,
    //                                @"timestamp":@(timestamp),
    //                                @"areaName":areaName,
    //                                }];
    
    NSString *title = self.infoDic[@"title"];
    if (!title || ![title isKindOfClass:[NSString class]]) {
        title = @"标题";
    }
    headTitleLabel.text = title;
    
    headTitleTimeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[self parseTimeWithTimeStamp:[self.infoDic[@"timestamp"] longLongValue]]];
    
    NSString *phoneString = self.infoDic[@"phone"];
    if (!phoneString || ![phoneString isKindOfClass:[NSString class]]) {
        phoneString = @"";
    }
    contactorPhoneLabel.text = phoneString;
    
    headTileTotalSeeLabel.text = [NSString stringWithFormat:@"%ld",[self.infoDic[@"hits"] longValue]];
    
    NSString *linkMan = self.infoDic[@"linkman"];
    if (!linkMan || ![linkMan isKindOfClass:[NSString class]]) {
        linkMan = @"";
    }
    contactorNameLabel.text = linkMan;
    
    NSString *areaNameString = self.infoDic[@"areaName"];
    if (!areaNameString || ![areaNameString isKindOfClass:[NSString class]]) {
        areaNameString = @"";
    }
    contactorRegionLabel.text = areaNameString;
    
    NSString *imageUrl = self.infoDic[@"image"];
    if (imageUrl && ![imageUrl isEqualToString:@""]) {
        imageUrl = [UNUrlConnection replaceUrl:imageUrl];
        offset += 10;
        UIImageView *imageview1 = [self addImageWithUrlString:imageUrl offset:offset];
        [contentScrollerView addSubview:imageview1];
        offset += HEIGHT(imageview1);
    }
    
    NSArray *lifeImagesArray = self.infoDic[@"lifeImages"];
    if (lifeImagesArray && [lifeImagesArray isKindOfClass:[NSArray class]] && lifeImagesArray.count != 0) {
        for (NSDictionary *imageDic in lifeImagesArray) {
            NSString *imagePath = [imageDic objectForKey:@"path"];
            if (imagePath && ![imagePath isEqualToString:@""]) {
                imagePath = [UNUrlConnection replaceUrl:imagePath];
                offset += 10;
                UIImageView *imageview1 = [self addImageWithUrlString:imageUrl offset:offset];
                [contentScrollerView addSubview:imageview1];
                offset += HEIGHT(imageview1);
            }
        }
    }
    
    NSString *contentString = self.infoDic[@"content"];
    
    if (contentString && [contentString isKindOfClass:[NSString class]])  {
        CGSize contentsSize = [UNTools getSizeWithString:contentString andSize:(CGSize){WIDTH(contentScrollerView)-20,MAXFLOAT} andFont:Font(13)];
        
        UILabel *contentsLabel = [[UILabel alloc] init];
        contentsLabel.frame = (CGRect){10,offset+10,WIDTH(contentScrollerView)-10*2,contentsSize.height};
        contentsLabel.text = contentString;
        contentsLabel.textAlignment = NSTextAlignmentLeft;
        contentsLabel.textColor = RGBColor(80, 80, 80);
        contentsLabel.font = Font(13);
        contentsLabel.numberOfLines = -1;
        [contentScrollerView addSubview:contentsLabel];
        
        offset += contentsSize.height;
        
        offset += 10;
    }
    
    contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),MAX(HEIGHT(contentScrollerView)+1, offset+10)};
}

-(UIImageView *)addImageWithUrlString:(NSString *)imageUrl offset:(float)offset{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = (CGRect){10,offset,WIDTH(contentScrollerView)-20,(WIDTH(contentScrollerView)-20)*9/16};
    
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [imageView addGestureRecognizer:imageTap];
    
    return imageView;
}

-(void)imageTap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    [self checkImgInFullScreen:imageView withImage:imageView.image];
}

static CGRect rectInFullScreen;
-(void)checkImgInFullScreen:(UIView *)View withImage:(UIImage *)image{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgColorView.alpha = 0.f;
    bgColorView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    bgColorView.tag = 7978;
    [keyWindow addSubview:bgColorView];
    
    UIScrollView *fullscreenBottomView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullscreenBottomView.contentSize = CGSizeMake(WIDTH(fullscreenBottomView), HEIGHT(fullscreenBottomView));
    fullscreenBottomView.backgroundColor = [UIColor clearColor];
    fullscreenBottomView.minimumZoomScale = 0.3f;
    fullscreenBottomView.maximumZoomScale = 3.f;
    fullscreenBottomView.contentMode = UIViewContentModeCenter;
    fullscreenBottomView.bounces = YES;
    fullscreenBottomView.bouncesZoom = YES;
    fullscreenBottomView.showsHorizontalScrollIndicator = NO;
    fullscreenBottomView.showsVerticalScrollIndicator = NO;
    fullscreenBottomView.delegate = self;
    fullscreenBottomView.tag = 9797;
    [keyWindow addSubview:fullscreenBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCheckImgView)];
    [fullscreenBottomView addGestureRecognizer:tap];
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    rectInFullScreen = [View convertRect:View.frame toView:window];
    UIImageView *imgViewIsShowing = [[UIImageView alloc] initWithFrame:rectInFullScreen];
    
    UIImage *imgToShow = image;
    imgViewIsShowing.image = imgToShow;
    imgViewIsShowing.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIsShowing.tag = 1001;
    [fullscreenBottomView addSubview:imgViewIsShowing];
    
    [UIView animateWithDuration:0.3f animations:^{
        imgViewIsShowing.frame = fullscreenBottomView.bounds;
        bgColorView.alpha = 1.f;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

-(void)exitCheckImgView{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    if (viewScroll) {
        if (viewScroll.zoomScale > 1.f) {
            [viewScroll setZoomScale:1.f animated:YES];
            [self performSelector:@selector(exitCheckBigImgView) withObject:nil afterDelay:0.5f];
        }else{
            [self exitCheckBigImgView];
        }
    }
}

-(void)exitCheckBigImgView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *viewBg = [keyWindow viewWithTag:7978];
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView*)[viewScroll.subviews firstObject]).frame = rectInFullScreen;
        viewScroll.alpha = 0.f;
        viewBg.alpha = 0.f;
    }completion:^(BOOL finished) {
        [viewScroll removeFromSuperview];
        [viewBg removeFromSuperview];
    }];
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scrollView.tag == 9797) {
        if (scale<1.f) {
            [scrollView setZoomScale:1.f animated:YES];
            if (scale<0.7f)
                [self exitCheckImgView];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 9797) {
        UIImageView *subView = (UIImageView*)[scrollView viewWithTag:1001];
        return subView;
    }else{
        return nil;
    }
}

-(void)contactButtonClick{
    NSString *phone = self.infoDic[@"phone"];
    if (!phone || ![phone isKindOfClass:[NSString class]] || [phone isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"未获取到电话信息,请稍候再试"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨号确认" message:[NSString stringWithFormat:@"确定拨打电话给%@吗？",phone] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[phone stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(NSString *)parseTimeWithTimeStamp:(long long)dbdateline{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dbdateline];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(UIView *)addSeprateViewAddYAligh:(float)yAligh{
    UIView *seprateView = [[UIView alloc] init];
    seprateView.frame = (CGRect){0,yAligh,WIDTH(contentScrollerView),5};
    seprateView.backgroundColor = RGBColor(240, 240, 240);
    
    UIView *sepLineViewTop =[[UIView alloc] init];
    sepLineViewTop.frame = (CGRect){0,0,WIDTH(seprateView),0.5};
    sepLineViewTop.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [seprateView addSubview:sepLineViewTop];
    
    UIView *sepLineViewBottom =[[UIView alloc] init];
    sepLineViewBottom.frame = (CGRect){0,HEIGHT(seprateView)-0.5,WIDTH(seprateView),0.5};
    sepLineViewBottom.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [seprateView addSubview:sepLineViewBottom];
    return seprateView;
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