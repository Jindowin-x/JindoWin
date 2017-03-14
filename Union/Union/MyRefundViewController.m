//
//  MyRefundViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyRefundViewController.h"

#import "RefundTableViewCell.h"

#import "UNUrlConnection.h"

#import "UIScrollView+XYRefresh.h"

@interface MyRefundViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSMutableArray *contentDataArray;

@property (nonatomic,assign) int currentPageIndex;

@end

@implementation MyRefundViewController

@synthesize contentView,contentTableView;

@synthesize contentDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的退款";
    
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 6301;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.backgroundColor = contentView.backgroundColor;
    
    [contentTableView initDownRefresh];
    [contentTableView initPullUpRefresh];
    
    weak(weakself, self);
    [contentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getRefundDataWithPageIndex:1];
    }];
    
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getRefundDataWithPageIndex:self.currentPageIndex+1];
    }];
    
    [self getRefundDataWithPageIndex:1];
}

-(void)getRefundDataWithPageIndex:(int)pageIndex{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(pageIndex) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getAllMyRefundWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *contentDic = resultDic[@"content"];
        NSMutableArray *addArrayTmp = [NSMutableArray array];
        if (contentDic && [contentDic isKindOfClass:[NSDictionary class]] && contentDic.count != 0) {
            NSArray *refundsArray = contentDic[@"refunds"];
            
            for (NSDictionary *refundDic in refundsArray) {
                float price = [[refundDic objectForKey:@"amount"] floatValue];
                long long timestamp = [[refundDic objectForKey:@"time"] longLongValue]/1000;
                NSString *shopName = [refundDic objectForKey:@"brand_name"];
                if (!shopName) {
                    shopName = @"未知商铺";
                }
                NSString *shopImage = [refundDic objectForKey:@"brand_logo"];
                
                NSArray *orderDetailArray = [refundDic objectForKey:@"order_item"];
                
                NSMutableArray *orderArrayTmp = [NSMutableArray array];
                for (NSDictionary *orderDic in orderDetailArray) {
                    NSString *name = [orderDic objectForKey:@"name"];
                    if (!name) {
                        name = @"";
                    }
                    int count = [[orderDic objectForKey:@"quantity"] intValue];
                    
                    float unitprice = [[orderDic objectForKey:@"price"] floatValue];
                    
                    [orderArrayTmp addObject:@{@"name":name,
                                               @"count":@(count),
                                               @"unitprice":@(unitprice)}];
                }
                
                [addArrayTmp addObject:@{
                                         @"price":@(price),
                                         @"timestamp":@(timestamp),
                                         @"shopName":shopName,
                                         @"shopImage":shopImage,
                                         @"orderMenu":orderArrayTmp,
                                         }];
            }
        }
        if (pageIndex == 1) {
            contentDataArray = [NSMutableArray array];
        }
        if (addArrayTmp && addArrayTmp.count != 0) {
            [contentDataArray addObjectsFromArray:addArrayTmp];
            
            self.currentPageIndex = pageIndex;
            
        }else{
            [BYToastView showToastWithMessage:@"未获取到数据"];
        }
        [contentTableView reloadData];
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
    }];
    return;
    contentDataArray = [NSMutableArray array];
    
    OrderInfo *order = [[OrderInfo alloc] init];
    order.imageUrlString = @"";
    order.shopName = @"胖子海鲜烧烤";
    //    order.orderState = OrderInfoOrderStateRefundingUpload;
    order.orderMenuDetail = @[@{@"name":@"油焖大虾",@"number":@"1",@"unitprice":@"188.5"},];
    order.deliveryNumber = 20;
    order.orderNumber = 208.5;
    order.timeStamp = 1432425000;
    [contentDataArray addObject:order];
    
    OrderInfo *o1 = [[OrderInfo alloc] init];
    o1.imageUrlString = @"";
    o1.shopName = @"川渝小吃";
    //    o1.orderState = OrderInfoOrderStateRefundingShop;
    o1.orderMenuDetail = @[@{@"name":@"水煮鱼",@"number":@"1",@"unitprice":@"168"},
                           @{@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"},];
    o1.deliveryNumber = 5;
    o1.orderNumber = 193;
    o1.timeStamp = 1431425000;
    
    [contentDataArray addObject:o1];
    
    OrderInfo *o2 = [[OrderInfo alloc] init];
    o2.imageUrlString = @"";
    o2.shopName = @"川渝小吃";
    //    o2.orderState = OrderInfoOrderStateRefundingSuccess;
    o2.orderMenuDetail = @[@{@"name":@"欧式培根炒饭",@"number":@"2",@"uniprice":@"60"},
                           @{@"name":@"扬州炒饭",@"number":@"1",@"unitprice":@"20"},];
    o2.deliveryNumber = 5;
    o2.orderNumber = 145;
    o2.timeStamp = 1431425000;
    
    [contentDataArray addObject:o2];
    
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return RefundTableViewCellViewHeight;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (contentDataArray) {
            return contentDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *RefundTableViewCellIdentifier6301 = @"RefundTableViewCellIdentifier6301";
        RefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundTableViewCellIdentifier6301];
        if (!cell) {
            cell = [[RefundTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RefundTableViewCellIdentifier6301];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = tableView.backgroundColor;
        }
        if (indexPath.row == contentDataArray.count-1) {
            cell.isLastCell = YES;
        }
        //        cell.orderInfo = [contentDataArray objectAtIndex:indexPath.row];
        
        /**
         *  todo  暂时不知道 这里是否显示的已经退款成功的数据  接口没有返回退款的状态,所以现在默认为退款成功的数据
         */
        cell.orderDic = [contentDataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  todo 暂时不知道 点击后跳转到哪里
     */
}

-(void)setUpNavigation{
    
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    //    if (contentTableView) {
    //        [self reloadContentDataTableView];
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
