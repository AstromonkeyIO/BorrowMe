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
                    newReview[@"referenceToUser"] = self.currentUser;
                    newReview[@"reviewedUserId"] = self.reviewedUser.objectId;
                    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                    {
                        
                        if(succeeded)
                        {
                            
                            NSMutableDictionary* returnDic = [self convertReviewsPFObjectToNSMutableDictionary:newReview];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewReviewAdded" object:self userInfo:returnDic];
                            
                            [self.review resignFirstResponder];
                            [self dismissViewControllerAnimated:true completion:nil];
                            
                        }
                        else
                        {
                            
                            // There was a problem, check error.description
                            
                        }
                        }];
                    }
                
            }];
        }];
    }];
    
    


}

- (IBAction)heartButton1Pressed:(id)sender {
    
    [self makeAllHeartImagesGray];
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartIconImage1.transform = CGAffineTransformMakeScale(1.3,1.3);
        [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartIconImage1.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    self.currentRating = @"1";

    
}

- (IBAction)heartButton2Pressed:(id)sender {
    
    [self makeAllHeartImagesGray];
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage2.image = [self.heartIconImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartIconImage1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage2.transform = CGAffineTransformMakeScale(1.3,1.3);
        [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartIconImage1.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage2.transform = CGAffineTransformMakeScale(1,1);
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
    
    [self makeAllHeartImagesGray];
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage2.image = [self.heartIconImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage3.image = [self.heartIconImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartIconImage1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage3.transform = CGAffineTransformMakeScale(1.3,1.3);
        [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartIconImage1.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage2.transform = CGAffineTransformMakeScale(1,1);
             self.heartIconImage3.transform = CGAffineTransformMakeScale(1,1);
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

    [self makeAllHeartImagesGray];
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage2.image = [self.heartIconImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage3.image = [self.heartIconImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage4.image = [self.heartIconImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartIconImage1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage3.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage4.transform = CGAffineTransformMakeScale(1.3,1.3);
        [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage4 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartIconImage1.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage2.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage3.transform = CGAffineTransformMakeScale(1,1);
             self.heartIconImage4.transform = CGAffineTransformMakeScale(1,1);
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
    
    [self makeAllHeartImagesGray];
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage2.image = [self.heartIconImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage3.image = [self.heartIconImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage4.image = [self.heartIconImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage5.image = [self.heartIconImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heartIconImage1.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage2.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage3.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage4.transform = CGAffineTransformMakeScale(1.3,1.3);
        self.heartIconImage5.transform = CGAffineTransformMakeScale(1.3,1.3);
        [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage4 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        [self.heartIconImage5 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartIconImage1.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage2.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage3.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage4.transform = CGAffineTransformMakeScale(1,1);
            self.heartIconImage5.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    self.currentRating = @"5";
    
}


- (void) makeAllHeartImagesGray {
    
    self.heartIconImage1.image = [self.heartIconImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage2.image = [self.heartIconImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage3.image = [self.heartIconImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage4.image = [self.heartIconImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.heartIconImage5.image = [self.heartIconImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.heartIconImage1 setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
    [self.heartIconImage2 setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
    [self.heartIconImage3 setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
    [self.heartIconImage4 setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
    [self.heartIconImage5 setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
    
    
}

- (NSMutableDictionary*) convertReviewsPFObjectToNSMutableDictionary:(PFObject*) reviewsPFObject
{

    NSArray * allKeys = [reviewsPFObject allKeys];
    NSMutableDictionary * retDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in allKeys)
    {
        
        [retDict setObject:[reviewsPFObject objectForKey:key] forKey:key];
        
    }
    
    [retDict setValue:reviewsPFObject.objectId forKey:@"objectId"];
    
    return retDict;
    
}

- (IBAction)dismissViewButtonPressed:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
