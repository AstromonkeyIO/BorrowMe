//
//  NewPost.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "NewPost.h"

@implementation NewPost

-(void)viewWillAppear:(BOOL)animated {
    
    [self.itemInput becomeFirstResponder];    
    
}

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
    
    CGPoint saveCenter = self.timeNoteSelectorBackground.center;
    CGRect newFrame = CGRectMake(self.timeNoteSelectorBackground.frame.origin.x, self.timeNoteSelectorBackground.frame.origin.y, 60, 60);
    self.timeNoteSelectorBackground.frame = newFrame;
    self.timeNoteSelectorBackground.layer.cornerRadius = 60 / 2.0;
    self.timeNoteSelectorBackground.center = saveCenter;
    self.timeNoteSelectorBackground.clipsToBounds = YES;
    
    [self.dateRangeSelector setTitle:@"Borrow Date"forSegmentAtIndex:0];
    [self.dateRangeSelector setTitle:@"Return Date"forSegmentAtIndex:1];
    
    self.returnDatePicker.hidden = YES;

    
    self.currentUser = [PFUser currentUser];
    
    NSLog(@"current zipcode in new post%@",self.currentUser[@"currentZipcode"]);
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllKeyboards)];
    self.gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.gestureRecognizer];
    
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    [self.returnDatePicker setTimeZone:nowTimeZone];
    [self.datePicker setTimeZone:nowTimeZone];

    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.itemInput becomeFirstResponder];
    [self.tabBarController.tabBar setHidden:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeWindow:(id)sender {
    
    self.itemInput.text = @"";
    //self.noteBox.text = @"Leave a little note!";
    self.noteBox.hidden = YES;
    self.returnDatePicker.hidden = YES;
    self.datePicker.hidden = NO;
    self.dateRangeSelector.hidden = NO;
    self.dateRangeSelector.selectedSegmentIndex = 0;
    
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self.tabBarController.tabBar setHidden:NO];
    //[self.tabBarController setSelectedIndex:0];
    //[self dismissViewControllerAnimated:YES completion:Nil];
    
}

