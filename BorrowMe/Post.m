//
//  Post.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Post.h"

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





@end
