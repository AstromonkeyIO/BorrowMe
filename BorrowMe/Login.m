//
//  Login.m
//  BorrowMe
//
//  Created by Tom Lee on 1/31/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Login.h"


@implementation Login

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[scroller setScrollEnabled:YES];
    //[scroller setContentSize:CGSizeMake(320, 625)];
    //self.usernameInput.delegate = self;
    
    CALayer * loginBoxLayer = [self.loginBox layer];
    [loginBoxLayer setMasksToBounds:YES];
    [loginBoxLayer setCornerRadius:5.0];
    
    CALayer * signUpBoxLayer = [self.signUpBox layer];
    [signUpBoxLayer setMasksToBounds:YES];
    [signUpBoxLayer setCornerRadius:5.0];
    
    CALayer * loginButtonLayer = [self.loginButton layer];
    [loginButtonLayer setMasksToBounds:YES];
    [loginButtonLayer setCornerRadius:5.0];
    
    CALayer * loginSuccessMessageLayer = [self.loginSuccessMessage layer];
    [loginSuccessMessageLayer setMasksToBounds:YES];
    [loginSuccessMessageLayer setCornerRadius:5.0];
    
    CALayer * signUpButtonLayer = [self.signUpButton layer];
    [signUpButtonLayer setMasksToBounds:YES];
    [signUpButtonLayer setCornerRadius:5.0];
    
    CGPoint saveCenter = self.userProfile.center;
    CGRect userProfileFrame = CGRectMake(self.userProfile.frame.origin.x, self.userProfile.frame.origin.y, 100, 100);
    self.userProfile.frame = userProfileFrame;
    self.userProfile.layer.cornerRadius = 100 / 2.0;
    self.userProfile.center = saveCenter;
    self.userProfile.clipsToBounds = YES;
    
    CGPoint saveCenter2 = self.signUpProfilePicture.center;
    CGRect signUpProfilePictureFrame = CGRectMake(self.signUpProfilePicture.frame.origin.x, self.signUpProfilePicture.frame.origin.y, 100, 100);
    self.signUpProfilePicture.frame = signUpProfilePictureFrame;
    self.signUpProfilePicture.layer.cornerRadius = 100 / 2.0;
    self.signUpProfilePicture.center = saveCenter2;
    self.signUpProfilePicture.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backGroundButtonPressed:(id)sender {
    
    [self.usernameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    
}

- (IBAction)exit:(id)sender {
    
    [self.usernameInput resignFirstResponder];
    
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.usernameInput.text password:self.passwordInput.text block:^(PFUser *user,NSError *error) {
        
        if (user)
        {
            // Do stuff after successful login.
            PFFile* profilePictureFile = user[@"profilePicture"];
            NSData* profilePictureData = [profilePictureFile getData];
            self.userProfile.image = [UIImage imageWithData:profilePictureData];
            self.loginSuccessMessage.text = [NSString stringWithFormat:@"Welcome %@!", user.username];
            self.loginSuccessMessage.hidden = NO;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(changeMessage)
                                           userInfo:nil
                                            repeats:NO];
            
            
            
            
            
            [NSTimer scheduledTimerWithTimeInterval:3.0
                                             target:self
                                           selector:@selector(goToMainPage)
                                           userInfo:nil
                                            repeats:NO];
            

            
        }
        else
        {
            // The login failed. Check error to see why.
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oh No" message:@"Please use correct username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            alertView.cancelButtonIndex = -1;
            [alertView show];
        }
        
    }];
    
}

- (IBAction)openSignUpBox:(id)sender {
    
    self.loginBox.hidden = YES;
    self.signUpBox.hidden = NO;
    
}

//Sign Up Part
- (IBAction)uploadProfilePictureButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    
    
    
}

- (IBAction)signUpButtonPressed:(id)sender {
    
    NSString* errorMessage;
    
    if(self.signUpUsernameInput.text.length == 0 || self.signUpPasswordInput.text.length == 0 || self.signUpPasswordInputRepeat.text.length == 0 || self.signUpEmailInput.text.length == 0 || self.signUpPhoneInput.text.length == 0)
    {
        
        errorMessage = @"Please fill out everything!";
        if(self.signUpPasswordInput.text != self.signUpPasswordInputRepeat.text)
        {
            
            errorMessage = @"Your passwords don't match!";
            
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oh No" message:errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        alertView.cancelButtonIndex = -1;
        [alertView show];
        
    }
    else
    {
        
        PFUser *user = [PFUser user];
        user.username = self.signUpUsernameInput.text;
        user.password = self.signUpPasswordInput.text;
        user.email = self.signUpEmailInput.text;
        user[@"phone"] = self.signUpPhoneInput.text;
        user[@"profilePicture"] = self.signUpUserProfilePictureFile;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                [self performSegueWithIdentifier:@"Login-Success" sender:self];
                // Hooray! Let them use the app now.
            } else
            {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oh No" message:errorString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                alertView.cancelButtonIndex = -1;
                [alertView show];
                // Show the errorString somewhere and let the user try again.
            }
        }];
        
    }
    
    
    
}

- (IBAction)goToLoginButtonPressed:(id)sender {
    
    self.signUpBox.hidden = YES;
    self.loginBox.hidden = NO;
    
}




- (void) changeMessage {
    
    self.loginSuccessMessage.backgroundColor = [UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0];
    self.loginSuccessMessage.text = @"Get Ready!";
    
}


- (void) goToMainPage {
 
    [self performSegueWithIdentifier:@"Login-Success" sender:self];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
            NSLog(@"choose from existing");
            break;
        default:
            break;
    }
}

- (void) takeNewPhotoFromCamera
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void) choosePhotoFromExistingImages
{
    //if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    //{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    self.signUpUserProfilePictureFile = [PFFile fileWithName:@"profileimage.png" data:imageData];
    
    self.signUpProfilePicture.image = [UIImage imageWithData:imageData];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    
    [self dismissViewControllerAnimated:NO completion:nil ];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return NO;
    
}





@end
