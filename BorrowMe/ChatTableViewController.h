//
//  ChatTableViewController.h
//  BorrowMe
//
//  Created by Tom Lee on 7/12/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THChatInput.h"

@interface ChatTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet THChatInput* chatInput;

@end
