//
//  AboutPost.m
//  BorrowMe
//
//  Created by Tom Lee on 4/17/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "AboutPost.h"
#define METERS_PER_MILE 1609.344

@implementation AboutPost

- (IBAction)aboutPostSelectorChanged:(id)sender {
    
    if(self.map.hidden == YES) {
        
        self.clockIcon.hidden = YES;
        self.borrowDuration.hidden = YES;
        self.borrowDate.hidden = YES;
        self.returnDate.hidden = YES;
        self.note.hidden = YES;
        self.distanceIcon.hidden = NO;
        self.postDistance.hidden = NO;
        self.map.hidden = NO;
        
        //set post location on map
        CLLocationCoordinate2D zoomLocation;
        
        zoomLocation.latitude = [self.postLatitude floatValue];
        zoomLocation.longitude= [self.postLongitude floatValue];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [self.map setRegion:viewRegion animated:YES];
        
    }
    else
    {
        
        self.clockIcon.hidden = NO;
        self.borrowDuration.hidden = NO;
        self.borrowDate.hidden = NO;
        self.returnDate.hidden = NO;
        self.note.hidden = NO;
        self.distanceIcon.hidden = YES;
        self.postDistance.hidden = YES;
        self.map.hidden = YES;
        
    }
    
    
}


@end
