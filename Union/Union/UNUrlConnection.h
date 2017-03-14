//
//  UNUrlConnection.h
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

@interface UNUrlConnection : NSObject

//验证手机号码是否有效
+(void)judgeUserPhoneUsefulWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取验证码接口
+(void)getEntryCodeWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//用户注册
+(void)registUser:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//忘记密码
+(void)forgetPassword:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//用户登录
+(void)loginUserName:(NSString *)userPhone password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//自动登录
+(void)autoLoginComplete:(void (^)(bool success))complete;
//获取用户头像
+(void)getUserHeadImageComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//修改密码
+(void)changePasswordWithOldPass:(NSString *)oldPass newPass:(NSString *)newPass complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//首页轮播图
+(void)getMainViewCarouselComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取首页分类
+(void)getMainPageTotalGategoryComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取首页推荐商家
+(void)getMainPageRecomandShopsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取首界面 商铺的分类列表和相关筛选的列表
+(void)getShopsWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取商铺的详细信息
+(void)getShopInfoDetailWithShopID:(NSString *)shopid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取商铺的所有商品的信息
+(void)getShopItemsDetailWithShopID:(NSString *)shopid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取商品的详细信息
+(void)getItemDetailWithItemID:(NSString *)itemid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取商铺的所有评价
+(void)getShopJudgeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//提交商铺的评价
+(void)submitJudgeWithShopID:(NSString *)shopid judgeContent:(NSString *)content score:(float)score complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//添加收藏的店铺
+(void)addCollectionShopWithShopID:(NSString *)shopid Complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//删除收藏的店铺
+(void)deleteCollectionShopWithShopID:(NSString *)shopid Complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取我的收藏的所有的店铺
+(void)getAllCollectionWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//验证店铺是否被用户收藏
+(void)getIsShopCollectWithShopID:(NSString *)shopID complete:(void (^)(BOOL isCollect))complete;
//搜索接口
+(AFHTTPRequestOperation *)searchShopsWithParmas:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//热门搜索词列表
+(void)getAllHotSearchKeywordsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;



/**
 *  订单相关
 */
//添加到订单
+(void)addToOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//重新计算订单价格
+(void)reCalcOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//提交订单
+(void)submitOrderWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取订单列表
+(void)getAllOrderWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//取消订单
+(void)cancelOrderWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//模拟订单支付结果
+(void)orderPayWithPayTradeSN:(NSString *)tradeSN complete:(void (^)(NSString *stateString))complete;
//订单 退款
+(void)orderRefundWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取订单的支付信息
+(void)getOrderPaymentInfoWithOrderSN:(NSString *)orderSN orderPayType:(OrderPaymentType)type complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个订单的详细信息 已经形成订单才能查询
+(void)getOrderDetailWithOrderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//订单投诉
+(void)orderSueWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


//获取收货地址
+(void)getAllReceiverListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加收货地址
+(void)addReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//修改收货地址
+(void)editReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//删除收货地址
+(void)deleteReceiveAddressWithAddressInfo:(AdressInfo *)addressInfo complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


//获取所有未使用的优惠券
+(void)getAllUnusedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取所有已经使用的优惠券
+(void)getAllUsedVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取所有已经过期的优惠券
+(void)getAllExpiredVoucherListComlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加优惠券代码
+(void)addVoucherWithCode:(NSString *)code comlete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


//获取我的余额
+(void)getAllMyCashWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//充值接口
+(void)chargeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//提现
+(void)withDrawWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取的退款
+(void)getAllMyRefundWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取我的所有评价
+(void)getAllMyJudgeWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


//获取我的消息
+(void)getAllMyNotificationWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取常见问题列表
+(void)getQAComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取服务条款
+(void)getServiceApprovementComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取关于我们
+(void)getAboutUsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//意见反馈
+(void)suggestionPostWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//商户入驻申请
+(void)addShopPostWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获得所有已经入驻的商家
+(void)getAllAskShopsWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//生活助手相关
//获得所有生活助手分类信息
+(void)getAllLifeCategroyComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//生活助手分类信息列表
+(void)getLifeCategroyListWithParams:(NSMutableDictionary *)paramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取我发布的信息
+(void)getAllMyLifeHelperInfoWithIndex:(int)index complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//增加生活助手的信息
+(void)uploadLifeHelperWithParams:(NSMutableDictionary *)pramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//修改生活助手的信息
+(void)updateLifeHelperWithParams:(NSMutableDictionary *)pramsDic complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//删除生活助手的信息
+(void)deleteLifeHelperWithID:(NSString *)lid complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;



//城市信息接口
+(void)getAreaListWithID:(long)longID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark - 支付相关
//微信预支付接口
+(void)wechatPrePayWithMoneyFen:(float)moneyNum orderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//支付宝支付接口 该接口直接打开支付宝客户端
+(BOOL)alipayPayWithMoneyYuan:(float)moneyYuan orderSN:(NSString *)orderSN complete:(void (^)(NSDictionary *result))complete;

+(void)paySuccessWithUrl:(NSString *)urlString complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark - 图片相关
+(void)uploadUserHeadImage:(UIImage *)headImage finish:(void (^)(NSString *imageUrl,NSString *errorString))finish;

+(void)suggestionPostImage:(UIImage *)postImage finish:(void (^)(NSString *imageUrl,NSString *errorString))finish;

+(NSString *)replaceUrl:(NSString *)url;

//返回支付的回调url
+(NSString *)getPayNotifyURL:(NSString *)orderSN;

@end
