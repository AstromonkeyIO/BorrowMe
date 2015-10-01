//
//  ReviewObject.h
//  BorrowMe
//
//  Created by Tom Lee on 3/29/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ReviewObject : NSObject

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) UIImage* userProfile;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) PFObject* reviewPFObject;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSString* review;

@end
