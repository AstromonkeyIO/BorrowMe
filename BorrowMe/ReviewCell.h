//
//  ReviewCell.h
//  BorrowMe
//
//  Created by Tom Lee on 3/29/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UITextView *review;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *container;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage1;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage2;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage3;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage4;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage5;

@end
