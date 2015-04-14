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
    [self.itemInput becomeFirstResponder];
    
    CALayer* backgroundBubbleLayer = [self.backgroundBubble layer];
    [backgroundBubbleLayer setMasksToBounds:YES];
    [backgroundBubbleLayer setCornerRadius:7.5];
    
    CALayer* askButtonLayer = [self.askButton layer];
    [askButtonLayer setMasksToBounds:YES];
    [askButtonLayer setCornerRadius:5.0];
    
    CALayer* noteBoxLayer = [self.noteBox layer];
    [noteBoxLayer setMasksToBounds:YES];
    [noteBoxLayer setCornerRadius:10.0];
    
    CALayer* loadingBoxLayer = [self.loadingBox layer];
    [loadingBoxLayer setMasksToBounds:YES];
    [loadingBoxLayer setCornerRadius:10.0];
    
    self.noteBox.text = @"Leave a little note!";
    
    //[[self.askButton layer] setBorderWidth:2.0f];
    //[[self.askButton layer] setBorderColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0].CGColor];
    
    self.currentUser = [PFUser currentUser];
    
    NSLog(@"current zipcode in new post%@",self.currentUser[@"currentZipcode"]);
    
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.itemInput becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeWindow:(id)sender {
    
    self.itemInput.text = @"";
    self.noteBox.text = @"Leave a little note!";
    self.noteBox.hidden = YES;
    self.datePicker.hidden = NO;
    
    [self resignFirstResponder];
    [self.tabBarController setSelectedIndex:0];
    //[self dismissViewControllerAnimated:YES completion:Nil];
    
}

- (IBAction)askButtonPressed:(id)sender {

    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CST"]];
    NSDate* currentDate = [NSDate date];

    NSTimeInterval secondsBetween = [self.datePicker.date timeIntervalSinceDate: currentDate];
    NSLog(@"currentDate %@", currentDate);
    NSLog(@"secondsBetween %f", secondsBetween);
    
    if(self.itemInput.text.length == 0)
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Please tell us what you are trying to borrow!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else if(secondsBetween <= 0)
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Don't set your deadline to the past!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
        
    }
    else
    {
        
        self.loadingBackground.hidden = NO;
        self.loadingBox.hidden = NO;
        self.loadingImage.hidden = NO;
        
        CABasicAnimation *rotation;
        rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = [NSNumber numberWithFloat:0];
        rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        rotation.duration = 0.8f; // Speed
        rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        [self.loadingImage.layer removeAllAnimations];
        [self.loadingImage.layer addAnimation:rotation forKey:@"Spin"];
        
        
        
        //[self.itemInput resignFirstResponder];
        PFObject *newPost = [PFObject objectWithClassName:@"Posts"];
        newPost[@"item"] = self.itemInput.text;
        if(![self.noteBox.text isEqualToString:@"Leave a little note!"] && self.noteBox.text.length != 0) {
            newPost[@"note"] = self.noteBox.text;
            
        }
        newPost[@"deadline"] = self.datePicker.date;
        newPost[@"zipcode"]= self.currentUser[@"currentZipcode"];
        PFRelation *relation = [newPost relationForKey:@"user"];
        [relation addObject:self.currentUser];
        //[newPost save];
        [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             
             if (succeeded)
             {
                 
                 PFRelation* userToPostRelation = [self.currentUser relationForKey:@"posts"];
                 [userToPostRelation addObject:newPost];
                 //[self.currentUser save];
                 [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                      if (succeeded)
                      {
                          
                          self.itemInput.text = @"";
                          self.loadingBackground.hidden = YES;
                          self.loadingBox.hidden = YES;
                          self.loadingImage.hidden = YES;
                          [self.tabBarController setSelectedIndex:0];
                          
                      }
                      else
                      {
                          self.itemInput.text = @"";
                          self.loadingBackground.hidden = YES;
                          self.loadingBox.hidden = YES;
                          self.loadingImage.hidden = YES;
                          
                          UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                                message:@"Something went wrong!"
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles: nil];
                          [myAlertView show];
                          
                      }
                  }];
                 
             }
             else
             {
                 
                 self.itemInput.text = @"";
                 self.loadingBackground.hidden = YES;
                 self.loadingBox.hidden = YES;
                 self.loadingImage.hidden = YES;
                 
                 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                       message:@"Something went wrong!"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                 [myAlertView show];
                 
             }
             
         }];
        //[self dismissViewControllerAnimated:YES completion:Nil];
        
    }
}

-(void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
}

- (IBAction)switchViewComponent:(id)sender {
    
    if(self.datePicker.hidden == YES)
    {
        self.noteBox.hidden = YES;
        self.datePicker.hidden = NO;
        [self.itemInput becomeFirstResponder];
    }
    else
    {
        self.datePicker.hidden = YES;
        self.noteBox.hidden = NO;
        //[self.noteBox becomeFirstResponder];
    }
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    self.noteBox.text = @"";
    self.noteBox.textColor = [UIColor blackColor];
    return YES;
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.noteBox.text.length == 0)
    {
        
        self.noteBox.textColor = [UIColor lightGrayColor];
        self.noteBox.text = @"Leave a little note!";
        [self.noteBox resignFirstResponder];
        [self.itemInput becomeFirstResponder];
        
    }
    
}





@end
