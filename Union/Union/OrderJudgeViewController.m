//
//  OrderJudgeViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/11.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderJudgeViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RatingView.h"
#import "UNUrlConnection.h"

@interface OrderJudgeViewController () <RatingViewDelegate,UITextViewDelegate,UIScrollViewDelegate>

@end

@implementation OrderJudgeViewController{
    TPKeyboardAvoidingScrollView *contentView;
    
    UIImageView *perfectSelectedImage;
    UIImageView *justSelectedImage;
    UIImageView *badSelectedImage;
    
    int currentSelectDeliveryIndex;
    
    RatingView *judgeDeliveryServiceRatingView;
    RatingView *judgeShopItemQualityRatingView;
    
    UILabel *judgeDeliveryServiceValueLabel;
    UILabel *judgeShopItemQualityValueLabel;
    
    UITextView *judgeMessagePlaceHolderTextView;
    UITextView *judgeMessageInfoTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"评价";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-45};
    contentView.backgroundColor = RGBColor(240, 240, 240);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    bottomView.backgroundColor = UN_RedColor;
    [self.view addSubview:bottomView];
    
    UIButton *bottomJudgeComfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomJudgeComfirmButton.frame = (CGRect){0,0,WIDTH(bottomView),HEIGHT(bottomView)};
    [bottomJudgeComfirmButton setTitleColor:RGBColor(250, 250, 250) forState:UIControlStateNormal];
    [bottomJudgeComfirmButton setTitle:@"提交评价" forState:UIControlStateNormal];
    bottomJudgeComfirmButton.titleLabel.font = Font(18);
    [bottomView addSubview:bottomJudgeComfirmButton];
    [bottomJudgeComfirmButton addTarget:self action:@selector(bottomJudgeComfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    float offset = 0;
    float headViewHeight = 40;
    float contentViewHeight = 45;
    UIView *judgeDeliveryView = [[UIView alloc] init];
    judgeDeliveryView.frame = (CGRect){0,offset,WIDTH(contentView),headViewHeight};
    judgeDeliveryView.backgroundColor = RGBColor(220, 220, 220);
    [contentView addSubview:judgeDeliveryView];
    
    UILabel *judgeDeliveryLabel = [[UILabel alloc] init];
    judgeDeliveryLabel.frame = (CGRect){15,0,WIDTH(judgeDeliveryView),HEIGHT(judgeDeliveryView)};
    judgeDeliveryLabel.text = @"配送评价";
    judgeDeliveryLabel.textColor = RGBColor(120, 120, 120);
    judgeDeliveryLabel.textAlignment = NSTextAlignmentLeft;
    judgeDeliveryLabel.font = Font(16);
    [judgeDeliveryView addSubview:judgeDeliveryLabel];
    
    UIView *judgeDeliverySepLineView = [[UIView alloc] init];
    judgeDeliverySepLineView.frame = (CGRect){0,headViewHeight-0.5,WIDTH(contentView),0.5};
    judgeDeliverySepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeDeliveryView addSubview:judgeDeliverySepLineView];
    
    offset += HEIGHT(judgeDeliveryView);
    
    UIView *judgeDeliveryTimeView = [[UIView alloc] init];
    judgeDeliveryTimeView.frame = (CGRect){0,offset,WIDTH(contentView),contentViewHeight};
    judgeDeliveryTimeView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:judgeDeliveryTimeView];
    
    UIView *judgeDeliveryTimeTopSepLineView =[[UIView alloc] init];
    judgeDeliveryTimeTopSepLineView.frame = (CGRect){0,0,WIDTH(judgeDeliveryTimeView),0.5};
    judgeDeliveryTimeTopSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeDeliveryTimeView addSubview:judgeDeliveryTimeTopSepLineView];
    
    UILabel *judgeDeliveryTimeLabel = [[UILabel alloc] init];
    judgeDeliveryTimeLabel.frame = (CGRect){15,0,80,HEIGHT(judgeDeliveryTimeView)};
    judgeDeliveryTimeLabel.text = @"送达时间";
    judgeDeliveryTimeLabel.textColor = RGBColor(80,80,80);
    judgeDeliveryTimeLabel.textAlignment = NSTextAlignmentLeft;
    judgeDeliveryTimeLabel.font = Font(17);
    [judgeDeliveryTimeView addSubview:judgeDeliveryTimeLabel];
    
    UIButton *perfectDeliveryButton;
    UIButton *justDeliveryButton;
    UIButton *badDeliveryButton;
    
    float deliveryButtonWidth = (WIDTH(judgeDeliveryTimeView)-15-80)/3.f;
    perfectDeliveryButton = [[UIButton alloc] init];
    perfectDeliveryButton.frame = (CGRect){RIGHT(judgeDeliveryTimeLabel),0,deliveryButtonWidth,HEIGHT(judgeDeliveryTimeView)};
    perfectDeliveryButton.tag = 0;
    [perfectDeliveryButton addTarget:self action:@selector(deliveryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [judgeDeliveryTimeView addSubview:perfectDeliveryButton];
    
    perfectSelectedImage = [[UIImageView alloc] init];
    perfectSelectedImage.frame = (CGRect){0,(HEIGHT(perfectDeliveryButton)-22)/2,22,22};
    perfectSelectedImage.image = [UIImage imageNamed:@"selected"];
    [perfectDeliveryButton addSubview: perfectSelectedImage];
    
    UILabel *perfectLabel = [[UILabel alloc] init];
    perfectLabel.frame = (CGRect){RIGHT(perfectSelectedImage)+10,0,WIDTH(perfectDeliveryButton)-(RIGHT(perfectSelectedImage)+10)-10,HEIGHT(perfectDeliveryButton)};
    perfectLabel.text = @"准确";
    perfectLabel.textAlignment = NSTextAlignmentLeft;
    perfectLabel.textColor = RGBColor(80, 80, 80);
    perfectLabel.font = Font(15);
    [perfectDeliveryButton addSubview: perfectLabel];
    
    currentSelectDeliveryIndex = 0;
    
    justDeliveryButton = [[UIButton alloc] init];
    justDeliveryButton.frame = (CGRect){RIGHT(judgeDeliveryTimeLabel)+deliveryButtonWidth,0,deliveryButtonWidth,HEIGHT(judgeDeliveryTimeView)};
    justDeliveryButton.tag = 1;
    [justDeliveryButton addTarget:self action:@selector(deliveryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [judgeDeliveryTimeView addSubview:justDeliveryButton];
    
    justSelectedImage = [[UIImageView alloc] init];
    justSelectedImage.frame = (CGRect){0,(HEIGHT(justDeliveryButton)-22)/2,22,22};
    justSelectedImage.image = [UIImage imageNamed:@"unselected"];
    [justDeliveryButton addSubview:justSelectedImage];
    
    UILabel *justLabel = [[UILabel alloc] init];
    justLabel.frame = (CGRect){RIGHT(justSelectedImage)+10,0,WIDTH(justDeliveryButton)-(RIGHT(justSelectedImage)+10)-10,HEIGHT(justDeliveryButton)};
    justLabel.text = @"不准确";
    justLabel.textAlignment = NSTextAlignmentLeft;
    justLabel.textColor = RGBColor(80, 80, 80);
    justLabel.font = Font(15);
    [justDeliveryButton addSubview: justLabel];
    
    badDeliveryButton = [[UIButton alloc] init];
    badDeliveryButton.frame = (CGRect){RIGHT(judgeDeliveryTimeLabel)+deliveryButtonWidth*2,0,deliveryButtonWidth,HEIGHT(judgeDeliveryTimeView)};
    badDeliveryButton.tag = 2;
    [badDeliveryButton addTarget:self action:@selector(deliveryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [judgeDeliveryTimeView addSubview:badDeliveryButton];
    
    badSelectedImage = [[UIImageView alloc] init];
    badSelectedImage.frame = (CGRect){0,(HEIGHT(badDeliveryButton)-22)/2,22,22};
    badSelectedImage.image = [UIImage imageNamed:@"unselected"];
    [badDeliveryButton addSubview:badSelectedImage];
    
    UILabel *badLabel = [[UILabel alloc] init];
    badLabel.frame = (CGRect){RIGHT(badSelectedImage)+10,0,WIDTH(badDeliveryButton)-(RIGHT(badSelectedImage)+10)-10,HEIGHT(badDeliveryButton)};
    badLabel.text = @"还行";
    badLabel.textAlignment = NSTextAlignmentLeft;
    badLabel.textColor = RGBColor(80, 80, 80);
    badLabel.font = Font(15);
    [badDeliveryButton addSubview:badLabel];
    
    UIView *judgeDeliveryTimeBottomSepLineView =[[UIView alloc] init];
    judgeDeliveryTimeBottomSepLineView.frame = (CGRect){15,HEIGHT(judgeDeliveryTimeView)-0.5,WIDTH(judgeDeliveryTimeView)-15,0.5};
    judgeDeliveryTimeBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeDeliveryTimeView addSubview:judgeDeliveryTimeBottomSepLineView];
    
    offset += HEIGHT(judgeDeliveryTimeView);
    
    UIView *judgeDeliveryServiceView = [[UIView alloc] init];
    judgeDeliveryServiceView.frame = (CGRect){0,offset,WIDTH(contentView),contentViewHeight};
    judgeDeliveryServiceView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:judgeDeliveryServiceView];
    
    UILabel *judgeDeliveryServiceLabel = [[UILabel alloc] init];
    judgeDeliveryServiceLabel.frame = (CGRect){15,0,80,HEIGHT(judgeDeliveryTimeView)};
    judgeDeliveryServiceLabel.text = @"配送服务";
    judgeDeliveryServiceLabel.textColor = RGBColor(80,80,80);
    judgeDeliveryServiceLabel.textAlignment = NSTextAlignmentLeft;
    judgeDeliveryServiceLabel.font = Font(17);
    [judgeDeliveryServiceView addSubview:judgeDeliveryServiceLabel];
    
    judgeDeliveryServiceRatingView = [[RatingView alloc] init];
    [judgeDeliveryServiceRatingView setImagesDeselected:@"star_big" partlySelected:@"star_on_big" fullSelected:@"star_on_big"];
    judgeDeliveryServiceRatingView.canTouchToChange = YES;
    judgeDeliveryServiceRatingView.frame = (CGRect){RIGHT(judgeDeliveryServiceLabel),(HEIGHT(judgeDeliveryServiceView)-20)/2,105,20};
    judgeDeliveryServiceRatingView.delegate = self;
    [judgeDeliveryServiceRatingView displayRating:5];
    [judgeDeliveryServiceView addSubview:judgeDeliveryServiceRatingView];
    
    judgeDeliveryServiceValueLabel = [[UILabel alloc] init];
    judgeDeliveryServiceValueLabel.frame = (CGRect){RIGHT(judgeDeliveryServiceRatingView)+20,0,80,HEIGHT(judgeDeliveryServiceView)};
    judgeDeliveryServiceValueLabel.text = @"极好";
    judgeDeliveryServiceValueLabel.textColor = UN_RedColor;
    judgeDeliveryServiceValueLabel.textAlignment = NSTextAlignmentLeft;
    judgeDeliveryServiceValueLabel.font = Font(17);
    [judgeDeliveryServiceView addSubview:judgeDeliveryServiceValueLabel];
    
    offset += HEIGHT(judgeDeliveryServiceView);
    
    UIView *judgeShopItemView = [[UIView alloc] init];
    judgeShopItemView.frame = (CGRect){0,offset,WIDTH(contentView),headViewHeight};
    judgeShopItemView.backgroundColor = RGBColor(220, 220, 220);
    [contentView addSubview:judgeShopItemView];
    
    UILabel *judgeShopItemLabel = [[UILabel alloc] init];
    judgeShopItemLabel.frame = (CGRect){15,0,WIDTH(judgeShopItemView),HEIGHT(judgeShopItemView)};
    judgeShopItemLabel.text = @"商品评价";
    judgeShopItemLabel.textColor = RGBColor(120, 120, 120);
    judgeShopItemLabel.textAlignment = NSTextAlignmentLeft;
    judgeShopItemLabel.font = Font(16);
    [judgeShopItemView addSubview:judgeShopItemLabel];
    
    UIView *judgeShopItemSepLineView = [[UIView alloc] init];
    judgeShopItemSepLineView.frame = (CGRect){0,headViewHeight-0.5,WIDTH(contentView),0.5};
    judgeShopItemSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeShopItemView addSubview:judgeShopItemSepLineView];
    
    offset += HEIGHT(judgeShopItemView);
    
    UIView *judgeShopItemQualityView = [[UIView alloc] init];
    judgeShopItemQualityView.frame = (CGRect){0,offset,WIDTH(contentView),contentViewHeight};
    judgeShopItemQualityView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:judgeShopItemQualityView];
    
    UILabel *judgeDShopItemQualityLabel = [[UILabel alloc] init];
    judgeDShopItemQualityLabel.frame = (CGRect){15,0,80,HEIGHT(judgeShopItemQualityView)};
    judgeDShopItemQualityLabel.text = @"商品评价";
    judgeDShopItemQualityLabel.textColor = RGBColor(80,80,80);
    judgeDShopItemQualityLabel.textAlignment = NSTextAlignmentLeft;
    judgeDShopItemQualityLabel.font = Font(17);
    [judgeShopItemQualityView addSubview:judgeDShopItemQualityLabel];
    
    judgeShopItemQualityRatingView = [[RatingView alloc] init];
    [judgeShopItemQualityRatingView setImagesDeselected:@"star_big" partlySelected:@"star_on_big" fullSelected:@"star_on_big"];
    judgeShopItemQualityRatingView.canTouchToChange = YES;
    [judgeShopItemQualityRatingView displayRating:5];
    judgeShopItemQualityRatingView.frame = (CGRect){RIGHT(judgeDShopItemQualityLabel),(HEIGHT(judgeShopItemQualityView)-20)/2,105,20};
    judgeShopItemQualityRatingView.delegate = self;
    [judgeShopItemQualityView addSubview:judgeShopItemQualityRatingView];
    
    judgeShopItemQualityValueLabel = [[UILabel alloc] init];
    judgeShopItemQualityValueLabel.frame = (CGRect){RIGHT(judgeShopItemQualityRatingView)+20,0,80,HEIGHT(judgeShopItemQualityView)};
    judgeShopItemQualityValueLabel.text = @"极好";
    judgeShopItemQualityValueLabel.textColor = UN_RedColor;
    judgeShopItemQualityValueLabel.textAlignment = NSTextAlignmentLeft;
    judgeShopItemQualityValueLabel.font = Font(17);
    [judgeShopItemQualityView addSubview:judgeShopItemQualityValueLabel];
    
    offset += HEIGHT(judgeShopItemQualityView);
    
    UIView *judgeMessageView = [[UIView alloc] init];
    judgeMessageView.frame = (CGRect){0,offset,WIDTH(contentView),headViewHeight};
    judgeMessageView.backgroundColor = RGBColor(220, 220, 220);
    [contentView addSubview:judgeMessageView];
    
    UILabel *judgeMessageLabel = [[UILabel alloc] init];
    judgeMessageLabel.frame = (CGRect){15,0,WIDTH(judgeMessageView),HEIGHT(judgeMessageView)};
    judgeMessageLabel.text = @"写点什么";
    judgeMessageLabel.textColor = RGBColor(120, 120, 120);
    judgeMessageLabel.textAlignment = NSTextAlignmentLeft;
    judgeMessageLabel.font = Font(16);
    [judgeMessageView addSubview:judgeMessageLabel];
    
    UIView *judgeMessageSepLineView = [[UIView alloc] init];
    judgeMessageSepLineView.frame = (CGRect){0,headViewHeight-0.5,WIDTH(contentView),0.5};
    judgeMessageSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [judgeMessageView addSubview:judgeMessageSepLineView];
    
    offset += HEIGHT(judgeMessageView);
    
    UIView *judgeMessageDetailView = [[UIView alloc] init];
    judgeMessageDetailView.frame = (CGRect){0,offset,WIDTH(contentView),200};
    judgeMessageDetailView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:judgeMessageDetailView];
    
    
    judgeMessagePlaceHolderTextView = [[UITextView alloc] init];
    judgeMessagePlaceHolderTextView.backgroundColor = RGBColor(250, 250, 250);
    judgeMessagePlaceHolderTextView.frame = (CGRect){10,0,(WIDTH(contentView)-20),200};
    judgeMessagePlaceHolderTextView.textColor = RGBColor(200, 200, 200);
    judgeMessagePlaceHolderTextView.font = Font(15);
    judgeMessagePlaceHolderTextView.keyboardType = UIKeyboardTypeDefault;
    judgeMessagePlaceHolderTextView.returnKeyType = UIReturnKeyDone;
    judgeMessagePlaceHolderTextView.text = @"请输入详细信息";
    judgeMessagePlaceHolderTextView.hidden = NO;
    judgeMessagePlaceHolderTextView.userInteractionEnabled = NO;
    judgeMessagePlaceHolderTextView.editable = NO;
    judgeMessagePlaceHolderTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    judgeMessagePlaceHolderTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [judgeMessageDetailView addSubview:judgeMessagePlaceHolderTextView];
    
    judgeMessageInfoTextView = [[UITextView alloc] init];
    judgeMessageInfoTextView.backgroundColor = [UIColor clearColor];
    judgeMessageInfoTextView.frame = judgeMessagePlaceHolderTextView.frame;
    judgeMessageInfoTextView.textColor = RGBColor(100, 100, 100);
    judgeMessageInfoTextView.font = Font(15);
    judgeMessageInfoTextView.tag = 18222;
    judgeMessageInfoTextView.delegate = self;
    judgeMessageInfoTextView.keyboardType = UIKeyboardTypeDefault;
    judgeMessageInfoTextView.returnKeyType = UIReturnKeyNext;
    judgeMessageInfoTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    judgeMessageInfoTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [judgeMessageDetailView addSubview:judgeMessageInfoTextView];
    
    offset += HEIGHT(judgeMessageInfoTextView);
    
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, offset)};
}

