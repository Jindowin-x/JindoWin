//
//  OrderTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderInfo.h"

@class OrderTableViewCell;
@protocol OrderTableViewCellDelegate <NSObject>

@optional

-(void)orderTableCell:(OrderTableViewCell *)cell didClickFunctionButton:(UIButton *)button;

@end


@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,strong) OrderInfo *orderInfo;

@property (nonatomic,assign) BOOL isLastcell;

@property (nonatomic,assign) id<OrderTableViewCellDelegate> delegate;

+(CGFloat)staticHeightWithOrderInfo:(OrderInfo *)orderInfo;

@end

