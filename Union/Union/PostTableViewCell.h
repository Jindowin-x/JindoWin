//
//  PostTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

static float PostTableViewCellViewHeight = 60.f;
@interface PostTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *postTitle;

@property (nonatomic,assign) long long postTimeStamp;

@end
