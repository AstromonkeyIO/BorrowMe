//
//  PostReview.m
//  BorrowMe
//
//  Created by Tom Lee on 3/31/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "PostReview.h"

@implementation PostReview

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //show camera...
}

- (void) viewDidLoad {

    
    [self.review becomeFirstResponder];
    self.currentUser = [PFUser currentUser];
    

    
}
- (IBAction)ratingSliderValueChanged:(id)sender
{
    
    int sliderValueInInt = (int)self.ratingSlider.value;
    self.ratingDisplay.text = [NSString stringWithFormat:@"%d", sliderValueInInt];

}

- (IBAction)writeReviewButtonPressed:(id)sender
{
    
    [self.review resignFirstResponder];
    PFObject *newReview = [PFObject objectWithClassName:@"Reviews"];
    newReview[@"review"] = self.review.text;
    newReview[@"rating"] = self.ratingDisplay.text;
    PFRelation *relation = [newReview relationForKey:@"user"];
    [relation addObject:self.currentUser];
    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            
            PFRelation* userToReviewRelation = [self.currentUser relationForKey:@"reviews"];
            [userToReviewRelation addObject:newReview];
            [self.currentUser save];
            [self dismissViewControllerAnimated:true completion:nil];
            
        }
        else {
            // There was a problem, check error.descriptio
        }
    }];

}

- (IBAction)dismissViewButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
