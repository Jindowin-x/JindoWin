//
//  QAViewController.m
//  Union
//
//  Created by xiaoyu on 15/12/28.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "FastQAViewController.h"
#import "UNUrlConnection.h"
#import "UNTools.h"

@interface FastQAViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation FastQAViewController{
    UITableView *contentTableView;
    
    NSArray *currentTableDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"常见问题";
    
    UIView *topAlighView = [[UIView alloc] init];
    topAlighView.frame = (CGRect){0,0,WIDTH(self.view),UN_NarbarHeight};
    topAlighView.backgroundColor = UN_RedColor;
    [self.view addSubview:topAlighView];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = (CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight};
    backView.backgroundColor = RGBColor(253, 253, 253);
    [self.view addSubview:backView];
    
    contentTableView = [[UITableView alloc] initWithFrame:(CGRect){0,UN_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-UN_NarbarHeight} style:UITableViewStylePlain];
    contentTableView.backgroundColor = RGBColor(253, 253, 253);
    contentTableView.tag = 4801;
    contentTableView.delegate = self;
    contentTableView.alpha = 1.f;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contentTableView];
    
    
    UIView *fixCiew = [[UIView alloc] init];
    fixCiew.frame = CGRectZero;
    [contentTableView addSubview:fixCiew];
    
    [self getAllFastQAReload];
}

-(void)getAllFastQAReload{
    [UNUrlConnection getQAComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return ;
        }
        NSDictionary *messageDic = resultDic[@"message"];
        NSString *typeString = messageDic[@"type"];
        NSMutableArray *contentArrayTmp = [NSMutableArray array];
        if (typeString && [typeString isKindOfClass:[NSString class]] && [typeString isEqualToString:@"success"]) {
            NSDictionary *contentDic = resultDic[@"data"];
            [contentDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL *stop) {
                if (key && [key isKindOfClass:[NSString class]]) {
                    NSString *title = @"";
                    if ([key isEqualToString:@"dclc"]) {
                        title = @"订餐流程";
                    }else if ([key isEqualToString:@"yhxg"]){
                        title = @"优惠相关";
                    }else if ([key isEqualToString:@"lxwm"]){
                        title = @"优惠相关";
                    }else if ([key isEqualToString:@"zfxg"]){
                        title = @"支付相关";
                    }
                    if (obj) {
                        [contentArrayTmp addObject:@{@"title":title,
                                                     @"data":obj}];
                    }
                }
            }];
        }
        
        currentTableDataArray = [NSArray arrayWithArray:contentArrayTmp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [contentTableView reloadData];
        });
    }];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == contentTableView){
        if (currentTableDataArray && currentTableDataArray.count != 0) {
            return currentTableDataArray.count;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (currentTableDataArray && currentTableDataArray.count != 0) {
            NSString *titleString = [currentTableDataArray[section] objectForKey:@"title"];
            UIView *view = [[UIView alloc] init];
            view.frame = (CGRect){0,0,WIDTH(tableView),30};
            view.backgroundColor = RGBColor(240, 240, 240);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = titleString;
            titleLabel.frame = (CGRect){15,0,WIDTH(view)-15,HEIGHT(view)};
            titleLabel.textColor = RGBColor(120, 120, 120);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = Font(15);
            [view addSubview:titleLabel];
            return view;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == contentTableView){
        return 30;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView){
        NSDictionary *sourcedic = [currentTableDataArray objectAtIndex:indexPath.section];
        NSArray *dataArray = [sourcedic objectForKey:@"data"];
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        NSString *ques = [dic objectForKey:@"ask"];
        NSString *answer = [dic objectForKey:@"question"];
        return [FastQATableViewCell staticHeightForCellWithTitleString:ques decriptionString:answer];
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView){
        if (currentTableDataArray && currentTableDataArray.count != 0) {
            return [[currentTableDataArray[section] objectForKey:@"data"] count];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView){
        static NSString *fastQATableViewCellIdentifier = @"fastQATableViewCellIdentifier4801";
        FastQATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fastQATableViewCellIdentifier];
        if (!cell) {
            cell = [[FastQATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fastQATableViewCellIdentifier];
        }
        NSDictionary *sourcedic = [currentTableDataArray objectAtIndex:indexPath.section];
        NSArray *dataArray = [sourcedic objectForKey:@"data"];
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        
        NSString *ques = [dic objectForKey:@"ask"];
        NSString *answer = [dic objectForKey:@"question"];
        
        cell.titleString = ques;
        cell.decriptionString = answer;
        
        return cell;
    }
    return nil;
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

@implementation FastQATableViewCell {
    UILabel *titleLabel;
    UILabel *desciptionLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font(15);
        titleLabel.textColor = RGBColor(140, 140, 140);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = -1;
        [self.contentView addSubview:titleLabel];
        
        desciptionLabel = [[UILabel alloc] init];
        desciptionLabel.font = Font(15);
        desciptionLabel.textColor = RGBColor(140, 140, 140);
        desciptionLabel.textAlignment = NSTextAlignmentLeft;
        desciptionLabel.numberOfLines = -1;
        [self.contentView addSubview:desciptionLabel];
        
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        self.imageView.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews{
    CGSize textLabelStringSize = [UNTools getSizeWithString:self.titleString andSize:(CGSize){WIDTH(self.contentView)-30,HUGE_VALL} andFont:titleLabel.font];
    
    titleLabel.frame = (CGRect){15,10,WIDTH(self.contentView)-30,textLabelStringSize.height};
    
    CGSize descriptionStringSize = [UNTools getSizeWithString:self.decriptionString andSize:(CGSize){WIDTH(self.contentView)-30-15,HUGE_VALL} andFont:desciptionLabel.font];
    
    desciptionLabel.frame = (CGRect){35,BOTTOM(titleLabel)+10,WIDTH(self.contentView)-15-30,descriptionStringSize.height};
}

-(void)setTitleString:(NSString *)titleString{
    _titleString = [NSString stringWithFormat:@"Q : %@",titleString];
    titleLabel.text = _titleString;
}

-(void)setDecriptionString:(NSString *)decriptionString{
    _decriptionString = decriptionString;
    desciptionLabel.text = decriptionString;
}

+(CGFloat)staticHeightForCellWithTitleString:(NSString *)titleString decriptionString:(NSString *)decriptionString{
    titleString = [NSString stringWithFormat:@"Q : %@",titleString];
    CGSize textLabelStringSize = [UNTools getSizeWithString:titleString andSize:(CGSize){GLOBALWIDTH-30,HUGE_VALL} andFont:Font(15)];
    
    CGSize descriptionStringSize = [UNTools getSizeWithString:decriptionString andSize:(CGSize){GLOBALWIDTH-30-15,HUGE_VALL} andFont:Font(15)];
    
    return 10+textLabelStringSize.height+10+descriptionStringSize.height+20;
}

@end


