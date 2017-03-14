//
//  AdressInfo.h
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface AdressInfo : NSObject <NSCoding>
@interface AdressInfo : NSObject

//addressID,mapAdress,mapLatitude,mapLongitude,detailAdress,name,sex,phone,zipCode,isDefault

@property (nonatomic,copy) NSString *addressID;

@property (nonatomic,copy) NSString *mapAdress;

@property (nonatomic,assign) float mapLatitude;

@property (nonatomic,assign) float mapLongitude;

@property (nonatomic,copy) NSString *detailAdress;

@property (nonatomic,copy) NSString *name;

// 0  male 1 female
@property (nonatomic,assign) int sex;

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *zipCode;

@property (nonatomic,assign) BOOL isDefault;

@end
