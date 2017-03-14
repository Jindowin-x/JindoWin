//
//  SearchViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/21.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "SearchViewController.h"
#import "ShopDetailViewController.h"

#import "UNUrlConnection.h"

#import "AFNetworking.h"
#import "UIScrollView+XYRefresh.h"
#import "XYAnimateTagsView.h"

@interface SearchViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@end

@implementation SearchViewController{
    UISearchBar *topSearchBar;
    
    XYAnimateTagsView *searchTagsView;
    
    NSArray *searchHistoryDataArray;
    
    UITableView *searchHistoryTableView;
    UIButton *tableBottomButton;
    
    UITableView *searchResultTableView;
    NSMutableArray *searchResultDataArray;
    
    AFHTTPRequestOperation *searchOperation;
    
    int currentSearchPageIndex;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //必须在这里设置navigation  不能在viewwillappear中设置不然 weak 的 searchbar指针会为空
    [self setUpNavigation];
    
    self.view.backgroundColor = UN_WhiteColor;
    
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
    
    float hotSearchViewHeight = 150.f;
    
    UIView *hotSearchView = [[UIView alloc] init];
    hotSearchView.frame = (CGRect){0,0,WIDTH(contentView),hotSearchViewHeight};
    hotSearchView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:hotSearchView];
    
    UILabel *hotSearchNoteLabel = [[UILabel alloc] init];
    hotSearchNoteLabel.text = @"热门搜索";
    hotSearchNoteLabel.textAlignment = NSTextAlignmentLeft;
    hotSearchNoteLabel.textColor = RGBColor(80, 80, 80);
    hotSearchNoteLabel.frame = (CGRect){10,0,WIDTH(hotSearchView)-20,30};
    hotSearchNoteLabel.font = Font(14);
    [hotSearchView addSubview:hotSearchNoteLabel];
    //    hotSearchNoteLabel.backgroundColor = [UIColor redColor];
    
    UIView *seplineView = [[UIView alloc] init];
    seplineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    seplineView.frame = (CGRect){0,BOTTOM(hotSearchNoteLabel)-0.5,WIDTH(hotSearchView),0.5};
    [hotSearchView addSubview:seplineView];
    
    UIView *hotSearchSeplineView = [[UIView alloc] init];
    hotSearchSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    hotSearchSeplineView.frame = (CGRect){0,HEIGHT(hotSearchView)-0.5,WIDTH(hotSearchView),0.5};
    [hotSearchView addSubview:hotSearchSeplineView];
    
    weak(weaktopSearchBar, topSearchBar);
    weak(weakself, self);
    
    searchTagsView = [[XYAnimateTagsView alloc] initWithFrame:(CGRect){10,BOTTOM(hotSearchNoteLabel),WIDTH(hotSearchView)-20,40} rowNumbers:3];
    searchTagsView.tagsArray = @[@"被套",@"床单",@"四件套",@"水果",@"米饭",@"鲜花"];
    searchTagsView.tagClickBlock = ^(NSString *str){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *searchText = str;
            [weaktopSearchBar setText:searchText];
            [weakself searchBar:weaktopSearchBar textDidChange:searchText];
            
            [UNUserDefaults saveSearchHistoryString:searchText];
            [weakself reloadHistoryTable];
        });
    };
    [searchTagsView draw];
    [hotSearchView addSubview:searchTagsView];
    
    UITapGestureRecognizer *contentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapGesture)];
    [hotSearchView addGestureRecognizer:contentTapGesture];
    
    searchHistoryTableView = [[UITableView alloc] initWithFrame:(CGRect){0,BOTTOM(hotSearchView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(hotSearchView)} style:UITableViewStylePlain];
    searchHistoryTableView.backgroundColor = [UIColor whiteColor];
    searchHistoryTableView.tag = 1101;
    searchHistoryTableView.delegate = self;
    searchHistoryTableView.dataSource = self;
    searchHistoryTableView.showsHorizontalScrollIndicator = NO;
    searchHistoryTableView.showsVerticalScrollIndicator = NO;
    searchHistoryTableView.backgroundColor = UN_WhiteColor;
    [contentView addSubview:searchHistoryTableView];
    
    
    UIView *historyTopView = [[UIView alloc] init];
    historyTopView.frame = (CGRect){0,0,WIDTH(searchHistoryTableView),30};
    historyTopView.backgroundColor = searchHistoryTableView.backgroundColor;
    searchHistoryTableView.tableHeaderView = historyTopView;
    
    UILabel *tableTopNoteLabel = [[UILabel alloc] init];
    tableTopNoteLabel.text = @"搜索历史";
    tableTopNoteLabel.textAlignment = NSTextAlignmentLeft;
    tableTopNoteLabel.textColor = RGBColor(80, 80, 80);
    tableTopNoteLabel.frame = (CGRect){10,0,WIDTH(historyTopView)-20,30};
    tableTopNoteLabel.font = Font(14);
    [historyTopView addSubview:tableTopNoteLabel];
    
    UIView *tableTopSearchSeplineView = [[UIView alloc] init];
    tableTopSearchSeplineView.frame = (CGRect){0,HEIGHT(historyTopView)-0.5,WIDTH(historyTopView),0.5};
    tableTopSearchSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.1);
    [historyTopView addSubview:tableTopSearchSeplineView];
    
    
    tableBottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tableBottomButton.frame = (CGRect){0,0,WIDTH(searchHistoryTableView),45};
    [tableBottomButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [tableBottomButton setTitleColor:RGBColor(120, 120, 120) forState:UIControlStateNormal];
    tableBottomButton.titleLabel.font = Font(15);
    searchHistoryTableView.tableFooterView = tableBottomButton;
    [tableBottomButton addTarget:self action:@selector(tableBottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tableBottomButtonSeplineView = [[UIView alloc] init];
    tableBottomButtonSeplineView.frame = (CGRect){15,1,WIDTH(tableBottomButton),1};
    tableBottomButtonSeplineView.backgroundColor = RGBAColor(200, 200, 200, 0.6);
    [tableBottomButton addSubview:tableBottomButtonSeplineView];
    
    [self reloadHistoryTable];
    
    searchResultTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    searchResultTableView.backgroundColor = [UIColor whiteColor];
    searchResultTableView.tag = 1102;
    searchResultTableView.alpha = 0;
    searchResultTableView.delegate = self;
    searchResultTableView.dataSource = self;
    searchResultTableView.showsHorizontalScrollIndicator = NO;
    searchResultTableView.showsVerticalScrollIndicator = NO;
    searchResultTableView.backgroundColor = UN_WhiteColor;
    searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:searchResultTableView];
    
    [searchResultTableView initDownRefresh];
    
    [searchResultTableView initPullUpRefresh];
    
    [searchResultTableView setDownRefreshBlock:^(id refreshView){
        [weakself reloadResultTableViewWithIndex:1];
    }];
    
    [searchResultTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself reloadResultTableViewWithIndex:currentSearchPageIndex+1];
    }];
    
    currentSearchPageIndex = 1;
    [self getAllHotSearchList];
}

