//
//  InfomationViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "InfomationViewController.h"
#import "InfomationTableViewCell.h"
#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

@interface InfomationViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSMutableArray *contentDataArray;

@property (nonatomic,assign) int currentPageIndex;

@end

@implementation InfomationViewController

@synthesize contentView,contentTableView,contentDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的消息";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 7201;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [contentTableView initDownRefresh];
    [contentTableView initPullUpRefresh];
    
    weak(weakself, self);
    [contentTableView setDownRefreshBlock:^(id refreshView){
        [weakself reloadContentDataTableViewWithPageIndex:1];
    }];
    
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself reloadContentDataTableViewWithPageIndex:self.currentPageIndex+1];
    }];
    
    self.currentPageIndex = 1;
    
    [self reloadContentDataTableViewWithPageIndex:self.currentPageIndex];
}

-(void)reloadContentDataTableViewWithPageIndex:(int)pageIndex{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(pageIndex) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getAllMyNotificationWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *contetDic = resultDic[@"content"];
        NSMutableArray *arrTmp = [NSMutableArray array];
        if (contetDic && [contetDic isKindOfClass:[NSDictionary class]]) {
            NSArray *noticesArray = contetDic[@"notices"];
            if (noticesArray && [noticesArray isKindOfClass:[NSArray class]] && noticesArray.count > 0) {
                for (NSDictionary *dic in noticesArray) {
                    NSString *title = dic[@"title"];
                    NSString *content = dic[@"content"];
                    
                    if (!title) {
                        title = @"提醒";
                    }
                    if (!content) {
                        content = @"";
                    }
                    [arrTmp addObject:@{@"title":title,
                                        @"detail":content}];
                }
            }
        }
        if (pageIndex == 1) {
            contentDataArray = [NSMutableArray array];
        }
        if (arrTmp && arrTmp.count != 0) {
            [contentDataArray addObjectsFromArray:arrTmp];
            self.currentPageIndex = pageIndex;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        
        if (contentDataArray && contentDataArray.count != 0) {
            [contentTableView reloadData];
        }
        
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        
    }];
    
    return;
    contentDataArray = [NSMutableArray array];
    
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"百度外卖,是由百度打造的专业的外卖平台百度外卖,是由百度打造的专业的外卖平台百度外卖,是由百度打造的专业的外卖平台百度外卖,是由百度打造的专业的外卖平台,"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"百度外卖,是由百度打造的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"百度外卖,是由百度打造的专业的外卖平台百度外卖,是由百度打造的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"百度外卖,是由百度打造的专业的外卖平台百度外卖,是由百度打造的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"百度外卖,是由百度打造的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    [contentDataArray addObject:@{@"title":@"",
                                  @"detail":@"的专业的外卖平台"}];
    
    
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return InfomationTableViewCellViewHeight;
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
        static NSString *InfomationTableViewIdentifier = @"InfomationTableViewCell7201";
        InfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfomationTableViewIdentifier];
        if (!cell) {
            cell = [[InfomationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:InfomationTableViewIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.messageTitle = contentDataArray[indexPath.row][@"title"];
        cell.messageDetail = contentDataArray[indexPath.row][@"detail"];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
