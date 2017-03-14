//
//  LHChooseGategroyDetailViewController.h
//  Union
//
//  Created by xiaoyu on 15/12/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHChooseGategroyDetailViewController : UIViewController

typedef void (^GategroyResultBlock)(NSDictionary *resultDic);

@property (nonatomic,copy) NSString *chooseTitle;

@property (nonatomic,strong) NSArray *detailArray;

@property (nonatomic,copy) GategroyResultBlock resultBlock;

-(void)reload;

@end
