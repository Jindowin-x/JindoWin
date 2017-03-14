//
//  ShopsTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/11.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopsTableViewCell.h"
#import "RatingView/RatingView.h"



@interface ShopsTableViewCell ()

@property (nonatomic,strong) RatingView *ratingView;

@property (nonatomic,strong) UILabel *minBuyLabel;

@property (nonatomic,strong) UILabel *minBuyNoteLabel;

@property (nonatomic,strong) UILabel *deliveryNumberLabel;

@property (nonatomic,strong) UILabel *deliveryNumberNoteLabel;

@property (nonatomic,strong) UILabel *businessStateLabel;

@property (nonatomic,strong) UILabel *sourceLabel;

@property (nonatomic,strong) UILabel *juanLabel;

@property (nonatomic,strong) UILabel *piaoLabel;

@property (nonatomic,strong) UILabel *fuLabel;

@property (nonatomic,strong) UILabel *peiLabel;

@end

@implementation ShopsTableViewCell

@synthesize ratingView;

@synthesize minBuyLabel,minBuyNoteLabel,deliveryNumberLabel,deliveryNumberNoteLabel,businessStateLabel,sourceLabel;

@synthesize juanLabel,piaoLabel,fuLabel,peiLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ratingView = [[RatingView alloc] init];
        [ratingView setImagesDeselected:@"star" partlySelected:@"star_on" fullSelected:@"star_on"];
        ratingView.frame = (CGRect){80,35,75,15};
        ratingView.hidden = YES;
        [self.contentView addSubview:ratingView];
        
        minBuyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:minBuyLabel];
        
        minBuyNoteLabel = [[UILabel alloc] init];
        [self.contentView addSubview:minBuyNoteLabel];
        
        deliveryNumberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:deliveryNumberLabel];
        
        deliveryNumberNoteLabel = [[UILabel alloc] init];
        [self.contentView addSubview:deliveryNumberNoteLabel];
        
        businessStateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:businessStateLabel];
        
        sourceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:sourceLabel];
        
        juanLabel = [[UILabel alloc] init];
        [self.contentView addSubview:juanLabel];
        juanLabel.layer.cornerRadius = 8.f;
        juanLabel.layer.masksToBounds = YES;
        juanLabel.layer.borderWidth = 1.f;
        juanLabel.layer.borderColor = UN_GreenColor_CGColor;
        juanLabel.textColor = UN_GreenColor;
        
        piaoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:piaoLabel];
        piaoLabel.layer.cornerRadius = 8.f;
        piaoLabel.layer.masksToBounds = YES;
        piaoLabel.layer.borderWidth = 1.f;
        piaoLabel.layer.borderColor = UN_GreenColor_CGColor;
        piaoLabel.textColor = UN_GreenColor;
        
        fuLabel = [[UILabel alloc] init];
        [self.contentView addSubview:fuLabel];
        fuLabel.layer.cornerRadius = 8.f;
        fuLabel.layer.masksToBounds = YES;
        fuLabel.layer.borderWidth = 1.f;
        fuLabel.layer.borderColor = UN_GreenColor_CGColor;
        fuLabel.textColor = UN_GreenColor;
        
        peiLabel = [[UILabel alloc] init];
        [self.contentView addSubview:peiLabel];
        peiLabel.layer.cornerRadius = 8.f;
        peiLabel.layer.masksToBounds = YES;
        peiLabel.layer.borderWidth = 1.f;
        peiLabel.layer.borderColor = UN_GreenColor_CGColor;
        peiLabel.textColor = UN_GreenColor;
        
        self.textLabel.font = IS5_5Inches()?Font(17.f):Font(16);
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.detailTextLabel.font = Font(12);
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        sourceLabel.textAlignment = NSTextAlignmentCenter;
        sourceLabel.textColor = [UIColor whiteColor];
        sourceLabel.font = Font(10);
        sourceLabel.backgroundColor = UN_RedColor;
        sourceLabel.layer.cornerRadius = 8.f;
        sourceLabel.layer.masksToBounds = YES;
        
        minBuyNoteLabel.text = @"起送";
        minBuyNoteLabel.font = Font(14);
        minBuyNoteLabel.textAlignment = NSTextAlignmentRight;
        minBuyNoteLabel.textColor = RGBColor(75, 75, 75);
        
        minBuyLabel.font = Font(18);
        minBuyLabel.textColor = UN_RedColor;
        minBuyLabel.textAlignment = NSTextAlignmentRight;
        
        deliveryNumberNoteLabel.font = Font(14);
        deliveryNumberNoteLabel.textAlignment = NSTextAlignmentRight;
        deliveryNumberNoteLabel.textColor = RGBColor(75, 75, 75);
        
        
        deliveryNumberLabel.font = Font(15);
        deliveryNumberLabel.textColor = UN_RedColor;
        deliveryNumberLabel.textAlignment = NSTextAlignmentRight;
        
        businessStateLabel.layer.cornerRadius = 2.f;
        businessStateLabel.layer.masksToBounds = YES;
        businessStateLabel.textColor = [UIColor whiteColor];
        businessStateLabel.font = Font(13);
        businessStateLabel.textAlignment = NSTextAlignmentCenter;
        
        self.peiLabel.text = @"赔";
        peiLabel.font = Font(11.f);
        peiLabel.textAlignment = NSTextAlignmentCenter;
        self.fuLabel.text = @"付";
        fuLabel.font = Font(11.f);
        fuLabel.textAlignment = NSTextAlignmentCenter;
        self.piaoLabel.text = @"票";
        piaoLabel.font = Font(11.f);
        piaoLabel.textAlignment = NSTextAlignmentCenter;
        self.juanLabel.text = @"券";
        juanLabel.font = Font(11.f);
        juanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

