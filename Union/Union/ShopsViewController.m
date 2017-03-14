//
//  ShopsViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/10.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopsViewController.h"

#import "ShopInfo.h"
#import "ShopsTableViewCell.h"

#import "ShopDetailViewController.h"
#import "SearchViewController.h"
#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"


@implementation SimpleSourceTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.imageView.backgroundColor = UN_RedColor;
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = Font(13);
        self.textLabel.textColor = RGBColor(100, 100, 100);
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){0,0,2,HEIGHT(self.contentView)};
    self.imageView.alpha = 0;
    self.textLabel.frame = (CGRect){0,0,WIDTH(self.contentView),HEIGHT(self.contentView)};
    
    
    [self.contentView bringSubviewToFront:self.imageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.backgroundColor = [UIColor whiteColor];
        self.imageView.alpha = 1;
    }else{
        self.textLabel.backgroundColor = RGBColor(235, 235, 235);
        self.imageView.alpha = 0;
    }
}

@end

@implementation DetailSourceTableCell{
    UIView *sepLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageView.image = [UIImage imageNamed:@"cellconfirm"];
        
        self.textLabel.font = Font(13);
        self.textLabel.textColor = RGBColor(100, 100, 100);
        
        sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UN_LineSeperateColor;
        [self.contentView addSubview:sepLine];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){WIDTH(self.contentView)-30,(HEIGHT(self.contentView)-15)/2,15,15};
    
    self.textLabel.frame = (CGRect){(GLOBALWIDTH/3-70)/2,0,WIDTH(self.contentView)-(GLOBALWIDTH/3-60)/2,HEIGHT(self.contentView)};
    
    sepLine.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.imageView.alpha = 1;
    }else{
        self.imageView.alpha = 0;
    }
}

@end

@implementation YouhuiSourceTableCell{
    UIView *sepLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = Font(12);
        self.textLabel.layer.cornerRadius = 10.f;
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.detailTextLabel.font = Font(14);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(80, 80, 80);
        
        sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UN_LineSeperateColor;
        [self.contentView addSubview:sepLine];
    }
    return self;
}

-(void)layoutSubviews{
    if (self.tagColor) {
        self.textLabel.backgroundColor = self.tagColor;
    }
    self.textLabel.frame = (CGRect){15,(HEIGHT(self)-20)/2,20,20};
    
    self.detailTextLabel.frame = (CGRect){RIGHT(self.textLabel)+15,(HEIGHT(self.contentView)-16)/2,WIDTH(self.contentView)-RIGHT(self.textLabel)-15,16};
    
    sepLine.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.detailTextLabel.textColor = UN_RedColor;
    }else{
        self.detailTextLabel.textColor = RGBColor(80, 80, 80);
    }
}

@end


@interface ShopsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *shopInfoTableView;

@property (nonatomic,strong) NSMutableArray *currentShopInfosDataArray;
@property (nonatomic,assign) int currentPageIndex;

@property (nonatomic,strong) UIButton *filteChooseMainView;
@property (nonatomic,strong) UITableView *allFenleiTableview1;
@property (nonatomic,strong) UITableView *allFenleiTableview2;
@property (nonatomic,strong) UITableView *allYouhuiTableview;
@property (nonatomic,strong) UITableView *allMoreTableview;

@end

@implementation ShopsViewController{
    UILabel *allSourceLabel,*allYouhuiLabel,*allMoreChooseLabel;
    
    NSArray *allSourceDataArray;
    
    NSArray *allYouhuiDataArray;
    
    NSArray *allMoreDataArray;
    
    NSArray *currentSourceTableDetailDataArray;
    
    float filteChooseTableHeight;
    
    int currentFilterYouhuiIndex;
    int currentFilterMoreIndex;
}

@synthesize contentView,shopInfoTableView;

@synthesize currentShopInfosDataArray;

@synthesize filteChooseMainView;

@synthesize allFenleiTableview1,allFenleiTableview2,allMoreTableview,allYouhuiTableview;

