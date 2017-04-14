//
//  UNUrlConnection.m
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "UNUrlConnection.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"
#import "DataSigner.h"

@implementation UNUrlConnection

static NSString *ServerAddress = @"120.27.115.125";
//http://42.96.177.233:8082/shopSales/
static NSString *baseUrl = @"http://120.27.115.125/";

static AFHTTPResponseSerializer *responseSerializer;

#pragma mark 验证相关
//验证手机号码是否冲突
+(void)judgeUserPhoneUsefulWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!phone || [phone isEqualToString:@""]) {
        complete(nil,@"电话号码不能为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/check_phone.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:phone forKey:@"mobile"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

//获得验证码
+(void)getEntryCodeWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/code.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:phone forKey:@"phone"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

///app/member/reg_submit.jhtml   注册接口
+(void)registUser:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/reg_submit.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:userPhone forKey:@"phone"];
    [paramsDic setObject:password forKey:@"pass"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

//忘记密码接口
+(void)forgetPassword:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/forgetPass.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:userPhone forKey:@"phone"];
    [paramsDic setObject:password forKey:@"newPass"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}


//app/member/login.jhtml  登录接口
+(void)loginUserName:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/login.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:userPhone forKey:@"phone"];
    [paramsDic setObject:password forKey:@"pass"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

//自动登录
+(void)autoLoginComplete:(void (^)(bool success))complete{
    NSString *loginString = [UNUserDefaults getUserPhone];
    NSString *password = [UNUserDefaults getUserPassword];
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    
    if (!loginString) {
        complete(NO);
        return;
    }else{
        if(!password || !token || !uid || [password isEqualToString:@""] || [token isEqualToString:@""] || [uid isEqualToString:@""]){
            complete(NO);
            return;
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/check_current_password.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:password forKey:@"currentPass"];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        /*
         -1：用户验证失败
         0：提交的密码正确
         1：uid参数错误
         2：currentPass错误
         */
        if (errorString) {
            NSLog(@"%@",errorString);
        }else{
            int result = [[resultDic objectForKey:@"result"] intValue];
            if (result == 0) {
                complete(YES);
            }else if (result == -1){
                complete(NO);
                NSLog(@"用户验证失败");
            }else if (result == 1){
                complete(NO);
                NSLog(@"uid参数错误");
            }else if (result == 2){
                complete(NO);
                NSLog(@"密码错误");
            }else{
                complete(NO);
            }
        }
    }];
}

//获取用户头像
+(void)getUserHeadImageComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/getHeadPic.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:token forKey:@"token"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)changePasswordWithOldPass:(NSString *)oldPass newPass:(NSString *)newPass complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!oldPass) {
        complete(nil,@"原密码不能为空");return;
    }
    if (!newPass) {
        complete(nil,@"要修改的密码不能为空");return;
    }
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/update_current_password.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [paramsDic setObject:oldPass forKey:@"currentPass"];
    [paramsDic setObject:newPass forKey:@"newPass"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}


#pragma mark 首页轮播图
+(void)getMainViewCarouselComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/ad/get.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

#pragma mark 商铺相关
+(void)getMainPageTotalGategoryComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/category/tree.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

+(void)getMainPageRecomandShopsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/chief.jhtml"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@([UNUserDefaults getMainAddressLatitude]) forKey:@"latitude"];
    [paramsDic setObject:@([UNUserDefaults getMainAddressLongitude]) forKey:@"longitude"];
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(token && uid && ![token isEqualToString:@""] && ![uid isEqualToString:@""]){
        [paramsDic setObject:uid forKey:@"uid"];
        [paramsDic setObject:token forKey:@"token"];
    }
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

