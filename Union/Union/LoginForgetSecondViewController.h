//
//  LoginForgetSecondViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/28.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginForgetType) {
    LoginForgetTypeRegist,
    LoginForgetTypeSettingPassword,
    LoginForgetTypeChangePassword,
};

@interface LoginForgetSecondViewController : UIViewController

@property (nonatomic,assign) LoginForgetType type;

@property (nonatomic,copy) NSString *loginName;

@end
