//
//  LHChooseGategroyViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LHChooseGategroyViewController.h"
#import "LHChooseGategroyDetailViewController.h"

@interface LHChooseGategroyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LHChooseGategroyViewController{
    UIView *contentView;
    
    UITableView *contentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择分类";
    
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
    contentTableView.tag = 7101;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (self.gategroyArray && self.gategroyArray.count != 0) {
            return 45;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (self.gategroyArray) {
            return self.gategroyArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *LHChooseGategroyViewCellIdentifier1111 = @"LHChooseGategroyViewCellIdentifier1111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LHChooseGategroyViewCellIdentifier1111];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LHChooseGategroyViewCellIdentifier1111];
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
        NSDictionary *dic = self.gategroyArray[indexPath.row];
        NSDictionary *nodeDic = dic[@"node"];
        NSString *nodeName = nodeDic[@"name"];
        cell.textLabel.text = nodeName;
        cell.textLabel.textColor = RGBColor(80, 80, 80);
        cell.textLabel.font = Font(15);
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        NSDictionary *dic = self.gategroyArray[indexPath.row];
        NSDictionary *nodeDic = dic[@"node"];
        NSString *nodeName = nodeDic[@"name"];
        NSArray *detailArray = dic[@"children"];
        
        LHChooseGategroyDetailViewController *lhcgdVC = [[LHChooseGategroyDetailViewController alloc] init];
        lhcgdVC.chooseTitle = nodeName;
        lhcgdVC.detailArray = detailArray;
        
        [lhcgdVC setResultBlock:^(NSDictionary *result){
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                if (self.completeBlock) {
                    self.completeBlock(nodeDic,result);
                }
            }
        }];
        [self presentViewController:lhcgdVC animated:YES completion:^{
            [lhcgdVC reload];
        }];
    }
}

#pragma mark -
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