-(void)getAllHotSearchList{
    [UNUrlConnection getAllHotSearchKeywordsComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        // todo 服务器返回多了一个s
        NSDictionary *messageDic = resultDic[@"messsage"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *contentDic = resultDic[@"content"];
            
            NSArray *hotArray = contentDic[@"hotsearches"];
            
            if (hotArray && [hotArray isKindOfClass:[NSArray class]] && hotArray.count > 0) {
                searchTagsView.tagsArray = hotArray;
                [searchTagsView draw];
            }
        }else{
            NSString *content = messageDic[@"content"];
            if (!content) {
                content = @"连接服务器失败,请重试";
            }
            [BYToastView showToastWithMessage:content];
        }
    }];
}


-(void)reloadResultTableViewWithIndex:(int)pageIndex{
    [searchOperation cancel];
    
    NSString *searchText = topSearchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!searchText || [searchText isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"搜索关键词不能为空"];
        return;
    }
    if ([searchText rangeOfString:@"*"].length > 0 ||
        [searchText rangeOfString:@"&"].length > 0 ||
        [searchText rangeOfString:@"#"].length > 0 ||
        [searchText rangeOfString:@"!"].length > 0 ||
        [searchText rangeOfString:@"|"].length > 0 ||
        [searchText rangeOfString:@"?"].length > 0 ) {
        [BYToastView showToastWithMessage:@"搜索关键词不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:searchText forKey:@"keyword"];
    [paramsDic setObject:@(pageIndex) forKey:@"pageNumber"];
    [paramsDic setObject:@(20) forKey:@"pageSize"];
    
    searchOperation = [UNUrlConnection searchShopsWithParmas:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        [searchResultTableView endDownRefresh];
        [searchResultTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *contentArray = resultDic[@"content"];
            NSMutableArray *tmpArray = [NSMutableArray array];
            [contentArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                ShopInfo *info = [ShopInfo shopInfoWithNetWorkDictionary:obj];
                [tmpArray addObject:info];
            }];
            
            if (pageIndex == 1) {
                searchResultDataArray = [NSMutableArray array];
            }
            
            if (tmpArray.count > 0) {
                [searchResultDataArray addObjectsFromArray:tmpArray];
                currentSearchPageIndex = pageIndex;
                
            }else{
                [BYToastView showToastWithMessage:@"无数据"];
            }
            searchResultTableView.alpha = 1.f;
            [searchResultTableView reloadData];
        }else{
            NSString *content = messageDic[@"content"];
            if (!content) {
                content = @"连接服务器失败,请重试";
            }
            [BYToastView showToastWithMessage:content];
        }
    }];
    
    return;
    searchResultDataArray = [NSMutableArray array];
    
    ShopInfo *info1 = [[ShopInfo alloc] init];
    info1.name = @"味必鲜排骨米饭";
    info1.isSelfDelivery = YES;
    info1.businessState = ShopInfoBusinessStateOpen;
    info1.minBuyNumber = 30;
    info1.deliveryNumber = 5;
    info1.starJudge = 3.5;
    info1.monthSaleNumber = 99;
    info1.juanEnabel = YES;
    info1.piaoEnabel = YES;
    info1.fuEnabel = YES;
    info1.peiEnabel = YES;
    info1.deliveryAverage = @"44";
    info1.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    info1.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    info1.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
                                @"特" :  @"本店参加917吃货节14:00档",
                                @"减": @"满90元减20元"};
    
    
    ShopInfo *info2 = [[ShopInfo alloc] init];
    info2.name = @"天禧海鲜馆";
    info2.isSelfDelivery = YES;
    info2.businessState = ShopInfoBusinessStateOpen;
    info2.minBuyNumber = 50;
    info2.deliveryNumber = 0;
    info2.starJudge = 4;
    info2.monthSaleNumber = 99;
    info2.peiEnabel = YES;
    info2.deliveryAverage = @"44";
    info2.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    info2.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    info2.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",};
    
    
    ShopInfo *info3 = [[ShopInfo alloc] init];
    info3.name = @"民以食为天";
    info3.businessState = ShopInfoBusinessStateBreak;
    info3.minBuyNumber = 50;
    info3.deliveryNumber = 0;
    info3.starJudge = 3;
    info3.monthSaleNumber = 99;
    info3.piaoEnabel = YES;
    info3.deliveryAverage = @"44";
    info3.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    info3.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    info3.huodongDictionary = @{@"减": @"新用户在线支付满30减5元",
                                @"特" :  @"本店参加双十一特价满20减10",};
    
    
    ShopInfo *info4 = [[ShopInfo alloc] init];
    info4.name = @"锅巴饭";
    info4.isSelfDelivery = YES;
    info4.businessState = ShopInfoBusinessStateBreak;
    info4.minBuyNumber = 25;
    info4.deliveryNumber = 0;
    info4.starJudge = 4.5;
    info4.monthSaleNumber = 99;
    info4.fuEnabel = YES;
    info4.deliveryAverage = @"44";
    info4.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    info4.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    info4.huodongDictionary = @{@"新": @"新用户在线支付满30减5元"};
    
    
    ShopInfo *info5 = [[ShopInfo alloc] init];
    info5.name = @"油焖大虾";
    info5.businessState = ShopInfoBusinessStateBreak;
    info5.minBuyNumber = 10;
    info5.deliveryNumber = 10;
    info5.starJudge = 5;
    info5.monthSaleNumber = 1034;
    info5.fuEnabel = YES;
    info5.deliveryAverage = @"44";
    info5.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    info5.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    info5.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
                                @"特" :  @"本店参加双十一特价满20减10",};
    
    
    [searchResultDataArray addObject:@{@"title":@"商户",
                                       @"data":@[info1,info2,info3,info4,info5]
                                       }];
    
    ShopItem *item1 = [[ShopItem alloc] init];
    item1.shopName = @"锅巴饭";
    item1.itemName = @"黄焖鸡";
    item1.price = 17.5;
    
    ShopItem *item2 = [[ShopItem alloc] init];
    item2.shopName = @"油焖大虾";
    item2.itemName = @"黄焖大虾";
    item2.price = 88;
    
    ShopItem *item3 = [[ShopItem alloc] init];
    item3.shopName = @"川渝小吃";
    item3.itemName = @"川";
    item3.price = 10;
    
    [searchResultDataArray addObject:@{@"title":@"商品",
                                       @"data":@[item1,item2,item3]
                                       }];
    searchResultTableView.alpha = 1.f;
    [searchResultTableView reloadData];
}