+(void)getShopsWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/query.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)getShopInfoDetailWithShopID:(NSString *)shopid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!shopid) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/get.jhtml"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:shopid forKey:@"brand_id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getShopItemsDetailWithShopID:(NSString *)shopid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!shopid) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brandCategory/get.jhtml"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:shopid forKey:@"brand_id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getItemDetailWithItemID:(NSString *)itemid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!itemid) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/product/detail.jhtml"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:itemid forKey:@"product_id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getShopJudgeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/appraise/get.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)submitJudgeWithShopID:(NSString *)shopid judgeContent:(NSString *)content score:(float)score complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!shopid) {
        complete(nil, @"id为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/appraise/submit.jhtml"];
    
    if (!content) {
        content = @"默认评价";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    [params setObject:shopid forKey:@"brand_id"];
    [params setObject:content forKey:@"content"];
    [params setObject:@(score) forKey:@"score"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)addCollectionShopWithShopID:(NSString *)shopid Complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!shopid) {
        complete(nil, @"shopid不能为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/favorite/add.jhtml"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    [params setObject:shopid forKey:@"brand_id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)deleteCollectionShopWithShopID:(NSString *)shopid Complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!shopid) {
        complete(nil, @"shopid不能为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/favorite/delete.jhtml"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    [params setObject:shopid forKey:@"brand_id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)getAllCollectionWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/favorite/list.jhtml"];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取店铺是否被用户收藏
+(void)getIsShopCollectWithShopID:(NSString *)shopID complete:(void (^)(BOOL isCollect))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(NO);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/favorite/check.jhtml"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    [params setObject:shopID forKey:@"brand_id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            complete(NO);
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            int resultCollect = [resultDic[@"content"][@"result"] intValue];
            if (resultCollect == 0) {
                complete(YES);
            }else{
                complete(NO);
            }
            return;
        }
        complete(NO);
        return;
    }];
}

+(AFHTTPRequestOperation *)searchShopsWithParmas:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/query.jhtml"];
    
    return [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)getAllHotSearchKeywordsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/hotsearch.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}



/**
 *  订单相关
 */
#pragma mark 订单相关
+(void)addToOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/cart/add.jhtml"];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)reCalcOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/calculate.jhtml"];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)submitOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/create.jhtml"];
    
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

+(void)getAllOrderWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/list.jhtml"];
    
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:token forKey:@"token"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)cancelOrderWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!orderSN) {
        complete(nil, @"订单编号不能为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/cancel.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:orderSN forKey:@"sn"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getOrderPaymentInfoWithOrderSN:(NSString *)orderSN orderPayType:(OrderPaymentType)type complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (type == OrderPaymentTypeNone) {
        complete(nil,@"未知的支付类型");
        return;
    }
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!orderSN) {
        complete(nil, @"订单编号不能为空");
        return;
    }
    
    NSString *paymentTypeString;
    if (type == OrderPaymentTypeAli) {
        paymentTypeString = @"alipayDirectPlugin";
    }else if (type == OrderPaymentTypeWechat){
        paymentTypeString = @"wxpayPlugin";
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:orderSN forKey:@"sn"];
    [paramsDic setObject:paymentTypeString forKey:@"paymentPluginId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/view.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getOrderDetailWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!orderSN) {
        complete(nil, @"订单编号不能为空");
        return;
    }
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:orderSN forKey:@"sn"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/queryOrderDetailbyPaymentSN.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

//模拟支付接口
+(void)orderPayWithPayTradeSN:(NSString *)tradeSN complete:(void (^)(NSString *stateString))complete{
    NSString *payUrl = [NSString stringWithFormat:@"http://%@/shopxx/app/order/notify/async/tradeSN.jhtml",ServerAddress];
    if (!tradeSN) {
        complete(@"收款编号不能为空");
        return;
    }
    NSString *url = [payUrl stringByReplacingOccurrencesOfString:@"localhost:8080" withString:ServerAddress];
    
    url = [url stringByReplacingOccurrencesOfString:@"tradeSN" withString:tradeSN];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse * response, NSError * error) {
        if (error) {
            complete(@"支付失败,网络错误");
            return;
        }
        
        NSError *err;
        NSDictionary *notifyDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if (err || !notifyDic) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (string && [string isEqualToString:@"success"]) {
                complete(@"支付成功");
                return;
            }
            complete(@"支付失败");
        }else{
            NSString *state = notifyDic[@"notifyMessage"];
            state = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (state && [state isEqualToString:@"success"]) {
                complete(@"支付成功");
                return;
            }
            complete(@"支付失败");
        }
    }] resume];
}

+(void)orderRefundWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    if (!orderSN) {
        complete(nil, @"订单编号不能为空");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/order/applyrefunds.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:orderSN forKey:@"sn"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)orderSueWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/complain/submit.jhtml"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}







