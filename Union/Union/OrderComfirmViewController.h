//
//  OrderComfirmViewController.h
//  Union
//
//  Created by xiaoyu on 15/12/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"
#import "OrderInfo.h"

@interface OrderComfirmViewController : UIViewController

@property (nonatomic,strong) ShopInfo *shopInfo;

@property (nonatomic,strong) OrderInfo *orderInfo;

@property (nonatomic,strong) NSArray *shopItemBuyArray;

//订单留言
@property (nonatomic,copy) NSString *noteMessage;

@end
