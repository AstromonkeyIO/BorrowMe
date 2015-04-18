//
//  NewPost.h
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainFeed.h"

@interface NewPost : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemInput;
@property (strong, nonatomic) PFUser* currentUser;
@property (weak, nonatomic) IBOutlet UILabel *itemInputBubble;
@property (weak, nonatomic) IBOutlet UIButton *askButton;
@property (strong, nonatomic) MainFeed* mainFeed;
@property (weak, nonatomic) IBOutlet UILabel *backgroundBubble;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *returnDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *noteBox;
@property (weak, nonatomic) IBOutlet UILabel *loadingBackground;
@property (weak, nonatomic) IBOutlet UILabel *loadingBox;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateRangeSelector;
@property (strong, nonatomic) UIGestureRecognizer* gestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *timeNoteSelectorBackground;


@end