-(void)bottomJudgeComfirmButtonClick{
    /**
     *  todo 评价接口测试
     *
     */
    NSString *judgeMessInfoString = judgeMessageInfoTextView.text;
    
    if (![judgeMessInfoString isEqualToString:@""] && ![self checkString:judgeMessInfoString]) {
        [BYToastView showToastWithMessage:@"评价总不能包含特殊字符,请重新输入"];
        return;
    }
    
    //判断送达时间的评价
    //currentSelectDeliveryIndex  为0表示准备  为1表示不准确  为2表示还行
    
    int judgeDeliveryTimeServiceValue = 0;
    if (currentSelectDeliveryIndex == 0) {
        judgeDeliveryTimeServiceValue = 5;
    }else if (currentSelectDeliveryIndex == 1){
        judgeDeliveryTimeServiceValue = 4;
    }else if (currentSelectDeliveryIndex == 2){
        judgeDeliveryTimeServiceValue = 3;
    }
    //配送服务的评价
    int judgeDeliveryServiceValue = (int)ceilf(judgeDeliveryServiceRatingView.selectedStarNum);
    //商品评价的评价
    int judgeShopItemQualityValue = (int)ceilf(judgeShopItemQualityRatingView.selectedStarNum);
    // value的值  1,2,3,4,5 代表5个等级
    
    float score = (judgeShopItemQualityValue+judgeDeliveryServiceValue+judgeDeliveryTimeServiceValue)/3.f;
    
    [UNUrlConnection submitJudgeWithShopID:self.orderInfo.shopID judgeContent:judgeMessInfoString score:score complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            [BYToastView showToastWithMessage:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
    if ([string rangeOfString:@"%"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"="].length != 0) {
        return NO;
    }
    return YES;
}

-(void)deliveryButtonClick:(UIButton *)button{
    perfectSelectedImage.image = [UIImage imageNamed:@"unselected"];
    justSelectedImage.image = [UIImage imageNamed:@"unselected"];
    badSelectedImage.image = [UIImage imageNamed:@"unselected"];
    switch (button.tag) {
        case 0:{
            perfectSelectedImage.image = [UIImage imageNamed:@"selected"];
            currentSelectDeliveryIndex = 0;
        }
            break;
        case 1:{
            justSelectedImage.image = [UIImage imageNamed:@"selected"];
            currentSelectDeliveryIndex = 1;
        }
            break;
        case 2:{
            badSelectedImage.image = [UIImage imageNamed:@"selected"];
            currentSelectDeliveryIndex = 2;
        }
            break;
        default:
            currentSelectDeliveryIndex = -1;
            break;
    }
}


#pragma mark - RatingViewDelegate
-(void)ratingViewDidChangeValue:(RatingView *)ratingView{
    int value = (int)ceilf(ratingView.selectedStarNum);
    NSString *showedValue;
    switch (value) {
        case 1:
            showedValue = @"差评";
            break;
        case 2:
            showedValue = @"还行";
            break;
        case 3:
            showedValue = @"不错";
            break;
        case 4:
            showedValue = @"很好";
            break;
        case 5:
            showedValue = @"极好";
            break;
        default:
            break;
    }
    if (!showedValue) {
        return;
    }
    if (ratingView == judgeDeliveryServiceRatingView) {
        judgeDeliveryServiceValueLabel.text = showedValue;
    }else if (ratingView == judgeShopItemQualityRatingView){
        judgeShopItemQualityValueLabel.text = showedValue;
    }
}

#pragma mark - UITextViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [judgeMessageInfoTextView resignFirstResponder];
    [judgeMessagePlaceHolderTextView resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [judgeMessageInfoTextView resignFirstResponder];
    [judgeMessagePlaceHolderTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 18222) {
        if (![text isEqualToString:@""]){
            judgeMessagePlaceHolderTextView.hidden = YES;
        }
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
            judgeMessagePlaceHolderTextView.hidden = NO;
        }
    }
    return YES;
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
