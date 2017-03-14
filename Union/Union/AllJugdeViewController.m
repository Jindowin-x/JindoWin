//
//  AllJugdeViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AllJugdeViewController.h"
#import "JudgeTableViewCell.h"
#import "UIScrollView+XYRefresh.h"
#import "UNUrlConnection.h"

@interface AllJugdeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSMutableArray *contentDataArray;

@end

@implementation AllJugdeViewController{
    UIButton *noJudgeShowedButton;
    UILabel *noItemRefreshLabel;
    
    int currentJudgePageIndex;
}
@synthesize contentView,contentTableView,contentDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的评价";
    
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
    
    noJudgeShowedButton = [[UIButton alloc] init];
    noJudgeShowedButton.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    noJudgeShowedButton.alpha = 1;
    [contentView addSubview:noJudgeShowedButton];
    [noJudgeShowedButton addTarget:self action:@selector(noJudgeShowedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    noItemRefreshLabel = [[UILabel alloc] init];
    noItemRefreshLabel.frame = (CGRect){10,WIDTH(noJudgeShowedButton)/2,WIDTH(noJudgeShowedButton)-20,40};
    noItemRefreshLabel.text = @"正在获取收藏店铺";
    noItemRefreshLabel.textColor = RGBColor(140, 140, 140);
    noItemRefreshLabel.font = Font(14);
    noItemRefreshLabel.textAlignment = NSTextAlignmentCenter;
    [noJudgeShowedButton addSubview:noItemRefreshLabel];
    
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 7401;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weak(weakself, self);
    [contentTableView initDownRefresh];
    [contentTableView setDownRefreshBlock:^(id refreshView){
        currentJudgePageIndex = 1;
        [weakself getAllMyJusgeWithIndex:1];
    }];
    
    [contentTableView initPullUpRefresh];
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getAllMyJusgeWithIndex:currentJudgePageIndex+1];
    }];
    
    
    currentJudgePageIndex = 1;
    [self getAllMyJusgeWithIndex:currentJudgePageIndex];
}

-(void)noJudgeShowedButtonClick{
    currentJudgePageIndex = 1;
    [self getAllMyJusgeWithIndex:currentJudgePageIndex];
}

-(void)getAllMyJusgeWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(index) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getAllMyJudgeWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            NSArray *listArray = dataDic[@"list"];
            
            if (listArray && [listArray isKindOfClass:[NSArray class]] && listArray.count != 0) {
                NSMutableArray *arrayTmp = [NSMutableArray array];
                [listArray enumerateObjectsUsingBlock:^(NSDictionary *shopDic, NSUInteger idx, BOOL *stop) {
                    if (shopDic) {
                        NSString *shopname = shopDic[@"brand_name"];
                        NSString *content = shopDic[@"detail"];
                        long long time = [shopDic[@"time"] longLongValue]/1000;
                        NSString *brand_logo = shopDic[@"brand_logo"];
                        
                        if (!shopname || ![shopname isKindOfClass:[NSString class]] || [shopname isEqualToString:@""]) {
                            shopname = @"";
                        }
                        if (!content || ![content isKindOfClass:[NSString class]] || [content isEqualToString:@""]) {
                            content = @"";
                        }
                        if (!brand_logo || ![brand_logo isKindOfClass:[NSString class]] || [brand_logo isEqualToString:@""]) {
                            brand_logo = @"";
                        }
                        [arrayTmp addObject:
                         @{@"shopName":shopname,
                           @"judgeMessage":content,
                           @"timestamp":@(time),
                           @"shoplogo":brand_logo
                           }
                         ];
                    }
                }];
                
                if (index == 1) {
                    contentDataArray = [NSMutableArray array];
                }
                if (arrayTmp.count > 0) {
                    [contentDataArray addObjectsFromArray:arrayTmp];
                    currentJudgePageIndex = index;
                }
                [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:contentDataArray waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(reloadContentDataTableViewWithArray:) withObject:nil waitUntilDone:YES];
            }
        }
        if (index == 1) {
            [contentTableView endDownRefresh];
        }else{
            [contentTableView endPullUpRefresh];
        }
    }];
}


-(void)reloadContentDataTableViewWithArray:(NSMutableArray *)array{
    if (array) {
        noJudgeShowedButton.alpha = 0;
        contentTableView.alpha = 1;
        contentDataArray = array;
        [contentTableView reloadData];
    }else{
        noJudgeShowedButton.alpha = 1;
        contentTableView.alpha = 0;
        noItemRefreshLabel.text = @"您还没有评价过任何店铺哦";
    }
    /**
     *  todo 测试我的评论
     */
    return;
    contentDataArray = [NSMutableArray array];
    
    [contentDataArray addObject:@{@"shopName":@"川渝小吃",
                                  @"judgeMessage":@"味道非常好,下次还回来,送的也非常快,下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"熊猫小馆",
                                  @"judgeMessage":@"味道非常好,下次还回来",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"肯德基麦辣鸡",
                                  @"judgeMessage":@"下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"川渝小吃",
                                  @"judgeMessage":@"味道非常好,下次还回来,送的也非常快,下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"川渝小吃",
                                  @"judgeMessage":@"味道非常好,下次还回来,送的也非常快,下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"川渝小吃",
                                  @"judgeMessage":@"味道非常好,下次还回来,送的也非常快,下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    [contentDataArray addObject:@{@"shopName":@"川渝小吃",
                                  @"judgeMessage":@"味道非常好,下次还回来,送的也非常快,下次还点这一家吃味道非常好,下次还回来,送的也非常快,下次还点这一家吃味道非常好,下次还回来,送的也非常快,下次还点这一家吃味道非常好,下次还回来,送的也非常快,下次还点这一家吃",
                                  @"timestamp":@(1447514624)}];
    
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return JudgeTableViewCellViewHeight;
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
        static NSString *JudgeTableViewCellIdentifier7401 = @"JudgeTableViewCellIdentifier7401";
        JudgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JudgeTableViewCellIdentifier7401];
        if (!cell) {
            cell = [[JudgeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JudgeTableViewCellIdentifier7401];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.judgeShopName = contentDataArray[indexPath.row][@"shopName"];
        cell.judgeMessage = contentDataArray[indexPath.row][@"judgeMessage"];
        cell.judgeTimeStamp = [contentDataArray[indexPath.row][@"timestamp"] longLongValue];
        NSString *imageUrl = contentDataArray[indexPath.row][@"shoplogo"];
        imageUrl = [UNUrlConnection replaceUrl:imageUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
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

@end
