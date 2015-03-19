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
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;


@end
