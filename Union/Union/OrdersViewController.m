//
//  OrdersViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderDetailViewController.h"
#import "OrderTableViewCell.h"
#import "OrderJudgeViewController.h"
#import "UserLoginViewController.h"
#import "UIScrollView+XYRefresh.h"
#import "ShopDetailViewController.h"

#import "UNUrlConnection.h"
#import "AppDelegate.h"
#import "XYW8IndicatorView.h"

@interface OrdersViewController () <UITableViewDataSource,UITableViewDelegate,OrderTableViewCellDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *noOrderView;

@property (nonatomic,strong) UITableView *orderTableView;

@end

@implementation OrdersViewController{
    NSMutableArray *currentOrderDataArray;
    
    int currentOrderPageIndex;
    
    id<NSObject> payClientBackNotificationInOrderList;
    XYW8IndicatorView *indicatorView;
}

@synthesize contentView,noOrderView,orderTableView;

-(void)viewDidLoad{
    
    UIView *bottomFixView = [[UIView alloc] init];
    bottomFixView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    bottomFixView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:bottomFixView];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-UN_TabbarHeight};
    
    [self.view addSubview:contentView];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectZero;
    [contentView addSubview:view];
    
    noOrderView = [[UIView alloc] init];
    noOrderView.alpha = 0;
    noOrderView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    noOrderView.backgroundColor = RGBColor(235, 235, 235);
    [contentView addSubview:noOrderView];
    
    UIImageView *noOrderOutImageView = [[UIImageView alloc] init];
    noOrderOutImageView.frame = (CGRect){(WIDTH(noOrderView)-90)/2,(HEIGHT(noOrderView)-190)/3,90,90};
    noOrderOutImageView.image = [UIImage imageNamed:@"order_noorder"];
    [noOrderView addSubview:noOrderOutImageView];
    
    UILabel *noorderLabel = [[UILabel alloc] init];
    noorderLabel.frame = (CGRect){0,BOTTOM(noOrderOutImageView)+15,WIDTH(noOrderView),20};
    noorderLabel.text = @"您现在还没有订单,赶紧点一份吧";
    noorderLabel.font = Font(14);
    noorderLabel.tag = 1001;
    noorderLabel.textColor = RGBColor(140, 140, 140);
    noorderLabel.textAlignment = NSTextAlignmentCenter;
    [noOrderView addSubview:noorderLabel];
    
    UIButton *noorderButton = [[UIButton alloc] init];
    noorderButton.frame = (CGRect){(WIDTH(noOrderView)-100)/2,BOTTOM(noorderLabel)+25,100,40};
    noorderButton.backgroundColor = UN_RedColor;
    noorderButton.layer.cornerRadius = 4.f;
    noorderButton.layer.masksToBounds = YES;
    noorderButton.tag = 1002;
    [noorderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [noOrderView addSubview:noorderButton];
    [noorderButton setTitle:@"去点一份" forState:UIControlStateNormal];
    noorderButton.titleLabel.font = Font(14);
    [noorderButton addTarget:self action:@selector(noorderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    orderTableView = [[UITableView alloc] init];
    orderTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:orderTableView];
    orderTableView.tag = 31011;
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.alpha = 0;
    orderTableView.showsHorizontalScrollIndicator = NO;
    orderTableView.showsVerticalScrollIndicator = NO;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [orderTableView initDownRefresh];
    [orderTableView initPullUpRefresh];
    
    weak(weakself, self);
    [orderTableView setDownRefreshBlock:^(id refreshView){
        [weakself getOrdersWithPage:1];
    }];
    
    [orderTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getOrdersWithPage:currentOrderPageIndex+1];
    }];
    
    
    currentOrderPageIndex = 1;
    if ([UNUserDefaults getIsLogin]) {
        [self getOrdersWithPage:1];
    }else{
        orderTableView.alpha = 0.f;
        noOrderView.alpha = 1.f;
        for (UIView *view in noOrderView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.text = @"还未登录";
            }else if ([view isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton*)view;
                [button setTitle:@"登录/注册" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)noorderButtonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"去点一份"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_DidSelectTabControllernotification object:@(1)];
    }else if([button.titleLabel.text isEqualToString:@"登录/注册"]){
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
    }
}

