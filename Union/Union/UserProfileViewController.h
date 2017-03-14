//
//  UserProfileViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserViewController;

@interface UserProfileViewController : UIViewController

@property (nonatomic,strong) UIImage *userImage;

@property (nonatomic,copy) NSString *phoneNumber;

@property (nonatomic,strong) UserViewController *userViewController;

@end