-(void)tableBottomButtonClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清楚所有的搜索记录吗?该操作不可恢复" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"删除", nil];
    alert.tag = 9091;
    [alert show];
}

-(void)reloadHistoryTable{
    searchHistoryDataArray = [UNUserDefaults getAllSearchHistory];
    if (!searchHistoryDataArray || searchHistoryDataArray.count == 0) {
        searchHistoryTableView.tableFooterView = [UIView new];
    }else{
        searchHistoryTableView.tableFooterView = tableBottomButton;
    }
    [searchHistoryTableView reloadData];
}

-(void)resignAllInput{
    [topSearchBar resignFirstResponder];
}

-(void)contentTapGesture{
    [self resignAllInput];
}

#pragma mark - tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == searchHistoryTableView) {
        return 1;
    }else if (tableView == searchResultTableView){
        //        return 2;
        return 1;
    }
    return 0;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView == searchHistoryTableView) {
//        return nil;
//    }else if (tableView == searchResultTableView) {
//        NSString *titleString = [searchResultDataArray[section] objectForKey:@"title"];
//        UIView *view = [[UIView alloc] init];
//        view.frame = (CGRect){0,0,WIDTH(tableView),35};
//        view.backgroundColor = RGBColor(240, 240, 240);
//        
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.text = titleString;
//        titleLabel.frame = (CGRect){15,0,WIDTH(view),HEIGHT(view)};
//        titleLabel.textColor = RGBColor(120, 120, 120);
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.font = Font(15);
//        [view addSubview:titleLabel];
//        return view;
//    }
//    return nil;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView == searchHistoryTableView) {
//        return 0;
//    }else if (tableView == searchResultTableView){
//        return 35;
//    }
//    return 0;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == searchHistoryTableView) {
        return 45;
    }else if (tableView == searchResultTableView){
        return 60;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == searchHistoryTableView) {
        if (searchHistoryDataArray && searchHistoryDataArray.count != 0) {
            return searchHistoryDataArray.count;
        }else{
            return 1;
        }
    }else if (tableView == searchResultTableView){
        //        return [searchResultDataArray[section] count];
        return [searchResultDataArray count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == searchHistoryTableView) {
        static NSString *UITableViewCellSearchHistoryIdentifier1101 = @"UITableViewCellSearchHistoryIdentifier1101";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellSearchHistoryIdentifier1101];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UITableViewCellSearchHistoryIdentifier1101];
            cell.backgroundColor = tableView.backgroundColor;
            cell.textLabel.textColor = RGBColor(120, 120, 120);
            cell.textLabel.font = Font(15);
            cell.imageView.hidden = YES;
        }
        if (!searchHistoryDataArray || searchHistoryDataArray.count == 0) {
            cell.textLabel.text = @"无搜索记录";
        }else{
            cell.textLabel.text = searchHistoryDataArray[searchHistoryDataArray.count-indexPath.row-1];
        }
        return cell;
    }else if (tableView == searchResultTableView){
        static NSString *shanghu_UITableViewCellSearchResultIdentifier1102 = @"shanghu_UITableViewCellSearchResultIdentifier1102";
        SearchShopHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shanghu_UITableViewCellSearchResultIdentifier1102];
        if (!cell) {
            cell = [[SearchShopHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:shanghu_UITableViewCellSearchResultIdentifier1102];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        ShopInfo *info = [searchResultDataArray objectAtIndex:indexPath.row];
        cell.shopInfo = info;
        return cell;
        
        
        //        NSDictionary *dic = [searchResultDataArray objectAtIndex:indexPath.section];
        //        NSString *title = [dic objectForKey:@"title"];
        //        NSArray *dataArray = [dic objectForKey:@"data"];
        //        if ([title isEqualToString:@"商户"]) {
        //            static NSString *shanghu_UITableViewCellSearchResultIdentifier1102 = @"shanghu_UITableViewCellSearchResultIdentifier1102";
        //            SearchShopHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shanghu_UITableViewCellSearchResultIdentifier1102];
        //            if (!cell) {
        //                cell = [[SearchShopHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:shanghu_UITableViewCellSearchResultIdentifier1102];
        //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //                cell.backgroundColor = [UIColor whiteColor];
        //            }
        //            ShopInfo *info = [dataArray objectAtIndex:indexPath.row];
        //            cell.shopInfo = info;
        //            return cell;
        //        }else if ([title isEqualToString:@"商品"]){
        //            static NSString *shangpin_UITableViewCellSearchResultIdentifier1102 = @"shangpin_UITableViewCellSearchResultIdentifier1102";
        //            SearchShopItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shangpin_UITableViewCellSearchResultIdentifier1102];
        //            if (!cell) {
        //                cell = [[SearchShopItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:shangpin_UITableViewCellSearchResultIdentifier1102];
        //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //                cell.backgroundColor = [UIColor whiteColor];
        //            }
        //            ShopItem *item = [dataArray objectAtIndex:indexPath.row];
        //            cell.shopItem = item;
        //            return cell;
        //        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == searchHistoryTableView) {
        if (searchHistoryDataArray && searchHistoryDataArray.count != 0) {
            NSString *searchText = searchHistoryDataArray[searchHistoryDataArray.count-indexPath.row-1];
            [topSearchBar setText:searchText];
            [UNUserDefaults saveSearchHistoryString:searchText];
            [self searchBar:topSearchBar textDidChange:searchText];
        }
    }else if (tableView == searchResultTableView){
        ShopInfo *info = [searchResultDataArray objectAtIndex:indexPath.row];
        ShopDetailViewController *sdVC = [[ShopDetailViewController alloc] init];
        sdVC.shopInfo = info;
        [self.navigationController pushViewController:sdVC animated:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [topSearchBar resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 9091) {
        if (buttonIndex == 1) {
            [UNUserDefaults removeAllSearchHistory];
            [self reloadHistoryTable];
        }
    }
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        searchResultTableView.alpha = 0.f;
        [self reloadHistoryTable];
    }else{
        [self reloadResultTableViewWithIndex:1];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText = topSearchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [UNUserDefaults saveSearchHistoryString:searchText];
    [self reloadHistoryTable];
    
    [self reloadResultTableViewWithIndex:1];
    
    [self resignAllInput];
}

#pragma mark - UpNavigation
-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view)-20-50, 44)];
    self.navigationItem.titleView = searchView;
    
    //导航条的搜索条
    topSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,WIDTH(searchView),44.0f)];
    topSearchBar.delegate = self;
    [topSearchBar setTintColor:UN_RedColor];
    [topSearchBar setPlaceholder:@"输入商户或商品名称"];
    topSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    topSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [topSearchBar setBackgroundImage:[UIImage new]];
    topSearchBar.translucent = YES;
    [searchView addSubview:topSearchBar];
}