-(void)viewDidLoad{
    self.navigationItem.title = @"全部";
    
    //    self.view.backgroundColor = UN_WhiteColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //    [self setUpNavigation];
    
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)};
    [self.view addSubview:contentView];
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = (CGRect){0,0,WIDTH(contentView),44};
    headView.backgroundColor = UN_WhiteColor;
    [contentView addSubview:headView];
    
    UIButton *allSourceButton = [[UIButton alloc] init];
    allSourceButton.tag = 1;
    allSourceButton.frame = (CGRect){0,0,WIDTH(headView)/3,HEIGHT(headView)};
    [allSourceButton addTarget:self action:@selector(topbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:allSourceButton];
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    filteChooseMainView = [[UIButton alloc] init];
    filteChooseMainView.frame = (CGRect){0,UN_NarbarHeight+HEIGHT(headView),WIDTH(keyWindow),HEIGHT(keyWindow)-(UN_NarbarHeight+HEIGHT(headView))};
    filteChooseMainView.backgroundColor = RGBAColor(10, 10, 10, 0.6);
    //    [keyWindow addSubview:filteChooseMainView];
    [filteChooseMainView addTarget:self action:@selector(filteChooseMainViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    filteChooseTableHeight = 240;
    
    allFenleiTableview1 = [[UITableView alloc] init];
    allFenleiTableview1.frame = (CGRect){0,0,WIDTH(filteChooseMainView)/3,filteChooseTableHeight};
    [filteChooseMainView addSubview:allFenleiTableview1];
    allFenleiTableview1.backgroundColor = RGBColor(235, 235, 235);
    allFenleiTableview1.tag = 21011;
    allFenleiTableview1.delegate = self;
    allFenleiTableview1.dataSource = self;
    allFenleiTableview1.showsHorizontalScrollIndicator = NO;
    allFenleiTableview1.showsVerticalScrollIndicator = NO;
    allFenleiTableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allFenleiTableview2 = [[UITableView alloc] init];
    allFenleiTableview2.frame = (CGRect){WIDTH(filteChooseMainView)/3,0,WIDTH(filteChooseMainView)*2/3.f,filteChooseTableHeight};
    [filteChooseMainView addSubview:allFenleiTableview2];
    allFenleiTableview2.tag = 21012;
    allFenleiTableview2.delegate = self;
    allFenleiTableview2.dataSource = self;
    allFenleiTableview2.showsHorizontalScrollIndicator = NO;
    allFenleiTableview2.showsVerticalScrollIndicator = NO;
    allFenleiTableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allYouhuiTableview = [[UITableView alloc] init];
    allYouhuiTableview.frame = (CGRect){0,0,WIDTH(filteChooseMainView),filteChooseTableHeight};
    [filteChooseMainView addSubview:allYouhuiTableview];
    allYouhuiTableview.tag = 22011;
    allYouhuiTableview.delegate = self;
    allYouhuiTableview.dataSource = self;
    allYouhuiTableview.showsHorizontalScrollIndicator = NO;
    allYouhuiTableview.showsVerticalScrollIndicator = NO;
    allYouhuiTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allMoreTableview = [[UITableView alloc] init];
    allMoreTableview.frame = (CGRect){0,0,WIDTH(filteChooseMainView),filteChooseTableHeight};
    [filteChooseMainView addSubview:allMoreTableview];
    allMoreTableview.tag = 23011;
    allMoreTableview.delegate = self;
    allMoreTableview.dataSource = self;
    allMoreTableview.showsHorizontalScrollIndicator = NO;
    allMoreTableview.showsVerticalScrollIndicator = NO;
    allMoreTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    allSourceLabel = [[UILabel alloc] init];
    allSourceLabel.frame = (CGRect){10,0,WIDTH(allSourceButton)-10*2,HEIGHT(allSourceButton)};
    allSourceLabel.text = @"全部分类";
    allSourceLabel.textAlignment = NSTextAlignmentCenter;
    allSourceLabel.textColor = RGBColor(80, 80, 80);
    allSourceLabel.font = Font(14);
    allSourceLabel.tag = 192;
    [allSourceButton addSubview:allSourceLabel];
    
    UIImageView *xialaImage = [[UIImageView alloc] init];
    xialaImage.image = [UIImage imageNamed:@"xiala"];
    xialaImage.frame = (CGRect){WIDTH(allSourceButton)-20,(HEIGHT(allSourceButton)-4)/2,8,4};
    [allSourceButton addSubview:xialaImage];
    
    UIView *allSouceLineSepLine = [[UIView alloc] init];
    allSouceLineSepLine.frame = (CGRect){WIDTH(allSourceButton)-0.5,10,0.5,HEIGHT(allSourceButton)-10*2};
    allSouceLineSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.8);
    [allSourceButton addSubview:allSouceLineSepLine];
    
    UIButton *allYouhuiButton = [[UIButton alloc] init];
    allYouhuiButton.tag = 2;
    allYouhuiButton.frame = (CGRect){WIDTH(headView)/3,0,WIDTH(headView)/3,HEIGHT(headView)};
    [allYouhuiButton addTarget:self action:@selector(topbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:allYouhuiButton];
    
    allYouhuiLabel = [[UILabel alloc] init];
    allYouhuiLabel.frame = (CGRect){10,0,WIDTH(allYouhuiButton)-20,HEIGHT(allYouhuiButton)};
    allYouhuiLabel.text = @"优惠活动";
    allYouhuiLabel.textAlignment = NSTextAlignmentCenter;
    allYouhuiLabel.textColor = RGBColor(80, 80, 80);
    allYouhuiLabel.font = Font(14);
    allYouhuiLabel.tag = 192;
    [allYouhuiButton addSubview:allYouhuiLabel];
    
    UIImageView *xialaImage2 = [[UIImageView alloc] init];
    xialaImage2.image = [UIImage imageNamed:@"xiala"];
    xialaImage2.frame = (CGRect){WIDTH(allYouhuiButton)-20,(HEIGHT(allYouhuiButton)-4)/2,8,4};
    [allYouhuiButton addSubview:xialaImage2];
    
    UIView *allYouhuiLineSepLine = [[UIView alloc] init];
    allYouhuiLineSepLine.frame = (CGRect){WIDTH(allYouhuiButton)-0.5,10,0.5,HEIGHT(allYouhuiButton)-10*2};
    allYouhuiLineSepLine.backgroundColor = RGBAColor(200, 200, 200, 0.8);
    [allYouhuiButton addSubview:allYouhuiLineSepLine];
    
    UIButton *allMoreChooseButton = [[UIButton alloc] init];
    allMoreChooseButton.tag = 3;
    allMoreChooseButton.frame = (CGRect){WIDTH(headView)/3*2,0,WIDTH(headView)/3,HEIGHT(headView)};
    [headView addSubview:allMoreChooseButton];
    [allMoreChooseButton addTarget:self action:@selector(topbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    allMoreChooseLabel = [[UILabel alloc] init];
    allMoreChooseLabel.frame = (CGRect){10,0,WIDTH(allMoreChooseButton)-20,HEIGHT(allMoreChooseButton)};
    allMoreChooseLabel.text = @"更多筛选";
    allMoreChooseLabel.tag = 192;
    allMoreChooseLabel.textAlignment = NSTextAlignmentCenter;
    allMoreChooseLabel.textColor = RGBColor(80, 80, 80);
    allMoreChooseLabel.font = Font(14);
    [allMoreChooseButton addSubview:allMoreChooseLabel];
    
    UIImageView *xialaImage3 = [[UIImageView alloc] init];
    xialaImage3.image = [UIImage imageNamed:@"xiala"];
    xialaImage3.frame = (CGRect){WIDTH(allMoreChooseButton)-20,(HEIGHT(allMoreChooseButton)-4)/2,8,4};
    [allMoreChooseButton addSubview:xialaImage3];
    
    UIView *sepLineTop = [[UIView alloc] init];
    sepLineTop.frame = (CGRect){0,HEIGHT(headView)-0.5,WIDTH(headView),0.5};
    sepLineTop.backgroundColor = RGBAColor(200, 200, 200, 0.8);
    [headView addSubview:sepLineTop];
    
    shopInfoTableView = [[UITableView alloc] init];
    shopInfoTableView.frame = (CGRect){0,BOTTOM(headView),WIDTH(contentView),HEIGHT(contentView)-BOTTOM(headView)-UN_NarbarHeight};
    shopInfoTableView.tag = 20001;
    shopInfoTableView.delegate = self;
    shopInfoTableView.dataSource = self;
    shopInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:shopInfoTableView];
    
    [shopInfoTableView initDownRefresh];
    [shopInfoTableView initPullUpRefresh];
    
    weak(weakself, self);
    [shopInfoTableView setDownRefreshBlock:^(id refreshView){
        [weakself getShopInfosDataWithPageIndex:1];
    }];
    
    [shopInfoTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getShopInfosDataWithPageIndex:self.currentPageIndex+1];
    }];
    
    UIView *tableBottomView = [[UIView alloc] init];
    tableBottomView.frame = (CGRect){0,0,WIDTH(shopInfoTableView),UN_TabbarHeight};
    shopInfoTableView.tableFooterView = tableBottomView;
    
    [self getShopInfosDataWithPageIndex:1];
    
    [self setUpData];
    
    [self setUpBaseViewWithSourceID:self.nodesourceid];
}

-(void)setNodeSourceid:(long)sourceid{
    _nodesourceid = sourceid;
    [self setUpBaseViewWithSourceID:sourceid];
}

-(void)setUpBaseViewWithSourceID:(long)sid{
    _nodesourceid = sid;
    if (allFenleiTableview1) {
        int selectInt = 0;
        if (sid == 0) {
            allSourceLabel.text = @"全部分类";
        }
        NSArray *array = allSourceDataArray;
        for (int i = 0; i < array.count; i++) {
            NSDictionary *nodeDic = allSourceDataArray[i][@"node"];
            int nodeid = [nodeDic[@"id"] intValue];
            if (nodeid == sid && nodeid != 0) {
                selectInt = i+1;
                NSString *nameString = nodeDic[@"name"];
                allSourceLabel.text = nameString;
                break;
            }
        }
        [allFenleiTableview1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectInt inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)setUpNavigation{
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *rightimage = [UIImage imageNamed:@"navi_search"];
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithImage:rightimage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
}

-(void)leftItemClick{
    
}

-(void)rightItemClick{
    [self.tabBarController.navigationController pushViewController:[SearchViewController new] animated:YES];
}

-(void)setUpData{
    if (!allSourceDataArray || allSourceDataArray.count == 0) {
        allSourceDataArray = @[@{@"node":@{@"id":@"5",@"name":@"餐饮美食"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               @{@"id":@"6",@"name":@"中式快餐1",@"order":@"2"},
                                               @{@"id":@"7",@"name":@"品牌快餐1",@"order":@"3"},
                                               @{@"id":@"8",@"name":@"米粉快餐1",@"order":@"4"},
                                               @{@"id":@"9",@"name":@"包子粥店1",@"order":@"5"},
                                               @{@"id":@"10",@"name":@"烧烤烤串1",@"order":@"6"},
                                               @{@"id":@"11",@"name":@"面食点心1",@"order":@"7"}
                                               ],
                                 },
                               @{@"node":@{@"id":@"12",@"name":@"超市购"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               ],
                                 },
                               @{@"node":@{@"id":@"13",@"name":@"水果生鲜"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               ],
                                 },
                               @{@"node":@{@"id":@"14",@"name":@"下午茶"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               ],
                                 },
                               @{@"node":@{@"id":@"15",@"name":@"夜宵"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               ],
                                 },
                               @{@"node":@{@"id":@"16",@"name":@"鲜花蛋糕"},
                                 @"children":@[@{@"id":@"-1",@"name":@"全部",@"order":@"1"},
                                               ],
                                 },
                               ];
    }
    
    
    allYouhuiDataArray = @[@{@"id":@"1",
                             @"name":@"新",
                             @"title":@"新用户立减"},
                           @{@"id":@"2",
                             @"name":@"特",
                             @"title":@"特价优惠"},
                           @{@"id":@"3",
                             @"name":@"减",
                             @"title":@"满就减"},
                           @{@"id":@"4",
                             @"name":@"预",
                             @"title":@"预订优惠"},
                           @{@"id":@"5",
                             @"name":@"免",
                             @"title":@"免配送费"}
                           ];
    
    allMoreDataArray = @[@"评分最高",
                         @"距离最近",
                         @"销量最高",
                         @"起送金额最低",
                         @"联合配送"];
    
    currentFilterYouhuiIndex = -1;
    currentFilterMoreIndex = 2;
    
    if (self.isUnionPS) {
        allMoreChooseLabel.text = @"联合配送";
    }
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    
    if (dataSourceArray) {
        NSMutableArray *souceResultArray = [NSMutableArray array];
        [dataSourceArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            NSDictionary *noteDic = dic[@"node"];
            NSMutableArray *childrenAaaa = [NSMutableArray array];
            [childrenAaaa addObject:@{@"id":@"-1",@"name":@"全部"}];
            
            NSArray *childrenArrayTmp = dic[@"children"];
            if (childrenArrayTmp) {
                for (int i = 0; i < childrenArrayTmp.count; i++) {
                    [childrenAaaa addObject:[childrenArrayTmp objectAtIndex:i]];
                }
            }
            [souceResultArray addObject:@{@"node":noteDic,@"children":[NSArray arrayWithArray:childrenAaaa]}];
        }];
        allSourceDataArray = [NSArray arrayWithArray:souceResultArray];
        
    }
}

-(void)filteChooseMainViewClick{
    [self dismissChooseMainView];
}

-(void)dismissChooseMainView{
    [filteChooseMainView removeFromSuperview];
}

-(void)topbuttonClick:(UIButton *)button{
    int butttontag = (int)button.tag;
    
    if (butttontag == 1) {
        //全部分类
        [self showAllSourceFilterView];
    }else if (butttontag == 2){
        //优惠活动
        [self showAllYouhuiFilterView];
    }else if (butttontag == 3){
        //更多筛选
        [self showAllMoreFilterView];
    }else{
        return;
    }
}

-(void)showAllSourceFilterView{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:filteChooseMainView]) {
        [[UIApplication sharedApplication].keyWindow addSubview:filteChooseMainView];
    }
    
    allMoreTableview.alpha = 0;
    allYouhuiTableview.alpha = 0;
    
    allFenleiTableview1.alpha = 1;
    allFenleiTableview2.alpha = 1;
    
    float height = allFenleiTableview1.contentSize.height;
    allFenleiTableview1.frame = (CGRect){0,0,WIDTH(filteChooseMainView)/3,MIN(height, filteChooseTableHeight)};
    allFenleiTableview2.frame = (CGRect){WIDTH(filteChooseMainView)/3,0,WIDTH(filteChooseMainView)-WIDTH(filteChooseMainView)/3,MIN(height, filteChooseTableHeight)};
}

