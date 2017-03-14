//
//  UserViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,copy) NSString *phoneString;

-(void)updateView;

-(void)pushToUserProfileViewController;

@end
