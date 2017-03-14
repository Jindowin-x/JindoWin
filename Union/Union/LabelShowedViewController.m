//
//  LabelShowedViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/1.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "LabelShowedViewController.h"

#import "UNUrlConnection.h"
#import "UNUserDefaults.h"
#import "BYToastView.h"

@interface LabelShowedViewController (){
    UIScrollView *contentView;
    UILabel *textShowedLabel;
}

@end

@implementation LabelShowedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type == LabelShowedTypeAbloutUs) {
        self.navigationItem.title = @"关于我们";
    }else if (self.type == LabelShowedTypeService) {
        self.navigationItem.title = @"服务条款";
    }
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = UN_WhiteColor;
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    

    textShowedLabel = [[UILabel alloc] init];
    textShowedLabel.numberOfLines = 0;
    textShowedLabel.contentMode = UIViewContentModeTop;
    textShowedLabel.font = [UIFont systemFontOfSize:16.f];
    textShowedLabel.textColor = RGBColor(80, 80, 80);
    [contentView addSubview:textShowedLabel];
    
    [self getLabelContentReload];
}

-(void)reloadWithContent:(NSString *)content{
    CGSize size = CGSizeMake(WIDTH(contentView)-20,MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textShowedLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    
    textShowedLabel.frame = CGRectMake(10, 10,labelSize.width, labelSize.height);
    
    textShowedLabel.text = content;
    
    if (labelSize.height + 20 <= HEIGHT(contentView)+1) {
        contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    }else{
        contentView.contentSize = (CGSize){WIDTH(contentView),labelSize.height + 20};
    }
}

-(void)getLabelContentReload{
    if (self.type == LabelShowedTypeAbloutUs) {
        [UNUrlConnection getAboutUsComplete:^(NSDictionary *resultDic, NSString *errorString) {
            runInMainThread(^{
                if (errorString) {
                    [BYToastView showToastWithMessage:errorString];
                    return;
                }
                NSDictionary *messDic = [resultDic objectForKey:@"message"];
                NSString *typeString = messDic[@"type"];
                if (typeString && [typeString isKindOfClass:[NSString class]] &&
                    [typeString isEqualToString:@"success"]) {
                    NSString *dataString = resultDic[@"data"];
                    if (dataString) {
                        [self reloadWithContent:dataString];
                    }
                }else{
                    NSString *messContent = messDic[@"content"];
                    if (messContent) {
                        [BYToastView showToastWithMessage:messContent];
                    }
                }
            });
        }];
    }else if (self.type == LabelShowedTypeService) {
        [UNUrlConnection getServiceApprovementComplete:^(NSDictionary *resultDic, NSString *errorString) {
            runInMainThread(^{
                if (errorString) {
                    [BYToastView showToastWithMessage:errorString];
                    return;
                }
                NSDictionary *messDic = [resultDic objectForKey:@"message"];
                NSString *typeString = messDic[@"type"];
                if (typeString && [typeString isKindOfClass:[NSString class]] &&
                    [typeString isEqualToString:@"success"]) {
                    NSString *dataString = resultDic[@"data"];
                    if (dataString) {
                        [self reloadWithContent:dataString];
                    }
                }else{
                    NSString *messContent = messDic[@"content"];
                    if (messContent) {
                        [BYToastView showToastWithMessage:messContent];
                    }
                }
            });
        }];
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
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

@end
