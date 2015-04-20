//
//  Post.h
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface Post : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *postBubble;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *username;
@property (strong, nonatomic) NSString* userId;
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UILabel *heartCount;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;
@property (strong, nonatomic) NSString* postId;
@property (strong, nonatomic) PFObject* postPFObject;

@end
