//
//  NewPost.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "NewPost.h"

@implementation NewPost

- (void)viewDidLoad
{
    [super viewDidLoad];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 625)];
    
    
    
    [self.itemInput becomeFirstResponder];
    
    
    self.currentUser = [PFUser currentUser];    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeWindow:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}

- (IBAction)askButtonPressed:(id)sender {
    
    PFObject *newPost = [PFObject objectWithClassName:@"Posts"];
    newPost[@"item"] = self.itemInput.text;
    PFRelation *relation = [newPost relationForKey:@"user"];
    [relation addObject:self.currentUser];
    [newPost saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}






@end
