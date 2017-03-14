//
//  InfomationTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "InfomationTableViewCell.h"

#import "UNTools.h"

@implementation InfomationTableViewCell{
    UILabel *detailInfoLabel;
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.hidden = YES;
        
        self.imageView.image = [UIImage imageNamed:@"icon_message"];
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.font = Font(15);
        
        detailInfoLabel = [[UILabel alloc] init];
        detailInfoLabel.numberOfLines = 2;
        detailInfoLabel.textColor = RGBColor(100, 100, 100);
        detailInfoLabel.textAlignment = NSTextAlignmentLeft;
        detailInfoLabel.font = Font(13);
        [self.contentView addSubview:detailInfoLabel];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:lineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){15,(InfomationTableViewCellViewHeight-43)/2,43,43};
    
    self.textLabel.frame = (CGRect){RIGHT(self.imageView)+15,10,WIDTH(self.contentView)-20-(RIGHT(self.imageView)+15),20};
    //    self.textLabel.text = @"外卖中心消息提醒标题";
    //    self.textLabel.backgroundColor = [UIColor redColor];
    
    self.detailTextLabel.hidden = YES;
    
    if (self.messageDetail) {
        CGSize size = [UNTools getSizeWithString:self.messageDetail andSize:(CGSize){WIDTH(self.textLabel),MAXFLOAT} andFont:Font(13)];
        
        float height2 = InfomationTableViewCellViewHeight-(BOTTOM(self.textLabel)+5)-10;
        
        detailInfoLabel.text = self.messageDetail;
        detailInfoLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+5,WIDTH(self.textLabel),MIN(size.height, height2)};
    }
    //    detailInfoLabel.backgroundColor = [UIColor purpleColor];
    
    lineView.frame = (CGRect){0,InfomationTableViewCellViewHeight-0.5,WIDTH(self.contentView),0.5};
}

-(void)setMessageTitle:(NSString *)messageTitle{
    _messageDetail = messageTitle;
    self.textLabel.text = messageTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
