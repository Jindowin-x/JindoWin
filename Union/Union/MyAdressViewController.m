//
//  MyAdressViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyAdressViewController.h"

#import "AdressInfo.h"
#import "AdressTableViewCell.h"
#import "AddAddressViewController.h"

#import "UNUrlConnection.h"
#import "UNUserDefaults.h"

#import "UIScrollView+XYRefresh.h"

@interface MyAdressViewController ()<UITableViewDataSource,UITableViewDelegate,AdressTableViewCellDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSMutableArray *contentDataArray;

@end

@implementation MyAdressViewController

@synthesize contentView,contentTableView,contentDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的收货地址";
    
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
    
    weak(weakself, self);
    
    [contentTableView initDownRefresh];
    [contentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getAllReceiverAddress];
    }];
    
    [self reloadContentDataTableView];
}

-(void)reloadContentDataTableView{
    [self getAllReceiverAddress];
}

-(void)getAllReceiverAddress{
    [UNUrlConnection getAllReceiverListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        NSArray *array = resultDic[@"content"];
        if ([array isKindOfClass:[NSArray class]] && array && array.count != 0) {
            contentDataArray = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                NSString *detailaddress = obj[@"address"];
                NSString *mapaddress = obj[@"areaName"];
                NSString *name = obj[@"consignee"];
                NSString *idstring = obj[@"id"];
                BOOL isDefault = [obj[@"isDefault"] boolValue];
                NSString *phone = obj[@"phone"];
                NSString *zipCode = obj[@"zipCode"];
                NSString *sex = obj[@"sex"];
                NSString *latitudeString = obj[@"latitude"];
                NSString *longitudeString = obj[@"longitude"];
                
                int sexInt;
                if (sex) {
                    if (![sex isKindOfClass:[NSNull class]] && [sex isEqualToString:@"female"]) {
                        sexInt = 1;
                    }
                }
                
                float latitude,longitude;
                if (latitudeString && ![latitudeString isKindOfClass:[NSNull class]]) {
                    latitude = [obj[@"latitude"] floatValue];
                }
                if (longitudeString && ![longitudeString isKindOfClass:[NSNull class]]) {
                    longitude = [obj[@"longitude"] floatValue];
                }
                
                AdressInfo *adressInfo = [[AdressInfo alloc] init];
                adressInfo.addressID = [NSString stringWithFormat:@"%lld",[idstring longLongValue]];
                adressInfo.mapAdress = mapaddress;
                adressInfo.detailAdress = detailaddress;
                adressInfo.zipCode = zipCode;
                adressInfo.name = name;
                adressInfo.isDefault = isDefault;
                adressInfo.phone = phone;
                adressInfo.sex = sexInt;
                adressInfo.mapLatitude = latitude;
                adressInfo.mapLongitude = longitude;
                
                [contentDataArray addObject:adressInfo];
                
                [UNUserDefaults saveAdressInfo:adressInfo];
            }];
            
            runInMainThread(^{
                [contentTableView reloadData];
                [contentTableView endDownRefresh];
            });
        }
    }];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (contentDataArray && contentDataArray.count != 0) {
            return AdressCellViewHeight;
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
        static NSString *AdressTableViewCellIdentifier = @"AdressTableViewCell7101";
        AdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AdressTableViewCellIdentifier];
        if (!cell) {
            cell = [[AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AdressTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.adressInfo = contentDataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        AdressInfo *address = contentDataArray[indexPath.row];
        if (self.resultBlock) {
            self.resultBlock(address);
            [self.navigationController popViewControllerAnimated:YES];
            /**
             *  todo 有争议的地方 在选择地址的时候 是否将选择的地址作为默认的地址
             */
            [UNUserDefaults setDefaultAddressID:address.addressID];
        }else{
            AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
            aavc.addressInfo = address;
            [self.navigationController pushViewController:aavc animated:YES];
        }
    }
}

-(void)addressTableDidTapEditImage:(AdressTableViewCell *)cell{
    if (!cell.adressInfo) {
        return;
    }
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    aavc.addressInfo = cell.adressInfo;
    [self.navigationController pushViewController:aavc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == contentTableView){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != contentTableView) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AdressInfo *addressInfo = contentDataArray[indexPath.row];
        
        [UNUrlConnection deleteReceiveAddressWithAddressInfo:addressInfo complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:@"删除失败,请稍候重试"];
                runInMainThread(^{
                    [tableView reloadData];
                });
                return;
            }
            NSDictionary *messageDic = resultDic[@"message"];
            NSString *type = [messageDic objectForKey:@"type"];
            if (type && [type isKindOfClass:[NSString class]] && [type isEqualToString:@"success"]) {
                [BYToastView showToastWithMessage:@"删除收货地址成功"];
                runInMainThread(^{
                    [contentDataArray removeObject:addressInfo];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                    [tableView reloadData];
                });
                return;
            }else{
                NSString *content = [messageDic objectForKey:@"content"];
                if (content) {
                    [BYToastView showToastWithMessage:content];
                }else{
                    [BYToastView showToastWithMessage:@"删除失败,请稍候重试"];
                }
                runInMainThread(^{
                    [tableView reloadData];
                });
                return;
            }
        }];
    }
}

-(void)setUpNavigation{
    
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"新增" forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,30,20};
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(15);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:aavc animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    if (contentTableView) {
        [self reloadContentDataTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
