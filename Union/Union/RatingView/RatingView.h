//
//  RatingViewController.h
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;
@protocol RatingViewDelegate <NSObject>

@optional
-(void)ratingViewDidChangeValue:(RatingView *)ratingView;

@end

@interface RatingView : UIView {
	UIImageView *s1, *s2, *s3, *s4, *s5;
	UIImage *unselectedImage, *partlySelectedImage, *fullySelectedImage;

	float starRating, lastRating;
	float height, width; // of each image of the star!
}

@property (nonatomic,assign,readonly) float selectedStarNum;

@property (nonatomic,assign) BOOL canTouchToChange;

@property (nonatomic,weak) id<RatingViewDelegate> delegate;

-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage 
			  fullSelected:(NSString *)fullSelectedImage;

-(void)setRatingAligh:(float)aligh;

-(void)displayRating:(float)rating;

-(float)rating;

@end