//
//  LifeHelperListViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeHelperListViewController : UIViewController

@property (nonatomic,strong) NSDictionary *infoDictionary;

@property (nonatomic,strong) NSArray *lifeGategroyArray;

@end

@class LifeHelperListTableCell;
@protocol LifeHelperListTableCellDelegate <NSObject>

@optional
-(void)listTableCell:(LifeHelperListTableCell *)cell didClickOutCallButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

static float LifeHelperListTableCellHieght = 80;
@interface LifeHelperListTableCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id<LifeHelperListTableCellDelegate> delegate;

@end