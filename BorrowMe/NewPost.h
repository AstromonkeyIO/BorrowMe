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
@property (weak, nonatomic) IBOutlet UITextView *noteBox;


@end
