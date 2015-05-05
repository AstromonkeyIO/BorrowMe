//
//  MyPostLender.m
//  BorrowMe
//
//  Created by Tom Lee on 3/9/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#import "MyPostLender.h"

@implementation MyPostLender





- (IBAction)RespondToLender:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RespondToLender" object:nil userInfo:@{@"index" : @(self.index)}];
    
    /*
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Hello from Mugunth";
        controller.recipients = [NSArray arrayWithObjects:@"12345678", @"87654321", nil];
        controller.messageComposeDelegate = self;
        [self. presentModalViewController:controller animated:YES];
    }
     */
    
    
}


- (IBAction)usernameButtonPressed:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayUserProfile" object:nil userInfo:@{@"index" : @(self.index)}];
    
    
}

- (IBAction)userProfileButtonPressed:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayUserProfile" object:nil userInfo:@{@"index" : @(self.index)}];    
    
}

- (IBAction)xButtonPressed:(id)sender {
    

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteResponse" object:nil userInfo:@{@"index" : @(self.index)}];
    

}


@end
