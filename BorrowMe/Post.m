//
//  Post.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Post.h"
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation Post

/*
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer * postBubbleLayer = [self.postBubble layer];
        [postBubbleLayer setMasksToBounds:YES];
        [postBubbleLayer setCornerRadius:5.0];
        
        CGPoint saveCenter = self.profilePicture.center;
        CGRect newFrame = CGRectMake(self.profilePicture.frame.origin.x, self.profilePicture.frame.origin.y, 60, 60);
        self.profilePicture.frame = newFrame;
        self.profilePicture.layer.cornerRadius = 60 / 2.0;
        self.profilePicture.center = saveCenter;
        self.profilePicture.clipsToBounds = YES;
        
        CALayer* helpButtonLayer = [self.helpButton layer];
        [helpButtonLayer setMasksToBounds:YES];
        [helpButtonLayer setCornerRadius:5.0];
        
    }
    return self;
}
*/

- (IBAction)heartButtonPressed:(id)sender {
   
    if(self.postId == self.postId)
    {
    
        //int heartCount = [self.heartCount.text intValue];
        //heartCount++;
        //self.heartCount.text = [NSString stringWithFormat:@"%d", heartCount];
        
        /*
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        [shake setDuration:0.1];
        [shake setRepeatCount:2];
        [shake setAutoreverses:YES];
        [shake setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(self.heartImage.center.x - 5,self.heartImage.center.y)]];
        [shake setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(self.heartImage.center.x + 5, self.heartImage.center.y)]];
        [self.heartImage.layer addAnimation:shake forKey:@"position"];
        */
        
        /*
        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
        
        self.heartImage.transform = leftWobble;  // starting point
        
        [UIView beginAnimations:@"wobble" context:(__bridge void *)(self.heartImage)];
        [UIView setAnimationRepeatAutoreverses:YES]; // important
        [UIView setAnimationRepeatCount:10];
        [UIView setAnimationDuration:0.03];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
        
        self.heartImage.transform = rightWobble; // end here & auto-reverse
        
        [UIView commitAnimations];
        */
        
        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-14.0));
        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(14.0));
        
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.heartImage.transform = CGAffineTransformMakeScale(1.3,1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.heartImage.transform = CGAffineTransformMakeScale(1,1);
            } completion:^(BOOL finished) {
                
            }];
            //[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
                //self.heartImage.transform = CGAffineTransformMakeScale(1,1);
            //} completion:^(BOOL finished) {
            
            //}];
        }];
        /*
        self.heartImage.transform = leftWobble;  // starting point
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptionAutoreverse) animations:^{
            self.heartImage.transform = rightWobble;
        }completion:^(BOOL finished){
            
            NSLog(@"stop wobble");
            CGAffineTransform stopWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
            self.heartImage.transform = stopWobble;
            [self.heartImage.layer removeAllAnimations];
            //self.heartImage.transform = CGAffineTransformIdentity;
            
            //[self.heartImage.layer removeAllAnimations];
            
        }];
        */
        
        bool alreadyLiked = NO;
        PFUser* currentUser = [PFUser currentUser];
        
        NSLog(@" yooo before %@",currentUser[@"likedPosts"]);
        
        for(int i = 0; i < [currentUser[@"likedPosts"] count]; i++) {
            
            if([[currentUser[@"likedPosts"] objectAtIndex:i] isEqualToString:[self.postPFObject valueForKey:@"objectId"]])
            {
                NSLog(@"found");
                /*
                CGAffineTransform stopWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
                self.heartImage.transform = stopWobble;
                */
                alreadyLiked = true;
                break;
                
            }
            
        }
        
        if(!alreadyLiked)
        {
            NSLog(@"not liked");
        
            NSNumber* likes = self.postPFObject[@"likes"];
            int likesInInt = [likes intValue];
            likesInInt++;
            self.heartCount.text = [NSString stringWithFormat:@"%d", likesInInt];
       
            likes = [NSNumber numberWithInt:likesInInt];
            self.postPFObject[@"likes"] = likes;

            NSLog(@"pfpost object %@", [self.postPFObject valueForKey:@"objectId"]);
            [currentUser[@"likedPosts"] addObject:[self.postPFObject valueForKey:@"objectId"]];
            NSLog(@"yo 1 %@", currentUser[@"likedPosts"]);
            //[currentUser saveInBackground];
            
            
            [self.postPFObject saveInBackground];
            
        }
        else {
            
            NSLog(@"already liked");
            
            NSNumber* likes = self.postPFObject[@"likes"];
            int likesInInt = [likes intValue];
            likesInInt--;
            self.heartCount.text = [NSString stringWithFormat:@"%d", likesInInt];
            
            likes = [NSNumber numberWithInt:likesInInt];
            self.postPFObject[@"likes"] = likes;
            [currentUser[@"likedPosts"] removeObject:[self.postPFObject valueForKey:@"objectId"]];
            NSLog(@"yo 2 %@", currentUser[@"likedPosts"]);
            //[currentUser saveInBackground];
            
            [self.postPFObject saveInBackground];
            
            
        }
        
        
        
    
    }
    
}

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

- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (UIView *)CFBridgingRelease(context);
        item.transform = CGAffineTransformIdentity;
    }
}





@end
