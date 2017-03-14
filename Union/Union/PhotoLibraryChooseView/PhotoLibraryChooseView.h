//
//  ImageUtilsView.h
//  ColorTest
//
//  Created by xiaoyu on 15/9/8.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageUtilsViewSourceType) {
    ImageUtilsViewSourceTypePhotoLibrary = 1 << 0,
};

@class PhotoLibraryChooseView;
@protocol PhotoLibraryChooseViewDelegate <NSObject>

@optional

-(void)photoLibraryChooseView:(PhotoLibraryChooseView *)chooseView didFinishChoosingImage:(UIImage *)image;

@end

@interface PhotoLibraryChooseView : UIView

@property (nonatomic,assign) ImageUtilsViewSourceType sourceType;

@property (nonatomic,assign) id<PhotoLibraryChooseViewDelegate> delegate;

+(instancetype)viewWithPhotoLibraryInViewController:(UIViewController *)viewController;

-(instancetype)initWithPhotoLibraryInViewController:(UIViewController *)viewController;
@end