//
//  ShopInfo.h
//  Union
//
//  Created by xiaoyu on 15/11/11.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShopInfoBusinessState) {
    ShopInfoBusinessStateBreak = 1 << 0,
    ShopInfoBusinessStateOpen = 1 << 1,
};

@interface ShopInfo : NSObject

@property (nonatomic,copy) NSString *shopID;
//商户图片网址
@property (nonatomic,copy) NSString *imageUrl;

//商户名称
@property (nonatomic,copy) NSString *name;
//商户地址
@property (nonatomic,copy) NSString *address;
//商户来源
@property (nonatomic,assign) BOOL isSelfDelivery;

//商户营业状态
@property (nonatomic,assign) ShopInfoBusinessState businessState;

//月销量
@property (nonatomic,assign) int monthSaleNumber;

//商户评价  星级水平
@property (nonatomic,assign) float starJudge;

//商户起送金额
@property (nonatomic,assign) int minBuyNumber;
//商户配送费
@property (nonatomic,assign) int deliveryNumber;

//优惠券功能是否有效
@property (nonatomic,assign) BOOL juanEnabel;
//小票回执是否有效
@property (nonatomic,assign) BOOL piaoEnabel;
//在线支付付 是否有效
@property (nonatomic,assign) BOOL fuEnabel;
//赔付是否有效
@property (nonatomic,assign) BOOL peiEnabel;

//商户活动策略
@property (nonatomic,strong) NSDictionary *huodongDictionary;

//营业时间
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,copy) NSString *endTime;

//平均配送时间
@property (nonatomic,copy) NSString *deliveryAverage;

//商家公告
@property (nonatomic,copy) NSString *shopNotification;

//商家简介
@property (nonatomic,copy) NSString *shopIndtroduction;

//商家电话
@property (nonatomic,copy) NSString *contactPhone;

+(instancetype)shopInfoWithNetWorkDictionary:(NSDictionary *)shopDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)shopDic;

@end
