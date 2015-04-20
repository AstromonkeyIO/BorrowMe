//
//  MyPostLender.h
//  BorrowMe
//
//  Created by Tom Lee on 3/9/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostLender : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIButton *userProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *messageButtonContainer;
@property (weak, nonatomic) IBOutlet UILabel *xButtonContainer;

@end
