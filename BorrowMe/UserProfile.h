//
//  UserProfile.h
//  BorrowMe
//
//  Created by Tom Lee on 3/26/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserProfile : UITableViewController

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) NSMutableArray* reviews;

@end
