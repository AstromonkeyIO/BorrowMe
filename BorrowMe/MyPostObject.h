//
//  MyPost.h
//  BorrowMe
//
//  Created by Tom Lee on 2/25/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MyPostObject : NSObject

@property (strong, nonatomic) NSString* item;
@property (strong, nonatomic) NSMutableArray* lenders;
@property (strong, nonatomic) NSMutableArray* responses;
@property (strong, nonatomic) PFObject* myPostPFObject;
@property (strong, nonatomic) NSString* deadline;
@property (strong, nonatomic) NSString* urgency;

- (void) initialize;


@end
