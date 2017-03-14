//
//  AdressInfoTableViewCell.h
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdressTableViewCell;
static float AdressCellViewHeight = 60.f;

@protocol AdressTableViewCellDelegate <NSObject>

@optional
-(void)addressTableDidTapEditImage:(AdressTableViewCell *)cell;

@end

@interface AdressTableViewCell : UITableViewCell

@property (nonatomic,strong) AdressInfo *adressInfo;

@property (nonatomic,assign) id<AdressTableViewCellDelegate> delegate;

@end