-(void)showAllYouhuiFilterView{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:filteChooseMainView]) {
        [[UIApplication sharedApplication].keyWindow addSubview:filteChooseMainView];
    }
    
    allMoreTableview.alpha = 0;
    allYouhuiTableview.alpha = 1;
    
    allFenleiTableview1.alpha = 0;
    allFenleiTableview2.alpha = 0;
    
    float height = allYouhuiTableview.contentSize.height;
    allYouhuiTableview.frame = (CGRect){0,0,WIDTH(filteChooseMainView),MIN(height, filteChooseTableHeight)};
}

-(void)showAllMoreFilterView{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:filteChooseMainView]) {
        [[UIApplication sharedApplication].keyWindow addSubview:filteChooseMainView];
    }
    
    allMoreTableview.alpha = 1;
    allYouhuiTableview.alpha = 0;
    
    allFenleiTableview1.alpha = 0;
    allFenleiTableview2.alpha = 0;
    
    float height = allMoreTableview.contentSize.height;
    allMoreTableview.frame = (CGRect){0,0,WIDTH(filteChooseMainView),MIN(height, filteChooseTableHeight)};
}

-(void)updateLocationWithLatitude:(float)latitude longitude:(float)longitude{
    [UNUserDefaults saveMainAddressLatitude:latitude longitude:longitude];
}

