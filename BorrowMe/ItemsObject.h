//
//  itemsObject.h
//  BorrowMe
//
//  Created by Tom Lee on 6/19/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemsObject : NSObject

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* leftItemTitle;
@property (strong, nonatomic) UIImage* leftItemImage;
@property (strong, nonatomic) NSString* rightItemTitle;
@property (strong, nonatomic) UIImage* rightItemImage;

@end
