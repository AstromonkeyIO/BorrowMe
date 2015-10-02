//
//  MyPosts.h
//  BorrowMe
//
//  Created by Tom Lee on 2/24/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface MyPosts : UITableViewController

@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) NSMutableArray* myPosts;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myPostsSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;
@property (strong, nonatomic) NSMutableArray* deletedMyPostsArray;


@end
