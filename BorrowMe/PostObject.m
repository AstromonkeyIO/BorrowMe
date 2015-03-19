//
//  PostObject.m
//  BorrowMe
//
//  Created by Tom Lee on 2/9/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "PostObject.h"

@implementation PostObject

- (void) setUserObject:(PFUser *)user {
    
    self.user = user;
    
}

- (void) setItemObject:(NSString *)item {
    
    self.item = item;
    
}

- (void) setPostObject:(PFObject *)post {
    
    self.post = post;
}

- (PFUser*) getUser {
    
    return self.user;
    
}

- (NSString*) getItem {
    
    return self.item;
    
}

- (PFObject*) getPost {
    
    return self.post;
    
}


@end
