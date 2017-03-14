//
//  VoucherTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/15.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "VoucherTableViewCell.h"

@implementation VoucherTableViewCell{
    UIImageView *voucherImage;
    
    UILabel *voucherNumberLabel;
    
    UILabel *voucherSourceLabel;
    
    UILabel *voucherExpredLabel;
    
    UILabel *voucherSerilLabel;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.hidden = YES;
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        
        voucherImage = [[UIImageView alloc] init];
        [self.contentView addSubview:voucherImage];
        
        voucherNumberLabel = [[UILabel alloc] init];
        voucherNumberLabel.textColor = [UIColor whiteColor];
        voucherNumberLabel.textAlignment = NSTextAlignmentCenter;
        voucherNumberLabel.font = Font(25);
        [voucherImage addSubview:voucherNumberLabel];
        
        voucherSourceLabel = [[UILabel alloc] init];
        voucherSourceLabel.textColor = [UIColor whiteColor];
        voucherSourceLabel.textAlignment = NSTextAlignmentLeft;
        voucherSourceLabel.font = Font(15);
        [voucherImage addSubview:voucherSourceLabel];
        
        voucherExpredLabel = [[UILabel alloc] init];
        voucherExpredLabel.textColor = [UIColor whiteColor];
        voucherExpredLabel.textAlignment = NSTextAlignmentLeft;
        voucherExpredLabel.font = Font(13);
        [voucherImage addSubview:voucherExpredLabel];
        
        voucherSerilLabel = [[UILabel alloc] init];
        voucherSerilLabel.numberOfLines = -1;
        voucherSerilLabel.textColor = [UIColor whiteColor];
        voucherSerilLabel.textAlignment = NSTextAlignmentLeft;
        voucherSerilLabel.font = Font(12);
        [voucherImage addSubview:voucherSerilLabel];
    }
    
    return self;
}

-(void)layoutSubviews{
    if (self.voucherType == VoucherTypeUnUsed) {
        voucherImage.image = [UIImage imageNamed:@"bg__yhq_unused"];
    }else if(self.voucherType == VoucherTypeUsed){
        voucherImage.image = [UIImage imageNamed:@"bg__yhq_used"];
    }else{
        voucherImage.image = [UIImage imageNamed:@"bg__yhq_expired"];
    }
    CGFloat height = [VoucherTableViewCell staticCellHieght];
    voucherImage.frame = (CGRect){5,5,WIDTH(self.contentView)-10,height-10};
    
    voucherNumberLabel.frame = (CGRect){15,7,75,HEIGHT(voucherImage)-14};
    
    voucherSerilLabel.frame = (CGRect){WIDTH(voucherImage)-15-75,7,75,HEIGHT(voucherImage)-14};
    
    voucherSourceLabel.frame = (CGRect){RIGHT(voucherNumberLabel)+2,10,LEFT(voucherSerilLabel)-5-RIGHT(voucherNumberLabel),(HEIGHT(voucherImage)-14-5)/2};
    
    voucherExpredLabel.frame = (CGRect){LEFT(voucherSourceLabel),BOTTOM(voucherSourceLabel)+3,WIDTH(voucherSourceLabel),(HEIGHT(voucherImage)-14-5)/2};
    
    
    
    
    
//    voucherSourceLabel.backgroundColor = [UIColor purpleColor];
//    voucherSourceLabel.text = @"百度外卖优惠券";
//    voucherExpredLabel.backgroundColor = [UIColor yellowColor];
//    voucherExpredLabel.text = @"有效期:2015/11/18";
//    voucherNumberLabel.backgroundColor = [UIColor redColor];
//    voucherNumberLabel.text = @"￥100";
//    voucherSerilLabel.backgroundColor = [UIColor redColor];
//    voucherSerilLabel.text = @"BWMN8787";
}

-(void)setVoucherNum:(int)voucherNum{
    _voucherNum = voucherNum;
    voucherNumberLabel.text = [NSString stringWithFormat:@"￥%d",voucherNum];
}

-(void)setVoucherSerilNumber:(NSString *)voucherSerilNumber{
    _voucherSerilNumber = voucherSerilNumber;
    if (voucherSerilNumber) {
        voucherSerilLabel.text = voucherSerilNumber;
    }
}

-(void)setVoucherSource:(NSString *)voucherSource{
    _voucherSource = voucherSource;
    if (voucherSource) {
        voucherSourceLabel.text = voucherSource;
    }
}

-(void)setVoucherExpredTimeStamp:(long long)voucherExpredTimeStamp{
    _voucherExpredTimeStamp = voucherExpredTimeStamp;
    if (voucherExpredTimeStamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:voucherExpredTimeStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        if (destDateString) {
            voucherExpredLabel.text = [NSString stringWithFormat:@"有效期:%@",destDateString];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(CGFloat)staticCellHieght{
    if (IS4_7Inches()) {
        return 100;
    }else if (Is4Inches() || Is3_5Inches()){
        return 100;
    }
    return 100;
}

@end
