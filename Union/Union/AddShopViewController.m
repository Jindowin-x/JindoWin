//
//  AddShopViewController.m
//  Union
//
//  Created by xiaoyu on 15/11/17.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AddShopViewController.h"
#import "ShopAskForViewController.h"

#import "UNUrlConnection.h"

@interface AddShopViewController ()

@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,strong) UIView *alreadyAddShopsView;

@end

@implementation AddShopViewController{
    float everyAddedShopImageAligh;
    int everyAddedShopImageHeight;
    
    NSArray *addedShopsInfpDataArray;
    
    CGSize contentOriginSize;
}

@synthesize contentView,alreadyAddShopsView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商户入驻";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight-45};
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addShopButton.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    addShopButton.backgroundColor = RGBColor(61, 157, 36);
    [addShopButton setTitle:@"我要入驻" forState:UIControlStateNormal];
    [addShopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addShopButton addTarget:self action:@selector(addShopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addShopButton];
    
    UIImageView *topIntroduceImage = [[UIImageView alloc] init];
    topIntroduceImage.image = [UIImage imageNamed:@"banner"];
    topIntroduceImage.frame = (CGRect){0,0,WIDTH(contentView),170};
    [contentView addSubview:topIntroduceImage];
    
    UIView *profileAddNoteView = [[UIView alloc] init];
    profileAddNoteView.frame = (CGRect){0,BOTTOM(topIntroduceImage),WIDTH(contentView),35};
    profileAddNoteView.backgroundColor = RGBColor(235, 235, 235);
    [contentView addSubview:profileAddNoteView];
    
    UILabel *profileAddNoteLabel = [[UILabel alloc] init];;
    profileAddNoteLabel.frame = (CGRect){10,0,WIDTH(profileAddNoteView)-10*2,HEIGHT(profileAddNoteView)-0};
    profileAddNoteLabel.text = @"加入联合外卖所需材料";
    profileAddNoteLabel.textColor = RGBColor(80, 80, 80);
    profileAddNoteLabel.textAlignment = NSTextAlignmentLeft;
    profileAddNoteLabel.font = Font(14);
    profileAddNoteLabel.backgroundColor = profileAddNoteView.backgroundColor;
    [profileAddNoteView addSubview:profileAddNoteLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineView1.frame = (CGRect){0,0,WIDTH(profileAddNoteView),0.5};
    [profileAddNoteView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineView2.frame = (CGRect){0,HEIGHT(profileAddNoteView)-0.5,WIDTH(profileAddNoteView),0.5};
    [profileAddNoteView addSubview:lineView2];
    
    UIView *profileAddTmpView = [[UIView alloc] init];
    profileAddTmpView.frame = (CGRect){0,BOTTOM(profileAddNoteView),WIDTH(contentView),120};
    profileAddTmpView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:profileAddTmpView];
    
    UIImageView *profileAddNoteImage = [[UIImageView alloc] init];
    profileAddNoteImage.frame = (CGRect){(WIDTH(profileAddTmpView)-320)/2,20,320,80};
    profileAddNoteImage.backgroundColor = [UIColor whiteColor];
    profileAddNoteImage.image = [UIImage imageNamed:@"sjrzlc"];
    [profileAddTmpView addSubview:profileAddNoteImage];
    
    UIView *profileAddedNoteView = [[UIView alloc] init];
    profileAddedNoteView.frame = (CGRect){0,BOTTOM(profileAddTmpView),WIDTH(contentView),35};
    profileAddedNoteView.backgroundColor = RGBColor(235, 235, 235);
    [contentView addSubview:profileAddedNoteView];
    
    UILabel *profileAddedNoteLabel = [[UILabel alloc] init];;
    profileAddedNoteLabel.frame = (CGRect){10,0,WIDTH(profileAddedNoteView)-10*2,HEIGHT(profileAddedNoteView)-0};
    profileAddedNoteLabel.text = @"已入驻商家";
    profileAddedNoteLabel.textColor = RGBColor(80, 80, 80);
    profileAddedNoteLabel.textAlignment = NSTextAlignmentLeft;
    profileAddedNoteLabel.font = Font(14);
    profileAddedNoteLabel.backgroundColor = profileAddedNoteView.backgroundColor;
    [profileAddedNoteView addSubview:profileAddedNoteLabel];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineView3.frame = (CGRect){0,0,WIDTH(profileAddedNoteView),0.5};
    [profileAddedNoteView addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineView4.frame = (CGRect){0,HEIGHT(profileAddedNoteView)-0.5,WIDTH(profileAddedNoteView),0.5};
    [profileAddedNoteView addSubview:lineView4];
    
    contentOriginSize = (CGSize){WIDTH(contentView),BOTTOM(profileAddedNoteView)};
    
    everyAddedShopImageAligh = 10;
    
    alreadyAddShopsView = [[UIView alloc] init];
    alreadyAddShopsView.backgroundColor = [UIColor whiteColor];
    alreadyAddShopsView.frame = (CGRect){0,BOTTOM(profileAddedNoteView),WIDTH(contentView),60};
    [contentView addSubview:alreadyAddShopsView];
    
    everyAddedShopImageHeight = (WIDTH(alreadyAddShopsView)-everyAddedShopImageAligh*4)/3;
    
    [self getAddedShopsData];
}

-(void)getAddedShopsData{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"1" forKey:@"pageNumber"];
    [paramsDic setObject:@"21" forKey:@"pageSize"];
    
    [UNUrlConnection getAllAskShopsWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *contentsDic = resultDic[@"content"];
        if (contentsDic && contentsDic.count > 0) {
            NSArray *brandsArray = [contentsDic objectForKey:@"brands"];
            if (brandsArray && [brandsArray isKindOfClass:[NSArray class]] && brandsArray.count > 0) {
                addedShopsInfpDataArray = brandsArray;
                
                [alreadyAddShopsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                [addedShopsInfpDataArray enumerateObjectsUsingBlock:^(NSDictionary  *objDic, NSUInteger idx, BOOL *stop) {
                    NSString *objUrl = objDic[@"logo"];
                    
                    int xA = idx % 3;
                    int yA = (int)idx / 3;
                    
                    UIImageView *image = [[UIImageView alloc] init];
                    
                    if (objUrl && [objUrl isKindOfClass:[NSString class]] && ![objUrl isEqualToString:@""]) {
                        [image setImageWithURL:[NSURL URLWithString:[UNUrlConnection replaceUrl:objUrl]]placeholderImage:[UIImage imageNamed:@"shopitemdetail_pic_moren"]];
                    }else{
                        image.image = [UIImage imageNamed:@"shopitemdetail_pic_moren"];
                    }
                    
                    image.backgroundColor = RGBColor(random()%255, random()%255, random()%255);
                    image.frame = (CGRect){
                        everyAddedShopImageAligh + (everyAddedShopImageHeight+everyAddedShopImageAligh)*xA ,
                        everyAddedShopImageAligh + (everyAddedShopImageHeight+everyAddedShopImageAligh)*yA ,
                        everyAddedShopImageHeight,
                        everyAddedShopImageHeight
                    };
                    [alreadyAddShopsView addSubview:image];
                }];
                
                int xC = addedShopsInfpDataArray.count % 3;
                int yC = (int)addedShopsInfpDataArray.count / 3;
                
                int rouCount = yC;
                if (xC > 0) {
                    rouCount += 1;
                }
                
                //    alreadyAddShopsView.backgroundColor = [UIColor redColor];
                
                float extraAddheight = (everyAddedShopImageHeight+everyAddedShopImageAligh)*rouCount + everyAddedShopImageAligh;
                
                CGRect oldRect = alreadyAddShopsView.frame;
                oldRect.size.height = extraAddheight;
                alreadyAddShopsView.frame = oldRect;
                
                if (contentOriginSize.height + extraAddheight <= HEIGHT(contentView)) {
                    contentView.contentSize = (CGSize){contentOriginSize.width,HEIGHT(contentView)+1};
                }else{
                    contentView.contentSize = (CGSize){contentOriginSize.width,contentOriginSize.height + extraAddheight};
                }
            }
        }
    }];
    
    //    
    //    
    //    addedShopsInfpDataArray = @[@"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",
    //                                @"",];
    
}


-(void)addShopButtonClick{
    [self.navigationController pushViewController:[ShopAskForViewController new] animated:YES];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
