
//
//  LifeHelperDetailViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/29.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LifeHelperDetailViewController.h"
#import "LifeHelperListViewController.h"
#import "LifeHelperPostViewController.h"
#import "UserLoginViewController.h"

@interface LifeHelperDetailViewController ()

@end

@implementation LifeHelperDetailViewController{
    UIScrollView *contentScrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = [[self.infoDictionary objectForKey:@"node"] objectForKey:@"name"];
    if (!title) {
        title = @"分类详情";
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
    
    contentScrollerView = [[UIScrollView alloc] init];
    contentScrollerView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    contentScrollerView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:contentScrollerView];
    contentScrollerView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentScrollerView)+1};
    contentScrollerView.showsHorizontalScrollIndicator = NO;
    contentScrollerView.showsVerticalScrollIndicator = NO;
    
    NSArray *titleStringArray = [self.infoDictionary objectForKey:@"children"];
    if (titleStringArray && titleStringArray.count != 0) {
        float everyButtonWidth = (WIDTH(contentScrollerView)-10*2-5*2)/3;
        __block float offset = 0;
        [titleStringArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            NSUInteger xAligh = idx%3;
            NSUInteger yAligh = idx/3;
            
            NSString *titleString = dic[@"name"];
            UIButton *dataButton = [[UIButton alloc] init];
            dataButton.frame = (CGRect){10+xAligh*everyButtonWidth+xAligh*5,
                10+yAligh*40+yAligh*5,
                everyButtonWidth,
                40};
            [dataButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [dataButton setTitle:titleString forState:UIControlStateNormal];
            dataButton.titleLabel.font = Font(14);
            dataButton.tag = idx;
            dataButton.backgroundColor = RGBColor(253, 253, 253);
            dataButton.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
            dataButton.layer.borderWidth = 0.5;
            dataButton.layer.masksToBounds = YES;
            [contentScrollerView addSubview:dataButton];
            [dataButton addTarget:self action:@selector(dataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            offset = BOTTOM(dataButton)+5;
        }];
        
        if (offset <= HEIGHT(contentScrollerView)) {
            contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),HEIGHT(contentScrollerView)+1};
        }else{
            contentScrollerView.contentSize = (CGSize){WIDTH(contentScrollerView),offset};
        }
    }
}

-(void)dataButtonClick:(UIButton *)button{
    NSArray *titleStringArray = [self.infoDictionary objectForKey:@"children"];
    if (titleStringArray && titleStringArray.count != 0) {
        NSInteger tag = button.tag;
        if (tag < 0 || tag >  titleStringArray.count-1) {
            return;
        }
        NSDictionary *dic = @{@"title":[[titleStringArray objectAtIndex:tag] objectForKey:@"name"],
                              @"id":[NSString stringWithFormat:@"%ld",[[[titleStringArray objectAtIndex:tag] objectForKey:@"id"] longValue]]};
        LifeHelperListViewController *lhlVX = [[LifeHelperListViewController alloc] init];
        lhlVX.infoDictionary = dic;
        lhlVX.lifeGategroyArray = self.lifeGategroyArray;
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