-(void)getOrdersWithPage:(int)pageIndex{
    //从网络获取
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(pageIndex) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getAllOrderWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [orderTableView endDownRefresh];
        [orderTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *contentsDic = resultDic[@"content"];
        
        if (contentsDic && contentsDic.count > 0) {
            NSArray *ordersArray = contentsDic[@"orders"];
            
            NSMutableArray *orderArrayTmp = [NSMutableArray array];
            [ordersArray enumerateObjectsUsingBlock:^(NSDictionary *orInfoDic, NSUInteger idx, BOOL *stop) {
                OrderInfo *orderInfo = [OrderInfo orderInfoWithNetworkDictionary:orInfoDic];
                [orderArrayTmp addObject:orderInfo];
            }];
            if (pageIndex == 1) {
                currentOrderDataArray = [NSMutableArray array];
            }
            if (orderArrayTmp.count != 0) {
                
                [currentOrderDataArray addObjectsFromArray:orderArrayTmp];
                currentOrderPageIndex = pageIndex;
            }
        }
        
        runInMainThread(^{
            if (currentOrderDataArray && currentOrderDataArray.count != 0) {
                orderTableView.alpha = 1;
                noOrderView.alpha = 0;
                [orderTableView reloadData];
            }else{
                noOrderView.alpha = 1;
                orderTableView.alpha = 0;
                for (UIView *view in noOrderView.subviews) {
                    if ([view isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)view;
                        label.text = @"您现在还没有订单,赶紧点一份吧";
                    }else if ([view isKindOfClass:[UIButton class]]){
                        UIButton *button = (UIButton*)view;
                        [button setTitle:@"去点一份" forState:UIControlStateNormal];
                    }
                }
            }
        });
    }];
    
    return;
    
    currentOrderDataArray = [NSMutableArray array];
    
    OrderInfo *o1 = [[OrderInfo alloc] init];
    o1.imageUrlString = @"";
    o1.shopName = @"川渝小吃";
    o1.shopID = @"21";
    o1.orderState = OrderInfoOrderStateComplete;
    o1.orderMenuDetail = @[@{@"name":@"欧式培根炒饭欧式培式培根炒饭欧式培式培根炒饭欧式培根炒饭欧式培根炒饭",@"number":@"2",@"unitprice":@"8888.5"},
                           @{@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"},];
    o1.deliveryNumber = 5;
    o1.orderNumber = 145;
    o1.timeStamp = 1431425000;
    
    
    
    OrderInfo *o2 = [[OrderInfo alloc] init];
    o2.imageUrlString = @"";
    o2.shopName = @"川渝小吃";
    o2.shopID = @"21";
    o2.orderState = OrderInfoOrderStateSubmitSuccess;
    o2.orderMenuDetail = @[@{@"name":@"欧式培根炒饭",@"number":@"2",@"unitprice":@"60"},
                           @{@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"},];
    o2.deliveryNumber = 5;
    o2.orderNumber = 145;
    o2.timeStamp = 1431425000;
    
    [currentOrderDataArray addObject:o1];
    [currentOrderDataArray addObject:o1];
    [currentOrderDataArray addObject:o2];
    [currentOrderDataArray addObject:o1];
    [currentOrderDataArray addObject:o2];
    [currentOrderDataArray addObject:o1];
    
    
    if (currentOrderDataArray && currentOrderDataArray.count != 0) {
        orderTableView.alpha = 1;
        noOrderView.alpha = 0;
        [orderTableView reloadData];
    }else{
        noOrderView.alpha = 1;
        orderTableView.alpha = 0;
    }
}


#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == orderTableView) {
        if (currentOrderDataArray && currentOrderDataArray.count != 0) {
            return [OrderTableViewCell staticHeightWithOrderInfo:currentOrderDataArray[indexPath.row]];
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == orderTableView) {
        if (currentOrderDataArray) {
            return currentOrderDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == orderTableView) {
        static NSString *orderTableViewCellIdentifier = @"orderTableViewCellIdentifier";
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderTableViewCellIdentifier];
        if (!cell) {
            cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:orderTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.orderInfo = currentOrderDataArray[indexPath.row];
        if (indexPath.row == currentOrderDataArray.count - 1) {
            cell.isLastcell = YES;
        }else{
            cell.isLastcell = NO;
        }
        cell.delegate = self;
        //        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *odVC = [[OrderDetailViewController alloc] init];
    odVC.orderInfo = currentOrderDataArray[indexPath.row];
    [self.navigationController pushViewController:odVC animated:YES];
}

-(void)orderTableCell:(OrderTableViewCell *)cell didClickFunctionButton:(UIButton *)button{
    /**
     *  取消订单  付款  退款  再来一单   评价
     */
    
    NSString *buttonTitle = button.titleLabel.text;
    if ([buttonTitle isEqualToString:@"查看详情"]) {
        OrderDetailViewController *odVC = [[OrderDetailViewController alloc] init];
        odVC.orderInfo = cell.orderInfo;
        [self.navigationController pushViewController:odVC animated:YES];
    }else if ([buttonTitle isEqualToString:@"去评价"] || [buttonTitle isEqualToString:@"评价"]){
        OrderJudgeViewController *ojvc = [[OrderJudgeViewController alloc] init];
        ojvc.orderInfo = cell.orderInfo;
        [self.navigationController pushViewController:ojvc animated:YES];
    }else if ([buttonTitle isEqualToString:@"再来一单"]){
        ShopDetailViewController *sdVC = [[ShopDetailViewController alloc] init];
        ShopInfo *shopInfo = [[ShopInfo alloc] init];
        shopInfo.shopID = cell.orderInfo.shopID;
        shopInfo.name = cell.orderInfo.shopName;
        sdVC.shopInfo = shopInfo;
        [self.navigationController pushViewController:sdVC animated:YES];
    }else if ([buttonTitle isEqualToString:@"取消订单"]){
        [UNUrlConnection cancelOrderWithOrderSN:cell.orderInfo.orderSN complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"订单取消成功"];
                cell.orderInfo.orderState = OrderInfoOrderStateCancel;
                [cell setOrderInfo:cell.orderInfo];
                return;
            }
            NSString *content = messageDic[@"content"];
            if (!content) {
                content = @"订单取消失败";
            }
            [BYToastView showToastWithMessage:content];
            
        }];
    }else if ([buttonTitle isEqualToString:@"退款"]){
        [BYToastView showToastWithMessage:@"正在提交退款申请..."];
        [UNUrlConnection orderRefundWithOrderSN:cell.orderInfo.orderSN complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"退款申请已提交"];
                cell.orderInfo.paymentStatus = OrderInfoOrderPaymentStatePartialRefunds;
                cell.orderInfo.orderState = OrderInfoOrderStateCancel;
                [cell setOrderInfo:cell.orderInfo];
                return;
            }
            NSString *contentString = messageDic[@"content"];
            if (!contentString) {
                contentString = @"退款申请失败";
            }
            [BYToastView showToastWithMessage:contentString];
        }];
    }else if ([buttonTitle isEqualToString:@"付款"]){
        [BYToastView showToastWithMessage:@"提交付款信息...."];
        [UNUrlConnection getOrderPaymentInfoWithOrderSN:cell.orderInfo.orderSN orderPayType:cell.orderInfo.payMentType complete:^(NSDictionary *resultDic, NSString *errorString) {
            
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *typeString = messageDic[@"type"];
            if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
                NSDictionary *contentDictionary = resultDic[@"content"];
                //                NSString *requestCharset = contentDictionary[@"requestCharset"];
                //                NSString *requestMethod = contentDictionary[@"requestMethod"];
                //                NSString *requestUrl = contentDictionary[@"requestUrl"];
                
                NSDictionary *payParamsDic = contentDictionary[@"payParameter"];
                
                __block float totalFee = [payParamsDic[@"total_fee"] floatValue];
                
                NSString *trade_no = payParamsDic[@"out_trade_no"];
                //                
                //                NSString *notifyUrl = payParamsDic[@"notify_url"];
                //初始化提示框；
                NSString *messageString;
                if ((totalFee*10)-((int)totalFee)*10 == 0) {
                    messageString = [NSString stringWithFormat:@"还需支付￥%d",(int)totalFee];
                }else{
                    messageString = [NSString stringWithFormat:@"还需支付¥%.1f",totalFee];
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *paymethod = [payParamsDic objectForKey:@"paymethod"];
                    if (!paymethod) {
                        [BYToastView showToastWithMessage:@"支付失败,未知的支付类型"];
                        return;
                    }
                    indicatorView = [XYW8IndicatorView new];
                    indicatorView.frame = (CGRect){0,0,WIDTH(MainWindow),HEIGHT(MainWindow)};
                    [MainWindow addSubview:indicatorView];
                    indicatorView.dotColor = [UIColor whiteColor];
                    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                    indicatorView.loadingLabel.text = @"获取订单信息";
                    [indicatorView startAnimating];
                    
                    //todo 不知道directPay 代表什么 暂时作为支付宝处理
                    if ([paymethod isEqualToString:@"directPay"]) {
                        payClientBackNotificationInOrderList = [[NSNotificationCenter defaultCenter] addObserverForName:UN_OrderDidSendToPayClientBackNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                            if ([[note object] boolValue]) {
                                [self getSelfOrderDetailWithPaymentSN:trade_no success:^{
                                    cell.orderInfo.paymentStatus = OrderInfoOrderPaymentStatePaid;
                                    cell.orderInfo.orderState = OrderInfoOrderStateSubmitSuccess;
                                    [cell setOrderInfo:cell.orderInfo];
                                }];
                            }else{
                                [BYToastView showToastWithMessage:@"支付失败,跳转订单列表"];
                                [self jumpToOrderList];
                            }
                            [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotificationInOrderList];
                        }];
                        //todo test
                        totalFee = 0.01;
                        [UNUrlConnection alipayPayWithMoneyYuan:totalFee orderSN:trade_no complete:^(NSDictionary *result) {
                            [(AppDelegate *)[UIApplication sharedApplication].delegate handleAliPayCallBackWithResult:result];
                        }];
                        return;
                    }else{
                        //todo 需要添加微信支付
                        //todo test
                        totalFee = 1;
                        [BYToastView showToastWithMessage:@"支付失败,未知的支付类型"];
                        [indicatorView stopAnimating:YES];
                        return;
                    }
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }else{
                NSString *contentString = messageDic[@"content"];
                if (!contentString) {
                    contentString = @"获取支付信息失败,请稍候再试";
                }
                [BYToastView showToastWithMessage:@"获取支付信息失败,请稍候再试"];
            }
        }];
    }
}

