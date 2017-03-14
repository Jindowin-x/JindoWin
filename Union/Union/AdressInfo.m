//
//  AdressInfo.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AdressInfo.h"

@implementation AdressInfo

#pragma mark - NSCoding for SaveToDisk

//addressID,mapAdress,mapLatitude,mapLongitude,detailAdress,name,sex,phone,zipCode,isDefault
static NSString *UUIDKey = @"UUIDKey";
static NSString *MapAdressKey = @"MapAdressKey";
static NSString *MapLatitudeKey = @"MapLatitudeKey";
static NSString *MapLongitudeKey = @"MapLongitudeKey";
static NSString *DetailAdressKey = @"DetailAdressKey";
static NSString *NameKey = @"NameKey";
static NSString *SexKey = @"SexKey";
static NSString *PhoneKey = @"PhoneKey";
static NSString *ZipCodeKey = @"ZipCodeKey";
static NSString *IsDefaultKey = @"IsDefaultKey";

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        NSString *UUIDTmp = [aDecoder decodeObjectForKey:UUIDKey];
        NSString *mapAdressTmp = [aDecoder decodeObjectForKey:MapAdressKey];
        long mapLatitudeTmp = [[aDecoder decodeObjectForKey:MapLatitudeKey] longValue];
        long mapLongitudeTmp = [[aDecoder decodeObjectForKey:MapLongitudeKey] longValue];
        NSString *detailAdressTmp = [aDecoder decodeObjectForKey:DetailAdressKey];
        NSString *nameTmp = [aDecoder decodeObjectForKey:NameKey];
        int sexTmp = [[aDecoder decodeObjectForKey:SexKey] intValue];
        NSString *phoneTmp = [aDecoder decodeObjectForKey:PhoneKey];
        BOOL isDeTmp = [[aDecoder decodeObjectForKey:IsDefaultKey] boolValue];
        NSString *zipCodeTmp = [aDecoder decodeObjectForKey:ZipCodeKey];
        
        
        self.addressID = UUIDTmp;
        self.mapAdress = mapAdressTmp;
        self.mapLatitude = mapLatitudeTmp;
        self.mapLongitude = mapLongitudeTmp;
        self.detailAdress = detailAdressTmp;
        self.name = nameTmp;
        self.sex = sexTmp;
        self.phone = phoneTmp;
        self.isDefault = isDeTmp;
        self.zipCode = zipCodeTmp;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if (self.addressID) {
        [aCoder encodeObject:self.addressID forKey:UUIDKey];
    }
    if (self.mapAdress) {
        [aCoder encodeObject:self.mapAdress forKey:MapAdressKey];
    }
    [aCoder encodeObject:@(self.mapLatitude) forKey:MapLatitudeKey];
    [aCoder encodeObject:@(self.mapLongitude) forKey:MapLongitudeKey];
    [aCoder encodeObject:@(self.sex) forKey:SexKey];
    [aCoder encodeObject:@(self.isDefault) forKey:IsDefaultKey];
    if (self.zipCode) {
        [aCoder encodeObject:self.zipCode forKey:ZipCodeKey];
    }
    if (self.detailAdress) {
        [aCoder encodeObject:self.detailAdress forKey:DetailAdressKey];
    }
    if (self.name) {
        [aCoder encodeObject:self.name forKey:NameKey];
    }
    if (self.phone) {
        [aCoder encodeObject:self.phone forKey:PhoneKey];
    }
}

@end
