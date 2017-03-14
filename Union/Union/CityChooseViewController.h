//
//  CityChooseViewController.h
//  Union
//
//  Created by xiaoyu on 16/1/17.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AreaChooseViewController.h"

@interface CityChooseViewController : UIViewController

@property (nonatomic,assign) ChooseStopType stopType;

@property (nonatomic,copy) ResultBlock resultBlock;

@property (nonatomic,assign) long parentID;

@end
