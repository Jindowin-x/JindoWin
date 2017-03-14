//
//  PostSuggestViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/1.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "PostSuggestViewController.h"
#import "CTAssetsPickerController.h"
#import "UserLoginViewController.h"

#import "UNUrlConnection.h"
#import "UIImage+Resize.h"
#import "XYW8IndicatorView.h"

@interface PostSuggestViewController () <UITextViewDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>

@end

@implementation PostSuggestViewController{
    float everyButtonWidth;
    
    UIScrollView *contentView;
    
    UITextView *postSuggestPlaceholderTextFiled;
    UITextView *postSuggestTextFiled;
    NSMutableArray *uploadImageArray;
    UIView *cameraView;
    UIButton *addImageButton;
    
    XYW8IndicatorView *indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIView *textview = [[UIView alloc] init];
    textview.frame = (CGRect){0,10,WIDTH(contentView),200};
    textview.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:textview];
    
    postSuggestPlaceholderTextFiled = [[UITextView alloc] init];
    postSuggestPlaceholderTextFiled.backgroundColor = [UIColor whiteColor];
    postSuggestPlaceholderTextFiled.frame = (CGRect){10,0,(WIDTH(textview)-20),HEIGHT(textview)};
    postSuggestPlaceholderTextFiled.textColor = RGBColor(200, 200, 200);
    postSuggestPlaceholderTextFiled.font = Font(15);
    postSuggestPlaceholderTextFiled.keyboardType = UIKeyboardTypeDefault;
    postSuggestPlaceholderTextFiled.returnKeyType = UIReturnKeyNext;
    postSuggestPlaceholderTextFiled.text = @"请输入反馈,我们将不断为您改进";
    [postSuggestPlaceholderTextFiled setEditable:NO];
    postSuggestPlaceholderTextFiled.userInteractionEnabled = NO;
    postSuggestPlaceholderTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postSuggestPlaceholderTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [textview addSubview:postSuggestPlaceholderTextFiled];
    postSuggestPlaceholderTextFiled.hidden = NO;
    
    
    postSuggestTextFiled = [[UITextView alloc] init];
    postSuggestTextFiled.backgroundColor = [UIColor clearColor];
    postSuggestTextFiled.frame = (CGRect){10,0,(WIDTH(textview)-20),HEIGHT(textview)};
    postSuggestTextFiled.textColor = RGBColor(100, 100, 100);
    postSuggestTextFiled.font = Font(15);
    postSuggestTextFiled.tag = 19100;
    postSuggestTextFiled.delegate = self;
    postSuggestTextFiled.keyboardType = UIKeyboardTypeDefault;
    postSuggestTextFiled.returnKeyType = UIReturnKeyNext;
    postSuggestTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postSuggestTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [textview addSubview:postSuggestTextFiled];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,BOTTOM(textview),WIDTH(contentView),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [contentView addSubview:sepLine];
    
    cameraView = [[UIView alloc] init];
    cameraView.frame = (CGRect){0,BOTTOM(textview)+5,WIDTH(contentView),130};
    cameraView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:cameraView];
    
    everyButtonWidth = (WIDTH(cameraView)-10*2-8*2)/3;
    
    addImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addImageButton.tintColor = RGBColor(140, 140, 140);
    addImageButton.frame = (CGRect){10,10,everyButtonWidth,everyButtonWidth};
    addImageButton.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    addImageButton.layer.cornerRadius = 3.f;
    addImageButton.layer.borderWidth = 0.5;
    addImageButton.layer.masksToBounds = YES;
    [cameraView addSubview:addImageButton];
    
    [addImageButton setImage:[UIImage imageNamed:@"suggestion_addpic"] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(addImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addImageButtonClick{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)reloadImageSrollContainer:(NSArray *)array{
    [cameraView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj != addImageButton) {
            [obj removeFromSuperview];
        }
    }];
    for (int i = 0;i<array.count;i++) {
        int XAligh = i%3;
        int YAligh = i/3;
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = (CGRect){10+(everyButtonWidth+8)*XAligh,10+(everyButtonWidth+8)*YAligh,everyButtonWidth,everyButtonWidth};
        button.tag = i;
        [button addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cameraView addSubview:button];
        
        UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, everyButtonWidth, everyButtonWidth)];
        ALAsset *asset = array[i];
        postImageView.image = [[UIImage alloc] initWithCGImage:asset.thumbnail];
        [button addSubview:postImageView];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(everyButtonWidth-15, -10, 25, 25);
        [button addSubview:deleteButton];
        [deleteButton setImage:[UIImage imageNamed:@"imagedelete"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int XAligh = (int)(array.count%3);
    int YAligh = (int)(array.count/3);
    addImageButton.frame = (CGRect){10+(everyButtonWidth+8)*XAligh,10+(everyButtonWidth+8)*YAligh,everyButtonWidth,everyButtonWidth};
    
    CGRect rect = cameraView.frame;
    cameraView.frame = (CGRect){rect.origin.x,rect.origin.y,rect.size.width,10*2+BOTTOM(addImageButton)};
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(BOTTOM(cameraView), HEIGHT(contentView)+1)};
}

