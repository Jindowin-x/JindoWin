//
//  LifeHelperPostViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/2.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LifeHelperPostViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PhotoLibraryChooseView.h"
#import "TOCropViewController.h"
#import "UIImage+Scale.h"
#import "UIButton+AFNetworking.h"
#import "UNUrlConnection.h"
#import "LHChooseGategroyViewController.h"
#import "ProvinceChooseViewController.h"
#import "CTAssetsPickerController.h"

#import "UIImage+Resize.h"
#import "XYW8IndicatorView.h"

@interface LifeHelperPostViewController () <UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,PhotoLibraryChooseViewDelegate,TOCropViewControllerDelegate>

@end

@implementation LifeHelperPostViewController{
    TPKeyboardAvoidingScrollView *contentScrollerView;
    
    BOOL defaultPhotoChanged;
    PhotoLibraryChooseView *chooseView;
    
    UIButton *addImageButton;
    UITextField *postTitleTextField;
    UILabel *postGategroyLabel;
    UITextField *postContacterTextField;
    UITextField *postContacterPhoneTextField;
    UILabel *postRegionLabel;
    UITextField *postDetailAddressTextField;
    UITextView *detailPostInfoPlaceHolderTextView;
    UITextView *detailPostInfoTextView;
    
    XYW8IndicatorView *indicatorView;
    
    NSString *lid;
    NSString *defaultImageUrl;
    long areaID;
    long life_GategroyID;
    NSArray *lifeImagesArray;
    
    NSMutableArray *contentPostImageArray;
    BOOL defaultContentPhotoChanged;
    
    UIView *cameraView;
    float everyButtonWidth;
    UIButton *addContentImageButton;
    
    BOOL isNewPost;//这个字段代表 是否是发布新的 信息 或编辑已有的信息
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发布信息";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(253,253,253);
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    contentScrollerView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)-45}];
    contentScrollerView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:contentScrollerView];
    contentScrollerView.delegate = self;
    contentScrollerView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentScrollerView)+1};
    contentScrollerView.showsHorizontalScrollIndicator = NO;
    contentScrollerView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *contentScrollerTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentScrollerTapGesTriggle)];
    [contentScrollerView addGestureRecognizer:contentScrollerTapGes];
    
    UIView *postDefaultImageView = [[UIView alloc] init];
    postDefaultImageView.backgroundColor = contentScrollerView.backgroundColor;
    postDefaultImageView.frame = (CGRect){0,0,WIDTH(contentScrollerView),WIDTH(contentScrollerView)*9/16};
    [contentScrollerView addSubview:postDefaultImageView];
    
    UIView *postNewHeadView = [[UIView alloc] init];
    postNewHeadView.frame = (CGRect){(WIDTH(postDefaultImageView)-70)/2,(HEIGHT(postDefaultImageView)-80)/2,70,80};
    [postDefaultImageView addSubview:postNewHeadView];
    
    UIImageView *postNewAddImage = [[UIImageView alloc] init];
    postNewAddImage.image = [UIImage imageNamed:@"lifehelper_postnew_addimage"];
    postNewAddImage.frame = (CGRect){0,0,WIDTH(postNewHeadView),50};
    [postNewHeadView addSubview:postNewAddImage];
    
    UILabel *postNewAddLabel = [[UILabel alloc] init];
    postNewAddLabel.frame = (CGRect){0,55,WIDTH(postNewHeadView),25};
    postNewAddLabel.text = @"上传logo";
    postNewAddLabel.textColor = RGBColor(80, 80, 80);
    postNewAddLabel.textAlignment = NSTextAlignmentCenter;
    postNewAddLabel.font = Font(16);
    [postNewHeadView addSubview:postNewAddLabel];
    
    addImageButton = [[UIButton alloc] init];
    addImageButton.frame = postDefaultImageView.bounds;
    [addImageButton addTarget:self action:@selector(addImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [postDefaultImageView addSubview:addImageButton];
    
    CGFloat offset = BOTTOM(postDefaultImageView);
    UIView *sepView1 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView1];
    offset += HEIGHT(sepView1);
    
    UIView *postTitleView = [[UIView alloc] init];
    postTitleView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postTitleView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:postTitleView];
    
    UILabel *postTitleNoteLabel = [[UILabel alloc] init];
    postTitleNoteLabel.frame = (CGRect){10,0,45,HEIGHT(postTitleView)};
    postTitleNoteLabel.text = @"标题：";
    postTitleNoteLabel.textAlignment = NSTextAlignmentLeft;
    postTitleNoteLabel.textColor = RGBColor(80, 80,80);
    postTitleNoteLabel.font = Font(14);
    [postTitleView addSubview:postTitleNoteLabel];
    
    postTitleTextField = [[UITextField alloc] init];
    postTitleTextField.frame = (CGRect){RIGHT(postTitleNoteLabel),0,WIDTH(postTitleView)-10-RIGHT(postTitleNoteLabel),HEIGHT(postTitleView)};
    postTitleTextField.textColor = RGBColor(100, 100, 100);
    postTitleTextField.font = Font(14);
    postTitleTextField.tag = 18101;
    postTitleTextField.keyboardType = UIKeyboardTypeDefault;
    postTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postTitleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    postTitleTextField.adjustsFontSizeToFitWidth = YES;
    postTitleTextField.minimumFontSize = 10;
    postTitleTextField.delegate = self;
    postTitleTextField.returnKeyType = UIReturnKeyDefault;
    postTitleTextField.placeholder = @"请输入标题";
    postTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [postTitleView addSubview:postTitleTextField];
    
    offset += HEIGHT(postTitleView);
    UIView *sepView2 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView2];
    offset += HEIGHT(sepView2);
    
    UIButton *postGategroyButton = [[UIButton alloc] init];
    postGategroyButton.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postGategroyButton.backgroundColor = contentScrollerView.backgroundColor;
    [postGategroyButton addTarget:self action:@selector(postGategroyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollerView addSubview:postGategroyButton];
    
    UILabel *postGategroyNoteLabel = [[UILabel alloc] init];
    postGategroyNoteLabel.frame = (CGRect){10,0,45,HEIGHT(postGategroyButton)};
    postGategroyNoteLabel.text = @"分类：";
    postGategroyNoteLabel.textAlignment = NSTextAlignmentLeft;
    postGategroyNoteLabel.textColor = RGBColor(80, 80,80);
    postGategroyNoteLabel.font = Font(14);
    [postGategroyButton addSubview:postGategroyNoteLabel];
    
    postGategroyLabel =[[UILabel alloc] init];
    postGategroyLabel.frame = (CGRect){RIGHT(postGategroyNoteLabel),0,WIDTH(postGategroyButton)-RIGHT(postGategroyNoteLabel)-20-5,HEIGHT(postGategroyButton)};
    postGategroyLabel.text = @"";
    postGategroyLabel.textAlignment = NSTextAlignmentRight;
    postGategroyLabel.textColor = RGBColor(80, 80,80);
    postGategroyLabel.font = Font(14);
    [postGategroyButton addSubview:postGategroyLabel];
    
    UIImageView *postGategroyMoreImage = [[UIImageView alloc] init];
    postGategroyMoreImage.image = [UIImage imageNamed:@"more"];
    postGategroyMoreImage.frame = (CGRect){WIDTH(postGategroyButton)-20,(HEIGHT(postGategroyButton)-11)/2,9,11};
    [postGategroyButton addSubview:postGategroyMoreImage];
    
    offset += HEIGHT(postGategroyButton);
    UIView *sepView3 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView3];
    offset += HEIGHT(sepView3);
    
    UIView *postContacterView = [[UIView alloc] init];
    postContacterView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postContacterView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:postContacterView];
    
    UILabel *postContacterNoteLabel = [[UILabel alloc] init];
    postContacterNoteLabel.frame = (CGRect){10,0,60,HEIGHT(postContacterView)};
    postContacterNoteLabel.text = @"联系人：";
    postContacterNoteLabel.textAlignment = NSTextAlignmentLeft;
    postContacterNoteLabel.textColor = RGBColor(80, 80,80);
    postContacterNoteLabel.font = Font(14);
    [postContacterView addSubview:postContacterNoteLabel];
    
    postContacterTextField = [[UITextField alloc] init];
    postContacterTextField.frame = (CGRect){RIGHT(postContacterNoteLabel),0,WIDTH(postContacterView)-10-RIGHT(postContacterNoteLabel),HEIGHT(postContacterView)};
    postContacterTextField.textColor = RGBColor(100, 100, 100);
    postContacterTextField.font = Font(14);
    postContacterTextField.tag = 18102;
    postContacterTextField.keyboardType = UIKeyboardTypeDefault;
    postContacterTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postContacterTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    postContacterTextField.adjustsFontSizeToFitWidth = YES;
    postContacterTextField.minimumFontSize = 10;
    postContacterTextField.delegate = self;
    postContacterTextField.returnKeyType = UIReturnKeyDefault;
    postContacterTextField.placeholder = @"请输入联系人姓名";
    postContacterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [postContacterView addSubview:postContacterTextField];
    
    offset += HEIGHT(postContacterView);
    
    UIView *inlineSepLineView11 = [[UIView alloc] init];
    inlineSepLineView11.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    inlineSepLineView11.frame = (CGRect){0,HEIGHT(postContacterView)-0.5,WIDTH(postContacterView),0.5};
    [postContacterView addSubview:inlineSepLineView11];
    
    UIView *postContacterPhoneView = [[UIView alloc] init];
    postContacterPhoneView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postContacterPhoneView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:postContacterPhoneView];
    
    UILabel *postContacterPhoneNoteLabel = [[UILabel alloc] init];
    postContacterPhoneNoteLabel.frame = (CGRect){10,0,75,HEIGHT(postContacterPhoneView)};
    postContacterPhoneNoteLabel.text = @"联系电话：";
    postContacterPhoneNoteLabel.textAlignment = NSTextAlignmentLeft;
    postContacterPhoneNoteLabel.textColor = RGBColor(80, 80,80);
    postContacterPhoneNoteLabel.font = Font(14);
    [postContacterPhoneView addSubview:postContacterPhoneNoteLabel];
    
    postContacterPhoneTextField = [[UITextField alloc] init];
    postContacterPhoneTextField.frame = (CGRect){RIGHT(postContacterPhoneNoteLabel),0,WIDTH(postContacterPhoneView)-10-RIGHT(postContacterPhoneNoteLabel),HEIGHT(postContacterPhoneView)};
    postContacterPhoneTextField.textColor = RGBColor(100, 100, 100);
    postContacterPhoneTextField.font = Font(14);
    postContacterPhoneTextField.tag = 18103;
    postContacterPhoneTextField.keyboardType = UIKeyboardTypeDefault;
    postContacterPhoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postContacterPhoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    postContacterPhoneTextField.adjustsFontSizeToFitWidth = YES;
    postContacterPhoneTextField.minimumFontSize = 10;
    postContacterPhoneTextField.delegate = self;
    postContacterPhoneTextField.returnKeyType = UIReturnKeyDefault;
    postContacterPhoneTextField.placeholder = @"请输入联系人电话号码";
    postContacterPhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [postContacterPhoneView addSubview:postContacterPhoneTextField];
    
    offset += HEIGHT(postContacterPhoneView);
    UIView *sepView4 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView4];
    offset += HEIGHT(sepView4);
    
    UIButton *postRegionButton = [[UIButton alloc] init];
    postRegionButton.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postRegionButton.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:postRegionButton];
    [postRegionButton addTarget:self action:@selector(postRegionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *postRegionNoteLabel = [[UILabel alloc] init];
    postRegionNoteLabel.frame = (CGRect){10,0,45,HEIGHT(postRegionButton)};
    postRegionNoteLabel.text = @"地区：";
    postRegionNoteLabel.textAlignment = NSTextAlignmentLeft;
    postRegionNoteLabel.textColor = RGBColor(80, 80,80);
    postRegionNoteLabel.font = Font(14);
    [postRegionButton addSubview:postRegionNoteLabel];
    
    postRegionLabel =[[UILabel alloc] init];
    postRegionLabel.frame = (CGRect){RIGHT(postRegionNoteLabel),0,WIDTH(postRegionButton)-RIGHT(postRegionNoteLabel)-20-5,HEIGHT(postRegionButton)};
    postRegionLabel.text = @"";
    postRegionLabel.textAlignment = NSTextAlignmentRight;
    postRegionLabel.textColor = RGBColor(80, 80,80);
    postRegionLabel.font = Font(14);
    [postRegionButton addSubview:postRegionLabel];
    
    UIImageView *postRegionMoreImage = [[UIImageView alloc] init];
    postRegionMoreImage.image = [UIImage imageNamed:@"more"];
    postRegionMoreImage.frame = (CGRect){WIDTH(postRegionButton)-20,(HEIGHT(postRegionButton)-11)/2,9,11};
    [postRegionButton addSubview:postRegionMoreImage];
    
    offset += HEIGHT(postContacterView);
    
    UIView *inlineSepLineView12 = [[UIView alloc] init];
    inlineSepLineView12.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    inlineSepLineView12.frame = (CGRect){0,HEIGHT(postRegionButton)-0.5,WIDTH(postContacterView),0.5};
    [postRegionButton addSubview:inlineSepLineView12];
    
    UIView *postDetailAddressView = [[UIView alloc] init];
    postDetailAddressView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),45};
    postDetailAddressView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:postDetailAddressView];
    
    UILabel *postDetailAddressNoteLabel = [[UILabel alloc] init];
    postDetailAddressNoteLabel.frame = (CGRect){10,0,75,HEIGHT(postDetailAddressView)};
    postDetailAddressNoteLabel.text = @"详细地址：";
    postDetailAddressNoteLabel.textAlignment = NSTextAlignmentLeft;
    postDetailAddressNoteLabel.textColor = RGBColor(80, 80,80);
    postDetailAddressNoteLabel.font = Font(14);
    [postDetailAddressView addSubview:postDetailAddressNoteLabel];
    
    
    postDetailAddressTextField = [[UITextField alloc] init];
    postDetailAddressTextField.frame = (CGRect){RIGHT(postDetailAddressNoteLabel),0,WIDTH(postDetailAddressView)-10-RIGHT(postDetailAddressNoteLabel),HEIGHT(postDetailAddressView)};
    postDetailAddressTextField.textColor = RGBColor(100, 100, 100);
    postDetailAddressTextField.font = Font(14);
    postDetailAddressTextField.tag = 18104;
    postDetailAddressTextField.keyboardType = UIKeyboardTypeDefault;
    postDetailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postDetailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    postDetailAddressTextField.adjustsFontSizeToFitWidth = YES;
    postDetailAddressTextField.minimumFontSize = 10;
    postDetailAddressTextField.delegate = self;
    postDetailAddressTextField.returnKeyType = UIReturnKeyDefault;
    postDetailAddressTextField.placeholder = @"请输入详细地址";
    postDetailAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [postDetailAddressView addSubview:postDetailAddressTextField];
    
    offset += HEIGHT(postDetailAddressView);
    
    UIView *sepView5 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView5];
    offset += HEIGHT(sepView5);
    
    UIView *detailPostInfoView = [[UIView alloc] init];
    detailPostInfoView.frame = (CGRect){0,offset,WIDTH(contentScrollerView),250};
    detailPostInfoView.backgroundColor = contentScrollerView.backgroundColor;
    [contentScrollerView addSubview:detailPostInfoView];
    
    UILabel *detailPostInfoNoteLabel = [[UILabel alloc] init];
    detailPostInfoNoteLabel.frame = (CGRect){10,0,WIDTH(contentScrollerView)-20,35};
    detailPostInfoNoteLabel.text = @"详细信息：";
    detailPostInfoNoteLabel.textAlignment = NSTextAlignmentLeft;
    detailPostInfoNoteLabel.textColor = RGBColor(80, 80,80);
    detailPostInfoNoteLabel.font = Font(14);
    [detailPostInfoView addSubview:detailPostInfoNoteLabel];
    
    UIView *inlineSepLine13 = [[UIView alloc] init];
    inlineSepLine13.frame = (CGRect){0,HEIGHT(detailPostInfoNoteLabel)-0.5,WIDTH(detailPostInfoView),0.5};
    inlineSepLine13.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [detailPostInfoView addSubview:inlineSepLine13];
    
    detailPostInfoPlaceHolderTextView = [[UITextView alloc] init];
    detailPostInfoPlaceHolderTextView.backgroundColor = [UIColor whiteColor];
    detailPostInfoPlaceHolderTextView.frame = (CGRect){10,BOTTOM(detailPostInfoNoteLabel),(WIDTH(detailPostInfoView)-20),HEIGHT(detailPostInfoView)-BOTTOM(detailPostInfoNoteLabel)};
    detailPostInfoPlaceHolderTextView.textColor = RGBColor(200, 200, 200);
    detailPostInfoPlaceHolderTextView.font = Font(15);
    detailPostInfoPlaceHolderTextView.keyboardType = UIKeyboardTypeDefault;
    detailPostInfoPlaceHolderTextView.returnKeyType = UIReturnKeyDone;
    detailPostInfoPlaceHolderTextView.text = @"请输入详细信息";
    detailPostInfoPlaceHolderTextView.hidden = NO;
    detailPostInfoPlaceHolderTextView.userInteractionEnabled = NO;
    detailPostInfoPlaceHolderTextView.editable = NO;
    detailPostInfoPlaceHolderTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    detailPostInfoPlaceHolderTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [detailPostInfoView addSubview:detailPostInfoPlaceHolderTextView];
    
    detailPostInfoTextView = [[UITextView alloc] init];
    detailPostInfoTextView.backgroundColor = [UIColor clearColor];
    detailPostInfoTextView.frame = detailPostInfoPlaceHolderTextView.frame;
    detailPostInfoTextView.textColor = RGBColor(100, 100, 100);
    detailPostInfoTextView.font = Font(15);
    detailPostInfoTextView.tag = 18111;
    detailPostInfoTextView.delegate = self;
    detailPostInfoTextView.keyboardType = UIKeyboardTypeDefault;
    detailPostInfoTextView.returnKeyType = UIReturnKeyNext;
    detailPostInfoTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    detailPostInfoTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [detailPostInfoView addSubview:detailPostInfoTextView];
    
    offset += HEIGHT(detailPostInfoView);
    
    UIView *sepView6 = [self addSeprateViewAddYAligh:offset];
    [contentScrollerView addSubview:sepView6];
    offset += HEIGHT(sepView6);
    
    UILabel *cameraViewNoteLabel = [[UILabel alloc] init];
    cameraViewNoteLabel.frame = (CGRect){10,offset,WIDTH(contentScrollerView)-20,35};
    cameraViewNoteLabel.text = @"上传图片：";
    cameraViewNoteLabel.textAlignment = NSTextAlignmentLeft;
    cameraViewNoteLabel.textColor = RGBColor(80, 80,80);
    cameraViewNoteLabel.font = Font(14);
    [contentScrollerView addSubview:cameraViewNoteLabel];
    
    offset += HEIGHT(cameraViewNoteLabel);
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,offset,WIDTH(contentView),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentScrollerView addSubview:sepLine];
    
    cameraView = [[UIView alloc] init];
    cameraView.frame = (CGRect){0,offset+5,WIDTH(contentView),130};
    cameraView.backgroundColor = [UIColor whiteColor];
    [contentScrollerView addSubview:cameraView];
    
    everyButtonWidth = (WIDTH(cameraView)-10*2-8*2)/3;
    
    addContentImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addContentImageButton.tintColor = RGBColor(140, 140, 140);
    addContentImageButton.frame = (CGRect){10,10,everyButtonWidth,everyButtonWidth};
    addContentImageButton.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    addContentImageButton.layer.cornerRadius = 3.f;
    addContentImageButton.layer.borderWidth = 0.5;
    addContentImageButton.layer.masksToBounds = YES;
    addContentImageButton.tag = 9999;
    [cameraView addSubview:addContentImageButton];
    
    [addContentImageButton setImage:[UIImage imageNamed:@"suggestion_addpic"] forState:UIControlStateNormal];
    [addContentImageButton addTarget:self action:@selector(addContentImageButtonnClick) forControlEvents:UIControlEventTouchUpInside];
    
    offset += HEIGHT(cameraView);
    offset += 10;
    contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),MAX(HEIGHT(contentScrollerView)+1, offset)};
    
    if (!self.postInfoDic) {
        areaID = 0;
        life_GategroyID = 0;
        isNewPost = YES;//标识是 新发布的信息  上传的时候 采用上传新的生活助手接口
        
        
        UIButton *detailPostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailPostButton.frame = (CGRect){0,HEIGHT(contentView)-45,WIDTH(contentView),45};
        detailPostButton.backgroundColor = UN_RedColor;
        [detailPostButton setTitle:@"发 布" forState:UIControlStateNormal];
        [detailPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailPostButton.titleLabel.font = Font(17);
        [contentView addSubview:detailPostButton];
        [detailPostButton addTarget:self action:@selector(detailPostButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        isNewPost = NO;//标识是 新发布的信息  上传的时候 编辑已有生活助手接口 和删除
        
        lid = [NSString stringWithFormat:@"%lld",[self.postInfoDic[@"id"] longLongValue]]; ;
        
        defaultImageUrl = self.postInfoDic[@"image"];
        if (defaultImageUrl && ![defaultImageUrl isEqualToString:@""]) {
            defaultImageUrl = [UNUrlConnection replaceUrl:defaultImageUrl];
            [addImageButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:defaultImageUrl]];
        }
        
        NSString *title = self.postInfoDic[@"title"];
        if (!title || ![title isKindOfClass:[NSString class]]) {
            title = @"";
        }
        postTitleTextField.text = title;
        
        NSString *phoneString = self.postInfoDic[@"phone"];
        if (!phoneString || ![phoneString isKindOfClass:[NSString class]]) {
            phoneString = @"";
        }
        postContacterPhoneTextField.text = phoneString;
        
        NSString *linkMan = self.postInfoDic[@"linkman"];
        if (!linkMan || ![linkMan isKindOfClass:[NSString class]]) {
            linkMan = @"";
        }
        postContacterTextField.text = linkMan;
        
        
        NSString *areaNameString = self.postInfoDic[@"areaName"];
        if (!areaNameString || ![areaNameString isKindOfClass:[NSString class]]) {
            areaNameString = @"";
        }
        postRegionLabel.text = areaNameString;
        
        areaID = (long)[self.postInfoDic[@"area"] longLongValue];
        
        NSString *lifeCategory_name = self.postInfoDic[@"lifeCategory_name"];
        if (!lifeCategory_name || ![lifeCategory_name isKindOfClass:[NSString class]]) {
            lifeCategory_name = @"";
        }
        postGategroyLabel.text = lifeCategory_name;
        
        life_GategroyID = (long)[self.postInfoDic[@"lifeCategory_id"] longLongValue];
        
        NSString *addressString = self.postInfoDic[@"address"];
        if (!addressString || ![addressString isKindOfClass:[NSString class]]) {
            addressString = @"";
        }
        postDetailAddressTextField.text = addressString;
        
        NSArray *lifeImagesArrayTmp = self.postInfoDic[@"lifeImages"];
        if (lifeImagesArrayTmp && [lifeImagesArrayTmp isKindOfClass:[NSArray class]] && lifeImagesArrayTmp.count != 0) {
            lifeImagesArray = lifeImagesArrayTmp;
            contentPostImageArray = [NSMutableArray array];
            [lifeImagesArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *urlString = obj[@"source"];
                [contentPostImageArray addObject:urlString];
            }];
            lifeImagesArray = [NSArray arrayWithArray:contentPostImageArray];
            [self reloadImageSrollContainer:contentPostImageArray];
        }
        
        NSString *contentString = self.postInfoDic[@"content"];
        if (contentString && [contentString isKindOfClass:[NSString class]] && ![contentString isEqualToString:@""])  {
            detailPostInfoPlaceHolderTextView.text = @"";
            detailPostInfoTextView.text = contentString;
        }
        
        UIButton *detailSaveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailSaveButton.frame = (CGRect){0,HEIGHT(contentView)-45,WIDTH(contentView)/2,45};
        detailSaveButton.backgroundColor = UN_RedColor;
        [detailSaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [detailSaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailSaveButton.titleLabel.font = Font(17);
        [contentView addSubview:detailSaveButton];
        [detailSaveButton addTarget:self action:@selector(detailPostSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *detailDeleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailDeleteButton.frame = (CGRect){WIDTH(contentView)/2,HEIGHT(contentView)-45,WIDTH(contentView)/2,45};
        detailDeleteButton.backgroundColor = RGBColor(25, 131, 207);
        [detailDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [detailDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailDeleteButton.titleLabel.font = Font(17);
        [contentView addSubview:detailDeleteButton];
        [detailDeleteButton addTarget:self action:@selector(detailDeleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)addContentImageButtonnClick{
    [self resignAllInputs];
    chooseView = [PhotoLibraryChooseView viewWithPhotoLibraryInViewController:self];
    chooseView.tag = 102;
    chooseView.delegate = self;
    [self.navigationController.view addSubview:chooseView];
}

-(void)addImageButtonClick{
    [self resignAllInputs];
    chooseView = [PhotoLibraryChooseView viewWithPhotoLibraryInViewController:self];
    chooseView.delegate = self;
    chooseView.tag = 101;
    [self.navigationController.view addSubview:chooseView];
}

-(void)postGategroyButtonClick{
    if (self.lifeGategroyArray) {
        [self jumpToChooseGategroyViewControllerWithArray:self.lifeGategroyArray];
    }else{
        [BYToastView showToastWithMessage:@"正在获取分类信息"];
        [UNUrlConnection getAllLifeCategroyComplete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                NSArray *contentArray = resultDic[@"content"];
                
                self.lifeGategroyArray = contentArray;
                [self jumpToChooseGategroyViewControllerWithArray:self.lifeGategroyArray];
            }else{
                [BYToastView showToastWithMessage:@"获取数据失败"];
                return;
            }
        }];
    }
}

-(void)jumpToChooseGategroyViewControllerWithArray:(NSArray *)array{
    LHChooseGategroyViewController *lgcgVC =[[LHChooseGategroyViewController alloc] init];
    lgcgVC.gategroyArray = array;
    lgcgVC.completeBlock = ^(NSDictionary *nodeDic,NSDictionary *childrenDic){
        //        self.postInfo.gategroyInfoDic = @{@"node":nodeDic,@"children":childrenDic};
        NSString *showName = childrenDic[@"name"];
        life_GategroyID = [childrenDic[@"id"] longValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            postGategroyLabel.text = showName;
        });
    };
    [self.navigationController pushViewController:lgcgVC animated:YES];
}

-(void)postRegionButtonClick{
    ProvinceChooseViewController *pcVC = [[ProvinceChooseViewController alloc] init];
    pcVC.stopType = ChooseStopTypeArea;
    [pcVC setResultBlock:^(NSDictionary *resultDic){
        dispatch_async(dispatch_get_main_queue(), ^{
            postRegionLabel.text = resultDic[@"name"];
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

-(void)resignAllInputs{
    [postTitleTextField resignFirstResponder];
    [postContacterTextField resignFirstResponder];
    [postContacterPhoneTextField resignFirstResponder];
    [postDetailAddressTextField resignFirstResponder];
    [detailPostInfoPlaceHolderTextView resignFirstResponder];
    [detailPostInfoTextView resignFirstResponder];
}

-(void)contentScrollerTapGesTriggle{
    [self resignAllInputs];
}

-(void)detailPostButtonClick{
    [self resetUploadStatus];
    [self uploadToServer];
}

-(void)uploadToServer{
    [self resignAllInputs];
    
    NSString *titleString = postTitleTextField.text;
    if ([titleString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"标题不能为空"];
        return;
    }
    if (![self checkString:titleString]) {
        [BYToastView showToastWithMessage:@"标题不能包含特殊字符"];
        return;
    }
    
    NSString *gategroyString = postGategroyLabel.text;
    if ([gategroyString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"分类不能为空"];
        return;
    }
    if (![self checkString:gategroyString]) {
        [BYToastView showToastWithMessage:@"分类不能包含特殊字符"];
        return;
    }
    NSString *contactString = postContacterTextField.text;
    if ([contactString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人不能为空"];
        return;
    }
    if (![self checkString:contactString]) {
        [BYToastView showToastWithMessage:@"联系人不能包含特殊字符"];
        return;
    }
    NSString *contactPhone = postContacterPhoneTextField.text;
    if ([contactPhone isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人电话不能为空"];
        return;
    }
    if (![self checkString:contactPhone]) {
        [BYToastView showToastWithMessage:@"联系人电话不能包含特殊字符"];
        return;
    }
    NSString *address = postDetailAddressTextField.text;
    if ([address isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"详细地址不能为空"];
        return;
    }
    if (![self checkString:address]) {
        [BYToastView showToastWithMessage:@"详细地址不能包含特殊字符"];
        return;
    }
    NSString *detailPosts = detailPostInfoTextView.text;
    if (![self checkString:detailPosts]) {
        [BYToastView showToastWithMessage:@"内容不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@(life_GategroyID) forKey:@"lifeCategory_id"];
    [paramsDic setObject:titleString forKey:@"title"];
    [paramsDic setObject:contactString forKey:@"linkman"];
    [paramsDic setObject:contactPhone forKey:@"phone"];
    [paramsDic setObject:@(areaID) forKey:@"areaId"];
    [paramsDic setObject:detailPosts forKey:@"content"];
    [paramsDic setObject:address forKey:@"address"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    if (defaultPhotoChanged) {
        indicatorView.loadingLabel.text = @"正在上传图片";
        double uploadstart = [[NSDate date] timeIntervalSince1970];
        
        [self uploadImage:addImageButton.imageView.image finish:^(NSString *imageUrl) {
            double uploadend = [[NSDate date] timeIntervalSince1970];
            float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (imageUrl) {
                    [paramsDic setObject:imageUrl forKey:@"image"];
                    //                    [self uploadWithParams:paramsDic];
                    [self uploadContentImageArray:contentPostImageArray andParamsDic:paramsDic];
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                }
            });
        }];
    }else{
        //        [self uploadWithParams:paramsDic];
        [self uploadContentImageArray:contentPostImageArray andParamsDic:paramsDic];
    }
}

-(void)resetUploadStatus{
    uploadImagesStart = YES;
    uploadImagesRemainCount = 0;
    uploadImagesTotalCount = 0;
    uploadImagesCurrentIndex = 0;
    uploadResultArray = nil;
}

static bool uploadImagesStart = YES;
static int uploadImagesRemainCount = 0;
static int uploadImagesTotalCount = 0;
static int uploadImagesCurrentIndex = 0;
static NSMutableArray *uploadResultArray;
-(void)uploadContentImageArray:(NSArray *)array andParamsDic:(NSMutableDictionary *)params{
    if (!contentPostImageArray || contentPostImageArray.count == 0) {
        [self uploadContentImageToServerWithImagesUrlArray:nil params:params];
    }else{
        if (uploadImagesStart) {
            uploadImagesRemainCount = (int)array.count;
            uploadImagesTotalCount = uploadImagesRemainCount;
            uploadImagesCurrentIndex = 0;
            uploadImagesStart = NO;
            uploadResultArray = [NSMutableArray array];
            [self uploadContentImageArray:array andParamsDic:params];
        }else{
            indicatorView.loadingLabel.text = [NSString stringWithFormat:@"正在上传第 %d/%d 张图片",uploadImagesCurrentIndex+1,uploadImagesTotalCount];
            double uploadstart = [[NSDate date] timeIntervalSince1970];
            
            id tmp = contentPostImageArray[uploadImagesCurrentIndex];
            if ([tmp isKindOfClass:[NSString class]]) {
                NSString *imageUrl = (NSString *)tmp;
                if (imageUrl) {
                    [uploadResultArray addObject:imageUrl];
                    uploadImagesRemainCount --;
                    uploadImagesCurrentIndex++;
                    if (uploadImagesRemainCount == 0) {
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                        return;
                    }else{
                        [self uploadContentImageArray:array andParamsDic:params];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                    [self resetUploadStatus];
                }
            }else if ([tmp isKindOfClass:[NSDictionary class]]){
                NSString *imageUrl = [tmp objectForKey:@"source"];
                if (imageUrl) {
                    [uploadResultArray addObject:imageUrl];
                    uploadImagesRemainCount --;
                    uploadImagesCurrentIndex++;
                    if (uploadImagesRemainCount == 0) {
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                        return;
                    }else{
                        [self uploadContentImageArray:array andParamsDic:params];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                    [self resetUploadStatus];
                }
            }else if ([tmp isKindOfClass:[UIImage class]]){
                UIImage *uploadContentImage = (UIImage *)tmp;
                [self uploadContentImage:uploadContentImage finish:^(NSString *imageUrl) {
                    double uploadend = [[NSDate date] timeIntervalSince1970];
                    float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (imageUrl) {
                            [uploadResultArray addObject:imageUrl];
                            uploadImagesRemainCount --;
                            uploadImagesCurrentIndex++;
                            if (uploadImagesRemainCount == 0) {
                                [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                                return;
                            }else{
                                [self uploadContentImageArray:array andParamsDic:params];
                            }
                        }else{
                            [indicatorView stopAnimating:YES];
                            [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                            [self resetUploadStatus];
                        }
                    });
                }];
            }
        }
    }
}

-(void)uploadContentImage:(UIImage *)image finish:(void (^)(NSString *imageUrl))finish{
    if (image) {
        UIImage *reszieImage = image;
        reszieImage = [reszieImage resizeImageGreaterThan:1280];
        [UNUrlConnection suggestionPostImage:reszieImage finish:^(NSString *imageUrl, NSString *errorString) {
            if (imageUrl) {
                finish(imageUrl);
            }else{
                finish(nil);
            }
        }];
    }
}

-(void)uploadContentImageToServerWithImagesUrlArray:(NSArray *)array params:(NSMutableDictionary *)params{
    if (array) {
        [array enumerateObjectsUsingBlock:^(NSString *urlstring, NSUInteger idx, BOOL *stop) {
            if (params) {
                [params setObject:urlstring forKey:[NSString stringWithFormat:@"imgs[%ld].source",idx]];
            }
        }];
    }
    if (isNewPost) {
        [self uploadWithParams:params];
    }else{
        [self saveWithParams:params];
    }
}

-(void)uploadWithParams:(NSMutableDictionary *)paramsDic{
    indicatorView.loadingLabel.text = @"提交至服务器";
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    [UNUrlConnection uploadLifeHelperWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                NSDictionary *messDic = resultDic[@"message"];
                NSString *typeString = messDic[@"type"];
                if (typeString && [typeString isEqualToString:@"success"]) {
                    [BYToastView showToastWithMessage:@"发布成功,感谢您的支持"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [BYToastView showToastWithMessage:@"发送失败,请稍候重试"];
                }
            }
        });
    }];
}

-(void)uploadImage:(UIImage *)image finish:(void (^)(NSString *imageUrl))finish{
    if (image) {
        UIImage *reszieImage = image;
        reszieImage = [reszieImage resizeImageGreaterThan:1280];
        [UNUrlConnection suggestionPostImage:reszieImage finish:^(NSString *imageUrl, NSString *errorString) {
            if (imageUrl) {
                finish(imageUrl);
            }else{
                finish(nil);
            }
        }];
    }
}

-(void)detailPostSaveButtonClick{
    [self resetUploadStatus];
    [self resignAllInputs];
    
    NSString *titleString = postTitleTextField.text;
    if ([titleString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"标题不能为空"];
        return;
    }
    if (![self checkString:titleString]) {
        [BYToastView showToastWithMessage:@"标题不能包含特殊字符"];
        return;
    }
    
    NSString *gategroyString = postGategroyLabel.text;
    if ([gategroyString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"分类不能为空"];
        return;
    }
    if (![self checkString:gategroyString]) {
        [BYToastView showToastWithMessage:@"分类不能包含特殊字符"];
        return;
    }
    NSString *contactString = postContacterTextField.text;
    if ([contactString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人不能为空"];
        return;
    }
    if (![self checkString:contactString]) {
        [BYToastView showToastWithMessage:@"联系人不能包含特殊字符"];
        return;
    }
    NSString *contactPhone = postContacterPhoneTextField.text;
    if ([contactPhone isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"联系人电话不能为空"];
        return;
    }
    if (![self checkString:contactPhone]) {
        [BYToastView showToastWithMessage:@"联系人电话不能包含特殊字符"];
        return;
    }
    NSString *address = postDetailAddressTextField.text;
    if ([address isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"详细地址不能为空"];
        return;
    }
    if (![self checkString:address]) {
        [BYToastView showToastWithMessage:@"详细地址不能包含特殊字符"];
        return;
    }
    NSString *detailPosts = detailPostInfoTextView.text;
    if (![self checkString:detailPosts]) {
        [BYToastView showToastWithMessage:@"内容不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:lid forKey:@"id"];
    [paramsDic setObject:@(life_GategroyID) forKey:@"lifeCategory_id"];
    [paramsDic setObject:titleString forKey:@"title"];
    [paramsDic setObject:contactString forKey:@"linkman"];
    [paramsDic setObject:contactPhone forKey:@"phone"];
    [paramsDic setObject:@(areaID) forKey:@"areaId"];
    [paramsDic setObject:detailPosts forKey:@"content"];
    [paramsDic setObject:address forKey:@"address"];
    
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    if (defaultPhotoChanged) {
        indicatorView.loadingLabel.text = @"正在上传图片";
        double uploadstart = [[NSDate date] timeIntervalSince1970];
        
        [self uploadImage:addImageButton.imageView.image finish:^(NSString *imageUrl) {
            double uploadend = [[NSDate date] timeIntervalSince1970];
            float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (imageUrl) {
                    [paramsDic setObject:imageUrl forKey:@"image"];
                    
                    if (defaultContentPhotoChanged) {
                        [self uploadContentImageArray:contentPostImageArray andParamsDic:paramsDic];
                    }else{
                        if (lifeImagesArray && lifeImagesArray.count != 0) {
                            int i = 0;
                            for (NSString *lifeImageURL in lifeImagesArray) {
                                [paramsDic setObject:lifeImageURL forKey:[NSString stringWithFormat:@"imgs[%d].source",i]];
                                i++;
                            }
                        }
                        [self saveWithParams:paramsDic];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                }
            });
        }];
    }else{
        if (defaultImageUrl) {
            [paramsDic setObject:defaultImageUrl forKey:@"image"];
        }
        if (defaultContentPhotoChanged) {
            [self uploadContentImageArray:contentPostImageArray andParamsDic:paramsDic];
        }else{
            if (lifeImagesArray && lifeImagesArray.count != 0) {
                int i = 0;
                for (NSDictionary *lifeImageURL in lifeImagesArray) {
                    [paramsDic setObject:lifeImageURL forKey:[NSString stringWithFormat:@"imgs[%d].source",i]];
                    i++;
                }
            }
            [self saveWithParams:paramsDic];
        }
    }
}

-(void)saveWithParams:(NSMutableDictionary *)params{
    indicatorView.loadingLabel.text = @"提交至服务器";
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    [UNUrlConnection updateLifeHelperWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }else{
                NSDictionary *messDic = resultDic[@"message"];
                NSString *typeString = messDic[@"type"];
                if (typeString && [typeString isEqualToString:@"success"]) {
                    [BYToastView showToastWithMessage:@"保存成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [BYToastView showToastWithMessage:@"保存失败,请稍候再试"];
                }
            }
        });
    }];
}


-(void)detailDeleteButtonClick{
    if (!lid) {
        [BYToastView showToastWithMessage:@"删除信息失败,请联系客服"];
    }
    [UNUrlConnection deleteLifeHelperWithID:lid complete:^(NSDictionary *resultDic, NSString *errorString) {
        [indicatorView stopAnimating:YES];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }else{
            NSDictionary *messDic = resultDic[@"message"];
            NSString *typeString = messDic[@"type"];
            if (typeString && [typeString isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"已删除"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *contentString = [messDic objectForKey:@"content"];
                if (!contentString) {
                    contentString = @"删除失败,请稍候再试";
                }
                [BYToastView showToastWithMessage:contentString];
            }
        }
    }];
}


-(BOOL)checkString:(NSString *)string{
    if ([string rangeOfString:@"*"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"&"].length != 0) {
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignAllInputs];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scrollView.tag == 19797) {
        if (scale<1.f) {
            [scrollView setZoomScale:1.f animated:YES];
            if (scale<0.7f)
                [self exitCheckImgView];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 19797) {
        UIImageView *subView = (UIImageView*)[scrollView viewWithTag:1001];
        return subView;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == postTitleTextField) {
        [postContacterTextField becomeFirstResponder];
    }else if (textField == postContacterTextField) {
        [postContacterPhoneTextField becomeFirstResponder];
    }else if (textField == postContacterPhoneTextField) {
        [postDetailAddressTextField becomeFirstResponder];
    }else if (textField == postDetailAddressTextField) {
        [detailPostInfoTextView becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 18111) {
        if (![text isEqualToString:@""]){
            detailPostInfoPlaceHolderTextView.hidden = YES;
        }
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
            detailPostInfoPlaceHolderTextView.hidden = NO;
        }
    }
    return YES;
}

#pragma mark - PhotoLibraryChooseViewDelegate
-(void)photoLibraryChooseView:(PhotoLibraryChooseView *)chooseView didFinishChoosingImage:(UIImage *)image{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
    cropController.delegate = self;
    cropController.aspectRadio = (CGSize){16,9};
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
    
    if (chooseView.tag == 101) {
        UIImage *resizeImage = [image scaleWithRadio:WIDTH(addImageButton)/image.size.width];
        
        [addImageButton setImage:resizeImage forState:UIControlStateNormal];
        defaultPhotoChanged = YES;
    }else if (chooseView.tag == 102) {
        if (!contentPostImageArray) {
            contentPostImageArray = [NSMutableArray array];
        }
        [contentPostImageArray addObject:image];
        defaultContentPhotoChanged = YES;
        [self reloadImageSrollContainer:contentPostImageArray];
    }
}

// 点击取消或从外部应用调回时触发的代理  如果canceled为yes 标识 可以认为是用户手动点击了取消按钮
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
}


//imagedelete
-(void)reloadImageSrollContainer:(NSArray *)array{
    [cameraView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj != addContentImageButton) {
            [obj removeFromSuperview];
        }
    }];
    for (int i = 0;i<array.count;i++) {
        int XAligh = i%3;
        int YAligh = i/3;
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = (CGRect){10+(everyButtonWidth+8)*XAligh,10+(everyButtonWidth+8)*YAligh,everyButtonWidth,everyButtonWidth};
        button.tag = i;
        [button addTarget:self action:@selector(contentImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cameraView addSubview:button];
        button.layer.cornerRadius = 2.f;
        button.layer.borderColor = RGBColor(200, 200, 200).CGColor;
        button.layer.borderWidth = 0.5f;
        
        UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, everyButtonWidth, everyButtonWidth)];
        id tmp = array[i];
        if ([tmp isKindOfClass:[UIImage class]]) {
            postImageView.image = array[i];
        }else if ([tmp isKindOfClass:[NSString class]]){
            tmp = [UNUrlConnection replaceUrl:tmp];
            [postImageView setImageWithURL:[NSURL URLWithString:tmp] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        }else if ([tmp isKindOfClass:[NSDictionary class]]){
            NSString *urlString = [tmp objectForKey:@"source"];
            urlString = [UNUrlConnection replaceUrl:urlString];
            [postImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        }
        [button addSubview:postImageView];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(everyButtonWidth-15, -10, 25, 25);
        [button addSubview:deleteButton];
        [deleteButton setImage:[UIImage imageNamed:@"imagedelete"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(contetImageDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int XAligh = (int)(array.count%3);
    int YAligh = (int)(array.count/3);
    addContentImageButton.frame = (CGRect){10+(everyButtonWidth+8)*XAligh,10+(everyButtonWidth+8)*YAligh,everyButtonWidth,everyButtonWidth};
    
    CGRect rect = cameraView.frame;
    cameraView.frame = (CGRect){rect.origin.x,rect.origin.y,rect.size.width,10*2+BOTTOM(addContentImageButton)};
    
    contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),MAX(BOTTOM(cameraView), HEIGHT(contentScrollerView)+1)};
    [contentScrollerView setContentOffset:(CGPoint){0,contentScrollerView.contentSize.height-contentScrollerView.frame.size.height} animated:YES];
}

-(void)contentImageButtonClick:(UIButton *)button{
    [self resignAllInputs];
    UIImageView *imageView = button.subviews[0];
    
    UIImage *image = imageView.image;
    if (image) {
        [self checkImgInFullScreen:button withImage:image];
    }
}

-(void)contetImageDeleteButtonClick:(UIButton *)buttn{
    [contentPostImageArray removeObjectAtIndex:buttn.tag];
    
    [self reloadImageSrollContainer:contentPostImageArray];
}

static CGRect rectInFullScreen;
-(void)checkImgInFullScreen:(UIView*)view withImage:(UIImage *)imgaeToShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgColorView.alpha = 0.f;
    bgColorView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    bgColorView.tag = 17978;
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
    fullscreenBottomView.tag = 19797;
    [keyWindow addSubview:fullscreenBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCheckImgView)];
    [fullscreenBottomView addGestureRecognizer:tap];
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    rectInFullScreen = [view convertRect:view.frame toView:window];
    UIImageView *imgViewIsShowing = [[UIImageView alloc] initWithFrame:rectInFullScreen];
    
    UIImage *imgToShow = imgaeToShow;
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
    [self resignAllInputs];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:19797];
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
    [self resignAllInputs];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *viewBg = [keyWindow viewWithTag:17978];
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:19797];
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView*)[viewScroll.subviews firstObject]).frame = rectInFullScreen;
        viewScroll.alpha = 0.f;
        viewBg.alpha = 0.f;
    }completion:^(BOOL finished) {
        [viewScroll removeFromSuperview];
        [viewBg removeFromSuperview];
    }];
}

#pragma mark -
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
