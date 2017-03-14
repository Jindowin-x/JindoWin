//
//  InfomationTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

static float InfomationTableViewCellViewHeight = 80.f;
@interface InfomationTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *messageTitle;

@property (nonatomic,copy) NSString *messageDetail;

@end
