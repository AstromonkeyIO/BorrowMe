//
//  PostReview.h
//  BorrowMe
//
//  Created by Tom Lee on 3/31/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface PostReview : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *container;
@property (weak, nonatomic) IBOutlet UITextView *review;
@property (weak, nonatomic) IBOutlet UILabel *ratingDisplay;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) NSString* currentRating;
@property (weak, nonatomic) IBOutlet UIButton *heartButton1;
@property (weak, nonatomic) IBOutlet UIButton *heartButton2;
@property (weak, nonatomic) IBOutlet UIButton *heartButton3;
@property (weak, nonatomic) IBOutlet UIButton *heartButton4;
@property (weak, nonatomic) IBOutlet UIButton *heartButton5;
@property (weak, nonatomic) IBOutlet UIImageView *heartIconImage1;
@property (weak, nonatomic) IBOutlet UIImageView *heartIconImage2;
@property (weak, nonatomic) IBOutlet UIImageView *heartIconImage3;
@property (weak, nonatomic) IBOutlet UIImageView *heartIconImage4;
@property (weak, nonatomic) IBOutlet UIImageView *heartIconImage5;


@end
