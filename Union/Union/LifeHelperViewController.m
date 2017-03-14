//
//  LifeHelperViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LifeHelperViewController.h"
#import "LifeHelperPostViewController.h"
#import "LifeHelperDetailViewController.h"
#import "LifeHelperListViewController.h"
#import "UserLoginViewController.h"
#import "UNUrlConnection.h"

@interface LifeHelperViewController ()

@end

@implementation LifeHelperViewController{
    UIScrollView *contentScrollerView;
    NSMutableArray *contentLifeHelperDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"生活助手";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(235,235,235);
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    contentScrollerView = [[UIScrollView alloc] init];
    contentScrollerView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    contentScrollerView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:contentScrollerView];
    contentScrollerView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentScrollerView)+1};
    contentScrollerView.showsHorizontalScrollIndicator = NO;
    contentScrollerView.showsVerticalScrollIndicator = NO;
    
    [self getAllLifeHelperData];
}

-(void)getAllLifeHelperData{
    [UNUrlConnection getAllLifeCategroyComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *contentArray = resultDic[@"content"];
            
            contentLifeHelperDataArray = [NSMutableArray arrayWithArray:contentArray];
            [self reloadAllLifeHelperViews];
        }else{
            [BYToastView showToastWithMessage:@"获取数据失败"];
            return;
        }
    }];
    
    
    
    return;
    contentLifeHelperDataArray = [NSMutableArray array];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"家政服务" forKey:@"title"];
    [dic1 setObject:@"" forKey:@"titleImage"];
    NSArray *dicarray1 = @[@"搬家",@"保洁清洗",@"保姆/月嫂",@"管道疏通",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6",@"电脑维修",@"开锁/修锁",@"家政测试1",@"家政测试2",@"家政测试3",@"家政测试4",@"家政测试5",@"家政测试6"];
    [dic1 setObject:dicarray1 forKey:@"data"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"休闲娱乐" forKey:@"title"];
    [dic2 setObject:@"" forKey:@"titleImage"];
    NSArray *dicarray2 = @[@"运动健身",@"户外",@"夜店/酒吧",@"足疗按摩",@"桌游/棋牌",@"电影院",@"休闲娱乐1",@"休闲娱乐2",@"休闲娱乐3",@"休闲娱乐4",@"休闲娱乐5",@"休闲娱乐6",@"休闲娱乐1",@"休闲娱乐2",@"休闲娱乐3",@"休闲娱乐4",@"休闲娱乐5",@"休闲娱乐6",@"休闲娱乐1",@"休闲娱乐2",@"休闲娱乐3",@"休闲娱乐4",@"休闲娱乐5",@"休闲娱乐6"];
    [dic2 setObject:dicarray2 forKey:@"data"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"装修建材" forKey:@"title"];
    [dic3 setObject:@"" forKey:@"titleImage"];
    NSArray *dicarray3 = @[@"家装服务",@"工装服务",@"家纺家饰",@"建材",@"家具",@"建房/翻建改造",@"装修建材1",@"装修建材2",@"装修建材3",@"装修建材4",@"装修建材5",@"装修建材6",@"装修建材5",@"装修建材6"];
    [dic3 setObject:dicarray3 forKey:@"data"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"教育培训" forKey:@"title"];
    [dic4 setObject:@"" forKey:@"titleImage"];
    NSArray *dicarray4 = @[@"家教机构",@"中小学辅导班",@"艺术培训",@"职业技能培训",@"IT培训",@"语言培训",@"教育培训1",@"教育培训2",@"教育培训3",@"教育培训4",@"教育培训5",@"教育培训6"];
    [dic4 setObject:dicarray4 forKey:@"data"];
    
    [contentLifeHelperDataArray addObject:dic1];
    [contentLifeHelperDataArray addObject:dic2];
    [contentLifeHelperDataArray addObject:dic3];
    [contentLifeHelperDataArray addObject:dic4];
    
    [self reloadAllLifeHelperViews];
}

