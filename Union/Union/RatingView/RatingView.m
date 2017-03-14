//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@interface RatingView ()

@property (nonatomic, strong) UIImageView *s1;
@property (nonatomic, strong) UIImageView *s2;
@property (nonatomic, strong) UIImageView *s3;
@property (nonatomic, strong) UIImageView *s4;
@property (nonatomic, strong) UIImageView *s5;

@end

@implementation RatingView

@synthesize s1, s2, s3, s4, s5;

static float ratingEveryAligh = 2;

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage {
	unselectedImage = [UIImage imageNamed:deselectedImage];
	partlySelectedImage = halfSelectedImage == nil ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	
	height=0.0; width=0.0;
	if (height < [fullySelectedImage size].height) {
		height = [fullySelectedImage size].height;
	}
	if (height < [partlySelectedImage size].height) {
		height = [partlySelectedImage size].height;
	}
	if (height < [unselectedImage size].height) {
		height = [unselectedImage size].height;
	}
	if (width < [fullySelectedImage size].width) {
		width = [fullySelectedImage size].width;
	}
	if (width < [partlySelectedImage size].width) {
		width = [partlySelectedImage size].width;
	}
	if (width < [unselectedImage size].width) {
		width = [unselectedImage size].width;
	}
	
	starRating = 0;
	lastRating = 0;
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
	
	[s1 setFrame:CGRectMake(0,         0, width, height)];
	[s2 setFrame:CGRectMake(width+ratingEveryAligh,     0, width, height)];
	[s3 setFrame:CGRectMake(2 * (width+ratingEveryAligh), 0, width, height)];
	[s4 setFrame:CGRectMake(3 * (width+ratingEveryAligh), 0, width, height)];
	[s5 setFrame:CGRectMake(4 * (width+ratingEveryAligh), 0, width, height)];
	
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
	
	[self addSubview:s1];
	[self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
	
	CGRect frame = [self frame];
	frame.size.width = width * 5 + ratingEveryAligh *4;
	frame.size.height = height;
	[self setFrame:frame];
}

-(void)setRatingAligh:(float)aligh{
    ratingEveryAligh = aligh;
    
    [s1 setFrame:CGRectMake(0,         0, width, height)];
    [s2 setFrame:CGRectMake(width+ratingEveryAligh,     0, width, height)];
    [s3 setFrame:CGRectMake(2 * (width+ratingEveryAligh), 0, width, height)];
    [s4 setFrame:CGRectMake(3 * (width+ratingEveryAligh), 0, width, height)];
    [s5 setFrame:CGRectMake(4 * (width+ratingEveryAligh), 0, width, height)];
    CGRect selfFrame = self.frame;
    self.frame = (CGRect){selfFrame.origin.x,selfFrame.origin.y,width * 5 + ratingEveryAligh *4,height};
}

-(void)displayRating:(float)rating {
	[s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
	
    _selectedStarNum = 0;
	if (rating >= 0.5) {
        _selectedStarNum = 0.5;
		[s1 setImage:partlySelectedImage];
	}
	if (rating >= 1) {
        _selectedStarNum = 1;
		[s1 setImage:fullySelectedImage];
	}
	if (rating >= 1.5) {
        _selectedStarNum = 1.5;
		[s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
        _selectedStarNum = 2;
		[s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
        _selectedStarNum = 2.5;
		[s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
        _selectedStarNum = 3;
		[s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
        _selectedStarNum = 3.5;
		[s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
        _selectedStarNum = 4;
		[s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
        _selectedStarNum = 4.5;
		[s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
        _selectedStarNum = 5;
		[s5 setImage:fullySelectedImage];
	}
	
	starRating = rating;
	lastRating = rating;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
    if (!self.canTouchToChange) {
        return;
    }
    [touches enumerateObjectsUsingBlock:^(UITouch *obj, BOOL *stop) {
        if([obj.view isKindOfClass:[self class]]){
            CGPoint po = [obj locationInView:self];
            CGFloat fl = 5.0f*po.x/self.frame.size.width+0.5;
            [self displayRating:fl];
            if (self.delegate && [self.delegate respondsToSelector:@selector(ratingViewDidChangeValue:)]) {
                [self.delegate ratingViewDidChangeValue:self];
            }
        }
    }];
}

-(float)rating {
	return starRating;
}

@end
