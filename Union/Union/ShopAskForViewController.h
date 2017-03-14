//
//  ShopAskForViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/18.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopAskForViewController : UIViewController

@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSDictionary *shopTypeDic;
@property (nonatomic,copy) NSDictionary *shopBussinessAreaDic;
@property (nonatomic,copy) NSString *shopCity;
@property (nonatomic,copy) NSString *shopMapAddress;
@property (nonatomic,assign) float shopMapLatitude;
@property (nonatomic,assign) float shopMapLongitude;
@property (nonatomic,copy) NSString *shopDetailAddress;
@property (nonatomic,copy) NSString *shopContactor;
@property (nonatomic,copy) NSString *shopOtherLink;

@end
