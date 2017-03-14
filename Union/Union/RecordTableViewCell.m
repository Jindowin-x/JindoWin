//
//  RecordTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "UNTools.h"

@implementation RecordTableViewCell{
    UILabel *recordNumLabel;
    UILabel *yueNumLabel;
    UIView *lineSepLineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.hidden = YES;
        
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(15);
        
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = Font(13);
        
        recordNumLabel = [[UILabel alloc] init];
        recordNumLabel.textColor = [UIColor redColor];
        recordNumLabel.textAlignment = NSTextAlignmentRight;
        recordNumLabel.font = Font(15);
        [self.contentView addSubview:recordNumLabel];
        
        yueNumLabel = [[UILabel alloc] init];
        yueNumLabel.textColor = RGBColor(140, 140, 140);
        yueNumLabel.textAlignment = NSTextAlignmentRight;
        yueNumLabel.font = Font(13);
        [self.contentView addSubview:yueNumLabel];
        
        lineSepLineView = [[UIView alloc] init];
        lineSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:lineSepLineView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){10,7,WIDTH(self.contentView)-120,20};
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),RecordTableViewCellViewHeight-8-15,120,15};
    
    recordNumLabel.frame = (CGRect){WIDTH(self.contentView)-10-120,TOP(self.textLabel),120,HEIGHT(self.textLabel)};
    
    yueNumLabel.frame  =(CGRect){LEFT(recordNumLabel),TOP(self.detailTextLabel),120,HEIGHT(self.detailTextLabel)};
    
    lineSepLineView.frame = (CGRect){0,RecordTableViewCellViewHeight-0.5,WIDTH(self.contentView),0.5};
}

-(void)setRecordName:(NSString *)recordName{
    if (!recordName) {
        return;
    }
    _recordName = recordName;
    self.textLabel.text = recordName;
}

-(void)setRecordNumber:(float)recordNumber{
    _recordNumber = recordNumber;
    NSString *prefix = @"+";
    if (recordNumber < 0) {
        prefix = @"-";
    }
    if ((int)(recordNumber*10)-((int)(recordNumber))*10 == 0) {
        recordNumLabel.text = [NSString stringWithFormat:@"%@￥%d",prefix,(int)recordNumber];
    }else{
        recordNumLabel.text = [NSString stringWithFormat:@"%@￥%.1f",prefix,recordNumber];
    }
}

-(void)setRecordTimeStamp:(long long)recordTimeStamp{
    if (recordTimeStamp != 0) {
        _recordTimeStamp = recordTimeStamp;
        NSString *timeDate = [UNTools parseTimeWithTimeStamp:recordTimeStamp];
        if (timeDate) {
            self.detailTextLabel.text = timeDate;
        }
    }
}

-(void)setRecordYueNumber:(float)recordYueNumber{
    _recordYueNumber = recordYueNumber;
    NSString *prefix = @"余额：￥";
    if (recordYueNumber < 0) {
        prefix = @"余额：￥-";
    }
    if ((int)(recordYueNumber*10)-((int)(recordYueNumber))*10 == 0) {
        yueNumLabel.text = [NSString stringWithFormat:@"%@%d",prefix,(int)recordYueNumber];
    }else{
        yueNumLabel.text = [NSString stringWithFormat:@"%@%.1f",prefix,recordYueNumber];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