#pragma mark - 获取商铺列表
-(void)getShopInfosDataWithPageIndex:(int)pageIndex{
    //    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    //    currentFilterYouhuiIndex = -1;
    //    currentFilterMoreIndex = 0;
    /**
     *  @[@{@"id":@"1",
     @"name":@"新",
     @"title":@"新用户立减"},
     @{@"id":@"2",
     @"name":@"特",
     @"title":@"特价优惠"},
     @{@"id":@"3",
     @"name":@"减",
     @"title":@"满就减"},
     @{@"id":@"4",
     @"name":@"预",
     @"title":@"预订优惠"},
     @{@"id":@"5",
     @"name":@"免",
     @"title":@"免配送费"}
     ];
     */
    
    /**
     *  @[@"评分最高",
     @"距离最近",
     @"销量最高",
     @"起送金额最低"];
     */
    
    NSMutableDictionary *pramasDic = [NSMutableDictionary dictionary];
    [pramasDic setObject:@(pageIndex) forKey:@"pageNumber"];
    [pramasDic setObject:@"20" forKey:@"pageSize"];
    float mainADDLatitude,mainADDLongitude;
    mainADDLatitude = [UNUserDefaults getMainAddressLatitude];
    mainADDLongitude = [UNUserDefaults getMainAddressLongitude];
    
    [pramasDic setObject:@(mainADDLatitude) forKey:@"latitude"];
    [pramasDic setObject:@(mainADDLongitude) forKey:@"longitude"];
    
    NSString *orderTypeString = @"salesDesc";
    //默认为2; 按照销量降序
    [pramasDic setObject:@(self.isUnionPS) forKey:@"isPS"];
    if (currentFilterMoreIndex == 0){
        orderTypeString = @"scoreAsc";
    }else if (currentFilterMoreIndex == 1) {
        orderTypeString = @"distanceAsc";
        if (mainADDLatitude == 0.f || mainADDLongitude == 0.f) {
            [BYToastView showToastWithMessage:@"定位错误,正在重新定位"];
            return;
        }
        [pramasDic setObject:@(mainADDLatitude) forKey:@"latitude"];
        [pramasDic setObject:@(mainADDLongitude) forKey:@"longitude"];
    }else if (currentFilterMoreIndex == 2){
        orderTypeString = @"salesDesc";
    }else if (currentFilterMoreIndex == 3){
        orderTypeString = @"feeAsc";
    }
    [pramasDic setObject:orderTypeString forKey:@"orderType"]; //界面上更多筛选项
    
    if (_nodesourceid != 0) {
        [pramasDic setObject:@(_nodesourceid) forKey:@"productCategoryId"]; //分类ID 筛选项
    }
    if (currentFilterYouhuiIndex != -1){
        NSString *youhuiString;
        if (currentFilterYouhuiIndex == 1) {
            youhuiString = @"preferential1";
        }else if (currentFilterYouhuiIndex == 2) {
            youhuiString = @"preferential2";
        }else if (currentFilterYouhuiIndex == 3) {
            youhuiString = @"preferential3";
        }else if (currentFilterYouhuiIndex == 4) {
            youhuiString = @"preferential4";
        }else if (currentFilterYouhuiIndex == 5) {
            youhuiString = @"preferential5";
        }
        if (youhuiString) {
            [pramasDic setObject:youhuiString forKey:@"type"];//优惠类型 筛选项
        }
    }
    
    [UNUrlConnection getShopsWithParams:pramasDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSArray *contentArray = resultDic[@"content"];
            NSMutableArray *shopsArrayTmp = [NSMutableArray array];
            if (contentArray && [contentArray isKindOfClass:[NSArray class]] && contentArray.count != 0) {
                for (NSDictionary *shopDic in contentArray) {
                    ShopInfo *infoTmp = [ShopInfo shopInfoWithNetWorkDictionary:shopDic];
                    [shopsArrayTmp addObject:infoTmp];
                }
            }
            if (pageIndex == 1) {
                currentShopInfosDataArray = [NSMutableArray array];
            }
            if (shopsArrayTmp.count != 0) {
                
                [currentShopInfosDataArray addObjectsFromArray:shopsArrayTmp];
                self.currentPageIndex = pageIndex;
                
            }else{
                [BYToastView showToastWithMessage:@"无数据"];
            }
            [shopInfoTableView reloadData];
            
            [shopInfoTableView endDownRefresh];
            [shopInfoTableView endPullUpRefresh];
        }
    }];
    
    //    shopInfosDataArray = [NSMutableArray array];
    //测试数据
    
    //    ShopInfo *info1 = [[ShopInfo alloc] init];
    //    info1.name = @"味必鲜排骨米饭";
    //    info1.isSelfDelivery = YES;
    //    info1.businessState = ShopInfoBusinessStateOpen;
    //    info1.minBuyNumber = 30;
    //    info1.deliveryNumber = 5;
    //    info1.starJudge = 3.5;
    //    info1.monthSaleNumber = 99;
    //    info1.juanEnabel = YES;
    //    info1.piaoEnabel = YES;
    //    info1.fuEnabel = YES;
    //    info1.peiEnabel = YES;
    //    info1.deliveryAverage = @"44";
    //    info1.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info1.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info1.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加917吃货节14:00档",
    //                                @"减": @"满90元减20元"};
    //    
    //    [arrayTmp addObject:info1];
    //    
    //    ShopInfo *info2 = [[ShopInfo alloc] init];
    //    info2.name = @"天禧海鲜馆";
    //    info2.isSelfDelivery = YES;
    //    info2.businessState = ShopInfoBusinessStateOpen;
    //    info2.minBuyNumber = 50;
    //    info2.deliveryNumber = 0;
    //    info2.starJudge = 4;
    //    info2.monthSaleNumber = 99;
    //    info2.peiEnabel = YES;
    //    info2.deliveryAverage = @"44";
    //    info2.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info2.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info2.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",};
    //    
    //    [arrayTmp addObject:info2];
    //    
    //    ShopInfo *info3 = [[ShopInfo alloc] init];
    //    info3.name = @"民以食为天";
    //    info3.businessState = ShopInfoBusinessStateBreak;
    //    info3.minBuyNumber = 50;
    //    info3.deliveryNumber = 0;
    //    info3.starJudge = 3;
    //    info3.monthSaleNumber = 99;
    //    info3.piaoEnabel = YES;
    //    info3.deliveryAverage = @"44";
    //    info3.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info3.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info3.huodongDictionary = @{@"减": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加双十一特价满20减10",};
    //    
    //    [arrayTmp addObject:info3];
    //    
    //    ShopInfo *info4 = [[ShopInfo alloc] init];
    //    info4.name = @"锅巴饭";
    //    info4.isSelfDelivery = YES;
    //    info4.businessState = ShopInfoBusinessStateBreak;
    //    info4.minBuyNumber = 25;
    //    info4.deliveryNumber = 0;
    //    info4.starJudge = 4.5;
    //    info4.monthSaleNumber = 99;
    //    info4.fuEnabel = YES;
    //    info4.deliveryAverage = @"44";
    //    info4.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info4.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info4.huodongDictionary = @{@"新": @"新用户在线支付满30减5元"};
    //    
    //    [arrayTmp addObject:info4];
    //    
    //    ShopInfo *info5 = [[ShopInfo alloc] init];
    //    info5.name = @"油焖大虾";
    //    info5.businessState = ShopInfoBusinessStateBreak;
    //    info5.minBuyNumber = 10;
    //    info5.deliveryNumber = 10;
    //    info5.starJudge = 5;
    //    info5.monthSaleNumber = 1034;
    //    info5.fuEnabel = YES;
    //    info5.deliveryAverage = @"44";
    //    info5.shopIndtroduction = @"新店开张优惠多多,因为每只海鲜都是新鲜所以我们的配送时间是60-90分钟";
    //    info5.shopNotification = @"新店开张,优惠多多,本店主要经营各种盖饭,炒菜,各种炒菜样式齐全,欢迎订购.";
    //    info5.huodongDictionary = @{@"新": @"新用户在线支付满30减5元",
    //                                @"特" :  @"本店参加双十一特价满20减10",};
    //    
    //    [arrayTmp addObject:info5];
    //    [self reloadTableWithArray:arrayTmp];
}