-(void)getSelfOrderDetailWithPaymentSN:(NSString *)paymentSN success:(void (^)(void))success{
    if (!paymentSN || [paymentSN isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"订单错误,请稍候再试"];
        [indicatorView stopAnimating:YES];
        return;
    }
    dispatch_async(dispatch_queue_create("getSelfOrderDetail", nil), ^{
        sleep(3);
        [UNUrlConnection getOrderDetailWithOrderSN:paymentSN complete:^(NSDictionary *resultDic, NSString *errorString) {
            [indicatorView stopAnimating:YES];
            NSLog(@"getOrderDetailWithOrderSN:%@ \n,result:%@,\nerror:%@",paymentSN,resultDic,errorString);
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            NSDictionary *contentsDic = resultDic[@"content"];
            
            if (contentsDic && [contentsDic isKindOfClass:[NSDictionary class]] && contentsDic.count > 0) {
                
                OrderInfo *orderInfo = [OrderInfo orderInfoWithNetworkDictionary:contentsDic];
                
                /**
                 OrderInfoOrderPaymentStateUnPaid,           //未支付
                 OrderInfoOrderPaymentStatePartialPayment,   //部分支付
                 OrderInfoOrderPaymentStatePaid,             //已支付
                 OrderInfoOrderPaymentStatePartialRefunds,   //部分退款
                 OrderInfoOrderPaymentStateRefunded,         //已退款
                 */
                //remove自己
                [[NSNotificationCenter defaultCenter] removeObserver:payClientBackNotificationInOrderList];
                
                if (orderInfo.paymentStatus == OrderInfoOrderPaymentStatePaid) {
                    [BYToastView showToastWithMessage:@"支付成功"];
                    success();
                    [self jumpToOrderDetail:orderInfo];
                }else{
                    [BYToastView showToastWithMessage:@"出现错误,跳转订单列表"];
                    [self jumpToOrderList];
                }
            }
        }];
    });
}

-(void)jumpToOrderDetail:(OrderInfo *)orderInfo{
    [indicatorView stopAnimating:YES];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.orderInfo = orderInfo;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

-(void)jumpToOrderList{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicatorView stopAnimating:YES];
    });
}

-(void)setUpNavigation{
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    if ([UNUserDefaults getIsLogin]) {
        [self getOrdersWithPage:1];
    }else{
        orderTableView.alpha = 0.f;
        noOrderView.alpha = 1.f;
        for (UIView *view in noOrderView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.text = @"还未登录";
            }else if ([view isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton*)view;
                [button setTitle:@"登录/注册" forState:UIControlStateNormal];
            }
        }
    }
}

@end