#pragma mark 收货地址
+(void)getAllReceiverListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/receiver/list.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)addReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/receiver/save.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [paramsDic setObject:addressInfo.name forKey:@"consignee"];
    [paramsDic setObject:addressInfo.sex==0?@"male":@"female" forKey:@"sex"];
    
    [paramsDic setObject:addressInfo.mapAdress forKey:@"areaName"];
    [paramsDic setObject:addressInfo.detailAdress forKey:@"address"];
    [paramsDic setObject:addressInfo.phone forKey:@"phone"];
    [paramsDic setObject:[NSString stringWithFormat:@"%.6f",addressInfo.mapLongitude] forKey:@"longitude"];
    [paramsDic setObject:[NSString stringWithFormat:@"%.6f",addressInfo.mapLatitude] forKey:@"latitude"];
    [paramsDic setObject:@(addressInfo.isDefault) forKey:@"isDefault"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)editReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    //
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/receiver/edit.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [paramsDic setObject:addressInfo.addressID forKey:@"id"];
    [paramsDic setObject:addressInfo.name forKey:@"consignee"];
    [paramsDic setObject:addressInfo.sex==0?@"male":@"female" forKey:@"sex"];
    [paramsDic setObject:addressInfo.mapAdress forKey:@"areaName"];
    [paramsDic setObject:addressInfo.detailAdress forKey:@"address"];
    [paramsDic setObject:addressInfo.phone forKey:@"phone"];
    [paramsDic setObject:@(addressInfo.mapLongitude) forKey:@"longitude"];
    [paramsDic setObject:@(addressInfo.mapLatitude) forKey:@"latitude"];
    [paramsDic setObject:@(addressInfo.isDefault) forKey:@"isDefault"];
    NSLog(@"%@",[paramsDic objectForKey:@"sex"]);
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)deleteReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    //
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/receiver/delete.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [paramsDic setObject:addressInfo.addressID forKey:@"id"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

#pragma mark 优惠券
+(void)getAllUnusedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/coupon_code/list.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@(0) forKey:@"type"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getAllUsedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/coupon_code/list.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@(1) forKey:@"type"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)getAllExpiredVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/coupon_code/list.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@(2) forKey:@"type"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(void)addVoucherWithCode:(NSString *)code comlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (!code) {
        complete(nil, @"代金券号码不能为空");
        return;
    }
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/coupon_code/add.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:code forKey:@"code"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}


