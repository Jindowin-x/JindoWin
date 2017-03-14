//
//  ImageUtilsView.m
//  ColorTest
//
//  Created by xiaoyu on 15/9/8.
//  Copyright © 2015年 xiaoyu. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "PhotoLibraryChooseView.h"
#import "Macros.h"

@interface PhotoLibraryChooseView()<UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PhotoLibraryChooseView{
    UIViewController *photoLibraryViewController;
    
    UIButton *photoLibraryView;
    NSMutableArray *photoLibraryArray;
}


float optionViewHeight = 50.f;

+(instancetype)viewWithPhotoLibraryInViewController:(UIViewController *)viewController{
    return [[PhotoLibraryChooseView alloc] initWithPhotoLibraryInViewController:viewController];
}

-(instancetype)initWithPhotoLibraryInViewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.frame = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height};
        photoLibraryViewController = viewController;
        [self setUpPhotoLibraryView];
    }
    return self;
}

#pragma mark 初始化照片选择器

static float PhotoPickerHeight = 150.f;
-(void)setUpPhotoLibraryView{
    photoLibraryView = [[UIButton alloc] initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height}];
    photoLibraryView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    [self addSubview:photoLibraryView];
    
    [photoLibraryView addTarget:self action:@selector(photoLibraryViewCancel) forControlEvents:UIControlEventTouchUpInside];
    UIView *photoPickerView = [[UIView alloc] initWithFrame:(CGRect){0,HEIGHT(photoLibraryView),WIDTH(photoLibraryView),PhotoPickerHeight}];
    photoPickerView.backgroundColor = RGBColor(255, 255, 255);
    [photoLibraryView addSubview:photoPickerView];
    
    
    UIButton *photoCameraButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,WIDTH(photoPickerView),50}];
    [photoCameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [photoCameraButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    photoCameraButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [photoPickerView addSubview:photoCameraButton];
    
    [photoCameraButton addTarget:self action:@selector(photoCameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *photoCameraButtonSepLine = [[UIView alloc] initWithFrame:(CGRect){5,BOTTOM(photoCameraButton)+1,WIDTH(photoPickerView)-5*2,0.5}];
    photoCameraButtonSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [photoPickerView addSubview:photoCameraButtonSepLine];
    
    UIButton *photoLibraryButton = [[UIButton alloc] initWithFrame:(CGRect){0,BOTTOM(photoCameraButtonSepLine),WIDTH(photoPickerView),50}];
    [photoLibraryButton setTitle:@"照片图库" forState:UIControlStateNormal];
    [photoLibraryButton setTitleColor:RGBColor(80, 80, 80) forState:UIControlStateNormal];
    photoLibraryButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [photoPickerView addSubview:photoLibraryButton];
    
    [photoLibraryButton addTarget:self action:@selector(photoLibraryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *photoLibraryButtonSepLine = [[UIView alloc] initWithFrame:(CGRect){5,BOTTOM(photoLibraryButton)+1,WIDTH(photoPickerView)-5*2,0.5}];
    photoLibraryButtonSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.4);
    [photoPickerView addSubview:photoLibraryButtonSepLine];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:(CGRect){0,BOTTOM(photoLibraryButtonSepLine),WIDTH(photoPickerView),50}];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBColor(240, 20, 20) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [photoPickerView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(photoLibraryViewCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3f animations:^{
       photoPickerView.frame = (CGRect){0,HEIGHT(photoLibraryView)-PhotoPickerHeight,WIDTH(photoLibraryView),PhotoPickerHeight};
    }];
}


-(void)dismissPhotoLibraryPickerView{
    [photoLibraryView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)photoLibraryViewCancel{
    [self dismissPhotoLibraryPickerView];
    [self removeFromSuperview];
}

-(void)photoLibraryButtonClick:(UIButton *)button{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    
    [photoLibraryViewController presentViewController:picker animated:YES completion:nil];
    
}

-(void)photoCameraButtonClick:(UIButton *)button{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    
    [photoLibraryViewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [self dismissPhotoLibraryPickerView];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoLibraryChooseView:didFinishChoosingImage:)]) {
            [self.delegate photoLibraryChooseView:self didFinishChoosingImage:chosenImage];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

