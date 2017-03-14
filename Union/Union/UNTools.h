//
//  UNTools.h
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNTools : NSObject

+(CGSize)getSizeWithString:(NSString *)contentString andSize:(CGSize)size andFont:(UIFont *)font;

+(NSString *)parseTimeWithTimeStamp:(long long)dbdateline;

+(BOOL)isPhoneNumber:(NSString *)phone;

+(BOOL)isNotZeroMoneyNumber:(NSString *)number;

@end

@interface NSString (MD5Hex)

- (NSString *)MD5;

@end