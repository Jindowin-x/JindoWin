//
//  ShopsViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsViewController : UIViewController

@property (nonatomic,assign) BOOL isUnionPS;

@property (nonatomic,assign) long nodesourceid;

@property (nonatomic,strong) NSArray *dataSourceArray;

-(void)updateLocationWithLatitude:(float)latitude longitude:(float)longitude;

@end

@interface SimpleSourceTableCell : UITableViewCell
@end

@interface DetailSourceTableCell : UITableViewCell
@end

@interface YouhuiSourceTableCell : UITableViewCell

@property (nonatomic,strong) UIColor *tagColor;

@end