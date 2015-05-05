//
//  Response.h
//  BorrowMe
//
//  Created by Tom Lee on 3/11/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Response : NSObject

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) UIImage* userProfile;
@property (strong, nonatomic) UIImage* itemImage;
@property (strong, nonatomic) NSData* itemImageData;
@property (strong, nonatomic) NSString* itemDescription;
@property (strong, nonatomic) NSString* note;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) PFObject* responsePFObject;

@end
