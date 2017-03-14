//
//  CityChooseViewController.m
//  Union
//
//  Created by xiaoyu on 16/1/17.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import "CityChooseViewController.h"

#import "UNUrlConnection.h"

@interface CityChooseViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CityChooseViewController {
    NSArray *contentDataArray;
    
    UITableView *contentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"省市区选择";
    
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
    contentTableView.tag = 17244;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self getAllProvinceList];
}

-(void)getAllProvinceList{
    [UNUrlConnection getAreaListWithID:self.parentID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *contentsArray = resultDic[@"content"];
            contentDataArray = contentsArray;
            
            [contentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"获取数据失败,请返回重试"];
            return;
        }
    }];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 17244) {
        if (contentDataArray && contentDataArray.count != 0) {
            return 40;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 17244) {
        if (contentDataArray) {
            return contentDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 17244) {
        static NSString *ProvinceTableCell17233 = @"ProvinceTableCell17233";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProvinceTableCell17233];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProvinceTableCell17233];
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        NSDictionary *listDic = contentDataArray[indexPath.row];
        cell.textLabel.text = listDic[@"name"];
        cell.textLabel.font = Font(14);
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 17244) {
        NSDictionary *listDic = contentDataArray[indexPath.row];
        if (self.stopType == ChooseStopTypeCity) {
            NSString *name = listDic[@"name"];
            if ([name rangeOfString:@"市"].length != 0) {
                if (self.resultBlock) {
                    self.resultBlock(listDic);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        
        if (self.stopType == ChooseStopTypeArea) {
            NSString *name = listDic[@"name"];
            if ([name rangeOfString:@"区"].length != 0) {
                if (self.resultBlock) {
                    self.resultBlock(listDic);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        
        AreaChooseViewController *areaChooseVC = [[AreaChooseViewController alloc] init];
        long parentsID = [listDic[@"id"] longValue];
        areaChooseVC.parentID = parentsID;
        if (self.resultBlock) {
            areaChooseVC.resultBlock = self.resultBlock;
        }
        if (self.navigationController) {
            [self.navigationController pushViewController:areaChooseVC animated:YES];
        }else{
            [self presentViewController:areaChooseVC animated:YES completion:nil];
        }
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
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
