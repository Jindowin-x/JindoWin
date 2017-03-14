//
//  UNUserDefaults.h
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdressInfo.h"

//保存首页选择的经纬度地址
//static float mainAddressLatitude,mainAddressLongitude;
//static float locationLatitude,locationLogitude;

@interface UNUserDefaults : NSObject

+(void)setIsLogin:(BOOL)isLogin;
+(BOOL)getIsLogin;

+(void)setIsNotFirshLuanch:(BOOL)isfirst;
+(BOOL)getIsNotFirshLuanch;

//注销登录
+(void)resetLoginStatus;

+(void)setUserID:(NSString *)uid;
+(NSString *)getUserID;

+(void)setUserPhone:(NSString *)phone;
+(NSString *)getUserPhone;

+(void)setUserPassword:(NSString *)password;
+(NSString *)getUserPassword;

+(void)setUserHeadImage:(UIImage *)image;
+(UIImage *)getUserHeadImage;

+(void)setUserHeadImageUrl:(NSString *)imageurl;
+(NSString *)getUserHeadImageUrl;

+(void)setUserToken:(NSString *)token;
+(NSString *)getUserToken;

+(void)saveCity:(NSString *)city;
+(NSString *)getCity;

+(void)saveLocationAddress:(NSString *)address;
+(NSString *)getLocationAddress;

+(void)saveLocationLatitude:(float)latitude longitude:(float)longitude;
+(float)getLocationLatitude;
+(float)getLocationLongitude;

+(void)saveMainAddressLatitude:(float)latitude longitude:(float)longitude;
+(float)getMainAddressLatitude;
+(float)getMainAddressLongitude;

+(void)saveMainGategroy:(NSArray *)gategroyArray;
+(NSArray *)getMainGategroy;

+(void)saveSearchHistoryString:(NSString *)searchKey;
+(NSMutableArray *)getAllSearchHistory;
+(void)removeAllSearchHistory;

+(void)setDefaultAddressID:(NSString *)addressID;
+(AdressInfo *)getDefaultAddressInfo;

+(void)saveAdressInfo:(AdressInfo *)adInfo;
+(NSMutableArray *)getAllAdressInfo;

@end
