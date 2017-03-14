//
//  ShopItem.m
//  Union
//
//  Created by xiaoyu on 15/11/21.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopItem.h"
#import "UNUrlConnection.h"

@implementation ShopItem

+(instancetype)shopItemWithNetworkDictionary:(NSDictionary *)dic{
    ShopItem *shopItem = [[ShopItem alloc] init];
    return [shopItem updateWithNetworkDictionary:dic];
}

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)dic{
    if (self) {
        NSString *imageUrl = dic[@"image"];
        if (imageUrl && [imageUrl isKindOfClass:[NSString class]] && ![imageUrl isEqualToString:@""]) {
            self.itemImageUrl = [UNUrlConnection replaceUrl:imageUrl];
        }
        NSString *name = dic[@"name"];
        if ([name isKindOfClass:[NSNull class]]) {
            name = @"";
        }else{
            if (name) {
                self.itemName = name;
            }
        }
        
        NSString *priceStr = dic[@"price"];
        if ([priceStr isKindOfClass:[NSNull class]]) {
            priceStr = 0;
        }else{
            if (priceStr) {
                self.price = [priceStr floatValue];
            }
        }
        
        long itemid = [dic[@"product_id"] longValue];
        self.itemID = [NSString stringWithFormat:@"%ld",itemid];
        
        int recommends = [dic[@"recommends"] isKindOfClass:[NSNull class]] ? 0 : [dic[@"recommends"] intValue];
        if (recommends != 0) {
            self.recommendNum = recommends;
        }
        
        int sales = [dic[@"sales"] isKindOfClass:[NSNull class]] ? 0 : [dic[@"sales"] intValue];
        if (sales != 0) {
            self.soldNum = sales;
        }
    }
    return self;
}


@end
