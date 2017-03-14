//
//  ShopItem.h
//  Union
//
//  Created by xiaoyu on 15/11/21.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopItem : NSObject

//唯一id
@property (nonatomic,copy) NSString *itemID;
//商品图片url
@property (nonatomic,copy) NSString *itemImageUrl;
@property (nonatomic,copy) NSString *itemBigImageUrl;
//商品所属的店铺信息
@property (nonatomic,copy) NSString *shopName;
//商品所属的店铺ID
@property (nonatomic,copy) NSString *shopID;
//商品名称
@property (nonatomic,copy) NSString *itemName;
//商品卖出的数量
@property (nonatomic,assign) int soldNum;
//商品推荐的数量
@property (nonatomic,assign) int recommendNum;
//商品选择数量
@property (nonatomic,assign) int chooseCount;
//商品单价
@property (nonatomic,assign) float price;
//商品原价
@property (nonatomic,assign) float originPrice;
//商品简介
@property (nonatomic,copy) NSString *itemDescription;

+(instancetype)shopItemWithNetworkDictionary:(NSDictionary *)dic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)dic;

@end