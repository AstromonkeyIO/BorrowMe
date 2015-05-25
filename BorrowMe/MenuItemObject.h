//
//  MenuItem.h
//  BorrowMe
//
//  Created by Tom Lee on 5/24/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MenuItemObject : NSObject

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) UIImage* userProfileImage;
@property (strong, nonatomic) NSString* username;

@end
