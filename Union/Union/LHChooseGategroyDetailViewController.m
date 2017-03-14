//
//  LHChooseGategroyDetailViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LHChooseGategroyDetailViewController.h"

@interface LHChooseGategroyDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation LHChooseGategroyDetailViewController{
    UIView *contentView;

    UITableView *contentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigation];
    
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
    contentTableView.tag = 7202;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)reload{
    [contentTableView reloadData];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (self.detailArray && self.detailArray.count != 0) {
            return 45;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (self.detailArray) {
            return self.detailArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *LHChooseGategroyDetailViewCell11212 = @"LHChooseGategroyDetailViewCell11212";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LHChooseGategroyDetailViewCell11212];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LHChooseGategroyDetailViewCell11212];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIView *sepLine = [[UIView alloc] init];
            sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            sepLine.frame = (CGRect){0,45-0.5,WIDTH(tableView),0.5};
            [cell.contentView addSubview:sepLine];
            
            UIImageView *rightImage = [[UIImageView alloc] init];
            rightImage.image = [UIImage imageNamed:@"more"];
            rightImage.frame = (CGRect){WIDTH(tableView)-15-7,(45-11)/2,7,11};
            [cell.contentView addSubview:rightImage];
        }
        //        cell.adressInfo = contentDataArray[indexPath.row];
        NSDictionary *dic = self.detailArray[indexPath.row];
        NSString *nodeName = dic[@"name"];
        cell.textLabel.text = nodeName;
        cell.textLabel.textColor = RGBColor(80, 80, 80);
        cell.textLabel.font = Font(15);
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        NSDictionary *dic = self.detailArray[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.resultBlock) {
            self.resultBlock(dic);
        }
    }
}

#pragma mark -
-(void)setUpNavigation{
    
    UIView *naviView = [[UIView alloc] initWithFrame:(CGRect){0,0,WIDTH(self.view),UN_NarbarHeight}];
    naviView.backgroundColor = UN_RedColor;
    [self.view addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = (CGRect){0,20,WIDTH(naviView),HEIGHT(naviView)-20};
    titleLabel.textColor = UN_Navigation_FontColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(18);
    titleLabel.text = self.chooseTitle;
    [naviView addSubview:titleLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    leftButton.frame = (CGRect){0,20,50,HEIGHT(naviView)-20};
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = Font(14);
    [leftButton addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:leftButton];
}

-(void)leftItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.resultBlock) {
        self.resultBlock(nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