#pragma mark 我的余额 充值 提现接口
//获取我的余额
+(void)getAllMyCashWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/deposit/list.jhtml"];
    
    [params setObject:token forKey:@"token"];
    [params setObject:uid forKey:@"uid"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//充值
+(void)chargeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/deposit/recharge.jhtml"];
    
    [params setObject:token forKey:@"token"];
    [params setObject:uid forKey:@"uid"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//提现
+(void)withDrawWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/deposit/withdraw.jhtml"];
    
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

#pragma mark 我的所有退款
+(void)getAllMyRefundWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    [params setObject:token forKey:@"token"];
    [params setObject:uid forKey:@"uid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/refunds/list.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 我的所有评价
+(void)getAllMyJudgeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    [params setObject:token forKey:@"token"];
    [params setObject:uid forKey:@"uid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/appraise/member.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 所有通知
+(void)getAllMyNotificationWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/notice/list.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 所有问答
+ (void)getQAComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete {
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    if (token && uid) {
        [paramsDic setObject:token forKey:@"token"];
        [paramsDic setObject:uid forKey:@"uid"];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/faq/list.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

#pragma mark 获取服务协议
+(void)getServiceApprovementComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/term/get.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@"fwtl" forKey:@"type"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

#pragma mark 获取关于我们
+(void)getAboutUsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/term/get.jhtml"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@"gywm" forKey:@"type"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

#pragma mark 意见反馈
+(void)suggestionPostWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/feedback/submit.jhtml"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 添加商铺
+(void)addShopPostWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/apply.jhtml"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 获得所有已经入驻的商家
+(void)getAllAskShopsWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/brand/launched.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


#pragma mark 生活助手相关
//生活助手分类名称
+(void)getAllLifeCategroyComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/lifeCategory/tree.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//生活助手分类信息列表
+(void)getLifeCategroyListWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(token && uid){
        [paramsDic setObject:token forKey:@"token"];
        [paramsDic setObject:uid forKey:@"uid"];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/life/list.jhtml"];
    
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

//获取我发布的信息
+(void)getAllMyLifeHelperInfoWithIndex:(int)index complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(index) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/life/list.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//增加生活助手的信息
+(void)uploadLifeHelperWithParams:(NSMutableDictionary *)pramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    [pramsDic setObject:token forKey:@"token"];
    [pramsDic setObject:uid forKey:@"uid"];
    [pramsDic setObject:@1 forKey:@"isView"];
    NSLog(@"增加生活助手的信息 %@",pramsDic);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/life/add.jhtml"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:pramsDic complete:complete];
}

//更新生活助手的信息
+(void)updateLifeHelperWithParams:(NSMutableDictionary *)pramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    [pramsDic setObject:token forKey:@"token"];
    [pramsDic setObject:uid forKey:@"uid"];
    NSLog(@"更新生活助手的信息 %@",pramsDic);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/life/update.jhtml"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:pramsDic complete:complete];
}

//删除生活助手的信息
+(void)deleteLifeHelperWithID:(NSString *)lid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    
    [paramsDic setObject:lid forKey:@"life_id"];
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/life/delete.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}




//获取城市列表相关信息
+(void)getAreaListWithID:(long)longID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (longID != -1) {
        [params setObject:@(longID) forKey:@"parentId"];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/area/get.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark - 支付相关
//微信预支付接口
+(void)wechatPrePayWithMoneyFen:(float)moneyNum orderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *token = [UNUserDefaults getUserToken];
    NSString *uid = [UNUserDefaults getUserID];
    if(!token || !uid || [token isEqualToString:@""] || [uid isEqualToString:@""]){
        complete(nil, @"未登录");
        return;
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    
    [paramsDic setObject:token forKey:@"token"];
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:@(moneyNum) forKey:@"money"];
    [paramsDic setObject:orderSN forKey:@"sn"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,@"app/payment/prePay.jhtml"];
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:paramsDic complete:complete];
}

+(BOOL)alipayPayWithMoneyYuan:(float)moneyYuan orderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *result))complete{
    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = Alipay_ParterID;
    order.sellerID = Alipay_SellerID;
    NSString *tradesn = orderSN;
    order.outTradeNO = tradesn; //订单ID（由商家自行制定）
    order.subject = [NSString stringWithFormat:@"订单:%@",tradesn]; //商品标题
    order.body = @"外卖支付宝支付"; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL = [self getPayNotifyURL:tradesn]; //回调URL
    
    order.service = Alipay_Service;
    order.paymentType = Alipay_PaymentType;
    order.inputCharset = Alipay_InputCharset;
    
    NSString *appScheme = Alipay_AppSchema;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(Alipay_PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /**
             这里的回调有能不发生  因为在调用支付宝支付的时候,有可能会打开支付宝的客户端这时候回调不会发生 会通过
             application的方法
             
             - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url (9.0以前)
             - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation(9.0以前)
             
             //9.0以后
             - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
             
             这几个方法去处理回调信息
             */
            NSLog(@"alipay callback:%@",resultDic);
            complete(resultDic);
        }];
        return YES;
    }
    return NO;
}

+(void)paySuccessWithUrl:(NSString *)urlString complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    [self loadGetAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//get
+(AFHTTPRequestOperation *)loadGetAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    ShowNetworkActivityIndicator();
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    if (responseSerializer != nil) {
        manager.responseSerializer = responseSerializer;
    }
    manager.requestSerializer.timeoutInterval = 10.f;
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    manager.requestSerializer.stringEncoding = enc;
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        responseSerializer = operation.responseSerializer;
        HideNetworkActivityIndicator();
        NSError *error;
        if (error) {
            complete(nil,@"服务器错误");
        }else{
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    complete((NSDictionary *)responseObject,nil);
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                    if (!dic) {
                        NSLog(@"返回的结果不是json :%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                        complete(nil,@"服务器错误");
                    }else{
                        complete(dic,nil);
                    }
                }
            }else{
                NSLog(@"服务器无返回值");
                complete(nil,@"服务器错误");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HideNetworkActivityIndicator();
        complete(nil,@"服务器无响应");
        NSLog(@"error %@",error);
    }];
    return operation;
}


