//
//  AboutPost.h
//  BorrowMe
//
//  Created by Tom Lee on 4/17/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AboutPost : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *container;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aboutPostSelector;
@property (weak, nonatomic) IBOutlet UIImageView *clockIcon;
@property (strong, nonatomic) IBOutlet UILabel *borrowDuration;
@property (strong, nonatomic) IBOutlet UILabel *borrowDate;
@property (strong, nonatomic) IBOutlet UILabel *returnDate;
@property (strong, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (weak, nonatomic) IBOutlet UILabel *postDistance;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSString* postLatitude;
@property (strong, nonatomic) NSString* postLongitude;

@end
