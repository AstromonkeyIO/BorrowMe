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
    
    CALayer* containerLayer = [self.container layer];
    [containerLayer setMasksToBounds:YES];
    [containerLayer setCornerRadius:5.0];
    
    
    CALayer* reviewLayer = [self.review layer];
    [reviewLayer setMasksToBounds:YES];
    [reviewLayer setCornerRadius:10.0];
    
    CALayer* rateButtonLayer = [self.rateButton layer];
    [rateButtonLayer setMasksToBounds:YES];
    [rateButtonLayer setCornerRadius:5.0];
    
    self.currentRating = @"0";
    
    [self.review becomeFirstResponder];
    self.currentUser = [PFUser currentUser];
    

    
}

- (IBAction)writeReviewButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.rateButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.rateButton.transform = CGAffineTransformMakeScale(0.9,0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.rateButton.transform = CGAffineTransformMakeScale(1,1);
            } completion:^(BOOL finished) {


                    if([self.currentRating isEqualToString:@"0"])
                    {
                        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                              message:@"Please rate!"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles: nil];
                        [myAlertView show];
                        
                        
                    }
                    else
                    {
                    
                    

                    PFObject *newReview = [PFObject objectWithClassName:@"Reviews"];
                    if(self.review.text.length == 0)
                    {
                        
                        newReview[@"review"] = @"";
                        
                    }
                    else
                    {
                        
                        newReview[@"review"] = self.review.text;
                        
                    }
                    newReview[@"rating"] = self.currentRating;
                    PFRelation *relation = [newReview relationForKey:@"user"];
                    [relation addObject:self.currentUser];
                    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded)
                        {
                            
                            PFRelation* userToReviewRelation = [self.currentUser relationForKey:@"reviews"];
                            [userToReviewRelation addObject:newReview];
                            [self.currentUser save];
                            [self.review resignFirstResponder];
                            [self dismissViewControllerAnimated:true completion:nil];
                            
                        }
                        else {
                            // There was a problem, check error.descriptio
                        }
                        }];
                    }
                
            }];
        }];
    }];
    
    


}

- (IBAction)heartButton1Pressed:(id)sender {
    
    
    UIImage * myImage = [UIImage imageNamed: @"hourglassIcon.png"];
    if(myImage == NULL)
    {
        NSLog(@"null!");
        
    }
    else
    {
        NSLog(@"here");
    }
    
    
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"heartIconPurple.png"]];
    
    NSLog(@"%@", imgData);
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartButton1.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartButton1.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
        //[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        //self.heartImage.transform = CGAffineTransformMakeScale(1,1);
        //} completion:^(BOOL finished) {
        
        //}];
    }];
    
    self.currentRating = @"1";

    
}

- (IBAction)heartButton2Pressed:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartButton1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton2.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartButton1.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton2.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
        //[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        //self.heartImage.transform = CGAffineTransformMakeScale(1,1);
        //} completion:^(BOOL finished) {
        
        //}];
    }];
    
    self.currentRating = @"2";

    
    
}

- (IBAction)heartButton3Pressed:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartButton1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton3.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartButton1.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton2.transform = CGAffineTransformMakeScale(1,1);
             self.heartButton3.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
        //[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        //self.heartImage.transform = CGAffineTransformMakeScale(1,1);
        //} completion:^(BOOL finished) {
        
        //}];
    }];
    
    self.currentRating = @"3";
    
    
}

- (IBAction)heartButton4Pressed:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartButton1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton3.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton4.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartButton1.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton2.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton3.transform = CGAffineTransformMakeScale(1,1);
             self.heartButton4.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
        //[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        //self.heartImage.transform = CGAffineTransformMakeScale(1,1);
        //} completion:^(BOOL finished) {
        
        //}];
    }];
    
    self.currentRating = @"4";
    
}

- (IBAction)heartButton5Pressed:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartButton1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton3.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton4.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartButton5.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartButton1.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton2.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton3.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton4.transform = CGAffineTransformMakeScale(1,1);
            self.heartButton5.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    self.currentRating = @"5";
    
}







- (IBAction)dismissViewButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
