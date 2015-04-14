//
//  HelpBorrower.h
//  BorrowMe
//
//  Created by Tom Lee on 2/22/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostObject.h"

@interface RespondToPost : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PostObject* receivedPostObject;
@property (weak, nonatomic) IBOutlet UITextField *itemDescription;
@property (weak, nonatomic) IBOutlet UIButton *itemImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *pickPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *addMoreDescriptionButton;
@property (weak, nonatomic) IBOutlet UIView *mainLayer;
@property (strong, nonatomic) UIGestureRecognizer* gestureRecognizer;
@property (strong, nonatomic) UIImage* selectedItemImage;
@property (weak, nonatomic) IBOutlet UIButton *removeItemImageButton;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextView *note;
@end
