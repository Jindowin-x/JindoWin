//
//  LifeHelperListViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LifeHelperListViewController.h"
#import "LifeHelperPostInfoDetailViewController.h"
#import "LifeHelperPostViewController.h"
#import "UserLoginViewController.h"

#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

@interface LifeHelperListViewController () <UITableViewDataSource,UITableViewDelegate,LifeHelperListTableCellDelegate>

@end

@implementation LifeHelperListViewController{
    UITableView *contentTableView;
    NSMutableArray *contentDataArray;
    
    int currentPageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = [self.infoDictionary objectForKey:@"title"];
    if (!title) {
        title = @"分类列表";
    }
    self.navigationItem.title = title;
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    
    contentTableView = [[UITableView alloc] init];
    contentTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    [contentView addSubview:contentTableView];
    contentTableView.tag = 1831;
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
        [weakself reloadContentDataTableViewWithPageIndex:currentPageIndex+1];
    }];
    
    [self reloadContentDataTableViewWithPageIndex:1];
    
}

-(void)reloadContentDataTableViewWithPageIndex:(int)pageIndex{
    NSString *idString = [self.infoDictionary objectForKey:@"id"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:idString forKey:@"lifeCategory_id"];
    [paramsDic setObject:@(pageIndex) forKey:@"pageNumber"];
    [paramsDic setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getLifeCategroyListWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            [contentTableView endDownRefresh];
            [contentTableView endPullUpRefresh];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        NSMutableArray *resultArrayTmp = [NSMutableArray array];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
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
                
                [resultArrayTmp addObject:@{@"image":image,
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
            if (resultArrayTmp.count != 0) {
                
                [contentDataArray addObjectsFromArray:[NSArray arrayWithArray:resultArrayTmp]];
                currentPageIndex = pageIndex;
            }else{
                [BYToastView showToastWithMessage:@"没有更多了"];
            }
            
            [contentTableView reloadData];
        }
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
    }];
    
    return;
    contentDataArray = [NSMutableArray array];
    
    [contentDataArray addObject:@{@"image":@"",
                                  @"title":@"对口升学太原文稻冲刺班开学啦",
                                  @"address":@"学府街-太原文稻培训学校",
                                  }];
    [contentDataArray addObject:@{@"image":@"",
                                  @"title":@"李老师讲英语专职英语教师培训",
                                  @"address":@"平阳-李老师讲英语",
                                  }];
    
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return LifeHelperListTableCellHieght;
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
        static NSString *LifeHelperListTableCellIdentifier1831 = @"LifeHelperListTableCellIdentifier1831";
        LifeHelperListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeHelperListTableCellIdentifier1831];
        if (!cell) {
            cell = [[LifeHelperListTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LifeHelperListTableCellIdentifier1831];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *info = [contentDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = info[@"title"];
        cell.detailTextLabel.text = info[@"address"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:info[@"image"]]  placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        LifeHelperPostInfoDetailViewController *lhpidVC = [[LifeHelperPostInfoDetailViewController alloc] init];
        lhpidVC.infoDic = [contentDataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:lhpidVC animated:YES];
    }
}

-(void)listTableCell:(LifeHelperListTableCell *)cell didClickOutCallButtonAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = [contentDataArray objectAtIndex:indexPath.row];
    callPhoneNumber = [info objectForKey:@"phone"];
    if (!callPhoneNumber) {
        [BYToastView showToastWithMessage:@"电话号码暂不可用"];
        return;
    }
    [self callToPhone];
}

static NSString *callPhoneNumber;
-(void)callToPhone{
    if (!callPhoneNumber || [callPhoneNumber isEqualToString:@""]) {
        return;
    }
    UIAlertView *callAlert  = [[UIAlertView alloc] initWithTitle:@"拨号确认" message:[NSString stringWithFormat:@"确定拨打电话给%@吗？",callPhoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [callAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[callPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
        callPhoneNumber = @"";
    }
}

-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *rightimage = [UIImage imageNamed:@"navi_edit"];
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithImage:rightimage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    if (![UNUserDefaults getIsLogin]) {
        [BYToastView showToastWithMessage:@"请先登录"];
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
    }else{
        LifeHelperPostViewController *lhpVC = [[LifeHelperPostViewController alloc] init];
        lhpVC.lifeGategroyArray = self.lifeGategroyArray;
        [self.navigationController pushViewController:lhpVC animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation LifeHelperListTableCell{
    UIView *hoSepLineView;
    
    UIButton *callOutButton;
    
    UIView *bottomSepLineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(13);
        self.textLabel.numberOfLines = 2;
        self.textLabel.textColor = RGBColor(80, 80, 80);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = Font(12);
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        
        hoSepLineView = [[UIView alloc] init];
        hoSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:hoSepLineView];
        
        callOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [callOutButton setTintColor:UN_RedColor];
        [callOutButton addTarget:self action:@selector(callOutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [callOutButton setImage:[UIImage imageNamed:@"lifehelper_callout"] forState:UIControlStateNormal];
        [self.contentView addSubview:callOutButton];
        
        bottomSepLineView = [[UIView alloc] init];
        bottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:bottomSepLineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){10,10,80,HEIGHT(self.contentView)-20};
    self.imageView.backgroundColor = UN_RedColor;
    
    self.textLabel.frame = (CGRect){100,10,WIDTH(self.contentView)-100-55,15};
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+10,WIDTH(self.textLabel),14};
    
    hoSepLineView.frame = (CGRect){WIDTH(self.contentView)-55-0.5,15,0.5,HEIGHT(self.contentView)-30};
    
    callOutButton.frame = (CGRect){WIDTH(self.contentView)-55,0,55,HEIGHT(self.contentView)};
    
    bottomSepLineView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

-(void)callOutButtonClick{
    if (self.delegate && self.indexPath && [self.delegate respondsToSelector:@selector(listTableCell:didClickOutCallButtonAtIndexPath:)]) {
        [self.delegate listTableCell:self didClickOutCallButtonAtIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //    if (selected) {
    //        self.imageView.hidden = NO;
    //        self.backgroundColor = [UIColor whiteColor];
    //    }else{
    //        self.imageView.hidden = YES;
    //        self.backgroundColor = RGBColor(240, 240, 240);
    //    }
}

@end


