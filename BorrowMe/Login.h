//
//  Login.h
//  BorrowMe
//
//  Created by Tom Lee on 1/31/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Login : UIViewController <UIImagePickerControllerDelegate> {
    
    IBOutlet UIScrollView* scroller;
    
}

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIView *loginBox;
@property (weak, nonatomic) IBOutlet UIView *signUpBox;
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginSuccessMessage;
@property (weak, nonatomic) IBOutlet UITextField *signUpUsernameInput;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordInput;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordInputRepeat;
@property (weak, nonatomic) IBOutlet UITextField *signUpEmailInput;
@property (weak, nonatomic) IBOutlet UITextField *signUpPhoneInput;
@property (weak, nonatomic) IBOutlet UIButton *uploadProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *signUpProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) PFFile* signUpUserProfilePictureFile;

@end
