//
//  UserSearchResultObject.h
//  BorrowMe
//
//  Created by Tom Lee on 5/5/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserSearchResultObject : NSObject

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) UIImage* userProfileImage;
@property (strong, nonatomic) NSString* username;

@end
