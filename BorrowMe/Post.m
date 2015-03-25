//
//  Post.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Post.h"

@implementation Post


- (IBAction)helpButtonPressed:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RespondToPost" object:nil userInfo:@{@"index" : @(self.index)}];
    
    NSString* buttonTitle = [NSString stringWithFormat:@":)"];
    [self.helpButton setTitle: buttonTitle forState: UIControlStateNormal];
    
    /*
    [NSTimer scheduledTimerWithTimeInterval:1.2
                                     target:self
                                   selector:@selector(temp)
                                   userInfo:nil
                                    repeats:NO];
     */
    
}


@end
