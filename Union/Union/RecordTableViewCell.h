//
//  RecordTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

static float RecordTableViewCellViewHeight = 60.f;
@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *recordName;

@property (nonatomic,assign) float recordNumber;

@property (nonatomic,assign) long long recordTimeStamp;

@property (nonatomic,assign) float recordYueNumber;

@end
