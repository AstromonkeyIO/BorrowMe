//
//  PostReview.h
//  BorrowMe
//
//  Created by Tom Lee on 3/31/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostReview : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *review;
@property (weak, nonatomic) IBOutlet UILabel *ratingDisplay;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) PFUser* currentUser;

@end
