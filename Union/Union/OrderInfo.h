//
//  OrderInfo.h
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OrderInfoOrderState) {
    OrderInfoOrderStateSubmitSuccess,   //提交成功
    OrderInfoOrderStateShopAccept,      //商家接受订单
    OrderInfoOrderStateComplete,        //已完成
    OrderInfoOrderStateCancel,          //已取消
};

typedef NS_ENUM(NSUInteger, OrderInfoOrderPaymentState) {
    OrderInfoOrderPaymentStateUnPaid,           //未支付
    OrderInfoOrderPaymentStatePartialPayment,   //部分支付
    OrderInfoOrderPaymentStatePaid,             //已支付
    OrderInfoOrderPaymentStatePartialRefunds,   //部分退款
    OrderInfoOrderPaymentStateRefunded,         //已退款
};

@interface OrderInfo : NSObject

@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,copy) NSString *orderSN;

@property (nonatomic,copy) NSString *imageUrlString;

@property (nonatomic,copy) NSString *shopName;

@property (nonatomic,copy) NSString *shopID;

@property (nonatomic,copy) NSString *orderAddress;

@property (nonatomic,copy) NSString *orderContactor;

@property (nonatomic,assign) OrderInfoOrderState orderState;

@property (nonatomic,assign) OrderPaymentType payMentType;

@property (nonatomic,assign) OrderInfoOrderPaymentState paymentStatus;

@property (nonatomic,strong) NSArray *orderMenuDetail;

@property (nonatomic,strong) NSArray *youhuiDetail;

@property (nonatomic,strong) NSArray *orderLogDetail;

@property (nonatomic,assign) BOOL isSelfDelivery;

@property (nonatomic,copy) NSString *deliveryTime;

@property (nonatomic,copy) NSString *orderConsigneePhone;

@property (nonatomic,copy) NSString *deliveryNote;

@property (nonatomic,assign) BOOL isFapiaoNeed;

@property (nonatomic,copy) NSString *faPiaoTitle;

@property (nonatomic,assign) int deliveryNumber;

@property (nonatomic,assign) float youhuiDiscountNumber; //订单 优惠活动的减少的金额  正数

@property (nonatomic,assign) float voucherDiscountNumber; //订单 代金券抵扣的金额 正数

@property (nonatomic,assign) float unionDiscountNumber; //订单 使用余额支付的金额 正数

@property (nonatomic,copy) NSString *voucherCode; //订单 使用代金券支付的代金券代码

@property (nonatomic,assign) float originNumber; //订单 菜单的价格 不包含配送费

@property (nonatomic,assign) float orderNumber;  //订单 菜单价格加上配送费 减去优惠后的价格

@property (nonatomic,assign) float payNumber; //订单  实际支付的价格  菜单价格 加上配送费 减去优惠券优惠的价格 减去代金券 减去账户余额抵扣

@property (nonatomic,assign) long long timeStamp;

@property (nonatomic,assign) BOOL isRefunded;//是否申请了退款

@property (nonatomic,assign) BOOL isJudged;

+(instancetype)orderInfoWithNetworkDictionary:(NSDictionary *)netDic;
-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;


@end