static float ratingViewOriginYAligh = 35;
static float ratingViewHeight = 15;
static float businessStateLabelOriginYAligh = 7;
static float businessStateLabelHeight = 17;
static float sourceLabelHeight = 16;
-(void)layoutSubviews{
    self.imageView.frame = (CGRect){10,10,60,60};
    //    self.imageView.backgroundColor = [UIColor redColor];
    
    sourceLabel.frame = (CGRect){LEFT(self.imageView)+5,BOTTOM(self.imageView)+5,50,16};
    
    float width = WIDTH(self.contentView);
    
    self.textLabel.frame =(CGRect){80,10,width-(40+55)-WIDTH(self.imageView)-20,20};
    //    self.textLabel.backgroundColor = [UIColor purpleColor];
    
    //    ratingView.hidden = no;
    //    ratingView.backgroundColor = [UIColor redColor];
    
    self.detailTextLabel.frame = (CGRect){RIGHT(ratingView),Y(ratingView),75,HEIGHT(ratingView)};
    
    minBuyNoteLabel.frame = (CGRect){width-10-30,BOTTOM(self.textLabel)-15,30,15};
    //    minBuyNoteLabel.backgroundColor  = [UIColor redColor];
    
    minBuyLabel.frame = (CGRect){LEFT(minBuyNoteLabel)-55,Y(self.textLabel),55,HEIGHT(self.textLabel)};
    //    minBuyLabel.backgroundColor  = [UIColor yellowColor];
    
    deliveryNumberNoteLabel.frame = (CGRect){width-10-45,BOTTOM(self.detailTextLabel)-15,45,15};
    //    deliveryNumberNoteLabel.backgroundColor = [UIColor redColor];
    
    deliveryNumberLabel.frame = (CGRect){LEFT(deliveryNumberNoteLabel)-45,Y(self.detailTextLabel),45,HEIGHT(self.detailTextLabel)};
    //    deliveryNumberLabel.backgroundColor = [UIColor yellowColor];
    
    businessStateLabel.frame = (CGRect){X(ratingView),BOTTOM(ratingView)+7,68,businessStateLabelHeight};
    if (self.shopInfo.businessState == ShopInfoBusinessStateOpen) {
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = UN_GreenColor;
        businessStateLabel.text = @"商家营业中";
    }else if(self.shopInfo.businessState == ShopInfoBusinessStateBreak){
        businessStateLabel.hidden = NO;
        businessStateLabel.backgroundColor = RGBColor(200, 200, 200);
        businessStateLabel.text = @"商家休息中";
    }else{
        businessStateLabel.hidden = YES;
    }
    
    int rightTagOffset = 10;
    
    if (self.shopInfo.peiEnabel) {
        peiLabel.frame = (CGRect){width-rightTagOffset-18,TOP(businessStateLabel),16,16};
        rightTagOffset = rightTagOffset + 18;
    }
    if (self.shopInfo.fuEnabel) {
        fuLabel.frame = (CGRect){width-rightTagOffset-18,TOP(businessStateLabel),16,16};
        rightTagOffset = rightTagOffset + 18;
    }
    if (self.shopInfo.piaoEnabel) {
        piaoLabel.frame = (CGRect){width-rightTagOffset-18,TOP(businessStateLabel),16,16};
        rightTagOffset = rightTagOffset + 18;
    }
    if (self.shopInfo.juanEnabel) {
        juanLabel.frame = (CGRect){width-rightTagOffset-18,TOP(businessStateLabel),16,16};
        rightTagOffset = rightTagOffset + 18;
    }
    
    if (!self.shopInfo.isSelfDelivery) {
        sourceLabel.hidden = YES;
    }else{
        sourceLabel.hidden = NO;
        sourceLabel.text = @"联合配送";
    }
    
    self.textLabel.text = self.shopInfo.name;
    
    ratingView.hidden = NO;
    [ratingView displayRating:self.shopInfo.starJudge];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"月销量%d",(unsigned int)self.shopInfo.monthSaleNumber];
    
    minBuyLabel.text = [NSString stringWithFormat:@"￥%d",(unsigned int)self.shopInfo.minBuyNumber];
    
    if (self.shopInfo.deliveryNumber <= 0) {
        deliveryNumberLabel.hidden = YES;
        CGRect rec = deliveryNumberNoteLabel.frame;
        rec.origin.x = rec.origin.x - WIDTH(deliveryNumberLabel);
        rec.size.width = rec.size.width + WIDTH(deliveryNumberLabel);
        deliveryNumberNoteLabel.frame = rec;
        deliveryNumberNoteLabel.text = @"免配送费";
    }else{
        deliveryNumberLabel.hidden = NO;
        deliveryNumberNoteLabel.text = @"配送费";
        deliveryNumberLabel.text = [NSString stringWithFormat:@"￥%d",self.shopInfo.deliveryNumber];
    }
    
    for (UIView *view in self.contentView.subviews) {
        if (view.tag > 10000) {
            [view removeFromSuperview];
        }
    }
    __block int huodongOffset = 10;
    __block int indexCount = 0;
    float cellSeplineOffset = 0;
    if (self.shopInfo.huodongDictionary && self.shopInfo.huodongDictionary.count != 0) {
        cellSeplineOffset = (self.shopInfo.huodongDictionary.count)*30;
        [self.shopInfo.huodongDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            UIColor *tagColor = UN_RedColor;
            if ([key isEqualToString:@"新"]) {
                tagColor = UN_FilterXin;
            }else if ([key isEqualToString:@"特"]){
                tagColor = UN_FilterTejia;
            }else if ([key isEqualToString:@"减"]){
                tagColor = UN_FilterJian;
            }else if ([key isEqualToString:@"预"]){
                tagColor = UN_FilterYu;
            }else if ([key isEqualToString:@"免"]){
                tagColor = UN_FilterMian;
            }
            
            
            UILabel *tagLabel = [[UILabel alloc] init];
            tagLabel.frame = (CGRect){X(businessStateLabel)-5,BOTTOM(businessStateLabel)+huodongOffset,16,16};
            tagLabel.backgroundColor = tagColor;
            tagLabel.layer.cornerRadius = 8.f;
            tagLabel.layer.masksToBounds = YES;
            tagLabel.text = key;
            tagLabel.layer.borderColor = tagColor.CGColor;
            tagLabel.layer.borderWidth = 1.f;
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.textColor = [UIColor whiteColor];
            tagLabel.font = Font(9);
            tagLabel.tag = 11111+indexCount;
            [self.contentView addSubview:tagLabel];
            
            UILabel *tagDescirptionLabel = [[UILabel alloc] init];
            tagDescirptionLabel.frame = (CGRect){RIGHT(tagLabel)+5,BOTTOM(businessStateLabel)+huodongOffset+3.5,WIDTH(self.contentView)-RIGHT(tagLabel)-5-10,10};
            tagDescirptionLabel.text = obj;
            tagDescirptionLabel.textAlignment = NSTextAlignmentLeft;
            tagDescirptionLabel.textColor = RGBColor(140, 140, 140);
            tagDescirptionLabel.font = Font(9);
            tagDescirptionLabel.tag = 11111+indexCount;
            [self.contentView addSubview:tagDescirptionLabel];
            
            UIView *lineSepline = [[UIView alloc] initWithFrame:(CGRect){X(tagLabel),BOTTOM(tagLabel)+5,WIDTH(self.contentView)-X(tagLabel)-10,0.5}];
            lineSepline.backgroundColor = UN_LineSeperateColor;
            lineSepline.tag = 22222+indexCount;
            [self.contentView addSubview:lineSepline];
            
            huodongOffset += 30;
            indexCount += 1;
        }];
        
        for (UIView *view in self.contentView.subviews) {
            if (view.tag == 22222+self.shopInfo.huodongDictionary.count-1) {
                [view removeFromSuperview];
            }
        }
    }else{
        if (sourceLabel.hidden) {
            cellSeplineOffset = 10;
        }else{
            cellSeplineOffset = 10 + HEIGHT(sourceLabel);
        }
    }
    
    UIView *cellSepLineView = [[UIView alloc] init];
    cellSepLineView.frame = (CGRect){0,BOTTOM(businessStateLabel)+cellSeplineOffset+5-0.5,width,0.5};
    cellSepLineView.backgroundColor = UN_CellLineSeperateColor;
    cellSepLineView.tag = 33333;
    [self.contentView addSubview:cellSepLineView];
}

+(CGFloat)staticHeightWithShopInfo:(ShopInfo *)info{
    float startOffset = ratingViewOriginYAligh + ratingViewHeight + businessStateLabelOriginYAligh+businessStateLabelHeight;
    if (info.huodongDictionary && info.huodongDictionary.count != 0) {
        startOffset += (info.huodongDictionary.count)*30;
    }else{
        if (!info.isSelfDelivery) {
            startOffset += 10;
        }else{
            startOffset += 10 + sourceLabelHeight;
        }
    }
    return startOffset + 5;
}

+(CGFloat)staticHeightWithShopInfos:(NSArray *)infos{
    CGFloat totlaHeight = 0;
    if (infos && infos.count != 0) {
        if (![infos[0] isKindOfClass:[ShopInfo class]]) {
            return totlaHeight;
        }
        for (ShopInfo *info in infos) {
            totlaHeight += [ShopsTableViewCell staticHeightWithShopInfo:info];
        }
    }
    return totlaHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