- (IBAction)askButtonPressed:(id)sender {

    
    NSLog(@"nsdate noww!!!!!!!!! %@", self.datePicker.date);
    
    NSDate* currentDate = [NSDate date];
    NSLog(@"current date = %@", currentDate);
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //NSTimeZone* currentTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    

    //[self.returnDatePicker setTimeZone:nowTimeZone];
    //[self.datePicker setTimeZone:nowTimeZone];
    NSLog(@"second date %@", self.datePicker.date);
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    
    NSInteger currentGMTOffset3 = [currentTimeZone secondsFromGMTForDate:self.returnDatePicker.date];
    NSInteger nowGMTOffset3 = [nowTimeZone secondsFromGMTForDate:self.returnDatePicker.date];
    NSTimeInterval interval3 = nowGMTOffset3 - currentGMTOffset3;
    NSDate* returnDate = [[NSDate alloc] initWithTimeInterval:interval3 sinceDate:self.returnDatePicker.date];
    
    NSInteger currentGMTOffset2 = [currentTimeZone secondsFromGMTForDate:self.datePicker.date];
    NSInteger nowGMTOffset2 = [nowTimeZone secondsFromGMTForDate:self.datePicker.date];
    NSTimeInterval interval2 = nowGMTOffset2 - currentGMTOffset2;
    NSDate* borrowDate = [[NSDate alloc] initWithTimeInterval:interval2 sinceDate:self.datePicker.date];

    NSLog(@"borrow date %@", borrowDate);
    NSLog(@"return date %@", returnDate);
    NSLog(@"currentDate %@", nowDate);
    
    NSTimeInterval secondsBetweenBorrowDateAndReturnDate = [self.returnDatePicker.date timeIntervalSinceDate: self.datePicker.date];
    
    
    NSTimeInterval secondsBetween = [borrowDate timeIntervalSinceDate:nowDate];
    
    NSLog(@"secondsBetween current %f", secondsBetween);
    NSLog(@"secondsBetween borrow and return %f", secondsBetweenBorrowDateAndReturnDate);
    
    if(self.itemInput.text.length == 0)
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Please tell us what you are trying to borrow!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else if(self.datePicker.date.timeIntervalSinceNow < 0)
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Don't set your deadline to the past!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else if(secondsBetweenBorrowDateAndReturnDate < 0)
    {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Please set the right time frame!"
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
        
        newPost[@"zipcode"]= self.currentUser[@"currentZipcode"];
        newPost[@"latitude"] = self.currentUser[@"latitude"];
        newPost[@"longitude"] = self.currentUser[@"longitude"];
        
        NSLog(@"nsdate lateerrrrrr!!!!!!!!! %@", self.datePicker.date);
        
        
        newPost[@"deadline"] = self.datePicker.date;
        newPost[@"returnDate"] = self.returnDatePicker.date;
        newPost[@"referenceToUser"] = self.currentUser;
        /*
        PFRelation *relation = [newPost relationForKey:@"user"];
        [relation addObject:self.currentUser];
        */
        

        [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             //__strong NewPost *strongSelf = weakSelf;
             if (succeeded)
             {
                 //__weak NewPost *weakSelf = self;
                 PFRelation* userToPostRelation = [self.currentUser relationForKey:@"posts"];
                 [userToPostRelation addObject:newPost];
                 //[self.currentUser save];
                 //NSDictionary *finishDict = @{@"postKey":postKey,@"objectId":newPost.objectId};
                 //[[NSNotificationCenter defaultCenter] postNotificationName:@"PostFinished" object:self userInfo:finishDict];
                 
                 NSMutableDictionary* returnDic = [self convertPFObjectToNSMutableDictionary:newPost];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserPost" object:self userInfo:returnDic];
                 
                 [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                      if (succeeded)
                      {
                          // Add all Parse data to returnDict

                          self.itemInput.text = @"";
                          self.noteBox.text = @"";
                          self.datePicker.hidden = NO;
                          self.returnDatePicker.hidden = YES;
                          self.noteBox.hidden = YES;
                          self.loadingBackground.hidden = YES;
                          self.loadingBox.hidden = YES;
                          self.loadingImage.hidden = YES;
                          [self dismissViewControllerAnimated:YES completion:NULL];
                          //[self.tabBarController.tabBar setHidden:NO];
                          //[self.tabBarController setSelectedIndex:0];
                          
                      }
                      else
                      {
                          //self.itemInput.text = @"";
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
                 
                 //self.itemInput.text = @"";
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

- (IBAction)dateRangeSelectorValueChanged:(id)sender {
    
    if(self.dateRangeSelector.selectedSegmentIndex == 0) {
        self.returnDatePicker.hidden = YES;
        self.datePicker.hidden = NO;
    }else if(self.dateRangeSelector.selectedSegmentIndex == 1){
        self.datePicker.hidden = YES;
        self.returnDatePicker.hidden = NO;
    }
    
}



-(void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
}

- (IBAction)switchViewComponent:(id)sender {
    
    
    if(self.datePicker.hidden == NO || self.returnDatePicker.hidden == NO)
    {
        
        self.dateRangeSelector.hidden = YES;
        if(self.datePicker.hidden == NO)
            self.datePicker.hidden = YES;
        else if(self.returnDatePicker.hidden == NO)
            self.returnDatePicker.hidden = YES;
        self.noteBox.hidden = NO;
        [self.noteBox becomeFirstResponder];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@", docDir, @"/Resources/noteIcon.png"];
        UIImage * noteIcon = [UIImage imageWithContentsOfFile:pngFilePath];
        [self.askButton setBackgroundImage:noteIcon
                                                  forState:UIControlStateNormal];

    }
    else if(self.noteBox.hidden == NO)
    {
    
        self.dateRangeSelector.hidden = NO;
        self.dateRangeSelector.selectedSegmentIndex = 0;
        self.noteBox.hidden = YES;
        self.datePicker.hidden = NO;
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@", docDir, @"/Resources/clockIcon.png"];
        UIImage * noteIcon = [UIImage imageWithContentsOfFile:pngFilePath];
        [self.askButton setBackgroundImage:noteIcon
                                  forState:UIControlStateNormal];

    }
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    //self.noteBox.text = @"";
    //self.noteBox.textColor = [UIColor blackColor];
    return YES;
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    /*
    if(self.noteBox.text.length == 0)
    {
        
        self.noteBox.textColor = [UIColor lightGrayColor];
        self.noteBox.text = @"Leave a little note!";
        [self.noteBox resignFirstResponder];
        [self.itemInput becomeFirstResponder];
        
    }
    */
    
}

- (void) dismissAllKeyboards {
    
    [self.view endEditing:YES];
    
}

- (NSMutableDictionary*) convertPFObjectToNSMutableDictionary:(PFObject*) pfobject
{
    
    NSLog(@"input pfObject %@", pfobject.objectId);
    
    NSArray * allKeys = [pfobject allKeys];
    NSMutableDictionary * retDict = [[NSMutableDictionary alloc] init];
    

    for (NSString * key in allKeys)
    {
        
        [retDict setObject:[pfobject objectForKey:key] forKey:key];

    }
    
    NSLog(@"retDict %@", retDict);
    
    [retDict setValue:pfobject.objectId forKey:@"objectId"];
    
    NSLog(@"result nsdictionary %@", retDict);
    
    return retDict;

}

@end
