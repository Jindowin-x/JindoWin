//
//  LabelShowedViewController.h
//  Union
//
//  Created by xiaoyu on 15/12/1.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LabelShowedType) {
    LabelShowedTypeAbloutUs,
    LabelShowedTypeService,
};

@interface LabelShowedViewController : UIViewController

@property (nonatomic,assign) LabelShowedType type;

@end
