//
//  PostTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "PostTableViewCell.h"
#import "UNTools.h"

@implementation PostTableViewCell{
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"more"];
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGBColor(80, 80, 80);
        self.textLabel.font = Font(15);
        self.textLabel.backgroundColor = self.contentView.backgroundColor;
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        self.detailTextLabel.font = Font(12);
        self.detailTextLabel.backgroundColor = self.contentView.backgroundColor;
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:lineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){10,10,WIDTH(self.contentView)-10-10-20,20};
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+10,WIDTH(self.textLabel),15};
    
    self.imageView.frame = (CGRect){WIDTH(self.contentView)-10-7,(PostTableViewCellViewHeight-11)/2,7,11};
    
    lineView.frame = (CGRect){0,PostTableViewCellViewHeight-0.5,WIDTH(self.contentView),0.5};
}

-(void)setPostTitle:(NSString *)postTitle{
    _postTitle = postTitle;
    if (postTitle) {
        self.textLabel.text = postTitle;
    }
}

-(void)setPostTimeStamp:(long long)postTimeStamp{
    _postTimeStamp = postTimeStamp;
    if (postTimeStamp > 0) {
        NSString *postTimeString = [UNTools parseTimeWithTimeStamp:postTimeStamp];
        if (postTimeString) {
            self.detailTextLabel.text = postTimeString;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