+(AFHTTPRequestOperation *)loadPostAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    ShowNetworkActivityIndicator();
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    if (responseSerializer != nil) {
        manager.responseSerializer = responseSerializer;
    }
    manager.requestSerializer.timeoutInterval = 10.f;
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    manager.requestSerializer.stringEncoding = enc;
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        responseSerializer = operation.responseSerializer;
        HideNetworkActivityIndicator();
        NSError *error;
        if (error) {
            complete(nil,@"服务器错误");
        }else{
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    complete((NSDictionary *)responseObject,nil);
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                    if (!dic) {
                        NSLog(@"返回的结果不是json :%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                        complete(nil,@"服务器错误");
                    }else{
                        complete(dic,nil);
                    }
                }
            }else{
                NSLog(@"服务器无返回值");
                complete(nil,@"服务器错误");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HideNetworkActivityIndicator();
        complete(nil,@"服务器无响应");
    }];
    return operation;
}


#pragma mark - 图片上传相关
//上传用户头像
+(void)uploadUserHeadImage:(UIImage *)headImage finish:(void (^)(NSString *imageUrl,NSString *errorString))finish{
    if (!headImage) {
        NSLog(@"错误:上传的图片不能为nil");
        return;
    }
    NSData *imageData = UIImagePNGRepresentation(headImage);
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",baseUrl,@"app/member/headPic.jhtml"];
    
    NSDictionary *params = @{@"uid":[UNUserDefaults getUserID],@"token":[UNUserDefaults getUserToken]};
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",UUID()] mimeType:@"image/jpg"];
    } error:nil];
    request.timeoutInterval = 60.f;
    
    ShowNetworkActivityIndicator();
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer * s = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = s;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        HideNetworkActivityIndicator();
        if (!error) {
            if (responseObject) {
                NSError *error2;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error2];
                if (responseDictionary && responseDictionary.count != 0) {
                    if (responseDictionary && responseDictionary.count != 0) {
                        NSString *url = responseDictionary[@"url"];
                        if (url) {
                            url = [self replaceUrl:url];
                            finish(url,nil);
                            return;
                        }else{
                            finish(nil,@"头像上传失败");
                        }
                    }
                }
            }
        }
        finish(nil,@"头像上传失败,服务器错误");
    }];
    [uploadTask resume];
}

+(void)suggestionPostImage:(UIImage *)postImage finish:(void (^)(NSString *imageUrl,NSString *errorString))finish{
    if (!postImage) {
        NSLog(@"错误:上传的图片不能为nil");
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(postImage, 0.8);
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",baseUrl,@"app/file/upload.jhtml"];
    
    NSDictionary *params = @{@"uid":[UNUserDefaults getUserID],@"token":[UNUserDefaults getUserToken],@"fileType":@"image"};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",UUID()] mimeType:@"image/jpg"];
    } error:nil];
    request.timeoutInterval = 120.f;
    
    ShowNetworkActivityIndicator();
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer * s = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = s;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        HideNetworkActivityIndicator();
        if (!error) {
            if (responseObject) {
                NSError *error2;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error2];
                if (responseDictionary && responseDictionary.count != 0) {
                    NSString *url = responseDictionary[@"url"];
                    if (url) {
                        finish(url,nil);
                        return;
                    }else{
                        finish(nil,@"图片上传失败");
                        return;
                    }
                }
            }
        }
        finish(nil,@"图片上传失败,服务器错误");
    }];
    [uploadTask resume];
}

+(NSString *)replaceUrl:(NSString *)url{
    if (!url || [url isKindOfClass:[NSNull class]]) {
        return nil;
    }
    url = [url stringByReplacingOccurrencesOfString:@"localhost:8080" withString:ServerAddress];
    return url;
}

+(NSString *)getPayNotifyURL:(NSString *)orderSN{
    return [NSString stringWithFormat:@"%@web/payment/notify/async/%@.jhtml",baseUrl,orderSN];
}

@end