-(void)reloadAllLifeHelperViews{
    [contentScrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (contentLifeHelperDataArray && contentLifeHelperDataArray.count != 0) {
        
        UIView *scrollerTopFix = [[UIView alloc] init];
        scrollerTopFix.frame = (CGRect){0,-HEIGHT(self.view),WIDTH(contentScrollerView),HEIGHT(self.view)};
        scrollerTopFix.backgroundColor = RGBColor(253, 253, 253);
        [contentScrollerView addSubview:scrollerTopFix];
        
        __block float lifeHelperOffset = 0;
        [contentLifeHelperDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            UIView *fuView = [[UIView alloc] init];
            fuView.frame = (CGRect){0,lifeHelperOffset,WIDTH(contentScrollerView),120};
            fuView.backgroundColor = scrollerTopFix.backgroundColor;
            [contentScrollerView addSubview:fuView];
            
            UIView *fuTitleView = [[UIView alloc] init];
            fuTitleView.frame = (CGRect){0,0,WIDTH(fuView),40};
            fuTitleView.backgroundColor = fuView.backgroundColor;
            [fuView addSubview:fuTitleView];
            fuTitleView.tag = idx;
            
            UITapGestureRecognizer *fuTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fuTitleTapTriggle:)];
            [fuTitleView addGestureRecognizer:fuTitleTap];
            
            NSString *title = obj[@"node"][@"name"];
            NSString *titleimageUrl = obj[@"node"][@"titleImage"];
            
            UIImage *fuTitleImage;
            if (titleimageUrl && ![titleimageUrl isEqualToString:@""]) {
                //                fuTitleImage =
            }else{
                fuTitleImage = [UIImage imageNamed:[NSString stringWithFormat:@"lifehelper_%@",title]];
            }
            if (!fuTitleImage) {
                
            }
            
            UIImageView *fuTitleImageView = [[UIImageView alloc] init];
            fuTitleImageView.frame = (CGRect){(HEIGHT(fuTitleView)-21)/2,(HEIGHT(fuTitleView)-21)/2,21,21};
            //            fuTitleImageView.backgroundColor = [UIColor redColor];
            fuTitleImageView.image = fuTitleImage;
            [fuTitleView addSubview:fuTitleImageView];
            
            UILabel *fuTitleLabel = [[UILabel alloc] init];
            fuTitleLabel.frame = (CGRect){HEIGHT(fuTitleView),0,WIDTH(fuTitleView)-RIGHT(fuTitleImageView)-10-10,HEIGHT(fuTitleView)};
            fuTitleLabel.textAlignment = NSTextAlignmentLeft;
            fuTitleLabel.textColor = RGBColor(50, 50, 50);
            fuTitleLabel.text = title;
            fuTitleLabel.font = Font(15);
            [fuTitleView addSubview:fuTitleLabel];
            
            UIImageView *moreImageView = [[UIImageView alloc] init];
            moreImageView.image = [UIImage imageNamed:@"more"];
            moreImageView.frame = (CGRect){WIDTH(fuTitleView)-10-7,(HEIGHT(fuTitleView)-11)/2,7,11};
            [fuTitleView addSubview:moreImageView];
            
            NSArray *dataStringArray = [obj objectForKey:@"children"];
            int count = (int)dataStringArray.count;
            if (count >= 6) {
                count = 6;
            }
            for (int i = 0; i < count; i++) {
                NSString *titleStrng = [[dataStringArray objectAtIndex:i] objectForKey:@"name"];
                int xAligh = i%3;
                int yAligh = i/3;
                
                UILabel *dataLabel = [[UILabel alloc] init];
                dataLabel.frame = (CGRect){xAligh*WIDTH(fuView)/3,HEIGHT(fuTitleView)+yAligh*40,WIDTH(fuView)/3,40};
                dataLabel.textAlignment = NSTextAlignmentCenter;
                dataLabel.textColor = RGBColor(50, 50, 50);
                dataLabel.text = titleStrng;
                dataLabel.font = Font(15);
                dataLabel.tag = idx *100 + i;
                dataLabel.userInteractionEnabled = YES;
                [fuView addSubview:dataLabel];
                
                UITapGestureRecognizer *dataLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataLabelTapTriggle:)];
                [dataLabel addGestureRecognizer:dataLabelTap];
                
                if (xAligh == 0) {
                    UIView *fuViewSepLineView = [[UIView alloc] init];
                    fuViewSepLineView.frame = (CGRect){0,HEIGHT(fuTitleView)+yAligh*40-0.5,WIDTH(fuView),0.5};
                    fuViewSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
                    [fuView addSubview:fuViewSepLineView];
                }
            }
            
            lifeHelperOffset += HEIGHT(fuView);
            if (idx != contentLifeHelperDataArray.count-1) {
                UIView *sepView = [[UIView alloc] init];
                sepView.frame = (CGRect){0,lifeHelperOffset,WIDTH(contentScrollerView),10};
                sepView.backgroundColor = RGBColor(235, 235, 235);
                [contentScrollerView addSubview:sepView];
                
                UIView *sepViewSepLine1 = [[UIView alloc] init];
                sepViewSepLine1.frame = (CGRect){0,0,WIDTH(sepView),0.5};
                sepViewSepLine1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
                [sepView addSubview:sepViewSepLine1];
                
                UIView *sepViewSepLine2 = [[UIView alloc] init];
                sepViewSepLine2.frame = (CGRect){0,HEIGHT(sepView)-0.5,WIDTH(sepView),0.5};
                sepViewSepLine2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
                [sepView addSubview:sepViewSepLine2];
                
                lifeHelperOffset += HEIGHT(sepView);
            }
        }];
        
        
        if (lifeHelperOffset <= HEIGHT(contentScrollerView)) {
            contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),HEIGHT(contentScrollerView)+1};
        }else{
            contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),lifeHelperOffset};
        }
    }
}

