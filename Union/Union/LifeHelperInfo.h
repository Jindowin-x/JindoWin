//
//  LifeHelperPostInfo.h
//  Union
//
//  Created by xiaoyu on 15/12/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeHelperInfo : NSObject

@property (nonatomic,copy) NSString *lid;

@property (nonatomic,copy) NSString *imageDefaultUrl;

@property (nonatomic,copy) NSString *titleString;

@property (nonatomic,copy) NSString *contactName;

@property (nonatomic,copy) NSString *contactPhone;

@property (nonatomic,copy) NSString *mapAdress;

@property (nonatomic,assign) float mapLatitude; //暂未使用

@property (nonatomic,assign) float mapLongitude; //暂未使用

@property (nonatomic,copy) NSString *detailAdress;

@property (nonatomic,strong) NSDictionary *gategroyInfoDic;

@property (nonatomic,copy) NSString *regionName;

@property (nonatomic,copy) NSString *detailMessage;

@property (nonatomic,assign) int seesNum;//查看次数

@end
