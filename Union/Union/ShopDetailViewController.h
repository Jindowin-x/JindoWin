//
//  ShopDetailViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/22.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"
#import "ShopItem.h"
@class ShopItemDetailTableCell;
@interface ShopDetailViewController : UIViewController

@property (nonatomic,strong) ShopInfo *shopInfo;

@property (nonatomic,copy) NSString *selectedItemID;

@end

static float ShopItemCategoryTableCellHeight = 45;
@interface ShopItemCategoryTableCell : UITableViewCell

@property (nonatomic,copy) NSString *textString;

@end

@protocol ShopItemDetailTableCellDelegate <NSObject>

@optional

-(void)shopItemDetailCell:(ShopItemDetailTableCell *)itemCell didClickAddButton:(UIButton *)button atIndexPath:(NSIndexPath *)indexPath;
-(void)shopItemDetailCell:(ShopItemDetailTableCell *)itemCell didClickMinusAtButton:(UIButton *)button atIndexPath:(NSIndexPath *)indexPath;

@end

static float ShopItemDetailTableCellHeight = 80;
@interface ShopItemDetailTableCell : UITableViewCell

@property (nonatomic,strong) ShopItem *shopItem;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id <ShopItemDetailTableCellDelegate> delegate;

@end

@interface ShopJudgeDetailTableCell : UITableViewCell

@property (nonatomic,assign) float rating;

@property (nonatomic,copy) NSString *username;

@property (nonatomic,assign) long long timeStamp;

@property (nonatomic,copy) NSString *judgeContent;

@property (nonatomic,copy) NSString *headUrlString;

+(CGFloat)staticHeightWithJudgeContent:(NSString *)content;

@end

