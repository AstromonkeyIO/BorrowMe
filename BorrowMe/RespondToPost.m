//
//  HelpBorrower.m
//  BorrowMe
//
//  Created by Tom Lee on 2/22/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "RespondToPost.h"

@implementation RespondToPost

- (void) viewDidLoad {
    
    NSLog(@"%@", [self.receivedPostObject getPost]);
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [myAlertView show];
        
    }
    
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
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.itemImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)sendResponseToBorrower:(id)sender {
    
    PFObject* newResponse = [PFObject objectWithClassName:@"Responses"];
    NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.1);
    PFFile* imageInPFFile = [PFFile fileWithName:@"test.png" data:imageData];
    newResponse[@"itemImage"] = imageInPFFile;
    
    PFRelation * newResponseToUserrelation = [newResponse relationForKey:@"user"];
    [newResponseToUserrelation addObject: [PFUser currentUser]];
    [newResponse save];
    
    PFRelation* responseToPostRelation = [[self.receivedPostObject getPost] relationForKey:@"responses"];
    [responseToPostRelation addObject: newResponse];
    [self.receivedPostObject.post save];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}


@end
