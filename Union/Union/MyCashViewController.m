//
//  MyCashViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "MyCashViewController.h"
#import "MyChargeViewController.h"
#import "MyWithDrawViewController.h"
#import "RecordTableViewCell.h"
#import "UNUrlConnection.h"
#import "UIScrollView+XYRefresh.h"

typedef NS_ENUM(NSUInteger, CashSearchType) {
    CashSearchType7Days     = 1 << 1,
    CashSearchType30Days    = 1 << 2,
    CashSearchType90Days    = 1 << 3,
};

@interface MyCashViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *yueLabel;

@property (nonatomic,strong) UISegmentedControl *segmenttControl;

@property (nonatomic,strong) UILabel *totalRecordNumberLabel;

@property (nonatomic,strong) UITableView *recordTableView;

@property (nonatomic,strong) NSMutableArray *currentRecordDataArray;

@property (nonatomic,assign) float currentRecordPageIndex;

@property (nonatomic,assign) CashSearchType cashSearchType;

@end

@implementation MyCashViewController{
    float cashRemain;
}

@synthesize contentView,segmenttControl,totalRecordNumberLabel;

@synthesize recordTableView,currentRecordDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的余额";
    
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
    
    UIView *yueShowView = [[UIView alloc] init];
    yueShowView.frame = (CGRect){0,0,WIDTH(contentView),85};
    yueShowView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:yueShowView];
    
    UILabel *yueNoteLabel = [[UILabel alloc] init];
    yueNoteLabel.frame = (CGRect){15,15,120,18};
    yueNoteLabel.text = @"账户余额（元）";
    yueNoteLabel.textColor = RGBColor(50, 50, 50);
    //    yueNoteLabel.backgroundColor = [UIColor redColor];
    yueNoteLabel.font = Font(15);
    yueNoteLabel.textAlignment = NSTextAlignmentLeft;
    [yueShowView addSubview:yueNoteLabel];
    
    self.yueLabel = [[UILabel alloc] init];
    self.yueLabel.frame = (CGRect){15,BOTTOM(yueNoteLabel)+12,120,25};
    
    self.yueLabel.textColor = UN_RedColor;
    //    self.yueLabel.backgroundColor = [UIColor redColor];
    self.yueLabel.font = Font(19);
    self.yueLabel.textAlignment = NSTextAlignmentLeft;
    [yueShowView addSubview:self.yueLabel];
    
    UIButton *outterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    outterButton.frame = (CGRect){WIDTH(yueShowView)-15-60,(HEIGHT(yueShowView)-30)/2,60,30};
    outterButton.backgroundColor = RGBColor(72, 203, 83);
    outterButton.layer.cornerRadius = 2.f;
    outterButton.layer.masksToBounds = YES;
    [outterButton setTitle:@"提现" forState:UIControlStateNormal];
    [outterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outterButton.titleLabel.font = Font(15);
    [yueShowView addSubview:outterButton];
    [outterButton addTarget:self action:@selector(outterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chargeButton.frame = (CGRect){LEFT(outterButton)-10-WIDTH(outterButton),TOP(outterButton),WIDTH(outterButton),HEIGHT(outterButton)};
    chargeButton.backgroundColor = UN_RedColor;
    [chargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [chargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chargeButton.layer.cornerRadius = 2.f;
    chargeButton.layer.masksToBounds = YES;
    chargeButton.titleLabel.font = Font(15);
    [yueShowView addSubview:chargeButton];
    [chargeButton addTarget:self action:@selector(chargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *recordHeadView = [[UIView alloc] init];
    recordHeadView.frame = (CGRect){0,BOTTOM(yueShowView),WIDTH(contentView),30};
    recordHeadView.backgroundColor = RGBColor(235, 235, 235);
    [contentView addSubview:recordHeadView];
    
    UIView *lineSepView1 = [[UIView alloc] init];
    lineSepView1.frame = (CGRect){0,0,WIDTH(recordHeadView),0.5};
    lineSepView1.backgroundColor = RGBAColor(200, 200, 200,0.5);
    [recordHeadView addSubview:lineSepView1];
    
    UILabel *recordNoteLabel = [[UILabel alloc] init];
    recordNoteLabel.frame = (CGRect){15,0,100,HEIGHT(recordHeadView)};
    recordNoteLabel.text = @"交易记录";
    recordNoteLabel.textColor = RGBColor(160, 160, 160);
    recordNoteLabel.font = Font(14);
    recordNoteLabel.textAlignment = NSTextAlignmentLeft;
    [recordHeadView addSubview:recordNoteLabel];
    
    UIView *lineSepView2 = [[UIView alloc] init];
    lineSepView2.frame = (CGRect){0,HEIGHT(recordHeadView)-0.5,WIDTH(recordHeadView),0.5};
    lineSepView2.backgroundColor = RGBAColor(200, 200, 200,0.5);
    [recordHeadView addSubview:lineSepView2];
    
    UIView *segementOutterView = [[UIView alloc] init];
    segementOutterView.frame = (CGRect){0,BOTTOM(recordHeadView),WIDTH(contentView),40};
    segementOutterView.backgroundColor = RGBColor(250, 250, 250);
    [contentView addSubview:segementOutterView];
    
    segmenttControl = [[UISegmentedControl alloc] init];
    segmenttControl.frame = (CGRect){15,5,WIDTH(segementOutterView)-15*2,HEIGHT(segementOutterView)-10};
    //    segmenttControl.backgroundColor = [UIColor redColor];
    [segmenttControl insertSegmentWithTitle:@"最近一周" atIndex:0 animated:NO];
    [segmenttControl insertSegmentWithTitle:@"最近一月" atIndex:1 animated:NO];
    [segmenttControl insertSegmentWithTitle:@"最近三月" atIndex:2 animated:NO];
    [segmenttControl setTintColor:RGBColor(100, 100, 100)];
    [segementOutterView addSubview:segmenttControl];
    
    [segmenttControl addTarget:self action:@selector(segmenttControlValueChange) forControlEvents:UIControlEventValueChanged];
    
    UIView *lineSepView3 = [[UIView alloc] init];
    lineSepView3.frame = (CGRect){0,HEIGHT(segementOutterView)-0.5,WIDTH(segementOutterView),0.5};
    lineSepView3.backgroundColor = RGBAColor(200, 200, 200,0.5);
    [segementOutterView addSubview:lineSepView3];
    
    UIView *recordShowView = [[UIView alloc] init];
    recordShowView.frame = (CGRect){15,BOTTOM(segementOutterView),WIDTH(contentView)-15*2,HEIGHT(contentView)-BOTTOM(segementOutterView)};
    recordShowView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:recordShowView];
    
    totalRecordNumberLabel = [[UILabel alloc] init];
    totalRecordNumberLabel.textAlignment = NSTextAlignmentRight;
    totalRecordNumberLabel.frame = (CGRect){0,0,WIDTH(recordShowView),40};
    totalRecordNumberLabel.font = Font(18);
    //    totalRecordNumberLabel.backgroundColor = [UIColor redColor];
    [recordShowView addSubview:totalRecordNumberLabel];
    
    recordTableView = [[UITableView alloc] init];
    recordTableView.frame = (CGRect){0,BOTTOM(totalRecordNumberLabel),WIDTH(recordShowView),HEIGHT(recordShowView)-BOTTOM(totalRecordNumberLabel)-15};
    [recordShowView addSubview:recordTableView];
    recordTableView.tag = 6101;
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.showsHorizontalScrollIndicator = NO;
    recordTableView.showsVerticalScrollIndicator = NO;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTableView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    recordTableView.layer.borderWidth = 0.5f;
    recordTableView.backgroundColor = [UIColor whiteColor];
    
    [recordTableView initDownRefresh];
    [recordTableView initPullUpRefresh];
    
    weak(weakself, self);
    [recordTableView setDownRefreshBlock:^(id refreshView){
        int searchDays = -1;
        switch (weakself.cashSearchType) {
            case CashSearchType7Days:
                searchDays = 7;
                break;
            case CashSearchType30Days:
                searchDays = 30;
                break;
            case CashSearchType90Days:
                searchDays = 90;
                break;
            default:
                break;
        }
        [weakself getAllCashWithSuperDate:searchDays pageIndex:1];
    }];
    
    [recordTableView setPullUpRefreshBlock:^(id refreshView){
        int searchDays = -1;
        switch (weakself.cashSearchType) {
            case CashSearchType7Days:
                searchDays = 7;
                break;
            case CashSearchType30Days:
                searchDays = 30;
                break;
            case CashSearchType90Days:
                searchDays = 90;
                break;
            default:
                break;
        }
        [weakself getAllCashWithSuperDate:searchDays pageIndex:self.currentRecordPageIndex+1];
    }];
    
    cashRemain = 0.f;
    
    segmenttControl.selectedSegmentIndex = 0;
    [self segmenttControlValueChange];
    
    self.cashSearchType = CashSearchType7Days;
    
    [self getAllCashWithSuperDate:7 pageIndex:1];
}

-(void)getAllCashWithSuperDate:(int)dateNum pageIndex:(int)pageIndex{
    [BYToastView showToastWithMessage:@"正在获取交易记录..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(dateNum) forKey:@"date"];
    [params setObject:@(pageIndex) forKey:@"pageNumber"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [UNUrlConnection getAllMyCashWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *contentDic = resultDic[@"content"];
            if (contentDic && [contentDic isKindOfClass:[NSDictionary class]] && contentDic.count != 0) {
                NSArray *depostisArray = [contentDic objectForKey:@"deposits"];
                
                float memberBalance = [contentDic[@"memberBalance"] floatValue];
                [self setTotalRecordNumber:memberBalance];
                
                
                NSMutableArray *depostisArrayTmp = [NSMutableArray array];
                [depostisArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSString *shopname = [obj objectForKey:@"brand_name"];
                    NSString *type = [obj objectForKey:@"type"];//余额动态类型
                    float credit = [[obj objectForKey:@"credit"] floatValue];//动态金额
                    float debit = [[obj objectForKey:@"debit"] floatValue];//支出金额
                    long long time = [[obj objectForKey:@"time"] longLongValue]/1000;//动态时间
                    float balance = [[obj objectForKey:@"balance"] floatValue];//消费后余额
                    
                    NSString *name = @"余额动态";
                    long long timestamp = time/1000;
                    float recodeNumber,yueNumber;
                    
                    yueNumber = balance;
                    
                    if (type && [type isKindOfClass:[NSString class]]) {
                        if ([type isEqualToString:@"memberRecharge"]) {
                            name = @"充值";
                            recodeNumber = credit;
                        }else if ([type isEqualToString:@"memberPayment"]) {
                            name = shopname;
                            recodeNumber = debit;
                        }else if ([type isEqualToString:@"adminRecharge"]) {
                            name = @"后台充值";
                            recodeNumber = credit;
                        }else if ([type isEqualToString:@"adminChargeback"]) {
                            name = @"后台扣费";
                            recodeNumber = debit;
                        }else if ([type isEqualToString:@"adminPayment"]) {
                            if (shopname) {
                                name = shopname;
                            }
                            name = @"后台支付";
                            recodeNumber = debit;
                        }else if ([type isEqualToString:@"adminRefunds"]) {
                            name = @"退款";
                            recodeNumber = credit;
                        }else if ([type isEqualToString:@"memberwithdraw"]) {
                            name = @"提现";
                            recodeNumber = debit;
                        }
                    }
                    
                    [depostisArrayTmp addObject:@{@"name":name,
                                                  @"timestamp":@(timestamp),
                                                  @"recordNumber":@(recodeNumber),
                                                  @"yueNumber":@(yueNumber),
                                                  }];
                }];
                if (pageIndex == 1) {
                    currentRecordDataArray = [NSMutableArray array];
                }
                if (depostisArrayTmp.count != 0) {
                    [currentRecordDataArray addObjectsFromArray:depostisArrayTmp];
                    self.currentRecordPageIndex = pageIndex;
                }else{
                    [BYToastView showToastWithMessage:@"无数据"];
                }
                [self getRecordReload];
            }
        }
        [recordTableView endDownRefresh];
        [recordTableView endPullUpRefresh];
    }];
}

-(void)getRecordReload{
    [recordTableView reloadData];
    return;
    
    currentRecordDataArray = [NSMutableArray array];
    
    [currentRecordDataArray addObject:@{@"name":@"肯德基大前门店",
                                        @"timestamp":@(1447222248),
                                        @"recordNumber":@(44.5),
                                        @"yueNumber":@(5.5),
                                        }];
    [currentRecordDataArray addObject:@{@"name":@"退款",
                                        @"timestamp":@(1447123000),
                                        @"recordNumber":@(21),
                                        @"yueNumber":@(50),
                                        }];
    [currentRecordDataArray addObject:@{@"name":@"提现",
                                        @"timestamp":@(1446222999),
                                        @"recordNumber":@(100),
                                        @"yueNumber":@(29),
                                        }];
    [currentRecordDataArray addObject:@{@"name":@"川渝小吃",
                                        @"timestamp":@(1446021234),
                                        @"recordNumber":@(21),
                                        @"yueNumber":@(129),
                                        }];
    [currentRecordDataArray addObject:@{@"name":@"充值",
                                        @"timestamp":@(1446020228),
                                        @"recordNumber":@(100),
                                        @"yueNumber":@(150),
                                        }];
    [currentRecordDataArray addObject:@{@"name":@"赠送",
                                        @"timestamp":@(1445522000),
                                        @"recordNumber":@(50),
                                        @"yueNumber":@(50),
                                        }];
    
    [recordTableView reloadData];
}

-(void)chargeButtonClick{
    //充值按钮点击
    [self.navigationController pushViewController:[[MyChargeViewController alloc] init] animated:YES];
}

-(void)outterButtonClick{
    //取现按钮点击
    MyWithDrawViewController *mwdVC = [[MyWithDrawViewController alloc] init];
    mwdVC.cashRemain = cashRemain;
    
    [self.navigationController pushViewController:mwdVC animated:YES];
}

-(void)segmenttControlValueChange{
    switch (segmenttControl.selectedSegmentIndex) {
        case 0:{
            if (self.cashSearchType == CashSearchType7Days) {
                [recordTableView setContentOffset:(CGPoint){0,0} animated:YES];
                return;
            }
            self.cashSearchType = CashSearchType7Days;
            [self getAllCashWithSuperDate:7 pageIndex:1];
        }
            break;
        case 1:{
            if (self.cashSearchType == CashSearchType30Days) {
                [recordTableView setContentOffset:(CGPoint){0,0} animated:YES];
                return;
            }
            self.cashSearchType = CashSearchType30Days;
            [self getAllCashWithSuperDate:30 pageIndex:1];
        }
            break;
        case 2:{
            if (self.cashSearchType == CashSearchType90Days) {
                [recordTableView setContentOffset:(CGPoint){0,0} animated:YES];
                return;
            }
            self.cashSearchType = CashSearchType90Days;
            [self getAllCashWithSuperDate:90 pageIndex:1];
        }
            break;
        default:
            break;
    }
}

-(void)setTotalRecordNumber:(float)num{
    cashRemain = num;
    NSMutableAttributedString *attriString;
    NSString *yueLabelString;
    if ((num*10)-((int)num)*10 == 0) {
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：￥%d",(int)num]];
        yueLabelString = [NSString stringWithFormat:@"￥%d",(int)num];
    }else{
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：￥%.1f",num]];
        yueLabelString = [NSString stringWithFormat:@"￥%.1f",num];
    }
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:80.f/255 green:80.f/255 blue:80.f/255 alpha:1]
                        range:NSMakeRange(0, 3)];
    UIColor *red = [UIColor redColor];
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:red
                        range:NSMakeRange(3, attriString.length-3)];
    totalRecordNumberLabel.attributedText = attriString;
    self.yueLabel.text = yueLabelString;
}


#pragma mark - tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recordTableView) {
        if (currentRecordDataArray && currentRecordDataArray.count != 0) {
            return RecordTableViewCellViewHeight;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == recordTableView) {
        if (currentRecordDataArray) {
            return currentRecordDataArray.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recordTableView) {
        static NSString *RecordTableViewCellIdentifier6101 = @"RecordTableViewCellIdentifier6101";
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordTableViewCellIdentifier6101];
        if (!cell) {
            cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RecordTableViewCellIdentifier6101];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.recordName = currentRecordDataArray[indexPath.row][@"name"];
        cell.recordNumber = [currentRecordDataArray[indexPath.row][@"recordNumber"] floatValue];
        cell.recordTimeStamp = [currentRecordDataArray[indexPath.row][@"timestamp"] longLongValue];
        cell.recordYueNumber = [currentRecordDataArray[indexPath.row][@"yueNumber"] floatValue];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
    if (recordTableView) {
        int searchDays = -1;
        switch (self.cashSearchType) {
            case CashSearchType7Days:
                searchDays = 7;
                break;
            case CashSearchType30Days:
                searchDays = 30;
                break;
            case CashSearchType90Days:
                searchDays = 90;
                break;
            default:
                break;
        }
        [self getAllCashWithSuperDate:searchDays pageIndex:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
