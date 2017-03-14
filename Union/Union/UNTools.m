//
//  UNTools.m
//  Union
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UNTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UNTools


+(CGSize)getSizeWithString:(NSString *)contentString andSize:(CGSize)size andFont:(UIFont *)font{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        //        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize size1 =[contentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        //NSLog(@"%@,%f,%f",contentString,size1.width,size1.height);
        return size1;
    }else{
        return [contentString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}

+(NSString *)parseTimeWithTimeStamp:(long long)dbdateline{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dbdateline];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//11位电话号码正则判断 var reg = /^1\d{10}$/;  //定义正则表达式
+(BOOL)isPhoneNumber:(NSString *)phone{
    if (!phone) {
        return NO;
    }
    if ([phone isEqualToString:@""]) {
        return NO;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [emailTest evaluateWithObject:phone];
}

//验证非零的正整数：^\+?[1-9][0-9]*$
+(BOOL)isNotZeroMoneyNumber:(NSString *)number{
    if (!number) {
        return NO;
    }
    if ([number isEqualToString:@""]) {
        return NO;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+$"];
    return [emailTest evaluateWithObject:number];
}

@end


@implementation NSString (MD5Hex)

- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

