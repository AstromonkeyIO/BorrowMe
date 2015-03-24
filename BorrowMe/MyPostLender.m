//
//  MyPostLender.m
//  BorrowMe
//
//  Created by Tom Lee on 3/9/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

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


@end
