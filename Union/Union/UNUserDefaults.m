//
//  UNUserDefaults.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UNUserDefaults.h"


@implementation UNUserDefaults

+(NSString *)getSaveKeyWithSimpleSaveKey:(NSString *)simpleSaveKey{
    NSString *reKey = [NSString stringWithFormat:@"UN_%@_%@",[self getUserID],simpleSaveKey];
    return reKey;
}

static NSString *LoginSaveKey = @"LoginSaveKey";
+(void)setIsLogin:(BOOL)isLogin{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(isLogin) forKey:LoginSaveKey];
    [userdefaults synchronize];
}

+(BOOL)getIsLogin{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:LoginSaveKey] boolValue];
}

static NSString *FirshLuanchSaveKey = @"FirshLuanchSaveKey";
+(void)setIsNotFirshLuanch:(BOOL)isfirst{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(isfirst) forKey:FirshLuanchSaveKey];
    [userdefaults synchronize];
}
+(BOOL)getIsNotFirshLuanch{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:FirshLuanchSaveKey] boolValue];
}

//注销登录
+(void)resetLoginStatus{
    [self setUserID:@""];
    [self setUserHeadImage:nil];
    [self setUserPhone:nil];
    [self setUserToken:nil];
    [self setUserPassword:nil];
    [self setIsLogin:NO];
}

static NSString *UIDSaveKey = @"UIDSaveKey";
+(void)setUserID:(NSString *)uid{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!uid) {
        [userdefaults removeObjectForKey:UIDSaveKey];
    }else{
        [userdefaults setObject:uid forKey:UIDSaveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserID{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userdefaults objectForKey:UIDSaveKey];
    if (!userID) {
        return nil;
    }
    return userID;
}

static NSString *UserPhoneSaveKey = @"UserPhoneSaveKey";
+(void)setUserPhone:(NSString *)phone{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPhoneSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!phone || [phone isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:phone forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserPhone{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPhoneSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserPasswordSaveKey = @"UserPasswordSaveKey";
+(void)setUserPassword:(NSString *)password{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPasswordSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!password || [password isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:password forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserPassword{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPasswordSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserHeadImageSaveKey = @"UserHeadImageSaveKey";
+(void)setUserHeadImage:(UIImage *)image{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (image) {
        NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
        [userdefaults setObject:imageData forKey:saveKey];
        [userdefaults synchronize];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
}

+(UIImage *)getUserHeadImage{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageSaveKey];
    NSData *imageData;
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
    if(imageData){
        UIImage *yourUIImage = [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
        if (yourUIImage) {
            return yourUIImage;
        }
    }
    return nil;
}

static NSString *UserHeadImageURLSaveKey = @"UserHeadImageURLSaveKey";
+(void)setUserHeadImageUrl:(NSString *)imageurl{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageURLSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (imageurl) {
        [userdefaults setObject:imageurl forKey:saveKey];
        [userdefaults synchronize];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
}

+(NSString *)getUserHeadImageUrl{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageURLSaveKey];
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
    return urlString;
}

static NSString *UserTokenSaveKey = @"UserTokenSaveKey";
+(void)setUserToken:(NSString *)token{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserTokenSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!token || [token isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:token forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserToken{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserTokenSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *CitySaveKey = @"CitySaveKey";
+(void)saveCity:(NSString *)city{
    NSString *saveKey = CitySaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (city && ![city isEqualToString:@""]) {
        [userdefaults setObject:city forKey:saveKey];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getCity{
    NSString *saveKey = CitySaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [userdefaults objectForKey:saveKey];
    if (!city) {
        return nil;
    }
    return city;
}

static NSString *LocationAddressSaveKey = @"LocationAddressSaveKey";
+(void)saveLocationAddress:(NSString *)address{
    NSString *saveKey = LocationAddressSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (address && ![address isEqualToString:@""]) {
        [userdefaults setObject:address forKey:saveKey];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getLocationAddress{
    NSString *saveKey = LocationAddressSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [userdefaults objectForKey:saveKey];
    if (!address) {
        return nil;
    }
    return address;
}

static NSString *LocationLatitudeSaveKey = @"LocationLatitudeSaveKey";
static NSString *LocationLongitudeSaveKey = @"LocationLongitudeSaveKey";
+(void)saveLocationLatitude:(float)latitude longitude:(float)longitude{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(latitude) forKey:LocationLatitudeSaveKey];
    [userdefaults setObject:@(longitude) forKey:LocationLongitudeSaveKey];
    [userdefaults synchronize];
}
+(float)getLocationLatitude{
    NSString *saveKey = LocationLatitudeSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] floatValue];
}
+(float)getLocationLongitude{
    NSString *saveKey = LocationLongitudeSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] floatValue];
}

static NSString *MainAddressLatitudeSaveKey = @"LocationLatitudeSaveKey";
static NSString *MainAddressLongitudeSaveKey = @"LocationLongitudeSaveKey";
+(void)saveMainAddressLatitude:(float)latitude longitude:(float)longitude{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(latitude) forKey:MainAddressLatitudeSaveKey];
    [userdefaults setObject:@(longitude) forKey:MainAddressLongitudeSaveKey];
    [userdefaults synchronize];
}
+(float)getMainAddressLatitude{
    NSString *saveKey = MainAddressLatitudeSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] floatValue];
}
+(float)getMainAddressLongitude{
    NSString *saveKey = MainAddressLongitudeSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] floatValue];
}


static NSString *MainGategroySaveKey = @"MainGategroySaveKey";
+(void)saveMainGategroy:(NSArray *)gategroyArray{
    NSString *saveKey = MainGategroySaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if (gategroyArray && gategroyArray.count != 0) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:gategroyArray]];
        [userdefaults setObject:data forKey:saveKey];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSArray *)getMainGategroy{
    NSString *saveKey = MainGategroySaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSData *tmp = [userdefaults objectForKey:saveKey];
    if (tmp) {
        NSArray *arrTmp = [NSKeyedUnarchiver unarchiveObjectWithData:tmp];
        if (arrTmp) {
            return [NSArray arrayWithArray:arrTmp];
        }
    }
    return [NSArray array];
}


static NSString *SearchHistorSaveKey = @"SearchHistorSaveKey";
+(void)saveSearchHistoryString:(NSString *)searchKey{
    if (searchKey && ![searchKey isEqualToString:@""]) {
        NSMutableArray *allSearchHistoryArray = [self getAllSearchHistory];
        
        [allSearchHistoryArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([searchKey isEqualToString:obj]) {
                [allSearchHistoryArray removeObjectAtIndex:idx];
                stop = (BOOL *)YES;
            }
        }];
        [allSearchHistoryArray addObject:searchKey];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:allSearchHistoryArray]];
        
        NSString *saveKey = SearchHistorSaveKey;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:data forKey:saveKey];
        [userdefaults synchronize];
    }
}

