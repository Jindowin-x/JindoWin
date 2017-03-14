//
//  ViewController.h
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITabBarController <UITabBarControllerDelegate>

-(void)selectedWithIndex:(int)index;

-(void)updateCurrentNavigation;

-(void)updateOtherNavigation;

@end

