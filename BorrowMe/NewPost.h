//
//  NewPost.h
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewPost : UIViewController {
    
    IBOutlet UIScrollView* scroller;
    
}

@property (weak, nonatomic) IBOutlet UITextField *itemInput;
@property (strong, nonatomic) PFUser* currentUser;


@end