-(void)imageButtonClick:(UIButton *)button{
    ALAsset *asset = uploadImageArray[button.tag];
    if (asset) {
        [self checkImgInFullScreen:button withImgAsset:asset];
    }
}

-(void)deleteButtonClick:(UIButton *)buttn{
    [uploadImageArray removeObjectAtIndex:buttn.tag];
    
    [self reloadImageSrollContainer:uploadImageArray];
}

-(void)suggestionPost{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if (!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"请登录"];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:[UserLoginViewController new]];
        
        NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
        [loginNavi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
        
        if ([loginNavi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
            NSArray *list = loginNavi.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *ar = imageView.subviews;
                    [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                    imageView.hidden=YES;
                }
            }
        }
        loginNavi.view.backgroundColor = UN_RedColor;
        loginNavi.navigationBar.barTintColor = UN_RedColor;
        loginNavi.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:loginNavi animated:YES completion:nil];
        return;
    }
    NSString *suggestionContent = postSuggestTextFiled.text;
    if (!suggestionContent || [[suggestionContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"要提交的内容不能为空"];
        return;
    }
    if (![self checkString:suggestionContent]) {
        [BYToastView showToastWithMessage:@"要提交的内容不能包含特殊字符"];
        return;
    }
    
    
    
    [self resetUploadStatus];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    [self uploadSuggestionAssets:uploadImageArray];
}

-(void)resetUploadStatus{
    uploadImagesStart = YES;
    uploadImagesRemainCount = 0;
    uploadImagesTotalCount = 0;
    uploadImagesCurrentIndex = 0;
    uploadResultArray = nil;
}

static bool uploadImagesStart = YES;
static int uploadImagesRemainCount = 0;
static int uploadImagesTotalCount = 0;
static int uploadImagesCurrentIndex = 0;
static NSMutableArray *uploadResultArray;
-(void)uploadSuggestionAssets:(NSArray *)array{
    if (!uploadImageArray || uploadImageArray.count == 0) {
        [self uploadSuggestionToServerWithImagesUrlArray:nil];
    }else{
        if (uploadImagesStart) {
            uploadImagesRemainCount = (int)array.count;
            uploadImagesTotalCount = uploadImagesRemainCount;
            uploadImagesCurrentIndex = 0;
            uploadImagesStart = NO;
            uploadResultArray = [NSMutableArray array];
            [self uploadSuggestionAssets:array];
        }else{
            indicatorView.loadingLabel.text = [NSString stringWithFormat:@"正在上传第 %d/%d 张图片",uploadImagesCurrentIndex+1,uploadImagesTotalCount];
            double uploadstart = [[NSDate date] timeIntervalSince1970];
            
            ALAsset *asset = uploadImageArray[uploadImagesCurrentIndex];
            [self uploadSuggestionAsset:asset finish:^(NSString *imageUrl) {
                double uploadend = [[NSDate date] timeIntervalSince1970];
                float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (imageUrl) {
                        [uploadResultArray addObject:imageUrl];
                        NSLog(@"%@",imageUrl);
                        uploadImagesRemainCount --;
                        uploadImagesCurrentIndex++;
                        if (uploadImagesRemainCount == 0) {
                            [self uploadSuggestionToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray]];
                            return;
                        }else{
                            [self uploadSuggestionAssets:array];
                        }
                    }else{
                        [indicatorView stopAnimating:YES];
                        [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                        [self resetUploadStatus];
                    }
                });
            }];
        }
    }
}

-(void)uploadSuggestionToServerWithImagesUrlArray:(NSArray *)array{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if (!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"请登录"];
        [indicatorView stopAnimating:YES];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:[UserLoginViewController new]];
        
        NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
        [loginNavi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
        
        if ([loginNavi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
            NSArray *list = loginNavi.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *ar = imageView.subviews;
                    [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                    imageView.hidden=YES;
                }
            }
        }
        loginNavi.view.backgroundColor = UN_RedColor;
        loginNavi.navigationBar.barTintColor = UN_RedColor;
        loginNavi.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:loginNavi animated:YES completion:nil];
        return;
    }
    NSString *suggestionContent = postSuggestTextFiled.text;
    if (!suggestionContent || [[suggestionContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [indicatorView stopAnimating:YES];
        [BYToastView showToastWithMessage:@"要提交的内容不能为空"];
        return;
    }
    if (![self checkString:suggestionContent]) {
        [indicatorView stopAnimating:YES];
        [BYToastView showToastWithMessage:@"要提交的内容不能包含特殊字符"];
        return;
    }
    indicatorView.loadingLabel.text = @"正在上传您的反馈";
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:suggestionContent forKey:@"content"];
    if (array && array.count != 0) {
        for (int i = 0; i < array.count; i++) {
            [paramsDic setObject:array[i] forKey:[NSString stringWithFormat:@"imgs[%d].source",i]];
        }
    }
    
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    [UNUrlConnection suggestionPostWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                NSDictionary *messDic = resultDic[@"message"];
                NSString *typeString = messDic[@"type"];
                if (typeString && [typeString isEqualToString:@"success"]) {
                    [BYToastView showToastWithMessage:@"发送成功,感谢您的支持"];
                }else{
                    [BYToastView showToastWithMessage:@"发送失败,请稍候重试"];
                }
            }
        });
    }];
}