+(NSMutableArray *)getAllSearchHistory{
    NSString *saveKey = SearchHistorSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSData *tmp = [userdefaults objectForKey:saveKey];
    if (tmp) {
        NSArray *arrTmp = [NSKeyedUnarchiver unarchiveObjectWithData:tmp];
        if (arrTmp) {
            return [NSMutableArray arrayWithArray:arrTmp];
        }
    }
    return [NSMutableArray array];
}

+(void)removeAllSearchHistory{
    NSString *saveKey = SearchHistorSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults removeObjectForKey:saveKey];
}

static NSString *DefaultAddressIDSaveKey = @"DefaultAddressIDSaveKey";
+(void)setDefaultAddressID:(NSString *)addressID{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:DefaultAddressIDSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (addressID && ![addressID isEqualToString:@""]) {
        [userdefaults setObject:addressID forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getDefaultAddressID{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:DefaultAddressIDSaveKey];
    
    if (saveKey) {
        NSString *addressID = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
        if (addressID) {
            return addressID;
        }
    }
    return nil;
}

+(AdressInfo *)getDefaultAddressInfo{
    NSString *defaultID = [self getDefaultAddressID];
    NSMutableArray *addressArrays = [self getAllAdressInfo];
    if (defaultID) {
        if (addressArrays) {
            for (AdressInfo *addInfo in addressArrays) {
                if ([addInfo.addressID isEqualToString:defaultID]) {
                    return addInfo;
                }
            }
        }
    }
    if (addressArrays && addressArrays.count > 0) {
        AdressInfo *info = addressArrays[0];
        NSString *addressid = info.addressID;
        if (addressid) {
            [self setDefaultAddressID:addressid];
        }
        return info;
    }
    return nil;
}

static NSString *AllAdressInfoSaveKey = @"AllAdressInfoSaveKey";
+(void)saveAdressInfo:(AdressInfo *)adInfo{
    NSMutableArray *allAdressInfoArray = [self getAllAdressInfo];
    if (!adInfo) {
        return;
    }
    __block BOOL needAdd = YES;
    [allAdressInfoArray enumerateObjectsUsingBlock:^(AdressInfo *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.addressID isEqualToString:adInfo.addressID]) {
            needAdd = NO;
            [allAdressInfoArray replaceObjectAtIndex:idx withObject:adInfo];
        }
    }];
    if (needAdd) {
        [allAdressInfoArray addObject:adInfo];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:allAdressInfoArray]];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self getSaveKeyWithSimpleSaveKey:AllAdressInfoSaveKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray *)getAllAdressInfo{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:AllAdressInfoSaveKey];
    NSData *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
    if (tmp) {
        NSArray *arrTmp = [NSKeyedUnarchiver unarchiveObjectWithData:tmp];
        if (arrTmp) {
            return [NSMutableArray arrayWithArray:arrTmp];
        }
    }
    return [NSMutableArray array];
}

@end
