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
    
    NSString* buttonTitle = [NSString stringWithFormat:@":)"];
    [self.helpButton setTitle: buttonTitle forState: UIControlStateNormal];
    
    [NSTimer scheduledTimerWithTimeInterval:1.2
                                     target:self
                                   selector:@selector(temp)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void) temp {
   
    UITableView *tableView = (UITableView *)self.superview.superview;
    //[tableView performSegueWithIdentifier:@"RespondTo" sender:tableView];
    
}


@end
