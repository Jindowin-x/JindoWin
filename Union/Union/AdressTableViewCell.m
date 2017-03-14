//
//  AdressInfoTableViewCell.m
//  Union
//
//  Created by xiaoyu on 15/11/14.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "AdressTableViewCell.h"

@implementation AdressTableViewCell{
    UILabel *phoneLabel;
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"icon_edit"];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTap:)];
        [self.imageView addGestureRecognizer:imageTap];
        
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = Font(16);
        
        self.detailTextLabel.textColor = RGBColor(100, 100, 100);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = Font(12);
        
        phoneLabel = [[UILabel alloc] init];
        phoneLabel.textColor = self.textLabel.textColor;
        phoneLabel.font = self.textLabel.font;
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        phoneLabel.font = Font(16);
        [self.contentView addSubview:phoneLabel];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:lineView];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){WIDTH(self.contentView)-40,(AdressCellViewHeight-22)/2,20,22};
//    self.imageView.backgroundColor = [UIColor redColor];
    
    self.textLabel.frame = (CGRect){15,10,110,15};
//    self.textLabel.backgroundColor = [UIColor redColor];
//    self.textLabel.text = @"欧阳高广 先生";
    
    self.detailTextLabel.frame = (CGRect){LEFT(self.textLabel),BOTTOM(self.textLabel)+10,LEFT(self.imageView)-LEFT(self.textLabel)-20,14};
//    self.detailTextLabel.backgroundColor = [UIColor yellowColor];
//    self.detailTextLabel.text = @"北极光冲了个凉卡嘉莉看那看那金卡还上课";
    
    phoneLabel.frame = (CGRect){140,TOP(self.textLabel),120,HEIGHT(self.textLabel)};
//    phoneLabel.backgroundColor = [UIColor purpleColor];
//    phoneLabel.text = @"13349906348";
    
    
    lineView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
    
//    [self.contentView bringSubviewToFront:self.imageView];
}

-(void)setAdressInfo:(AdressInfo *)adressInfo{
    _adressInfo = adressInfo;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@",adressInfo.name,adressInfo.sex==0?@"先生":@"女士"];
    
    if (adressInfo.mapAdress) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",adressInfo.mapAdress,adressInfo.detailAdress?adressInfo.detailAdress:@""];
    }else{
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",adressInfo.detailAdress?adressInfo.detailAdress:@""];
    }
    
    phoneLabel.text = adressInfo.phone?adressInfo.phone:@"";
}

-(void)editTap:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressTableDidTapEditImage:)]) {
        [self.delegate addressTableDidTapEditImage:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