-(void)fuTitleTapTriggle:(UITapGestureRecognizer *)tapGesture{
    UIView *view = tapGesture.view;
    int tag = (int)view.tag;
    if (tag < 0 || tag > contentLifeHelperDataArray.count-1) {
        return;
    }
    NSDictionary *infoDic = [contentLifeHelperDataArray objectAtIndex:tag];
    if (infoDic) {
        LifeHelperDetailViewController *lhdVC = [[LifeHelperDetailViewController alloc] init];
        lhdVC.infoDictionary = infoDic;
        lhdVC.lifeGategroyArray = [NSArray arrayWithArray:contentLifeHelperDataArray];
        [self.navigationController pushViewController:lhdVC animated:YES];
    }
}

-(void)dataLabelTapTriggle:(UITapGestureRecognizer *)tapGesture{
    UIView *view = tapGesture.view;
    int tagOutter = (int)(view.tag/100);
    int tagInner = (int)(view.tag%100);
    
    if (tagOutter < 0 || tagOutter > contentLifeHelperDataArray.count-1) {
        return;
    }
    NSDictionary *infoDic = [contentLifeHelperDataArray objectAtIndex:tagOutter];
    
    NSArray *titleStringArray = [infoDic objectForKey:@"children"];
    if (!titleStringArray || titleStringArray.count == 0) {
        return;
    }
    if (tagInner < 0 || tagInner > titleStringArray.count-1) {
        return;
    }
    NSString *titleString = [[titleStringArray objectAtIndex:tagInner] objectForKey:@"name"];
    if (titleString) {
        NSDictionary *dic = @{@"title":titleString,
                              @"id":[NSString stringWithFormat:@"%ld",[[[titleStringArray objectAtIndex:tagInner] objectForKey:@"id"] longValue]]};
        LifeHelperListViewController *lhlVX = [[LifeHelperListViewController alloc] init];
        lhlVX.infoDictionary = dic;
        lhlVX.lifeGategroyArray = contentLifeHelperDataArray;
        [self.navigationController pushViewController:lhlVX animated:YES];
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
        lhpVC.lifeGategroyArray = [NSArray arrayWithArray:contentLifeHelperDataArray];
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
