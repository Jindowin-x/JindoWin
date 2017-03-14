//
//  MyPostsViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyPostsViewController.h"
#import "PostTableViewCell.h"
#import "LifeHelperPostViewController.h"

#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

#import "LifeHelperInfo.h"

@interface MyPostsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSMutableArray *contentDataArray;

@end

@implementation MyPostsViewController{
    int currentPostIndex;
    
    UIButton *noPostsShowedButton;
    UILabel *noItemRefreshLabel;
}

@synthesize contentView,contentTableView,contentDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的发布";
    
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
    
    noPostsShowedButton = [[UIButton alloc] init];
    noPostsShowedButton.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    noPostsShowedButton.alpha = 1;
    [contentView addSubview:noPostsShowedButton];
    [noPostsShowedButton addTarget:self action:@selector(noPostsShowedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    noItemRefreshLabel = [[UILabel alloc] init];
    noItemRefreshLabel.frame = (CGRect){10,WIDTH(noPostsShowedButton)/2,WIDTH(noPostsShowedButton)-20,40};
    noItemRefreshLabel.text = @"正在获取发布的信息";
    noItemRefreshLabel.textColor = RGBColor(140, 140, 140);
    noItemRefreshLabel.font = Font(14);
    noItemRefreshLabel.textAlignment = NSTextAlignmentCenter;
    [noPostsShowedButton addSubview:noItemRefreshLabel];
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 7701;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weak(weakself, self);
    [contentTableView initDownRefresh];
    [contentTableView setDownRefreshBlock:^(id refreshView){
        currentPostIndex = 1;
        [weakself getAllMyPostsWithIndex:1];
    }];
    
    [contentTableView initPullUpRefresh];
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getAllMyPostsWithIndex:currentPostIndex+1];
    }];
    
    currentPostIndex = 1;
    [self getAllMyPostsWithIndex:1];
}

-(void)noPostsShowedButtonClick{
    currentPostIndex = 1;
    noItemRefreshLabel.text = @"正在获取发布的信息";
    [BYToastView showToastWithMessage:@"正在获取发布的信息"];
    [self getAllMyPostsWithIndex:1];
}

-(void)getAllMyPostsWithIndex:(int)pageIndex{
    [UNUrlConnection getAllMyLifeHelperInfoWithIndex:pageIndex complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSMutableArray *arrayTmp = [NSMutableArray array];
            NSArray *contentArray = [resultDic[@"content"] objectForKey:@"lifes"];
            
            [contentArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                NSString *contentString = [obj objectForKey:@"content"];
                if (!contentString) {
                    contentString = @"";
                }
                
                NSString *idString = [NSString stringWithFormat:@"%ld",[obj[@"id"] longValue]];
                
                NSString *phoneString = [obj objectForKey:@"phone"];
                if (!phoneString) {
                    phoneString = @"";
                }
                
                NSString *title = [obj objectForKey:@"title"];
                if (!title) {
                    title = @"";
                }
                
                NSString *area = [obj objectForKey:@"area"];
                if (!area) {
                    area = @"";
                }
                
                NSString *address = [obj objectForKey:@"address"];
                if (!address) {
                    address = @"";
                }
                
                NSString *linkman = [obj objectForKey:@"linkman"];
                if (!linkman) {
                    linkman = @"";
                }
                
                NSString *image = [UNUrlConnection replaceUrl:[obj objectForKey:@"image"]];
                if (!image) {
                    image = @"";
                }
                long long timestamp = [[obj objectForKey:@"creatDate"] longLongValue]/1000;
                
                long hitsNumber = [[obj objectForKey:@"hits"] longValue];
                
                NSString *areaName = [obj objectForKey:@"areaName"];
                
                if (!areaName || ![areaName isKindOfClass:[NSString class]]) {
                    areaName = @"";
                }
                
                long lifeGategroyID = (long)[[obj objectForKey:@"lifeCategory_id"] longLongValue];
                NSString *lifeGategroyName = [obj objectForKey:@"lifeCategory_name"];
                
                if (!lifeGategroyName || ![lifeGategroyName isKindOfClass:[NSString class]]) {
                    lifeGategroyName = @"";
                }
                
                NSArray *lifeImagesArray = [obj objectForKey:@"lifeImages"];
                
                [arrayTmp addObject:@{@"image":image,
                                      @"hits":@(hitsNumber),
                                      @"lifeImages":lifeImagesArray,
                                      @"title":title,
                                      @"address":address,
                                      @"content":contentString,
                                      @"id":idString,
                                      @"area":area,
                                      @"lifeCategory_id":@(lifeGategroyID),
                                      @"lifeCategory_name":lifeGategroyName,
                                      @"linkman":linkman,
                                      @"phone":phoneString,
                                      @"timestamp":@(timestamp),
                                      @"areaName":areaName,
                                      }];
            }];
            
            
            if (pageIndex == 1) {
                contentDataArray = [NSMutableArray array];
            }
            if (arrayTmp.count > 0) {
                [contentDataArray addObjectsFromArray:arrayTmp];
                currentPostIndex= pageIndex;
            }
            [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:contentDataArray waitUntilDone:YES];
        }else{
            [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:nil waitUntilDone:YES];
        }
        if (pageIndex == 1) {
            [contentTableView endDownRefresh];
        }else{
            [contentTableView endPullUpRefresh];
        }
    }];
}

-(void)reloadContentDataTableViewWithArray:(NSMutableArray *)array{
    if (array) {
        noPostsShowedButton.alpha = 0;
        contentTableView.alpha = 1;
        contentDataArray = array;
        [contentTableView reloadData];
    }else{
        noPostsShowedButton.alpha = 1;
        contentTableView.alpha = 0;
        noItemRefreshLabel.text = @"您还没有发布过任何信息哦";
    }
    return;
    contentDataArray = [NSMutableArray array];
    
    [contentDataArray addObject:@{@"name":@"初中辅导作业",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"name":@"健身教练",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"name":@"同城清洁服务",
                                  @"timestamp":@(1447514624)}];
    
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return PostTableViewCellViewHeight;
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
        static NSString *PostTableViewCellIdentifier7701 = @"PostTableViewCellIdentifier7701";
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PostTableViewCellIdentifier7701];
        if (!cell) {
            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PostTableViewCellIdentifier7701];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.postTitle = contentDataArray[indexPath.row][@"title"];
        cell.postTimeStamp = [contentDataArray[indexPath.row][@"timestamp"] longLongValue];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        LifeHelperPostViewController *lhpVC = [[LifeHelperPostViewController alloc] init];
        lhpVC.postInfoDic = [contentDataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:lhpVC animated:YES];
    }
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
    if (contentTableView) {
        currentPostIndex = 1;
        [self getAllMyPostsWithIndex:1];
    }
}

@end
