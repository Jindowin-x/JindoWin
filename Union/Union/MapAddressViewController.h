//
//  MapAddressViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/19.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapAddressViewController : UIViewController

typedef void (^MapAddressResultBlock) (NSString *name,NSString *address,float latitude,float longitude);

@property (nonatomic,copy) MapAddressResultBlock resultBlock;

@property (nonatomic,assign) float mapLatitude;

@property (nonatomic,assign) float mapLongitude;

@end
