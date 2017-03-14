//
//  RefundTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "RefundTableViewCell.h"
#import "UNUrlConnection.h"

@implementation RefundTableViewCell{
    UIView *contenBackView;
    
    UIImageView *moreImage;
    
    UIView *sepLineView1;
    
    UILabel *orderInfoLabel;
    
    UILabel *timeLabel;
    
    UILabel *orderNumberLabel;
    
    UILabel *orderStateLabel;
    
    UIView *sepLineView2;
    
    UIView *bottomFixView;
    
    UIView *sepLineView3;
}

static float refundCellImageHieght = 30.f;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UN_WhiteColor;
        
        contenBackView = [[UIView alloc] init];
        contenBackView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contenBackView];
        
        [self.contentView bringSubviewToFront:self.imageView];
        self.imageView.layer.cornerRadius = refundCellImageHieght/2;
        self.imageView.layer.masksToBounds = YES;
        
        [self.contentView bringSubviewToFront:self.textLabel];
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.backgroundColor = contenBackView.backgroundColor;
        self.textLabel.font = Font(15);
        
        //        [self.contentView bringSubviewToFront:self.detailTextLabel];
        //        self.detailTextLabel.textColor = RGBColor(50, 50, 50);
        //        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        //        self.detailTextLabel.font = Font(17);
        
        self.detailTextLabel.hidden = YES;
        
        moreImage = [[UIImageView alloc] init];
        moreImage.image = [UIImage imageNamed:@"more"];
        [self.contentView addSubview:moreImage];
        
        sepLineView1 = [[UIView alloc] init];
        sepLineView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView1];
        
        orderInfoLabel = [[UILabel alloc] init];
        orderInfoLabel.textColor = RGBColor(50, 50, 50);
        orderInfoLabel.textAlignment = NSTextAlignmentLeft;
        orderInfoLabel.font = Font(15);
        orderInfoLabel.backgroundColor = contenBackView.backgroundColor;
        [self.contentView addSubview:orderInfoLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGBColor(100, 100, 100);
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = Font(12);
        timeLabel.backgroundColor = contenBackView.backgroundColor;
        [self.contentView addSubview:timeLabel];
        
        orderNumberLabel = [[UILabel alloc] init];
        orderNumberLabel.textColor = RGBColor(120, 120, 120);
        orderNumberLabel.textAlignment = NSTextAlignmentRight;
        orderNumberLabel.font = Font(16);
        orderNumberLabel.backgroundColor = contenBackView.backgroundColor;
        [self.contentView addSubview:orderNumberLabel];
        
        orderStateLabel = [[UILabel alloc] init];
        orderStateLabel.textColor = UN_RedColor;
        orderStateLabel.textAlignment = NSTextAlignmentRight;
        orderStateLabel.font = Font(15);
        orderStateLabel.backgroundColor = contenBackView.backgroundColor;
        [self.contentView addSubview:orderStateLabel];
        
        sepLineView2 = [[UIView alloc] init];
        sepLineView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView2];
        
        bottomFixView = [[UIView alloc] init];
        bottomFixView.backgroundColor = RGBColor(235, 235, 235);
        [self.contentView addSubview:bottomFixView];
        
        sepLineView3 = [[UIView alloc] init];
        sepLineView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView3];
    }
    return self;
}

-(void)layoutSubviews{
    contenBackView.frame = (CGRect){0,0,WIDTH(self.contentView),RefundTableViewCellViewHeight-5};
    //    contenBackView.backgroundColor =
    
    self.imageView.frame = (CGRect){15,10,refundCellImageHieght,refundCellImageHieght};
    //    self.imageView.backgroundColor = [UIColor redColor];
    
    moreImage.frame = (CGRect){WIDTH(self.contentView)- 15-7,TOP(self.imageView) +(refundCellImageHieght-11)/2,7,11};
    
    
    self.textLabel.frame = (CGRect){RIGHT(self.imageView)+15,TOP(self.imageView),WIDTH(self.contentView)-RIGHT(self.imageView)-LEFT(self.imageView)-7-15*2,refundCellImageHieght};
    //    self.textLabel.backgroundColor = [UIColor redColor];
    //    self.textLabel.text = @"胖子海鲜烧烤(城北街)";
    
    sepLineView1.frame = (CGRect){0,TOP(self.imageView)+refundCellImageHieght+5-0.5,WIDTH(self.contentView),0.5};
    
    orderNumberLabel.frame = (CGRect){WIDTH(self.contentView)-90-15,BOTTOM(sepLineView1)+15,90,20};
    //    orderNumberLabel.text = @"￥60";
    //    orderNumberLabel.backgroundColor = [UIColor purpleColor];
    
    orderInfoLabel.frame = (CGRect){20,BOTTOM(sepLineView1)+15,LEFT(orderNumberLabel)-10-15,20};
    //    orderInfoLabel.text = @"欧式培根炒饭";
    //    orderInfoLabel.backgroundColor = [UIColor yellowColor];
    
    timeLabel.frame = (CGRect){LEFT(orderInfoLabel),BOTTOM(orderInfoLabel)+10,WIDTH(orderInfoLabel),15};
    //    timeLabel.text = @"2015/10/31  16:20";
    
    orderStateLabel.frame = (CGRect){LEFT(orderNumberLabel),BOTTOM(orderNumberLabel)+2,WIDTH(orderNumberLabel),25};
    //    orderStateLabel.text = @"商家退款成功";
    //    orderStateLabel.backgroundColor = [UIColor blueColor];
    
    sepLineView2.frame = (CGRect){0,RefundTableViewCellViewHeight-5-0.5,WIDTH(self.contentView),0.5};
    
    if (self.isLastCell) {
        bottomFixView.hidden = YES;
    }else{
        bottomFixView.hidden = NO;
    }
    bottomFixView.frame = (CGRect){0,RefundTableViewCellViewHeight-5,WIDTH(self.contentView),5};
}

