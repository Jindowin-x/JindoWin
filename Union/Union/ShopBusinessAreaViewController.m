//
//  ShopBusinessAreaViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/19.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ShopBusinessAreaViewController.h"
#import "ShopAskForViewController.h"

@interface ShopBusinessAreaViewController ()

@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,copy) NSString *selectedBussinessAraeString;

@end

@implementation ShopBusinessAreaViewController{
    NSMutableArray *shopBussinessAreaButtonsArray;
}

@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"经营范围选择";
    
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
    
    shopBussinessAreaButtonsArray = [NSMutableArray array];
    NSArray *shopAreaDataArray = @[@"餐饮美食",@"超市购",@"鲜花蛋糕",@"夜宵",@"水果生鲜",@"下午茶"];
    
    float viewHeight = IS5_5Inches()?50:40;
    UIFont *font = IS5_5Inches()?Font(17):Font(15);
    __block float viewOffset = 20;
    
    [shopAreaDataArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = (CGRect){0,viewOffset,WIDTH(contentView),viewHeight};
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 100;
        [contentView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shopBussinessAreaButtonsArray addObject:button];
        
        UILabel *textLable = [[UILabel alloc] init];
        textLable.font = font;
        textLable.textAlignment = NSTextAlignmentLeft;
        textLable.frame = (CGRect){10,0,90,HEIGHT(button)};
        textLable.text = obj;
        textLable.tag = 192;
        [button addSubview:textLable];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"unselected"];
        imageView.frame = (CGRect){WIDTH(button)-10-22,(HEIGHT(button)-22)/2,22,22};
        imageView.tag = 1000;
        [button addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = (CGRect){0,HEIGHT(button)-0.5,WIDTH(button),0.5};
        lineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [button addSubview:lineView];
        
        viewOffset += viewHeight;
    }];
    
    contentView.contentSize = (CGSize){WIDTH(contentView),viewOffset>HEIGHT(contentView)?viewOffset:HEIGHT(contentView)+1};
}

-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 100) {
        for (UIButton *bbbbbbbuuuuu in shopBussinessAreaButtonsArray) {
            UIImageView *imageview = [bbbbbbbuuuuu viewWithTag:1000];
            imageview.image = [UIImage imageNamed:@"unselected"];
            bbbbbbbuuuuu.tag = 100;
        }
        button.tag = 101;
        
        UIImageView *imageview = [button viewWithTag:1000];
        imageview.image = [UIImage imageNamed:@"selected"];
        
        UILabel *label = [button viewWithTag:192];
        self.selectedBussinessAraeString = label.text;
    }else{
        button.tag = 100;
        UIImageView *imageview = [button viewWithTag:1000];
        imageview.image = [UIImage imageNamed:@"unselected"];
        self.selectedBussinessAraeString = @"";
    }
    NSLog(@"%@",self.selectedBussinessAraeString);
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
    if (self.selectedBussinessAraeString) {
        /*
         food：餐饮美食
         supermarket:超市购
         fruit:水果生鲜
         tea:下午茶
         supper：夜宵
         flower：鲜花蛋糕
         */
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if ([self.selectedBussinessAraeString isEqualToString:@"餐饮美食"]) {
            [dictionary setObject:@"food" forKey:@"dbname"];
            [dictionary setObject:@"餐饮美食" forKey:@"name"];
        }else if ([self.selectedBussinessAraeString isEqualToString:@"超市购"]){
            [dictionary setObject:@"supermarket" forKey:@"dbname"];
            [dictionary setObject:@"超市购" forKey:@"name"];
        }else if ([self.selectedBussinessAraeString isEqualToString:@"水果生鲜"]){
            [dictionary setObject:@"fruit" forKey:@"dbname"];
            [dictionary setObject:@"水果生鲜" forKey:@"name"];
        }else if ([self.selectedBussinessAraeString isEqualToString:@"夜宵"]){
            [dictionary setObject:@"supper" forKey:@"dbname"];
            [dictionary setObject:@"夜宵" forKey:@"name"];
        }else if ([self.selectedBussinessAraeString isEqualToString:@"鲜花蛋糕"]){
            [dictionary setObject:@"flower" forKey:@"dbname"];
            [dictionary setObject:@"鲜花蛋糕" forKey:@"name"];
        }
        if (dictionary.count == 0) {
            return;
        }
        self.shopVC.shopBussinessAreaDic = dictionary;
    }else{
        [self showAlertWithMessage:@"经营范围没有选择"];
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