-(void)uploadSuggestionAsset:(ALAsset *)asset finish:(void (^)(NSString *imageUrl))finish{
    if (asset) {
        UIImage *uploadImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        UIImage *reszieImage = [PostSuggestViewController fixImageOrientationWithimage:uploadImage orientation:(ALAssetOrientation)[[asset valueForProperty:ALAssetPropertyOrientation] intValue]];
        reszieImage = [reszieImage resizeImageGreaterThan:1280];
        [UNUrlConnection suggestionPostImage:reszieImage finish:^(NSString *imageUrl, NSString *errorString) {
            if (imageUrl) {
                finish(imageUrl);
            }else{
                finish(nil);
            }
        }];
    }
}

+(UIImage *)fixImageOrientationWithimage:(UIImage *)img orientation:(ALAssetOrientation)imageOrientation{
    
    UIImageOrientation orient = (int)imageOrientation;
    
    CGImageRef imgRef = img.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
    
}

-(BOOL)checkString:(NSString *)string{
    if ([string rangeOfString:@"*"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"&"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"="].length != 0) {
        return NO;
    }
    return YES;
}

static CGRect rectInFullScreen;
-(void)checkImgInFullScreen:(UIView*)view withImgAsset:(ALAsset*)asset{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgColorView.alpha = 0.f;
    bgColorView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    bgColorView.tag = 7978;
    [keyWindow addSubview:bgColorView];
    
    UIScrollView *fullscreenBottomView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullscreenBottomView.contentSize = CGSizeMake(WIDTH(fullscreenBottomView), HEIGHT(fullscreenBottomView));
    fullscreenBottomView.backgroundColor = [UIColor clearColor];
    fullscreenBottomView.minimumZoomScale = 0.3f;
    fullscreenBottomView.maximumZoomScale = 3.f;
    fullscreenBottomView.contentMode = UIViewContentModeCenter;
    fullscreenBottomView.bounces = YES;
    fullscreenBottomView.bouncesZoom = YES;
    fullscreenBottomView.showsHorizontalScrollIndicator = NO;
    fullscreenBottomView.showsVerticalScrollIndicator = NO;
    fullscreenBottomView.delegate = self;
    fullscreenBottomView.tag = 9797;
    [keyWindow addSubview:fullscreenBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCheckImgView)];
    [fullscreenBottomView addGestureRecognizer:tap];
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    rectInFullScreen = [view convertRect:view.frame toView:window];
    UIImageView *imgViewIsShowing = [[UIImageView alloc] initWithFrame:rectInFullScreen];
    
    UIImage *imgToShow = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    imgViewIsShowing.image = imgToShow;
    imgViewIsShowing.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIsShowing.tag = 1001;
    [fullscreenBottomView addSubview:imgViewIsShowing];
    
    [UIView animateWithDuration:0.3f animations:^{
        imgViewIsShowing.frame = fullscreenBottomView.bounds;
        bgColorView.alpha = 1.f;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (scale<1.f) {
        [scrollView setZoomScale:1.f animated:YES];
        if (scale<0.7f)
            [self exitCheckImgView];
    }
}

-(void)exitCheckImgView{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    if (viewScroll) {
        if (viewScroll.zoomScale > 1.f) {
            [viewScroll setZoomScale:1.f animated:YES];
            [self performSelector:@selector(exitCheckBigImgView) withObject:nil afterDelay:0.5f];
        }else{
            [self exitCheckBigImgView];
        }
    }
}

-(void)exitCheckBigImgView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *viewBg = [keyWindow viewWithTag:7978];
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView*)[viewScroll.subviews firstObject]).frame = rectInFullScreen;
        viewScroll.alpha = 0.f;
        viewBg.alpha = 0.f;
    }completion:^(BOOL finished) {
        [viewScroll removeFromSuperview];
        [viewBg removeFromSuperview];
    }];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *subView = (UIImageView*)[scrollView viewWithTag:1001];
    return subView;
}

#pragma mark - CTAssetsPickerControllerDelegate
-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (!uploadImageArray){
        uploadImageArray = [NSMutableArray array];
    }
    [uploadImageArray addObjectsFromArray:assets];
    [self reloadImageSrollContainer:uploadImageArray];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 19100) {
        if (![text isEqualToString:@""]){
            postSuggestPlaceholderTextFiled.hidden = YES;
        }
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
            postSuggestPlaceholderTextFiled.hidden = NO;
        }
    }
    return YES;
}

-(void)setUpNavigation{
    
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,30,20};
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(15);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    [self suggestionPost];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
