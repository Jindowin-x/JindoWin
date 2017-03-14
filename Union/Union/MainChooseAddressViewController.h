//
//  MainChooseAddressViewController.h
//  Union
//
//  Created by xiaoyu on 16/1/29.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainChooseAddressViewController : UIViewController

@end

@interface MainChooseAddressInfo : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) float latitude;

@property (nonatomic,assign) float longitude;

@end