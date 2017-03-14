//
//  AreaChooseViewController.h
//  Union
//
//  Created by xiaoyu on 16/1/17.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ChooseStopType) {
    ChooseStopTypeArea = 1,
    ChooseStopTypeCity = 2,
};

typedef void (^ResultBlock) (NSDictionary *resultDic);

@interface AreaChooseViewController : UIViewController

@property (nonatomic,copy) ResultBlock resultBlock;

@property (nonatomic,assign) long parentID;

@end
