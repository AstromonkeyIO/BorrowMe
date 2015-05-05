//
//  UserCell.h
//  BorrowMe
//
//  Created by Tom Lee on 3/29/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userProfilePictureButton;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIButton *background;
@property (weak, nonatomic) IBOutlet UILabel *container;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;

@end