-(void)leftItemClick{
    [topSearchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation SearchShopHouseTableViewCell{
    UIView *sepLineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(17);
        self.textLabel.textColor = RGBColor(80, 80, 80);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(150, 150, 150);
        self.detailTextLabel.font = Font(13);
        
        sepLineView = [[UIView alloc] init];
        sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){15,8,WIDTH(self.contentView)-30,17};
    //    self.textLabel.backgroundColor = [UIColor redColor];
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+10,WIDTH(self.contentView)-30,13};
    //    self.detailTextLabel.backgroundColor = [UIColor yellowColor];
    
    sepLineView.frame = (CGRect){15,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView)-30,0.5};
}

-(void)setShopInfo:(ShopInfo *)shopInfo{
    if (shopInfo) {
        _shopInfo = shopInfo;
        
        self.textLabel.text = shopInfo.name;
        
        float minbuy = shopInfo.minBuyNumber;
        float deliveryNum = shopInfo.deliveryNumber;
        
        NSString *minBuyString;
        if (minbuy <= 0.1) {
            minBuyString = @"无起送费";
        }
        
        if ((minbuy*10)-((int)minbuy)*10 == 0) {
            minBuyString = [NSString stringWithFormat:@"起送费 ￥%d",(int)minbuy];
        }else{
            minBuyString = [NSString stringWithFormat:@"起送费 ￥%.1f",minbuy];
        }
        
        NSString *deliveryString;
        if (deliveryNum <= 0.1) {
            deliveryString = @"无配送费";
        }
        
        if ((deliveryNum*10)-((int)deliveryNum)*10 == 0) {
            deliveryString = [NSString stringWithFormat:@"配送费 ￥%d",(int)deliveryNum];
        }else{
            deliveryString = [NSString stringWithFormat:@"配送费 ￥%.1f",deliveryNum];
        }
        
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",minBuyString,deliveryString];
    }
}

