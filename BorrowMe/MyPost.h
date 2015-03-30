//
//  MyPost.h
//  BorrowMe
//
//  Created by Tom Lee on 2/26/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPost : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UIImageView *lenderPicture1;
@property (weak, nonatomic) IBOutlet UIImageView *lenderPicture2;
@property (weak, nonatomic) IBOutlet UIImageView *lenderPicture3;
@property (weak, nonatomic) IBOutlet UIImageView *lenderPicture4;
@property (weak, nonatomic) IBOutlet UILabel *addtionalLenders;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

@end
