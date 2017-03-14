//
//  JudgeTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

static float JudgeTableViewCellViewHeight = 100.f;
@interface JudgeTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *judgeShopName;

@property (nonatomic,copy) NSString *judgeMessage;

@property (nonatomic,assign) long long judgeTimeStamp;

@end
