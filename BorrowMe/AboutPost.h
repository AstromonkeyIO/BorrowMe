//
//  AboutPost.h
//  BorrowMe
//
//  Created by Tom Lee on 4/17/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPost : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *container;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aboutPostSelector;
@property (strong, nonatomic) IBOutlet UILabel *borrowDuration;
@property (strong, nonatomic) IBOutlet UILabel *borrowDate;
@property (strong, nonatomic) IBOutlet UILabel *returnDate;
@property (strong, nonatomic) IBOutlet UITextView *note;

@end
