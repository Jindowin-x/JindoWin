//
//  AppDelegate.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AppDelegate.h"

#import "UNNavigationController.h"
#import "ViewController.h"

#import "BYToastView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"

//test
#import "UNUrlConnection.h"



@interface AppDelegate () <BMKGeneralDelegate>

@property (nonatomic,strong) ViewController *vc;

@end

@implementation AppDelegate{
    BMKMapManager* mapManager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    //    AC3GZpvDiQurAwGjIOjINH1sTiaQcwRV -- com.union.UnionHoc
    //    ri7Oyhi7VeRVGZpBA044YE3FCKhcEP4F -- com.union.Union
    
    BOOL ret = [mapManager start:@"AC3GZpvDiQurAwGjIOjINH1sTiaQcwRV"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    /**
     *  注册微信权限
     */
    [WXApi registerApp:@"wxf211b52729d06b91"];
    
    [UNUserDefaults setIsLogin:NO];
    [UNUrlConnection autoLoginComplete:^(bool success) {
        [UNUserDefaults setIsLogin:success];
    }];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:UN_Navigation_FontColor,NSFontAttributeName:Font(18)};
    
    self.vc = [ViewController new];
    
    UNNavigationController *navi = [[UNNavigationController alloc] initWithRootViewController:self.vc];
    
    [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    if ([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = navi.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *ar = imageView.subviews;
                [ar makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
                imageView.hidden=YES;
            }
        }
    }
    navi.view.backgroundColor = UN_RedColor;
    navi.navigationBar.barTintColor = UN_RedColor;
    navi.navigationBar.barStyle = UIBarStyleBlack;
    
    navi.delegate = self;
    
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    return YES;
}


//-(UIUserNotificationType)getCurrentRemoteNotifications{
//    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
//        return [[UIApplication sharedApplication] currentUserNotificationSettings].types;
//    }else{
//        return UIUserNotificationTypeNone;
//    }
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.vc) {
        [self.vc updateCurrentNavigation];
    }else{
        [self.vc updateOtherNavigation];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [BMKMapView didForeGround];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    //    BMKErrorOk = 0,	///< 正确，无错误
    //    BMKErrorConnect = 2,	///< 网络连接错误
    //    BMKErrorData = 3,	///< 数据错误
    //    BMKErrorRouteAddr = 4, ///<起点或终点选择(有歧义)
    //    BMKErrorResultNotFound = 100,	///< 搜索结果未找到
    //    BMKErrorLocationFailed = 200,	///< 定位失败
    //    BMKErrorPermissionCheckFailure = 300,	///< 百度地图API授权Key验证失败
    //    BMKErrorParse = 310		///< 数据解析失败
    
    NSString *messageString;
    switch (iError) {
        case BMKErrorConnect:
            messageString = @"网络连接错误";
            break;
        case BMKErrorData:
            messageString = @"服务器数据错误";
            break;
        case BMKErrorRouteAddr:
            messageString = @"起点或终点选择有歧义";
            break;
        case BMKErrorResultNotFound:
            messageString = @"未找到搜索结果";
            break;
        case BMKErrorLocationFailed:
            messageString = @"定位失败";
            break;
        case BMKErrorPermissionCheckFailure:
            messageString = @"授权失败";
            break;
        case BMKErrorParse:
            messageString = @"地图数据解析失败";
            break;
        default:
            break;
    }
    if (messageString) {
        [BYToastView showToastWithMessage:messageString];
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    //    E_PERMISSIONCHECK_CONNECT_ERROR = -300,//链接服务器错误
    //    E_PERMISSIONCHECK_DATA_ERROR = -200,//服务返回数据异常
    //    E_PERMISSIONCHECK_OK = 0,	// 授权验证通过
    //    E_PERMISSIONCHECK_KEY_ERROR = 101,	//ak不存在
    //    E_PERMISSIONCHECK_MCODE_ERROR = 102,	//mcode签名值不正确
    //    E_PERMISSIONCHECK_UID_KEY_ERROR = 200,	// APP不存在，AK有误请检查再重试
    //    E_PERMISSIONCHECK_KEY_FORBIDEN= 201,	// APP被用户自己禁用，请在控制台解禁
    
    NSString *messageString;
    switch (iError) {
        case E_PERMISSIONCHECK_CONNECT_ERROR:
            messageString = @"链接服务器错误";
            break;
        case E_PERMISSIONCHECK_DATA_ERROR:
            messageString = @"服务返回数据异常";
            break;
        case E_PERMISSIONCHECK_KEY_ERROR:
            messageString = @"授权验证码不存在";
            break;
        case E_PERMISSIONCHECK_MCODE_ERROR:
            messageString = @"签名不正确";
            break;
        case E_PERMISSIONCHECK_UID_KEY_ERROR:
            messageString = @"APP不存在，AK有误请检查再重试";
            break;
        case E_PERMISSIONCHECK_KEY_FORBIDEN:
            messageString = @"APP被禁用，请在控制台解禁";
            break;
        default:
            break;
    }
    if (messageString) {
        [BYToastView showToastWithMessage:messageString];
    }
}

/**
 *  打开外部程序回调
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"1");
    NSLog(@"%@",url);
    if ([url.absoluteString rangeOfString:Alipay_AppSchema].length != 0) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAliPayCallBackWithResult:resultDic];
        }];
    }else{
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"2");
    NSLog(@"%@  %@",url,sourceApplication);
    if ([url.absoluteString rangeOfString:Alipay_AppSchema].length != 0) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAliPayCallBackWithResult:resultDic];
        }];
    }else{
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"3");
    NSLog(@"%@  %@",url,options);
    if ([url.absoluteString rangeOfString:@"safepay"].length != 0) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAliPayCallBackWithResult:resultDic];
        }];
    }else{
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

-(void)handleAliPayCallBackWithResult:(NSDictionary *)resultDic{
    NSLog(@"result = %@",resultDic);
    if (!resultDic) {
        return;
    }
    int resultStatus = [resultDic[@"resultStatus"] intValue];
    if (resultStatus == 9000) {
        //调用改变状态接口
        NSString *orderString = resultDic[@"result"];
        
        //    NSString *orderString = @"partner=\"2088121625250897\"&seller_id=\"2088121625250897\"\"&body=\"&total_fee=\"0.01\"&notify_url=\"http://42.96.177.233:8082/shopSales/web/payment/notify/async/2016059499.jhtml\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&success=\"true\"&sign_type=\"RSA\"&sign=\"bPWnC3jqcvsLc1w9Z0jwpwSXfe1YbrvaJsfYcTFZQecFaZeNImWLSFT3RvpyGCMi+IRZ0hwQkNAYEO5hSo9RTsM3NjE+vsdwUE2mvJFw5dbVopVpCjNttA3bRRwXM0ncZO+Hl7zZOfyvOUQQPnrPO+z5EK4mx93411vtc1Dy6Lk=\"";
        
        NSScanner *htmlScanner = [NSScanner scannerWithString:orderString];
        NSString *url = nil;
        [htmlScanner scanUpToString:@"&notify_url=\"" intoString:NULL];
        [htmlScanner scanUpToString:@"\"&" intoString:&url];
        url = [url stringByReplacingOccurrencesOfString:@"&notify_url=\"" withString:@""];
        if (!url) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UN_OrderDidSendToPayClientBackNotification object:@(NO)];
        }else{
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError || !data) {
                    //失败 跳转
                    [[NSNotificationCenter defaultCenter] postNotificationName:UN_OrderDidSendToPayClientBackNotification object:@(NO)];
                    return;
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:UN_OrderDidSendToPayClientBackNotification object:@(YES)];
                }
            }];
        }
    }else if(resultStatus == 6001){
        [BYToastView showToastWithMessage:@"取消支付"];
        //回到订单列表
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_OrderDidSendToPayClientBackNotification object:@(NO)];
    }else{
        [BYToastView showToastWithMessage:@"支付失败"];
        //回到订单页
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_OrderDidSendToPayClientBackNotification object:@(NO)];
    }
}

@end