#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == shopInfoTableView) {
        if (currentShopInfosDataArray && currentShopInfosDataArray.count != 0) {
            return [ShopsTableViewCell staticHeightWithShopInfo:currentShopInfosDataArray[indexPath.row]];
        }
    }else if (tableView == allFenleiTableview1){
        return 40;
    }else if (tableView == allFenleiTableview2){
        return 40;
    }else if (tableView == allYouhuiTableview){
        return 40;
    }else if (tableView == allMoreTableview){
        return 40;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == shopInfoTableView) {
        if (currentShopInfosDataArray) {
            return currentShopInfosDataArray.count;
        }
    }else if (tableView == allFenleiTableview1){
        if (!allSourceDataArray) {
            return 0;
        }
        if (allSourceDataArray) {
            return allSourceDataArray.count+1;
        }
        return 1;
    }else if (tableView == allFenleiTableview2){
        if (!currentSourceTableDetailDataArray || self.nodesourceid == 0) {
            return 0;
        }
        if (currentSourceTableDetailDataArray) {
            return currentSourceTableDetailDataArray.count;
        }
        return 1;
    }else if (tableView == allYouhuiTableview){
        if (allYouhuiDataArray) {
            return allYouhuiDataArray.count+1;
        }
        return 1;
    }else if (tableView == allMoreTableview){
        if (allMoreDataArray) {
            return allMoreDataArray.count;
        }
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == shopInfoTableView) {
        static NSString *shopInfoTableViewCellIdentifier = @"shopInfoTableViewCellIdentifier";
        ShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopInfoTableViewCellIdentifier];
        if (!cell) {
            cell = [[ShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:shopInfoTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ShopInfo *shopInfo = currentShopInfosDataArray[indexPath.row];
        cell.shopInfo = shopInfo;
        [cell.imageView setImageWithURL:[NSURL URLWithString:shopInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
        return cell;
    }else if (tableView == allFenleiTableview1){
        static NSString *allFenleiTableview1CellIdentifier = @"allFenleiTableview1CellIdentifier";
        SimpleSourceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:allFenleiTableview1CellIdentifier];
        if (!cell) {
            cell = [[SimpleSourceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allFenleiTableview1CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部分类";
        }else{
            NSDictionary *dic = [allSourceDataArray objectAtIndex:indexPath.row-1];
            cell.textLabel.text = dic[@"node"][@"name"];
        }
        return cell;
    }else if (tableView == allFenleiTableview2){
        static NSString *allFenleiTableview2CellIdentifier = @"allFenleiTableview2CellIdentifier";
        DetailSourceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:allFenleiTableview2CellIdentifier];
        if (!cell) {
            cell = [[DetailSourceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allFenleiTableview2CellIdentifier];
        }
        if (self.nodesourceid == 0) {
        }else{
            cell.textLabel.text = currentSourceTableDetailDataArray[indexPath.row][@"name"];
        }
        return cell;
    }else if (tableView == allYouhuiTableview){
        static NSString *allYouhuiTableview1CellIdentifier = @"allYouhuiTableview1CellIdentifier";
        YouhuiSourceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:allYouhuiTableview1CellIdentifier];
        if (!cell) {
            cell = [[YouhuiSourceTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allYouhuiTableview1CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全";
            cell.tagColor = UN_FilterQuan;
            cell.detailTextLabel.text = @"全部优惠";
        }else{
            NSDictionary *dic = [allYouhuiDataArray objectAtIndex:indexPath.row-1];
            NSString *textName = dic[@"name"];
            if (textName) {
                cell.textLabel.text = textName;
                if ([textName isEqualToString:@"新"]) {
                    cell.tagColor = UN_FilterXin;
                }else if ([textName isEqualToString:@"特"]){
                    cell.tagColor = UN_FilterTejia;
                }else if ([textName isEqualToString:@"减"]){
                    cell.tagColor = UN_FilterJian;
                }else if ([textName isEqualToString:@"预"]){
                    cell.tagColor = UN_FilterYu;
                }else if ([textName isEqualToString:@"免"]){
                    cell.tagColor = UN_FilterMian;
                }
            }
            cell.detailTextLabel.text = dic[@"title"];
        }
        return cell;
    }else if (tableView == allMoreTableview){
        static NSString *allMoreTableviewCellIdentifier = @"allMoreTableviewCellIdentifier";
        DetailSourceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:allMoreTableviewCellIdentifier];
        if (!cell) {
            cell = [[DetailSourceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allMoreTableviewCellIdentifier];
        }
        cell.textLabel.text = allMoreDataArray[indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == shopInfoTableView) {
        ShopInfo *shopInfo = currentShopInfosDataArray[indexPath.row];
        ShopDetailViewController *sdVC= [[ShopDetailViewController alloc] init];
        sdVC.shopInfo = shopInfo;
        [self.navigationController pushViewController:sdVC animated:YES];
    }else if (tableView == allFenleiTableview1){
        if (indexPath.row == 0) {
            allSourceLabel.text = @"全部分类";
            _nodesourceid = 0;
            [self dismissChooseMainView];
            
            [self getShopInfosDataWithPageIndex:1];
        }else{
            NSDictionary *dataDic = [allSourceDataArray objectAtIndex:indexPath.row -1];
            
            NSDictionary *nodeDic = dataDic[@"node"];
            _nodesourceid = [[nodeDic objectForKey:@"id"] longValue];
            
            currentSourceTableDetailDataArray = dataDic[@"children"];
            [allFenleiTableview2 reloadData];
        }
    }else if (tableView == allFenleiTableview2){
        if (indexPath.row == 0) {
            NSIndexPath *indexpppp = [allFenleiTableview1 indexPathForSelectedRow];
            allSourceLabel.text = [allFenleiTableview1 cellForRowAtIndexPath:indexpppp].textLabel.text;
        }else{
            NSDictionary *dic = [currentSourceTableDetailDataArray objectAtIndex:indexPath.row];
            _nodesourceid = [[dic objectForKey:@"id"] longValue];
            allSourceLabel.text = [allFenleiTableview2 cellForRowAtIndexPath:indexPath].textLabel.text;
        }
        [self getShopInfosDataWithPageIndex:1];
        [self dismissChooseMainView];
        allYouhuiLabel.text = @"优惠活动";
        [allYouhuiTableview deselectRowAtIndexPath:[allYouhuiTableview indexPathForSelectedRow] animated:YES];
        allMoreChooseLabel.text = @"更多优惠";
        [allMoreTableview deselectRowAtIndexPath:[allMoreTableview indexPathForSelectedRow] animated:YES];
    }else if (tableView == allYouhuiTableview){
        NSIndexPath *indexpppp = [allYouhuiTableview indexPathForSelectedRow];
        allYouhuiLabel.text = [allYouhuiTableview cellForRowAtIndexPath:indexpppp].detailTextLabel.text;
        [self dismissChooseMainView];
        if (indexPath.row == 0) {
            currentFilterYouhuiIndex = -1;
        }else{
            NSDictionary *dic = [allYouhuiDataArray objectAtIndex:indexPath.row-1];
            int youhuiID = [[dic objectForKey:@"id"] intValue];
            currentFilterYouhuiIndex = youhuiID;
        }
        [self getShopInfosDataWithPageIndex:1];
    }else if (tableView == allMoreTableview){
        NSIndexPath *indexpppp = [allMoreTableview indexPathForSelectedRow];
        NSString *moreFilterString= [allMoreTableview cellForRowAtIndexPath:indexpppp].textLabel.text;
        allMoreChooseLabel.text = moreFilterString;
        [self dismissChooseMainView];
        
        if (moreFilterString && [moreFilterString isEqualToString:@"联合配送"]) {
            self.isUnionPS = YES;
        }else{
            self.isUnionPS = NO;
            int moreID = (int)indexPath.row;
            currentFilterMoreIndex = moreID;
        }
        [self getShopInfosDataWithPageIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}


@end
