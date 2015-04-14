//
//  HelpBorrower.m
//  BorrowMe
//
//  Created by Tom Lee on 2/22/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "RespondToPost.h"

@implementation RespondToPost

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //show camera...
}

- (void) viewDidLoad {
    
    NSLog(@"%@", [self.receivedPostObject getPost]);
    
    CALayer* mainLayer = [self.mainLayer layer];
    [mainLayer setMasksToBounds:YES];
    [mainLayer setCornerRadius:7.5];
    
    CALayer* sendButtonLayer = [self.sendButton layer];
    [sendButtonLayer setMasksToBounds:YES];
    [sendButtonLayer setCornerRadius:5.0];
    
    CALayer* noteLayer = [self.note layer];
    [noteLayer setMasksToBounds:YES];
    [noteLayer setCornerRadius:10.0];
    
    CALayer* loadingBoxLayer = [self.loadingBox layer];
    [loadingBoxLayer setMasksToBounds:YES];
    [loadingBoxLayer setCornerRadius:10.0];
    
 
    CGPoint saveCenter = self.removeItemImageButton.center;
    CGRect newFrame = CGRectMake(self.removeItemImageButton.frame.origin.x, self.removeItemImageButton.frame.origin.y, 50, 50);
    self.removeItemImageButton.frame = newFrame;
    self.removeItemImageButton.layer.cornerRadius = 50 / 2.0;
    self.removeItemImageButton.center = saveCenter;
    self.removeItemImageButton.clipsToBounds = YES;
    
    
    [self.itemDescription becomeFirstResponder];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllKeyboards)];
    self.gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.gestureRecognizer];
    
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [myAlertView show];
        
    }
    
    
    
    
}

- (IBAction)itemImageButtonPressed:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)removeItemImageButtonPressed:(id)sender {
    
    self.removeItemImageButton.hidden = YES;
    self.itemImage.image = NULL;
    self.itemImage.hidden = YES;
    self.itemImageButton.hidden = NO;
    
    
}



- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)pickPicture:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //self.selectedItemImage = info[UIImagePickerControllerEditedImage];
    UIImage* selectedItemImage = info[UIImagePickerControllerEditedImage];
    self.itemImage.image = selectedItemImage;
    self.itemImage.hidden = NO;
    self.itemImageButton.hidden = YES;
    self.removeItemImageButton.hidden = NO;
    //[self.itemImageButton setBackgroundImage:self.selectedItemImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)sendResponseToBorrower:(id)sender {
    
    if(self.itemDescription.text.length == 0)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"Please talk about your item just a little bit"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    
    }
    else if(!self.itemImage.image) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                              message:@"No image of the item!"
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
        
        PFObject* newResponse = [PFObject objectWithClassName:@"Responses"];
        NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.1);
        PFFile* imageInPFFile = [PFFile fileWithName:@"test.png" data:imageData];
        newResponse[@"itemImage"] = imageInPFFile;
        if(self.note.text.length != 0 || ![self.note.text isEqualToString:@"Leave a little note!"])
        {
        
            newResponse[@"description"] = self.note.text;
            
        }
        /*
        PFRelation * newResponseToUserrelation = [newResponse relationForKey:@"user"];
        [newResponseToUserrelation addObject: [PFUser currentUser]];
        [newResponse save];
        */
        PFRelation * newResponseToUserrelation = [newResponse relationForKey:@"user"];
        [newResponseToUserrelation addObject: [PFUser currentUser]];
        [newResponse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            
            if (succeeded)
            {
                
                NSLog(@"new response saved");
                PFRelation* responseToPostRelation = [[self.receivedPostObject getPost] relationForKey:@"responses"];
                [responseToPostRelation addObject: newResponse];
                [self.receivedPostObject.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                {
                    if (succeeded)
                    {
                        
                        self.loadingBackground.hidden = YES;
                        self.loadingBox.hidden = YES;
                        self.loadingImage.hidden = YES;
                        
                        self.itemDescription.text = @"";
                        [self dismissViewControllerAnimated:YES completion:Nil];
                    }
                    else
                    {
                        
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
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)notePhotoSwitchButton:(id)sender {
    
    if(self.note.hidden == YES)
    {
        
        self.itemImage.hidden = YES;
        if(self.itemImage.image != NULL)
        {
            self.removeItemImageButton.hidden = YES;
        }
        self.itemImageButton.hidden = YES;

        self.note.hidden = NO;
        
    }
    else
    {
        self.note.hidden = YES;
        if(self.itemImage.image != NULL)
        {
            
            self.itemImage.hidden = NO;
            self.removeItemImageButton.hidden = NO;
            
        }
        else
        {
            
            self.itemImageButton.hidden = NO;
            
        }
        
        
    }
    
    
}


- (void) dismissAllKeyboards {
    
    [self.view endEditing:YES];
    
}

@end