@end

@implementation SearchShopItemTableViewCell{
    UILabel *priceLabel;
    UIView *sepLineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(17);
        self.textLabel.textColor = RGBColor(80, 80, 80);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(150, 150, 150);
        self.detailTextLabel.font = Font(13);
        
        priceLabel = [[UILabel alloc] init];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = UN_RedColor;
        priceLabel.font = Font(18);
        [self.contentView addSubview:priceLabel];
        
        sepLineView = [[UIView alloc] init];
        sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:sepLineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){15,8,WIDTH(self.contentView)-15-15-100,17};
    //    self.textLabel.backgroundColor = [UIColor redColor];
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+10,WIDTH(self.contentView)-15-15-100,13};
    //    self.detailTextLabel.backgroundColor = [UIColor yellowColor];
    
    priceLabel.frame = (CGRect){WIDTH(self.contentView)-15-100,0,100,HEIGHT(self.contentView)};
    
    sepLineView.frame = (CGRect){15,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView)-30,0.5};
}

-(void)setShopItem:(ShopItem *)shopItem{
    _shopItem = shopItem;
    if (shopItem) {
        self.textLabel.text = shopItem.itemName;
        
        self.detailTextLabel.text = shopItem.shopName;
        
        float price = shopItem.price;
        NSString *priceString;
        if ((price*10)-((int)price)*10 == 0) {
            priceString = [NSString stringWithFormat:@"￥%d",(int)price];
        }else{
            priceString = [NSString stringWithFormat:@"￥%.1f",price];
        }
        priceLabel.text = priceString;
    }
}

@end
