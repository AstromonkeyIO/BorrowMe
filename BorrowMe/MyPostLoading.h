//
//  MyPostLoading.h
//  BorrowMe
//
//  Created by Tom Lee on 9/29/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostLoading : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

@end
