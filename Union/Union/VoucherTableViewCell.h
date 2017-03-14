//
//  VoucherTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VoucherType) {
    VoucherTypeUnUsed,
    VoucherTypeUsed,
    VoucherTypeExpired,
};

@interface VoucherTableViewCell : UITableViewCell

@property (nonatomic,assign) VoucherType voucherType;

@property (nonatomic,assign) int voucherNum;

@property (nonatomic,copy) NSString *voucherSource;

@property (nonatomic,assign) long long voucherExpredTimeStamp;

@property (nonatomic,copy) NSString *voucherSerilNumber;

+(CGFloat)staticCellHieght;

@end