-(void)setOrderInfo:(OrderInfo *)orderInfo{
    //    _orderInfo = orderInfo;
    
    if (orderInfo.shopName) {
        self.textLabel.text = orderInfo.shopName;
    }else{
        self.textLabel.text = @"";
    }
    
    if (orderInfo.orderState == OrderInfoOrderStateSubmitSuccess){
        orderStateLabel.text = @"提交成功";
    }else if (orderInfo.orderState == OrderInfoOrderStateShopAccept){
        orderStateLabel.text = @"商家接受订单";
    }else if (orderInfo.orderState == OrderInfoOrderStateComplete){
        orderStateLabel.text = @"订单已完成";
    }
    //    else if (orderInfo.orderState == OrderInfoOrderStateRefundingUpload){
    //        orderStateLabel.text = @"退款申请提交";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingShop){
    //        orderStateLabel.text = @"等待商户处理";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingSuccess){
    //        orderStateLabel.text = @"退款完成";
    //    }
    
    NSString *timeString = [self parseTime:orderInfo.timeStamp];
    if (!timeString) {
        timeString = [self parseTime:[[NSDate date] timeIntervalSince1970]];
    }
    timeLabel.text = timeString;
    
    
    if (orderInfo.orderNumber <= 0) {
        orderInfo.orderNumber = 0;
    }
    
    NSString *numberString;
    if ((orderInfo.orderNumber*10)-((int)orderInfo.orderNumber)*10 == 0) {
        numberString = [NSString stringWithFormat:@"￥%d",(int)orderInfo.orderNumber];
    }else{
        numberString = [NSString stringWithFormat:@"￥%.1f",orderInfo.orderNumber];
    }
    orderNumberLabel.text = numberString;
    
    if (orderInfo.orderMenuDetail && orderInfo.orderMenuDetail.count != 0) {
        NSString *menuFirstText = orderInfo.orderMenuDetail[0][@"name"];
        if (menuFirstText) {
            if(orderInfo.orderMenuDetail.count > 1){
                orderInfoLabel.text = [NSString stringWithFormat:@"%@ 等",menuFirstText];
            }else{
                orderInfoLabel.text = menuFirstText;
            }
        }else{
            orderInfoLabel.text = @"未知商品";
        }
    }else{
        orderInfoLabel.text = @"未选择商品";
    }
}

-(void)setOrderDic:(NSDictionary *)orderDic{
    
    NSString *shopName = [orderDic objectForKey:@"shopName"];
    
    if (shopName) {
        self.textLabel.text = shopName;
    }else{
        self.textLabel.text = @"";
    }
    
    NSString *shopImage = [orderDic objectForKey:@"shopImage"];
    if (!shopImage) {
        [self.imageView setImage:[UIImage new]];
    }else{
        shopImage = [UNUrlConnection replaceUrl:shopImage];
        [self.imageView setImageWithURL:[NSURL URLWithString:shopImage] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
    }
    
    //    if (orderInfo.orderState == OrderInfoOrderStateSubmitSuccess){
    //        orderStateLabel.text = @"提交成功";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateShopAccept){
    //        orderStateLabel.text = @"商家接受订单";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateComplete){
    //        orderStateLabel.text = @"订单已完成";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingUpload){
    //        orderStateLabel.text = @"退款申请提交";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingShop){
    //        orderStateLabel.text = @"等待商户处理";
    //    }else if (orderInfo.orderState == OrderInfoOrderStateRefundingSuccess){
    orderStateLabel.text = @"退款完成";
    //}
    
    NSString *timeString = [self parseTime:[[orderDic objectForKey:@"timestamp"] longLongValue]];
    if (!timeString) {
        timeString = [self parseTime:[[NSDate date] timeIntervalSince1970]];
    }
    timeLabel.text = timeString;
    
    float orderNumber = [[orderDic objectForKey:@"price"] floatValue];
    
    if (orderNumber <= 0) {
        orderNumber = 0;
    }
    
    NSString *numberString;
    if ((orderNumber*10)-((int)orderNumber)*10 == 0) {
        numberString = [NSString stringWithFormat:@"￥%d",(int)orderNumber];
    }else{
        numberString = [NSString stringWithFormat:@"￥%.1f",orderNumber];
    }
    orderNumberLabel.text = numberString;
    
    NSArray *orderMenu = [orderDic objectForKey:@"orderMenu"];
    
    if (orderMenu && orderMenu.count != 0) {
        NSString *menuFirstText = orderMenu[0][@"name"];
        if (menuFirstText) {
            if(orderMenu.count > 1){
                orderInfoLabel.text = [NSString stringWithFormat:@"%@ 等",menuFirstText];
            }else{
                orderInfoLabel.text = menuFirstText;
            }
        }else{
            orderInfoLabel.text = @"未知商品";
        }
    }else{
        orderInfoLabel.text = @"未选择商品";
    }
}

-(NSString *)parseTime:(long long)timeStamp{
    if (timeStamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        if (destDateString) {
            return destDateString;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
