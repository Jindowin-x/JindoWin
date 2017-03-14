//
//  SearchViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/21.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopInfo.h"
#import "ShopItem.h"

@interface SearchViewController : UIViewController

@end

@interface SearchShopHouseTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopInfo *shopInfo;

@end

@interface SearchShopItemTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopItem *shopItem;

@end

