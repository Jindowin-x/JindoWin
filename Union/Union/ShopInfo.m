//
//  ShopInfo.m
//  Union
//
//  Created by xiaoyu on 15/11/11.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopInfo.h"
#import "UNUrlConnection.h"

@implementation ShopInfo
/**
 *  @property (nonatomic,copy) NSString *shopID;
 //商户图片网址
 @property (nonatomic,copy) NSString *imageUrl;
 
 //商户名称
 @property (nonatomic,copy) NSString *name;
 
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
 */
+(instancetype)shopInfoWithNetWorkDictionary:(NSDictionary *)shopDic{
    ShopInfo *info = [[ShopInfo alloc] init];
    return [info updateWithNetworkDictionary:shopDic];
}

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)shopDic{
    NSString *logo = shopDic[@"logo"];
    if (logo) {
        self.imageUrl = [UNUrlConnection replaceUrl:logo];
    }
    long shopid = [shopDic[@"id"] longValue];
    self.shopID = [NSString stringWithFormat:@"%ld",shopid];
    NSString *name = shopDic[@"name"];
    if ([name isKindOfClass:[NSNull class]]) {
        self.name = @"";
    }else{
        if (name) {
            self.name = name;
        }
    }
    
    NSString *address = shopDic[@"address"];
    if ([address isKindOfClass:[NSNull class]]) {
        self.address = @"";
    }else{
        if (address) {
            self.address = address;
        }
    }
    
    NSString *saleNum = shopDic[@"saleNum"];
    if ([saleNum isKindOfClass:[NSNull class]]) {
        self.monthSaleNumber = 0;
    }else{
        if (saleNum) {
            self.monthSaleNumber = [saleNum intValue];
        }
    }
    
    NSString *score = shopDic[@"score"];
    if ([score isKindOfClass:[NSNull class]]) {
        self.starJudge = 0;
    }else{
        if (score) {
            self.starJudge = [score floatValue];
        }
    }
    
    NSString *begin_price = shopDic[@"begin_price"];
    if ([begin_price isKindOfClass:[NSNull class]]) {
        self.minBuyNumber = 0;
    }else{
        if (begin_price) {
            self.minBuyNumber = [begin_price floatValue];
        }
    }
    
    NSString *fee = shopDic[@"fee"];
    if ([fee isKindOfClass:[NSNull class]]) {
        self.deliveryNumber = 0;;
    }else{
        if (fee) {
            self.deliveryNumber = [fee intValue];
        }
    }
    
    NSString *notice = shopDic[@"notice"];
    if ([notice isKindOfClass:[NSNull class]]) {
        self.shopNotification = @"";
    }else{
        if (notice) {
            self.shopNotification = notice;
        }
    }
    
    NSString *introduction = shopDic[@"introduction"];
    if ([introduction isKindOfClass:[NSNull class]]) {
        self.shopIndtroduction = @"";
    }else{
        if (introduction) {
            self.shopIndtroduction = introduction;
        }
    }
    
    NSString *begin_time = shopDic[@"begin_time"];
    if ([begin_time isKindOfClass:[NSNull class]]) {
        self.beginTime = @"00:00:00";
    }else{
        if (begin_time) {
            self.beginTime = begin_time;
        }
    }
    
    NSString *end_time = shopDic[@"end_time"];
    if ([end_time isKindOfClass:[NSNull class]]) {
        self.endTime = @"23:59:59";
    }else{
        if (end_time) {
            self.endTime = end_time;
        }
    }
    
    int reach_time = 40;
    NSString *reach_timeString = shopDic[@"reach_time"];
    if ([reach_timeString isKindOfClass:[NSNull class]]) {
        reach_time = 40;
    }else{
        if (reach_timeString) {
            reach_time = [reach_timeString intValue];
        }
    }
    
    self.deliveryAverage = [NSString stringWithFormat:@"%d",reach_time];
    
    BOOL isFP = [shopDic[@"isFP"] isKindOfClass:[NSNull class]] ? NO:[shopDic[@"isFP"] boolValue];
    self.piaoEnabel = isFP;
    BOOL isZF = [shopDic[@"isZF"] isKindOfClass:[NSNull class]] ? NO:[shopDic[@"isZF"] boolValue];
    self.fuEnabel = isZF;
    BOOL isPS = [shopDic[@"isPS"] isKindOfClass:[NSNull class]] ? NO:[shopDic[@"isPS"] boolValue];
    self.isSelfDelivery = isPS;
    BOOL isYH = [shopDic[@"isYH"] isKindOfClass:[NSNull class]] ? NO:[shopDic[@"isYH"] boolValue];
    self.peiEnabel = isYH;
    
    BOOL isClosed = [[shopDic objectForKey:@"isClosed"] boolValue];
    self.businessState = isClosed ? ShopInfoBusinessStateBreak:ShopInfoBusinessStateOpen;
    
    self.juanEnabel = YES;
    
    NSString *contactNumber = shopDic[@"contactNumber"];
    if (contactNumber && [contactNumber isKindOfClass:[NSString class]]) {
        self.contactPhone = contactNumber;
    }
    
    NSArray *promotionsArray = shopDic[@"promotions"];
    if (promotionsArray) {
        NSMutableDictionary *youhuiDicTmp = [NSMutableDictionary dictionary];
        [promotionsArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSString *type = [obj objectForKey:@"promotion_type"];
            NSString *value = [obj objectForKey:@"promotion_name"];
            if (type && [type isKindOfClass:[NSString class]]) {
                if ([type isEqualToString:@"preferential1"]) {
                    [youhuiDicTmp setObject:value forKey:@"新"];
                }else if ([type isEqualToString:@"preferential2"]){
                    [youhuiDicTmp setObject:value forKey:@"特"];
                }else if ([type isEqualToString:@"preferential3"]){
                    [youhuiDicTmp setObject:value forKey:@"减"];
                }else if ([type isEqualToString:@"preferential4"]){
                    [youhuiDicTmp setObject:value forKey:@"预"];
                }else if ([type isEqualToString:@"preferential5"]){
                    [youhuiDicTmp setObject:value forKey:@"免"];
                }else if ([type isEqualToString:@"preferential6"]){
                    [youhuiDicTmp setObject:value forKey:@"劵"];
                }
            }
        }];
        self.huodongDictionary = [NSDictionary dictionaryWithDictionary:youhuiDicTmp];
    }
    return self;
}

@end
