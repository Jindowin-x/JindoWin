//
//  OpenWebViewController.m
//  Union
//
//  Created by xiaoyu on 16/1/16.
//  Copyright © 2016年 _companyname_. All rights reserved.
//

#import "OpenWebViewController.h"

@interface OpenWebViewController () <UIWebViewDelegate>{
    UIWebView *unwebView;
}

@end

@implementation OpenWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(235,235,235);
    [self.view addSubview:contentView];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    unwebView = [[UIWebView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)}];
    unwebView.delegate = self;
    [contentView addSubview:unwebView];
    
    if (self.openUrl) {
        if ([self.openUrl rangeOfString:@"http"].length == 0) {
            self.openUrl = [@"http://" stringByAppendingString:self.openUrl];
        }
        
        [unwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.openUrl]]];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSString *currentURL= webView.request.URL.absoluteString;
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;
    return YES;
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
