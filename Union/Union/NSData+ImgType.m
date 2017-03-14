//
//  NSData+ImgType.m
//  gif test
//
//  Created by archer on 14/12/20.
//  Copyright (c) 2014年 archer. All rights reserved.
//

#import "NSData+ImgType.h"
#import "UIImage+GIF.h"

@implementation NSData(ImgType)

-(UIImage*)imageForImageRawData{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return nil;//@"image/jpeg";
        case 0x89:
            return nil;//@"image/png";
        case 0x47:
            return [UIImage sd_animatedGIFWithData:self];//@"image/gif";
        case 0x49:
        case 0x4D:
            return nil;//@"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([(NSData*)self length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[(NSData*)self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return nil;//@"image/webp";
            }
            
            return nil;
    }
    return nil;
}


@end
