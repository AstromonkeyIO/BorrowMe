//
//  UserObject.h
//  BorrowMe
//
//  Created by Tom Lee on 3/30/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserObject : NSObject

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) UIImage* userProfile;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* averageRating;

@end
