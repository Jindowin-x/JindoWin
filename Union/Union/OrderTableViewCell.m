//
//  OrderTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderTableViewCell.h"

#import "UNTools.h"

@interface OrderTableViewCell ()

@property (nonatomic,strong) UIView *topSepLineView;
@property (nonatomic,strong) UIView *mainSepLineView;

@property (nonatomic,strong) UIView *menuBottomLineView;

@property (nonatomic,strong) UILabel *deliveryLabel;

@property (nonatomic,strong) UILabel *totalLabel;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,copy) NSString *timeString;

@property (nonatomic,strong) UIButton *functionButton1,*functionButton2;

@property (nonatomic,strong) UIView *lastBottomLineView;

@property (nonatomic,strong) UIView *cellSeperateView;

@end

@implementation OrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = RGBColor(80, 80, 80);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(15);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.textColor = UN_RedColor;
        self.detailTextLabel.font = Font(12);
        
        self.topSepLineView = [[UIView alloc] init];
        self.topSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.2);
        [self.contentView addSubview:self.topSepLineView];
        
        self.mainSepLineView = [[UIView alloc] init];
        self.mainSepLineView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:self.mainSepLineView];
        
        self.menuBottomLineView = [[UIView alloc] init];
        self.menuBottomLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:self.menuBottomLineView];
        
        self.deliveryLabel = [[UILabel alloc] init];
        self.deliveryLabel.textAlignment = NSTextAlignmentLeft;
        self.deliveryLabel.textColor = RGBColor(80, 80, 80);
        self.deliveryLabel.font = Font(13);
        [self.contentView addSubview:self.deliveryLabel];
        
        self.totalLabel = [[UILabel alloc] init];
        self.totalLabel.textAlignment = NSTextAlignmentRight;
        self.totalLabel.textColor = RGBColor(80, 80, 80);
        self.totalLabel.font = Font(13);
        [self.contentView addSubview:self.totalLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = RGBColor(120, 120, 120);
        self.timeLabel.font = Font(10);
        [self.contentView addSubview:self.timeLabel];
        
        self.functionButton1 = [[UIButton alloc] init];
        [self.functionButton1 setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        [self.functionButton1 setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateSelected];
        self.functionButton1.layer.borderColor = RGBColor(100, 100, 100).CGColor;
        self.functionButton1.layer.borderWidth = 1.f;
        self.functionButton1.layer.cornerRadius = 2.f;
        self.functionButton1.layer.masksToBounds = YES;
        [self.contentView addSubview:self.functionButton1];
        [self.functionButton1 setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.functionButton1 addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.functionButton1.titleLabel.font = Font(11);
        
        
        self.functionButton2 = [[UIButton alloc] init];
        [self.functionButton2 setTitleColor:UN_RedColor forState:UIControlStateNormal];
        [self.functionButton2 setTitleColor:UN_RedColor forState:UIControlStateSelected];
        self.functionButton2.layer.borderColor = UN_RedColor.CGColor;
        self.functionButton2.layer.borderWidth = 1.f;
        self.functionButton2.layer.cornerRadius = 2.f;
        self.functionButton2.layer.masksToBounds = YES;
        [self.contentView addSubview:self.functionButton2];
        [self.functionButton2 addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.functionButton2.titleLabel.font = Font(11);
        
        
        self.lastBottomLineView = [[UIView alloc] init];
        self.lastBottomLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:self.lastBottomLineView];
        
        self.cellSeperateView = [[UIView alloc] init];
        self.cellSeperateView.backgroundColor = RGBColor(235, 235, 235);
        [self.contentView addSubview:self.cellSeperateView];
        
    }
    return self;
}

static float firstRowHeight = 45.f;
static float bottomRowHeight = 40.f;
static float priceabelWidth = 70;
static float namelabelWidth;
static UIFont *nameLabelFont;
-(void)layoutSubviews{
    self.imageView.frame = (CGRect){10,5,firstRowHeight-5*2,firstRowHeight-5*2};
    
    
    self.textLabel.frame = (CGRect){RIGHT(self.imageView)+5,(firstRowHeight-16)/2,170,16};
    
    self.detailTextLabel.frame = (CGRect){WIDTH(self.contentView)-10-90,(firstRowHeight-14)/2,90,14};
    
    self.topSepLineView.frame = (CGRect){0,0,WIDTH(self.contentView),0.5};
    
    self.mainSepLineView.frame = (CGRect){0,firstRowHeight-0.5,WIDTH(self.contentView),0.5};
    
    for (UIView *view in self.contentView.subviews) {
        if (view.tag >= 2000) {
            [view removeFromSuperview];
        }
    }
    
    if (namelabelWidth == 0) {
        namelabelWidth = GLOBALWIDTH-20-10-priceabelWidth-20;
    }
    if (!nameLabelFont) {
        nameLabelFont = Font(14);
    }
    __block float labelOriginYBlock = firstRowHeight;
    NSArray *detailArray  = self.orderInfo.orderMenuDetail;
    if (detailArray && detailArray.count != 0) {
        [detailArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
            UIView *outterAddView = [[UIView alloc] init];
            outterAddView.tag = 2000+idx;
            outterAddView.frame = (CGRect){0,labelOriginYBlock+firstRowHeight,WIDTH(self.contentView),firstRowHeight};
            [self.contentView addSubview:outterAddView];
            
            
            //@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"}
            NSString *nameString = menuInfo[@"name"];
            int count = [menuInfo[@"number"] intValue];
            float priceUnit = [menuInfo[@"unitprice"] floatValue];
            NSString *priceUnitString;
            int unitDotNum = (int)(priceUnit*10) - ((int)priceUnit)*10;
            if (unitDotNum == 0) {
                priceUnitString = [NSString stringWithFormat:@"%d",(int)priceUnit];
            }else{
                priceUnitString = [NSString stringWithFormat:@"%.1f",priceUnit];
            }
            
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.frame = (CGRect){WIDTH(outterAddView)-priceabelWidth-10,4,priceabelWidth,14};
            priceLabel.text = [NSString stringWithFormat:@"￥%@",priceUnitString];
            priceLabel.textColor = RGBColor(100, 100, 100);
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = Font(13);
            //            priceLabel.backgroundColor = [UIColor redColor];
            [outterAddView addSubview:priceLabel];
            
            UILabel *countLabel = [[UILabel alloc] init];
            countLabel.frame = (CGRect){WIDTH(outterAddView)-priceabelWidth-10,BOTTOM(priceLabel)+3,priceabelWidth,15};
            countLabel.text = [NSString stringWithFormat:@"x %d",count];
            countLabel.textColor = RGBColor(100, 100, 100);
            countLabel.textAlignment = NSTextAlignmentRight;
            countLabel.font = Font(13);
            //            countLabel.backgroundColor = [UIColor redColor];
            [outterAddView addSubview:countLabel];
            
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.numberOfLines = 0;
            CGSize labelSize = [UNTools getSizeWithString:nameString andSize:(CGSize){namelabelWidth,MAXFLOAT} andFont:nameLabelFont];
            float labelHeight = MAX(labelSize.height, 31);
            if (labelHeight > 31) {
                nameLabel.frame = (CGRect){20,10,namelabelWidth,labelHeight};
                outterAddView.frame = (CGRect){0,labelOriginYBlock,WIDTH(self.contentView),HEIGHT(nameLabel)+20};
                priceLabel.frame = (CGRect){WIDTH(outterAddView)-priceabelWidth-10,10,priceabelWidth,14};
                countLabel.frame = (CGRect){WIDTH(outterAddView)-priceabelWidth-10,BOTTOM(priceLabel)+3,priceabelWidth,15};
            }else{
                nameLabel.frame = (CGRect){20,4,namelabelWidth,labelHeight};
                outterAddView.frame = (CGRect){0,labelOriginYBlock,WIDTH(self.contentView),HEIGHT(nameLabel)+10};
            }
            
            nameLabel.text = nameString;
            nameLabel.textColor = RGBColor(100, 100, 100);
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = nameLabelFont;
            [outterAddView addSubview:nameLabel];
            
            labelOriginYBlock += HEIGHT(outterAddView);
            
            UIView *sepLine = [[UIView alloc] init];
            sepLine.frame = (CGRect){20,HEIGHT(outterAddView)-0.5,WIDTH(outterAddView)-20,0.5};
            sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            [outterAddView addSubview:sepLine];
        }];
    }
    
    
    self.deliveryLabel.frame = (CGRect){20,labelOriginYBlock,140,firstRowHeight};
    self.totalLabel.frame = (CGRect){WIDTH(self.contentView)-140-10,labelOriginYBlock,140,firstRowHeight};
    
    labelOriginYBlock += firstRowHeight;
    
    self.menuBottomLineView.frame = (CGRect){0,labelOriginYBlock-0.5,WIDTH(self.contentView),0.5};
    
    self.timeLabel.frame = (CGRect){10,labelOriginYBlock,110,bottomRowHeight};
    self.timeLabel.text = self.timeString;
    
    self.functionButton2.frame = (CGRect){WIDTH(self.contentView)-10-60,labelOriginYBlock+5,60,bottomRowHeight-5*2};
    
    self.functionButton1.frame = (CGRect){WIDTH(self.contentView)-10*2-60*2,labelOriginYBlock+5,60,bottomRowHeight-5*2};
    
    labelOriginYBlock += bottomRowHeight;
    
    self.lastBottomLineView.frame = (CGRect){0,labelOriginYBlock-0.5,WIDTH(self.contentView),0.5};
    
    if (!self.isLastcell) {
        self.cellSeperateView.frame = (CGRect){0,labelOriginYBlock,WIDTH(self.contentView),5};
    }else{
        self.cellSeperateView.frame = (CGRect){0,labelOriginYBlock,WIDTH(self.contentView),0};
    }
    
    //    self.imageView.backgroundColor = [UIColor redColor];
    //    self.textLabel.backgroundColor = [UIColor yellowColor];
    //    self.detailTextLabel.backgroundColor  =[UIColor purpleColor];
    //    self.timeLabel.backgroundColor = [UIColor redColor];
    //    self.deliveryLabel.backgroundColor = [UIColor yellowColor];
    //    self.totalLabel.backgroundColor = [UIColor redColor];
    
    
}

