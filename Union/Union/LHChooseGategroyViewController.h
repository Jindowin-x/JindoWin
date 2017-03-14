//
//  LHChooseGategroyViewController.h
//  Union
//
//  Created by xiaoyu on 15/12/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHChooseGategroyViewController : UIViewController

typedef void (^GategroyCompleteBlock)(NSDictionary *nodeDic,NSDictionary *childrenDic);

@property (nonatomic,strong) NSArray *gategroyArray;

@property (nonatomic,copy) GategroyCompleteBlock completeBlock;

@end
