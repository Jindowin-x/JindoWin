//
//  RefundTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

static float RefundTableViewCellViewHeight = 130.f;
@interface RefundTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isLastCell;

//@property (nonatomic,strong) OrderInfo *orderInfo;

@property (nonatomic,strong) NSDictionary *orderDic;

@end
