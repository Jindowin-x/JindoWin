//
//  ShopsTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/11.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopInfo.h"

@interface ShopsTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopInfo *shopInfo;

+(CGFloat)staticHeightWithShopInfo:(ShopInfo *)info;

+(CGFloat)staticHeightWithShopInfos:(NSArray *)infos;

@end
