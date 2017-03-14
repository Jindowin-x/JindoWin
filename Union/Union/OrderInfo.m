//
//  OrderInfo.m
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderInfo.h"

#import "UNUrlConnection.h"

@implementation OrderInfo

+(instancetype)orderInfoWithNetworkDictionary:(NSDictionary *)netDic{
    OrderInfo *info = [[OrderInfo alloc] init];
    return [info updateWithNetworkDictionary:netDic];
}

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic{
    NSString *addressString = [netDic objectForKey:@"address"];
    if (addressString && [addressString isKindOfClass:[NSString class]] && ![addressString isEqualToString:@""]) {
        self.orderAddress = addressString;
    }
    NSString *payNumberString = netDic[@"amountPayable"];
    if ([payNumberString isKindOfClass:[NSNull class]]) {
        self.payNumber = 0;
    }else{
        if (payNumberString) {
            float payNum = [payNumberString floatValue];
            self.payNumber = payNum;
        }
    }
    
    NSString *deliveryNumString = netDic[@"brand_fee"];
    if ([deliveryNumString isKindOfClass:[NSNull class]]) {
        self.deliveryNumber = 0;
    }else{
        if (deliveryNumString) {
            float deliveryNum = [deliveryNumString floatValue];
            self.deliveryNumber = deliveryNum;
        }
    }
    
    
    
    self.shopID = [NSString stringWithFormat:@"%ld",[netDic[@"brand_id"] longValue]];
    
    NSString *shopLogo = netDic[@"brand_logo"];
    if (shopLogo && [shopLogo isKindOfClass:[NSString class]] && ![shopLogo isEqualToString:@""]) {
        self.imageUrlString = [UNUrlConnection replaceUrl:shopLogo];
    }
    
    NSString *shopName = netDic[@"brand_name"];
    if (shopName && [shopName isKindOfClass:[NSString class]] && ![shopName isEqualToString:@""]) {
        self.shopName = shopName;
    }
    
    NSString *contactor = netDic[@"consignee"];
    if (contactor) {
        if ([contactor isKindOfClass:[NSString class]] && ![contactor isEqualToString:@""]) {
            self.orderContactor = contactor;
        }else{
            self.orderContactor = @"匿名用户";
        }
    }
    NSString *contactorPhone = netDic[@"phone"];
    if (contactorPhone && [contactorPhone isKindOfClass:[NSString class]] && ![contactorPhone isEqualToString:@""]) {
        self.orderConsigneePhone = contactorPhone;
    }
    
    NSString *deliveryTime = netDic[@"delivery_time"];
    if (deliveryTime) {
        if ([deliveryTime isKindOfClass:[NSString class]] && ![deliveryTime isEqualToString:@""]) {
            self.deliveryTime = deliveryTime;
        }else{
            self.deliveryTime = @"尽快送达";
        }
    }
    
    NSString *deliveryMethod = netDic[@"shippingMethod"];
    if ([deliveryMethod isKindOfClass:[NSNull class]]) {
        self.isSelfDelivery = NO;
    }else{
        if (deliveryMethod) {
            if ([deliveryMethod intValue] == 0) {
                self.isSelfDelivery = YES;
            }else{
                self.isSelfDelivery = NO;
            }
        }else{
            self.isSelfDelivery = NO;
        }
    }
    
    self.orderID = [NSString stringWithFormat:@"%ld",[[netDic objectForKey:@"id"] longValue]];
    
    NSString *fapiaoTitle = netDic[@"invoiceTitle"];
    if (fapiaoTitle) {
        if ([fapiaoTitle isKindOfClass:[NSString class]] && ![fapiaoTitle isEqualToString:@""]) {
            self.faPiaoTitle = fapiaoTitle;
        }else{
            self.faPiaoTitle = @"";
        }
    }
    
    NSString *needFapiao = netDic[@"isInvoice"];
    if ([needFapiao isKindOfClass:[NSNull class]]) {
        self.isFapiaoNeed = NO;
    }else{
        if (needFapiao) {
            self.isFapiaoNeed = [netDic[@"isInvoice"] boolValue];
        }
    }
    
    NSString *orderNote = netDic[@"memo"];
    if (orderNote) {
        if ([orderNote isKindOfClass:[NSString class]] && ![orderNote isEqualToString:@""]) {
            self.deliveryNote = orderNote;
        }else{
            self.deliveryNote = @"";
        }
    }
    
    NSArray *menuArray = netDic[@"order_item"];
    NSMutableArray *itemMuneArray = [NSMutableArray array];
    for (NSDictionary *itemdic in menuArray) {
        NSString *name = itemdic[@"name"];
        NSString *unitprice = [NSString stringWithFormat:@"%.1f",[itemdic[@"price"] floatValue]];
        NSString *number = [NSString stringWithFormat:@"%d",[itemdic[@"quantity"] intValue]];
        
        if (name && unitprice && number) {
            [itemMuneArray addObject:@{@"name":name,@"unitprice":unitprice,@"number":number}];
        }
    }
    if (itemMuneArray.count != 0) {
        self.orderMenuDetail = [NSArray arrayWithArray:itemMuneArray];
    }
    
    NSArray *orderlogArray = netDic[@"order_log"];
    if (orderlogArray && orderlogArray.count != 0) {
        self.orderLogDetail = orderlogArray;
    }
    
    NSString *payPluginID = netDic[@"paymentPluginId"];
    if (payPluginID && [payPluginID isKindOfClass:[NSString class]] && ![payPluginID isEqualToString:@""]) {
        if ([payPluginID isEqualToString:@"alipayDirectPlugin"]) {
            self.payMentType = OrderPaymentTypeAli;
        }else if ([payPluginID isEqualToString:@"wxpayPlugin"]){
            self.payMentType = OrderPaymentTypeWechat;
        }
    }
    
    NSString *orderStatus = netDic[@"status"];
    if (orderStatus && [orderStatus isKindOfClass:[NSString class]] && ![orderStatus isEqualToString:@""]) {
        if ([orderStatus isEqualToString:@"unconfirmed"]) {
            self.orderState = OrderInfoOrderStateSubmitSuccess;
        }else if ([orderStatus isEqualToString:@"confirmed"]){
            self.orderState = OrderInfoOrderStateShopAccept;
        }else if ([orderStatus isEqualToString:@"completed"]){
            self.orderState = OrderInfoOrderStateComplete;
        }else if ([orderStatus isEqualToString:@"cancelled"]){
            self.orderState = OrderInfoOrderStateCancel;
        }
    }
    
    NSString *payStatus = netDic[@"paymentStatus"];
    if (payStatus && [payStatus isKindOfClass:[NSString class]] && ![payStatus isEqualToString:@""]) {
        if ([payStatus isEqualToString:@"unpaid"]) {
            self.paymentStatus = OrderInfoOrderPaymentStateUnPaid;
        }else if ([payStatus isEqualToString:@"partialPayment"]){
            self.paymentStatus = OrderInfoOrderPaymentStatePartialPayment;
        }else if ([payStatus isEqualToString:@"paid"]){
            self.paymentStatus = OrderInfoOrderPaymentStatePaid;
        }else if ([payStatus isEqualToString:@"partialRefunds"]){
            self.paymentStatus = OrderInfoOrderPaymentStatePartialRefunds;
        }else if ([payStatus isEqualToString:@"refunded"]){
            self.paymentStatus = OrderInfoOrderPaymentStateRefunded;
        }
    }
    
    NSString *orderSN = netDic[@"sn"];
    if (orderSN && [orderSN isKindOfClass:[NSString class]] && ![orderSN isEqualToString:@""]) {
        self.orderSN = orderSN;
    }
    
    NSString *priceString = netDic[@"price"];
    if ([priceString isKindOfClass:[NSNull class]]) {
        self.orderNumber = 0;
    }else{
        if (priceString) {
            self.orderNumber = [priceString floatValue];
        }
    }
    
    NSString *youhuiDiscount = netDic[@"promotionDiscount"];
    if ([youhuiDiscount isKindOfClass:[NSNull class]]) {
        self.youhuiDiscountNumber = 0;
    }else{
        if (youhuiDiscount) {
            self.youhuiDiscountNumber = [youhuiDiscount floatValue];
        }
    }
    
    
    NSString *voucherDiscount = netDic[@"couponDiscount"];
    if ([voucherDiscount isKindOfClass:[NSNull class]]) {
        self.voucherDiscountNumber = 0;
    }else{
        if (voucherDiscount) {
            self.voucherDiscountNumber = [voucherDiscount floatValue];
        }
    }
    
    
    NSString *orderVoucherCode = netDic[@"couponName"];
    if (orderVoucherCode && [orderVoucherCode isKindOfClass:[NSString class]] && ![orderVoucherCode isEqualToString:@""]) {
        self.voucherCode = orderVoucherCode;
    }
    
    NSString *unionDiscount = netDic[@"amountPaid"];
    if ([unionDiscount isKindOfClass:[NSNull class]]) {
        unionDiscount = 0;
    }else{
        if (unionDiscount) {
            self.unionDiscountNumber = [unionDiscount floatValue];
        }
    }
    
    NSString *timeString = netDic[@"time"];
    if ([timeString isKindOfClass:[NSNull class]]) {
        self.timeStamp = 0;
    }else{
        if (timeString) {
            long long time = [timeString longLongValue]/1000;
            self.timeStamp = time;
        }
    }
    
    NSNumber *isRefundedNum = [netDic objectForKey:@"isRefunded"];
    if (isRefundedNum && [isRefundedNum isKindOfClass:[NSNumber class]]) {
        self.isRefunded = [isRefundedNum boolValue];
    }
    
    NSNumber *isReviewedNum = [netDic objectForKey:@"isReviewed"];
    if (isReviewedNum && [isReviewedNum isKindOfClass:[NSNumber class]]) {
        self.isJudged = [isReviewedNum boolValue];
    }
    
    return self;
}

@end
