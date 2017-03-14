//
//  JudgeTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "JudgeTableViewCell.h"
#import "UNTools.h"

@implementation JudgeTableViewCell{
    UILabel *judgeLabel;
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.font = Font(15);
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(120, 120, 120);
        self.detailTextLabel.font = Font(11);
        
        judgeLabel = [[UILabel alloc] init];
        judgeLabel.numberOfLines = 2;
        judgeLabel.textColor = RGBColor(80, 80, 80);
        judgeLabel.textAlignment = NSTextAlignmentLeft;
        judgeLabel.font = Font(13);
        [self.contentView addSubview:judgeLabel];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:lineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){15,15,70,70};
    //    self.imageView.backgroundColor = [UIColor redColor];
    
    self.textLabel.frame = (CGRect){RIGHT(self.imageView)+15,TOP(self.imageView),WIDTH(self.contentView)-20-(RIGHT(self.imageView)+15),20};
    //        self.textLabel.backgroundColor = [UIColor redColor];
    
    
    if (self.judgeMessage) {
        CGSize size = [UNTools getSizeWithString:self.judgeMessage andSize:(CGSize){WIDTH(self.textLabel),MAXFLOAT} andFont:Font(13)];
        
        float height2 = JudgeTableViewCellViewHeight-(BOTTOM(self.textLabel)+5)-25;
        
        judgeLabel.text = self.judgeMessage;
        judgeLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+5,WIDTH(self.textLabel),MIN(size.height, height2)};
    }
    //        judgeLabel.backgroundColor = [UIColor purpleColor];
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),JudgeTableViewCellViewHeight-20,WIDTH(self.textLabel),15};
    //    self.detailTextLabel.
    
    lineView.frame = (CGRect){0,JudgeTableViewCellViewHeight-0.5,WIDTH(self.contentView),0.5};
}

-(void)setJudgeShopName:(NSString *)judgeShopName{
    if (judgeShopName) {
        _judgeMessage = judgeShopName;
        self.textLabel.text = judgeShopName;
    }
}

-(void)setJudgeTimeStamp:(long long)judgeTimeStamp{
    _judgeTimeStamp = judgeTimeStamp;
    NSString *judgeTimeString = [UNTools parseTimeWithTimeStamp:judgeTimeStamp];
    if (judgeTimeString) {
        self.detailTextLabel.text = judgeTimeString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
