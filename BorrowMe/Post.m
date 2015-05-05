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

- (IBAction)heartButtonPressed:(id)sender {
   
    if(self.postId == self.postId)
    {
        
        bool alreadyLiked = NO;
        PFUser* currentUser = [PFUser currentUser];
        
        NSLog(@" yooo before %@",currentUser[@"likedPosts"]);
        
        for(int i = 0; i < [currentUser[@"likedPosts"] count]; i++) {
            
            if([[currentUser[@"likedPosts"] objectAtIndex:i] isEqualToString:[self.postPFObject valueForKey:@"objectId"]])
            {
                NSLog(@"found");
                alreadyLiked = true;
                break;
                
            }
            
        }
        
        if(!alreadyLiked)
        {

            self.heartImage.image = [self.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.heartImage.transform = CGAffineTransformMakeScale(1.3,1.3);
                [self.heartImage setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.heartImage.transform = CGAffineTransformMakeScale(1,1);
                } completion:^(BOOL finished) {
                    
                    
                    
                }];
            }];
            
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
            [currentUser saveInBackground];
            [self.postPFObject saveInBackground];
            
        }
        else
        {
            
            NSLog(@"already liked");
            
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-14.0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(14.0));

            self.heartImage.transform = leftWobble;  // starting point
            self.heartImage.image = [self.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptionAutoreverse) animations:^{
                self.heartImage.transform = rightWobble;
            }completion:^(BOOL finished){
                
                NSLog(@"stop wobble");
                CGAffineTransform stopWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
                self.heartImage.transform = stopWobble;
                [self.heartImage.layer removeAllAnimations];
                [self.heartImage setTintColor:[UIColor colorWithRed: 64.0/255.0 green: 64.0/255.0 blue:64.0/255.0 alpha: 1.0]];
            }];
            
            NSNumber* likes = self.postPFObject[@"likes"];
            int likesInInt = [likes intValue];
            likesInInt--;
            self.heartCount.text = [NSString stringWithFormat:@"%d", likesInInt];
            
            likes = [NSNumber numberWithInt:likesInInt];
            self.postPFObject[@"likes"] = likes;
            [currentUser[@"likedPosts"] removeObject:[self.postPFObject valueForKey:@"objectId"]];
            NSLog(@"yo 2 %@", currentUser[@"likedPosts"]);
            [currentUser saveInBackground];
            
            [self.postPFObject saveInBackground];
            
            
        }
    
    }
    
}

- (IBAction)helpButtonPressed:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RespondToPost" object:nil userInfo:@{@"index" : @(self.index)}];
    
   // NSString* buttonTitle = [NSString stringWithFormat:@":)"];
    //[self.helpButton setTitle: buttonTitle forState: UIControlStateNormal];
    
    
}

- (IBAction)usernameButtonPressed:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayUserProfile" object:nil userInfo:@{@"index" : @(self.index)}];
    
}


- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (UIView *)CFBridgingRelease(context);
        item.transform = CGAffineTransformIdentity;
    }
}





@end
