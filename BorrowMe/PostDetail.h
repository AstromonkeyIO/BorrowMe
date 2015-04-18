//
//  PostDetail.h
//  BorrowMe
//
//  Created by Tom Lee on 4/17/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import "PostObject.h"
#import "RespondToPost.h"
#import "AboutPost.h"

@interface PostDetail : UITableViewController

@property (strong, nonatomic) PostObject* receivedPostObject;
@property (strong, nonatomic) NSMutableArray* postDetails;
@property (strong, nonatomic) PFUser* currentUser;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) CLLocation* currentLocation;

@end
