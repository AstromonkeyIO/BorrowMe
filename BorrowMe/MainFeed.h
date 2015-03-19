//
//  MainFeed.h
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostObject.h"
#import <Parse/Parse.h>

@interface MainFeed : UITableViewController

@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) NSMutableArray* posts;
@property (strong, nonatomic) UINavigationBar* navBar;

@end
