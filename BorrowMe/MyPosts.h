//
//  MyPosts.h
//  BorrowMe
//
//  Created by Tom Lee on 2/24/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPosts : UITableViewController

@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) NSMutableArray* myPosts;


@end
