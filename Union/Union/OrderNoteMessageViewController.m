//
//  OrderNoteMessageViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "OrderNoteMessageViewController.h"
#import "XYAnimateTagsView.h"

@interface OrderNoteMessageViewController () <UIScrollViewDelegate,UITextViewDelegate>

@end

@implementation OrderNoteMessageViewController{
    UIScrollView *contentView;
    
    UITextView *noteMessagePlaceholderTextFiled,*noteMessageTextFiled;
    UILabel *textLengthLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"配送备注";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    contentView.backgroundColor = RGBColor(240, 240, 240);
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.delegate = self;
    [self.view addSubview:contentView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [self.view addGestureRecognizer:backTap];
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentView addSubview:fixCiew];
    
    UIView *textview = [[UIView alloc] init];
    textview.frame = (CGRect){10,10,WIDTH(contentView)-20,100};
    textview.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:textview];
    
    noteMessagePlaceholderTextFiled = [[UITextView alloc] init];
    noteMessagePlaceholderTextFiled.backgroundColor = [UIColor whiteColor];
    noteMessagePlaceholderTextFiled.frame = (CGRect){5,0,(WIDTH(textview)-10),HEIGHT(textview)};
    noteMessagePlaceholderTextFiled.textColor = RGBColor(200, 200, 200);
    noteMessagePlaceholderTextFiled.font = Font(15);
    noteMessagePlaceholderTextFiled.keyboardType = UIKeyboardTypeDefault;
    noteMessagePlaceholderTextFiled.returnKeyType = UIReturnKeyNext;
    noteMessagePlaceholderTextFiled.text = @"给商家留言,可输入对商家的要求,不超过50字";
    [noteMessagePlaceholderTextFiled setEditable:NO];
    noteMessagePlaceholderTextFiled.userInteractionEnabled = NO;
    noteMessagePlaceholderTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteMessagePlaceholderTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [textview addSubview:noteMessagePlaceholderTextFiled];

    noteMessageTextFiled = [[UITextView alloc] init];
    noteMessageTextFiled.backgroundColor = [UIColor clearColor];
    noteMessageTextFiled.frame = (CGRect){5,0,(WIDTH(textview)-10),HEIGHT(textview)};
    noteMessageTextFiled.textColor = RGBColor(100, 100, 100);
    noteMessageTextFiled.font = Font(15);
    noteMessageTextFiled.tag = 1010210;
    noteMessageTextFiled.delegate = self;
    noteMessageTextFiled.keyboardType = UIKeyboardTypeDefault;
    noteMessageTextFiled.returnKeyType = UIReturnKeyNext;
    noteMessageTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteMessageTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [textview addSubview:noteMessageTextFiled];

    textLengthLabel = [[UILabel alloc] init];
    textLengthLabel.frame = (CGRect){20,BOTTOM(textview)+5,WIDTH(contentView)-40,15};
    textLengthLabel.textColor = RGBColor(140, 140, 140);
    textLengthLabel.textAlignment = NSTextAlignmentRight;
    textLengthLabel.font = Font(13);
    [contentView addSubview:textLengthLabel];
    
    NSString *noteMessage = self.orderVC.noteMessage;
    if (noteMessage && noteMessage.length != 0) {
        noteMessagePlaceholderTextFiled.hidden = YES;
        noteMessageTextFiled.text = noteMessage;
        textLengthLabel.text = [NSString stringWithFormat:@"%ld/50",noteMessage.length];
    }else{
        noteMessagePlaceholderTextFiled.hidden = NO;
        textLengthLabel.text = @"0/50";
    }
    
    XYAnimateTagsView *searchTagsView = [[XYAnimateTagsView alloc] initWithFrame:(CGRect){10,BOTTOM(textLengthLabel),WIDTH(contentView)-20,40} rowNumbers:2];
    searchTagsView.tagsArray = @[@"请提供餐具",@"不吃辣椒",@"微辣",@"辣椒多一点",@"米饭都一点",@"没零钱"];
    searchTagsView.tagClickBlock = ^(NSString *str){
        dispatch_async(dispatch_get_main_queue(), ^{
            noteMessageTextFiled.text = [noteMessageTextFiled.text stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
            noteMessagePlaceholderTextFiled.hidden = YES;
            [noteMessageTextFiled.delegate textViewDidChange:noteMessageTextFiled];
        });
    };
    [searchTagsView draw];
    [contentView addSubview:searchTagsView];
}

-(void)resignAllInputs{
    [noteMessageTextFiled resignFirstResponder];
    [noteMessagePlaceholderTextFiled resignFirstResponder];
}

-(void)backTap{
    [self resignAllInputs];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == contentView) {
        [self resignAllInputs];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 1010210) {
        if (![text isEqualToString:@""]){
            noteMessagePlaceholderTextFiled.hidden = YES;
        }
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
            noteMessagePlaceholderTextFiled.hidden = NO;
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger length = textView.text.length;
    textLengthLabel.text = [NSString stringWithFormat:@"%ld/50",length];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    UIImage *leftimage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:leftimage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
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
    NSString *noteMessage = noteMessageTextFiled.text;
    if (noteMessage.length != 0) {
        if (noteMessage.length > 50) {
            [BYToastView showToastWithMessage:@"配送备注不能超过50字"];
            return;
        }
        self.orderVC.noteMessage = noteMessage;
    }else{
        self.orderVC.noteMessage = @"";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resignAllInputs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
