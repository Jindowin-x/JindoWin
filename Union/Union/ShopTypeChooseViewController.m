//
//  ShopTypeChooseViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/19.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopTypeChooseViewController.h"
#import "ShopAskForViewController.h"


@interface ShopTypeChooseViewController ()

@property (nonatomic,strong) UIScrollView *contentView;

@end

@implementation ShopTypeChooseViewController{
    UIButton *commpanyButton;
    UIImageView *commpanySelect;
    
    UIButton *personalButton;
    UIImageView *personalSelect;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商户类型选择";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(235, 235, 235);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    float viewHeight = IS5_5Inches()?50:40;
    UIFont *font = IS5_5Inches()?Font(17):Font(15);
    float viewOffset = 20;
    
    UIView *commpanyView = [[UIView alloc] init];
    commpanyView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    commpanyView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:commpanyView];
    
    UILabel *commpanyNoteLabel = [[UILabel alloc] init];
    commpanyNoteLabel.frame = (CGRect){10,0,90,HEIGHT(commpanyView)};
    commpanyNoteLabel.textAlignment = NSTextAlignmentLeft;
    commpanyNoteLabel.font = font;
    commpanyNoteLabel.text = @"企业商户";
    [commpanyView addSubview:commpanyNoteLabel];
    

    
    commpanyButton = [[UIButton alloc] init];
    commpanyButton.tag = 0;
    commpanyButton.frame = (CGRect){WIDTH(commpanyView)-10-80,0,80,HEIGHT(commpanyView)};
    [commpanyView addSubview:commpanyButton];
    [commpanyButton addTarget:self action:@selector(commpanyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    commpanySelect = [[UIImageView alloc] init];
    commpanySelect.frame = (CGRect){WIDTH(commpanyButton)-5-22,(HEIGHT(commpanyButton)-22)/2,22,22};
    commpanySelect.image = [UIImage imageNamed:@"unselected"];
    [commpanyButton addSubview: commpanySelect];
    
    UIView *lineSepView2 = [[UIView alloc] init];
    lineSepView2.frame = (CGRect){0,HEIGHT(commpanyView)-0.5,WIDTH(commpanyView),0.5};
    lineSepView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [commpanyView addSubview:lineSepView2];
    
    viewOffset += viewHeight;
    
    UIView *personalView = [[UIView alloc] init];
    personalView.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
    personalView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:personalView];
    
    UILabel *personalNoteLabel = [[UILabel alloc] init];
    personalNoteLabel.frame = (CGRect){10,0,90,HEIGHT(personalView)};
    personalNoteLabel.textAlignment = NSTextAlignmentLeft;
    personalNoteLabel.font = font;
    personalNoteLabel.text = @"个人商户";
    [personalView addSubview:personalNoteLabel];

    personalButton = [[UIButton alloc] init];
    personalButton.tag = 0;
    personalButton.frame = (CGRect){WIDTH(personalView)-10-80,0,80,HEIGHT(personalView)};
    [personalView addSubview:personalButton];
    [personalButton addTarget:self action:@selector(personalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    personalSelect = [[UIImageView alloc] init];
    personalSelect.frame = (CGRect){WIDTH(personalButton)-5-22,(HEIGHT(personalButton)-22)/2,22,22};
    personalSelect.image = [UIImage imageNamed:@"unselected"];
    [personalButton addSubview:personalSelect];
    
    UIView *lineSepView3 = [[UIView alloc] init];
    lineSepView3.frame = (CGRect){0,HEIGHT(personalView)-0.5,WIDTH(personalView),0.5};
    lineSepView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [personalView addSubview:lineSepView3];
    
    viewOffset += viewHeight;
}

-(void)commpanyButtonClick{
    if (commpanyButton.tag == 0) {
        commpanyButton.tag = 1;
        personalButton.tag = 0;
        
        commpanySelect.image = [UIImage imageNamed:@"selected"];
        personalSelect.image = [UIImage imageNamed:@"unselected"];
    }else{
        commpanyButton.tag = 0;
        
        commpanySelect.image = [UIImage imageNamed:@"unselected"];
    }
}

-(void)personalButtonClick{
    if (personalButton.tag == 0) {
        personalButton.tag = 1;
        commpanyButton.tag = 0;
        
        commpanySelect.image = [UIImage imageNamed:@"unselected"];
        personalSelect.image = [UIImage imageNamed:@"selected"];
        
    }else{
        personalButton.tag = 0;
        personalSelect.image = [UIImage imageNamed:@"unselected"];
    }
}

-(void)showAlertWithMessage:(NSString *)string{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil] show];
}

-(void)setUpNavigation{
    
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
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
    BOOL isCommanyMent = NO;
    if (commpanyButton.tag == 0 && personalButton.tag == 0) {
        [self showAlertWithMessage:@"必须选择一种类型"];
        return;
    }else if (commpanyButton.tag == 1 && personalButton.tag == 1) {
        [self showAlertWithMessage:@"商户类型为单一选择项"];
        return;
    }else{
        if (commpanyButton.tag == 1) {
            isCommanyMent = YES;
        }
    }
    if (isCommanyMent) {
        self.shopVC.shopTypeDic = @{@"name":@"企业商户",@"dbname":@"enterprise"};
    }else{
        self.shopVC.shopTypeDic = @{@"name":@"个体商户",@"dbname":@"person"};
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
