//
//  MapAddressViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/19.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MapAddressViewController.h"

#import "BYToastView.h"
#import "UNUserDefaults.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MapAddressViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@end

@implementation MapAddressViewController{
    UISearchBar *topSearchBar;
    
    CLLocationCoordinate2D currentLocation;
    BMKPoiInfo *currentLocationPoiInfo;
    
    BMKMapView *contentMapView;
    
    BOOL beenLocated;
    BMKLocationService *service;
    BMKLocationViewDisplayParam *locationParam;
    
    UIView *tableIndicatorView;
    UITableView *locationTableView;
    NSMutableArray *locationDataArray;
    
    BMKPoiSearch *poiSearch;
    BMKGeoCodeSearch *searcher;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"选择地点";
    
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
    
    contentMapView = [[BMKMapView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),WIDTH(contentView)*3/4.f}];
    contentMapView.delegate = self;
    [contentView addSubview:contentMapView];
    contentMapView.rotateEnabled = NO;
    contentMapView.zoomLevel = 15;
    contentMapView.minZoomLevel = 5;
    contentMapView.maxZoomLevel = 25;
    
    UIImageView *centerLocationImage = [[UIImageView alloc] init];
    centerLocationImage.image = [UIImage imageNamed:@"icon_location"];
    centerLocationImage.frame = (CGRect){(WIDTH(contentMapView)-21)/2,(HEIGHT(contentMapView))/2-21,21,21};
    [contentMapView addSubview:centerLocationImage];
    
    locationTableView = [[UITableView alloc] initWithFrame:(CGRect){0,BOTTOM(contentMapView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(contentMapView)} style:UITableViewStylePlain];
    locationTableView.backgroundColor = [UIColor whiteColor];
    locationTableView.tag = 6111;
    locationTableView.delegate = self;
    locationTableView.dataSource = self;
    locationTableView.showsHorizontalScrollIndicator = NO;
    locationTableView.showsVerticalScrollIndicator = NO;
    locationTableView.tableFooterView = [UIView new];
    [contentView addSubview:locationTableView];
    
    tableIndicatorView = [[UIView alloc] init];
    tableIndicatorView.frame = (CGRect){0,BOTTOM(contentMapView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(contentMapView)};
    tableIndicatorView.alpha = 0;
    [contentView addSubview:tableIndicatorView];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [tableIndicatorView addSubview:indicatorView];
    [indicatorView startAnimating];
    indicatorView.hidesWhenStopped = NO;
    CenterSubView(indicatorView);
    
    locationParam = [[BMKLocationViewDisplayParam alloc] init];
    locationParam.isAccuracyCircleShow = NO;
    locationParam.isRotateAngleValid = NO;
}

-(void)tableBecomeSearchType{
    [UIView animateWithDuration:0.3 animations:^{
        locationTableView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    }];
}

-(void)tableBecomeLocationType{
    [UIView animateWithDuration:0.3 animations:^{
        locationTableView.frame = (CGRect){0,BOTTOM(contentMapView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(contentMapView)};
    }];
}

-(void)startLocateUserLocation{
    if (!service) {
        service = [[BMKLocationService alloc] init];
        service.delegate = self;
        //启动LocationService
    }
    beenLocated = NO;
    [service startUserLocationService];
}

-(void)startSearchWithLocation:(CLLocationCoordinate2D)location{
    if (!searcher) {
        searcher =[[BMKGeoCodeSearch alloc]init];
    }
    searcher.delegate = self;
    //发起检索
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = location;
    BOOL flag = [searcher reverseGeoCode:option];
    if(flag){
        tableIndicatorView.alpha = 1;
    }else{
        NSLog(@"反地址编码解析查询发送失败");
    }
}

-(void)startSearchWithKeyWord:(NSString *)key{
    if (currentLocation.latitude == 0 || currentLocation.longitude == 0) {
        [BYToastView showToastWithMessage:@"等待定位..."];
        return;
    }
    
    if (!poiSearch) {
        poiSearch =[[BMKPoiSearch alloc]init];
    }
    poiSearch.delegate = self;
    //发起检索
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.location = currentLocation;
    option.radius = 10;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    
    option.keyword = key;
    option.pageIndex = 0;
    option.pageCapacity = 50;
    
    BOOL flag = [poiSearch poiSearchNearBy:option];
    if(flag){
        tableIndicatorView.alpha = 1;
    }else{
        NSLog(@"反地址编码解析查询发送失败");
    }
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == locationTableView) {
        return 50;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == locationTableView) {
        if (locationDataArray) {
            return locationDataArray.count;
        }else{
            return 1;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == locationTableView) {
        static NSString *UITableViewCellMapAddressIdentifier6111 = @"UITableViewCellMapAddressIdentifier6111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellMapAddressIdentifier6111];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UITableViewCellMapAddressIdentifier6111];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = tableView.backgroundColor;
            cell.imageView.image = [UIImage imageNamed:@"icon_location"];
            cell.textLabel.font = Font(16);
            cell.detailTextLabel.font = Font(13);
        }
        if (!locationDataArray) {
            cell.imageView.hidden = YES;
            cell.textLabel.text = @"未查询到任何结果";
            cell.textLabel.textColor = RGBColor(80, 80, 80);
            cell.detailTextLabel.text = @"";
        }else{
            cell.imageView.hidden = NO;
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.textColor = RGBColor(120, 120, 120);
            BMKPoiInfo *poi = [locationDataArray objectAtIndex:indexPath.row];
            NSString *name = poi.name;
            NSString *address = poi.address;
            
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"[当前]%@",name];
                cell.detailTextLabel.text = address;
                cell.textLabel.textColor = UN_RedColor;
            }else{
                cell.textLabel.text = name;
                cell.detailTextLabel.text = address;
                cell.textLabel.textColor = RGBColor(80, 80, 80);
            }
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (locationDataArray) {
        BMKPoiInfo *poi = [locationDataArray objectAtIndex:indexPath.row];
        if (self.resultBlock) {
            self.resultBlock(poi.name,poi.address,poi.pt.latitude,poi.pt.longitude);
        }
        [self leftItemClick];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [topSearchBar resignFirstResponder];
}

#pragma mark - BMKMapViewDelegate

/**
 *地图初始化完毕时会调用此接口
 *@param mapview 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    [self startLocateUserLocation];
}

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (beenLocated) {
        [self startSearchWithLocation:mapView.centerCoordinate];
    }
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"%f,%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
//}

#pragma mark - BMKLocationServiceDelegate
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    beenLocated = NO;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //以下_mapView为BMKMapView对象
    contentMapView.showsUserLocation = YES;//显示定位图层
    [contentMapView updateLocationData:userLocation];
    [contentMapView updateLocationViewWithParam:locationParam];
    
    currentLocation = userLocation.location.coordinate;
    
    [contentMapView setCenterCoordinate:currentLocation animated:YES];
    
    [contentMapView mapForceRefresh];
    
    [service stopUserLocationService];
    
    beenLocated = YES;
    
    
    
    [self startSearchWithLocation:userLocation.location.coordinate];
}

///搜索delegate，用于获取搜索结果
#pragma mark -  BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    //    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
    //    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    //    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    //    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    //    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    //    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    //    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    //    BMK_SEARCH_KEY_ERROR,///<key错误
    //    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    //    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
    //    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    
    tableIndicatorView.alpha = 0.f;
    
    if(errorCode != BMK_SEARCH_NO_ERROR){
        NSString *errorString;
        switch (errorCode) {
            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
                errorString = @"检索词有岐义";
                break;
            case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
                errorString = @"检索地址有岐义";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS:
                errorString = @"该城市不支持公交搜索";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
                errorString = @"不支持跨城市公交";
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:
                errorString = @"没有找到检索结果";
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:
                errorString = @"起终点太近";
                break;
            case BMK_SEARCH_KEY_ERROR:
                errorString = @"key错误";
                break;
            case BMK_SEARCH_NETWOKR_ERROR:
                errorString = @"网络连接错误";
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:
                errorString = @"网络连接超时";
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:
                errorString = @"还未完成鉴权，请在鉴权通过后重试";
                break;
            default:
                break;
        }
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }
        locationDataArray = nil;
        [locationTableView reloadData];
        return;
    }
    if (poiResult.poiInfoList && poiResult.poiInfoList.count != 0) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:currentLocationPoiInfo];
        [array addObjectsFromArray:poiResult.poiInfoList];
        locationDataArray = array;
    }else{
        locationDataArray = nil;
    }
    [locationTableView reloadData];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)errorCode{
    //    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
    //    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    //    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    //    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    //    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    //    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    //    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    //    BMK_SEARCH_KEY_ERROR,///<key错误
    //    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    //    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
    //    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    
    tableIndicatorView.alpha = 0.f;
    
    if(errorCode != BMK_SEARCH_NO_ERROR){
        NSString *errorString;
        switch (errorCode) {
            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
                errorString = @"检索词有岐义";
                break;
            case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
                errorString = @"检索地址有岐义";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS:
                errorString = @"该城市不支持公交搜索";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
                errorString = @"不支持跨城市公交";
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:
                errorString = @"没有找到检索结果";
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:
                errorString = @"起终点太近";
                break;
            case BMK_SEARCH_KEY_ERROR:
                errorString = @"key错误";
                break;
            case BMK_SEARCH_NETWOKR_ERROR:
                errorString = @"网络连接错误";
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:
                errorString = @"网络连接超时";
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:
                errorString = @"还未完成鉴权，请在鉴权通过后重试";
                break;
            default:
                break;
        }
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }
        locationDataArray = nil;
        [locationTableView reloadData];
        return;
    }
//    if (result.poiList && result.poiList.count != 0) {
//        locationDataArray = result.poiList;
//    }else{
//        locationDataArray = nil;
//    }
//    [locationTableView reloadData];
    NSLog(@"%@,%f,%f",result.address,result.location.latitude,result.location.longitude);
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)errorCode{
    //    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
    //    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    //    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    //    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    //    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    //    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    //    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    //    BMK_SEARCH_KEY_ERROR,///<key错误
    //    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    //    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
    //    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    
    tableIndicatorView.alpha = 0.f;
    
    if(errorCode != BMK_SEARCH_NO_ERROR){
        NSString *errorString;
        switch (errorCode) {
            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
                errorString = @"检索词有岐义";
                break;
            case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
                errorString = @"检索地址有岐义";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS:
                errorString = @"该城市不支持公交搜索";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
                errorString = @"不支持跨城市公交";
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:
                errorString = @"没有找到检索结果";
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:
                errorString = @"起终点太近";
                break;
            case BMK_SEARCH_KEY_ERROR:
                errorString = @"key错误";
                break;
            case BMK_SEARCH_NETWOKR_ERROR:
                errorString = @"网络连接错误";
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:
                errorString = @"网络连接超时";
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:
                errorString = @"还未完成鉴权，请在鉴权通过后重试";
                break;
            default:
                break;
        }
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
        }
        return;
    }
    if (result.poiList && result.poiList.count != 0) {
        currentLocationPoiInfo = [result.poiList objectAtIndex:0];
        locationDataArray = [NSMutableArray arrayWithArray:result.poiList];
    }else{
        locationDataArray = nil;
    }
    [locationTableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self tableBecomeSearchType];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSString *text = searchBar.text;
    [self judgeSearchText:text];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self judgeSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self judgeSearchText:searchBar.text];
}

-(void)judgeSearchText:(NSString *)searchText{
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchText && ![searchText isEqualToString:@""]) {
        [self tableBecomeSearchType];
        [self startSearchWithKeyWord:searchText];
    }else{
        [self tableBecomeLocationType];
        [self startLocateUserLocation];
    }
}



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
    [topSearchBar setPlaceholder:@"输入地址检索"];
    [topSearchBar setBackgroundImage:[UIImage new]];
    topSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    topSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    topSearchBar.translucent = YES;
    [searchView addSubview:topSearchBar];
}

-(void)leftItemClick{
    [self.navigationController.view endEditing:YES];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    [contentMapView viewWillAppear];
    contentMapView.delegate = self;
    service.delegate = self;
    [service startUserLocationService];
    searcher.delegate = self;
    poiSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [contentMapView viewWillDisappear];
    contentMapView.delegate = nil;
    service.delegate = nil;
    searcher.delegate = nil;
    poiSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