-(void)setOrderInfo:(OrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:orderInfo.imageUrlString] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
    
    if (orderInfo.shopName) {
        self.textLabel.text = orderInfo.shopName;
    }else{
        self.textLabel.text = @"";
    }
    /**
     *  取消订单  付款  退款  再来一单  取消订单  评价
     */
    
    if (orderInfo.orderState == OrderInfoOrderStateSubmitSuccess){
        [self.functionButton1 setTitle:@"取消订单" forState:UIControlStateNormal];
        self.detailTextLabel.text = @"订单已提交";
        if (orderInfo.paymentStatus == OrderInfoOrderPaymentStateUnPaid) {
            self.detailTextLabel.text = @"订单未支付";
            [self.functionButton2 setTitle:@"付款" forState:UIControlStateNormal];
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStatePaid){
            [self.functionButton2 setTitle:@"退款" forState:UIControlStateNormal];
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStatePartialPayment){
            [self.functionButton2 setTitle:@"付款" forState:UIControlStateNormal];
        }else if(orderInfo.paymentStatus == OrderInfoOrderPaymentStateRefunded){
            [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
        }
    }else if (orderInfo.orderState == OrderInfoOrderStateShopAccept){
        self.detailTextLabel.text = @"商家接受订单";
        [self.functionButton1 setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.functionButton2 setTitle:@"退款" forState:UIControlStateNormal];
    }else if (orderInfo.orderState == OrderInfoOrderStateComplete){
        self.detailTextLabel.text = @"订单已完成";
        [self.functionButton1 setTitle:@"查看详情" forState:UIControlStateNormal];
        if (orderInfo.isJudged) {
            [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
        }else{
            [self.functionButton2 setTitle:@"评价" forState:UIControlStateNormal];
        }
    }else if (orderInfo.orderState == OrderInfoOrderStateCancel){
        self.detailTextLabel.text = @"订单已取消";
        [self.functionButton1 setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    
    if (orderInfo.isRefunded) {
        self.detailTextLabel.text = @"订单已取消";
        [self.functionButton1 setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    //    else if (orderInfo.orderState == OrderInfoOrderStateRefundingUpload){
    //        self.detailTextLabel.text = @"退款申请提交";
    //        [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingShop){
    //        self.detailTextLabel.text = @"等待商户处理";
    //        [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingSuccess){
    //        self.detailTextLabel.text = @"退款完成";
    //        [self.functionButton2 setTitle:@"再来一单" forState:UIControlStateNormal];
    //    }
    
    
    if (orderInfo.timeStamp > 0) {
        self.timeString = [UNTools parseTimeWithTimeStamp:orderInfo.timeStamp];
    }else{
        self.timeString = [UNTools parseTimeWithTimeStamp:[[NSDate date] timeIntervalSince1970]];
    }
    self.timeLabel.text = self.timeString;
    
    
    float orderCalcNum = orderInfo.orderNumber + orderInfo.deliveryNumber;
    if (orderCalcNum <= 0) {
        orderCalcNum = 0;
    }
    NSMutableAttributedString *attriString;
    if ((orderCalcNum*10)-((int)orderCalcNum)*10 == 0) {
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单合计：￥%d",(int)orderCalcNum]];
    }else{
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单合计：￥%.1f",orderCalcNum]];
    }
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:80.f/255 green:80.f/255 blue:80.f/255 alpha:1]
                        range:NSMakeRange(0, 5)];
    UIColor *red = UN_RedColor;
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:red
                        range:NSMakeRange(5, attriString.length-5)];
    self.totalLabel.attributedText = attriString;
    
    self.deliveryLabel.text = [NSString stringWithFormat:@"配送费：￥%d",orderInfo.deliveryNumber];
}

+(CGFloat)staticHeightWithOrderInfo:(OrderInfo *)orderInfo{
    if (namelabelWidth == 0) {
        namelabelWidth = GLOBALWIDTH-20-10-priceabelWidth-20;
    }
    if (!nameLabelFont) {
        nameLabelFont = Font(14);
    }
    __block float labelOriginYBlock = firstRowHeight;
    NSArray *detailArray  = orderInfo.orderMenuDetail;
    if (detailArray && detailArray.count != 0) {
        [detailArray enumerateObjectsUsingBlock:^(NSDictionary *menuInfo, NSUInteger idx, BOOL *stop) {
            
            //@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"}
            NSString *nameString = menuInfo[@"name"];
            
            CGSize labelSize = [UNTools getSizeWithString:nameString andSize:(CGSize){namelabelWidth,MAXFLOAT} andFont:nameLabelFont];
            float labelHeight = MAX(labelSize.height, 31);
            if (labelHeight > 31) {
                labelOriginYBlock += labelHeight + 20;
            }else{
                labelOriginYBlock += labelHeight + 10;
            }
        }];
    }
    return labelOriginYBlock + firstRowHeight +bottomRowHeight + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)functionButtonClick:(UIButton *)butt{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderTableCell:didClickFunctionButton:)]) {
        [self.delegate orderTableCell:self didClickFunctionButton:butt];
    }
}

@end
