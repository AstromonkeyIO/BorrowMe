//
//  MyPostsSelectorHeaderCell.m
//  BorrowMe
//
//  Created by Tom Lee on 7/19/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "MyPostsSelectorHeaderCell.h"

@implementation MyPostsSelectorHeaderCell

- (void)awakeFromNib {
    // Initialization code
    /*
    [self.MyPostsSegmentedControl setTitle:@"Posts"forSegmentAtIndex:0];
    [self.MyPostsSegmentedControl setTitle:@"Items"forSegmentAtIndex:1];
    [self.MyPostsSegmentedControl setTitle:@"Messages"forSegmentAtIndex:2];
    [self.MyPostsSegmentedControl setSelectedSegmentIndex:0];
     */
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
