//
//  MainFeed.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "MainFeed.h"
#import "HeaderCell.h"
#import "Post.h"
#import "RespondToPost.h"
#import "LoadingCell.h"
#import "PostDetail.h"
#import "UserProfile.h"
#import "SWRevealViewController.h"
#import "ItemsObject.h"
#import "ItemsCell.h"

@implementation MainFeed {
    
    NSString* zipCode;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    self.currentUser = [PFUser currentUser];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    }
    
    [self.navBarSegmentedControl setTitle:@"Lend"forSegmentAtIndex:0];
    [self.navBarSegmentedControl setTitle:@"Borrow"forSegmentAtIndex:1];
    [self.navBarSegmentedControl setSelectedSegmentIndex:0];
    
     self.searchBar.delegate = (id)self;
    //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    //Current user object
    self.currentUser = [PFUser currentUser];

    
    
    //Initializing all the mainfeed arrays
    self.posts = [[NSMutableArray alloc] init];
    self.items = [[NSMutableArray alloc] init];
    self.mainfeedRows = [[NSMutableArray alloc] init];
    
    PostObject* loadingCell = [[PostObject alloc] init];
    loadingCell.type = @"loadingCell";
    
    //*[self.posts addObject: loadingCell];
    [self.mainfeedRows addObject:loadingCell];

    //[self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePost:) name:@"DeletePost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directToUserProfile:) name:@"DisplayUserProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostAdded:) name:@"NewUserPost" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed: 169.0/255.0 green: 226.0/255.0 blue:243.0/255.0 alpha: 1.0];
    
}

- (void) pullPostsFromDatabase
{
    NSLog(@"zipcode !!!!!!   %@", zipCode);
    self.tableView.scrollEnabled = NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"zipcode" equalTo:self.currentUser[@"currentZipcode"]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"User"];
    [query includeKey:@"referenceToUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            
            // The find succeeded.
            // Do something with the found objects
            
            if([self.posts count] != 0)
            {
                [self.posts removeAllObjects];
            }
            
            for (PFObject *post in posts)
            {
                
                PFUser* userTemp = post[@"referenceToUser"];
                if(userTemp)
                {
                    NSLog(@"userTemp %@", userTemp);
                }
                
                PFUser* user = (PFUser*)[[[post relationForKey:@"user"] query] getFirstObject];
                //NSLog(@"%@", user);
                
                PostObject* postObject = [[PostObject alloc] init];
                postObject.type = @"post";
                postObject.user = user;
                postObject.item = [post valueForKey:@"item"];
                postObject.post = post;
                /*
                [postObject setUserObject:user];
                [postObject setItemObject: [post valueForKey:@"item"]];
                [postObject setPostObject: post];
                */
                PFFile* profilePictureFile = [user valueForKey:@"profilePicture"];
                NSData* profilePictureData = [profilePictureFile getData];
                postObject.userProfileImage = [UIImage imageWithData: profilePictureData];
                
                
                NSLog(@"post deadline %@,   %@", post[@"deadline"], post[@"item"]);
                
                postObject.alreadyLiked = false;
                for(int i = 0; i < [self.currentUser[@"likedPosts"] count]; i++) {
                    
                    if([[self.currentUser[@"likedPosts"] objectAtIndex:i] isEqualToString:[post valueForKey:@"objectId"]])
                    {
                        
                        postObject.alreadyLiked = true;
                        break;
                        
                    }
                    
                }
                
                
                
                NSDate* currentDate = [NSDate date];
                //NSLog(@"current date = %@", currentDate);
                NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
  
                NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
                NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
                NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
                currentDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
                
                NSInteger currentGMTOffset2 = [currentTimeZone secondsFromGMTForDate:post[@"deadline"]];
                NSInteger nowGMTOffset2 = [nowTimeZone secondsFromGMTForDate:post[@"deadline"]];
                NSTimeInterval interval2 = nowGMTOffset2 - currentGMTOffset2;
                NSDate* borrowDate = [[NSDate alloc] initWithTimeInterval:interval2 sinceDate:post[@"deadline"]];
                
                
                
                
                NSLog(@"current date after = %@", currentDate);
                
                NSLog(@"current borrow  date fter = %@", borrowDate);
                
                NSLog(@"borrow date before %@", post[@"deadline"]);
                
 
                
                //NSDate* borrowDate;
                
                NSTimeInterval secondsBetween = [borrowDate timeIntervalSinceDate:currentDate];
                NSLog(@"seconds difference %f", secondsBetween);
                //NSTimeInterval secondsBetween = [[post valueForKey:@"deadline"] timeIntervalSinceDate: n];
                
                
                if(secondsBetween <= 0)
                {
                    
                    postObject.deadline = @"ex";
                    
                }
                else
                {
                
                int numberOfWeeksElapsed;
                int numberOfDaysElapsed;
                int numberOfHoursElapsed;
                int numberofMinutesElapsed;
                NSString* timeDifferenceInString;
                
                numberOfWeeksElapsed = secondsBetween / 604800;
                if(numberOfWeeksElapsed >= 1)
                {
                    
                    timeDifferenceInString = [NSString stringWithFormat:@"%dw", numberOfWeeksElapsed];
                    postObject.deadline = timeDifferenceInString;
                    
                }
                else
                {
                    
                    numberOfDaysElapsed = secondsBetween / 86400;
                    NSLog(@"number of days %d", numberOfDaysElapsed);
                    if(numberOfDaysElapsed >= 1)
                    {
                        
                        if(numberOfDaysElapsed == 1)
                        {
                            postObject.urgent = true;
                        }
                        timeDifferenceInString = [NSString stringWithFormat:@"%dd", numberOfDaysElapsed];
                        postObject.deadline = timeDifferenceInString;
                        
                    }
                    else
                    {
                        
                        postObject.urgent = true;
                        numberOfHoursElapsed = secondsBetween / 3600;
                        if(numberOfHoursElapsed >= 1)
                        {

                            timeDifferenceInString = [NSString stringWithFormat:@"%dh", numberOfHoursElapsed];
                            postObject.deadline = timeDifferenceInString;
                            
                        }
                        else
                        {
                            numberofMinutesElapsed = secondsBetween / 60;
                            if(numberofMinutesElapsed >= 1)
                            {
                                timeDifferenceInString = [NSString stringWithFormat:@"%dm", numberofMinutesElapsed];
                                //postObject.deadline = timeDifferenceInString;
                                postObject.deadline = timeDifferenceInString;
                                
                            }
                            else
                            {
                            timeDifferenceInString = [NSString stringWithFormat:@"%fs", secondsBetween];
                            //postObject.deadline = timeDifferenceInString;
                            postObject.deadline = @"Now";
                            }
                            
                        }
                        
                        
                    }
                    
                }
                    
                [self.posts addObject:postObject];
                
                }
                
                
                
            }
            
            if([self.mainfeedRows count] > 0)
            {
                
                [self.mainfeedRows removeAllObjects];
                
            }
            
            [self.mainfeedRows addObjectsFromArray:self.posts];
            
            //NSLog(@"posts array %@", self.posts);
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                self.tableView.scrollEnabled = YES;
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
}

- (void) pullItemsFromDatabase
{
    
    PFQuery *queryItemsFromDatabase = [PFQuery queryWithClassName:@"Items"];
    //[query whereKey:@"zipcode" equalTo:self.currentUser[@"currentZipcode"]];
    [queryItemsFromDatabase orderByDescending:@"createdAt"];
    //[query includeKey:@"User"];
    [queryItemsFromDatabase findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error)
    {
        
        if (!error)
        {
            
            if([self.items count] != 0)
            {
                
                [self.items removeAllObjects];
                
            }
            
            for (int i = 0; i < [items count]; i = i + 2)
            {
                
                int tempIndex = i;
                if ([items count] > tempIndex && [items objectAtIndex:tempIndex] !=nil)
                {
                    
                    NSLog(@"I'm heree");
                    ItemsObject* itemsObject = [[ItemsObject alloc] init];
                    itemsObject.type = @"items";
                    PFFile* itemImageFile = [[items objectAtIndex:tempIndex] valueForKey:@"itemImage"];
                    NSData* itemImageData = [itemImageFile getData];
                    itemsObject.leftItemImage = [UIImage imageWithData: itemImageData];
                    NSLog(@"left image %@", itemsObject.leftItemImage);
                    tempIndex += 1;
                    NSLog(@"tempIndex %d", tempIndex);
                    
                    if ([items count] > tempIndex && [items objectAtIndex:tempIndex] !=nil)
                    {

                        NSLog(@"I'm heree2");
                        PFObject* itemPFObject = [items objectAtIndex:tempIndex];
                        NSLog(@"itemPFObject %@", itemPFObject);
                        PFFile* itemImageFile = itemPFObject[@"itemImage"];
                        NSData* itemImageData = [itemImageFile getData];
                        itemsObject.rightItemImage = [UIImage imageWithData: itemImageData];
                        
                        [self.items addObject:itemsObject];
                        
                    }
                    else
                    {
                        
                        [self.items addObject:itemsObject];
                        break;
                        
                    }
                    
                    
                }
                else
                {
                    
                    break;
                    
                }
        
            }
            
            if([self.mainfeedRows count] > 0)
            {
                
                [self.mainfeedRows removeAllObjects];
                
            }

            [self.mainfeedRows addObjectsFromArray:self.items];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                self.tableView.scrollEnabled = YES;
            });
            
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30.0;
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    HeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    // 3. And return
    return headerCell;
    
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //*return [self.posts count];
    return [ self.mainfeedRows count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"loadingCell"])
    {
        
        LoadingCell* loadingCell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
        loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CABasicAnimation *rotation;
        rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = [NSNumber numberWithFloat:0];
        rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        rotation.duration = 0.8f; // Speed
        rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        [loadingCell.loadingImage.layer removeAllAnimations];
        [loadingCell.loadingImage.layer addAnimation:rotation forKey:@"Spin"];
        
        CALayer * loadingBoxLayer = [loadingCell.loadingBox layer];
        [loadingBoxLayer setMasksToBounds:YES];
        [loadingBoxLayer setCornerRadius:10.0];
        
        return loadingCell;
        
    }
    else if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"post"])
    {

        Post* post = [tableView dequeueReusableCellWithIdentifier:@"Post" forIndexPath:indexPath];
        post.backgroundColor = [UIColor clearColor];
            
        post.index = indexPath.row;
        
        //PostObject* postObject =
        
        PFUser* user = [[self.mainfeedRows objectAtIndex:indexPath.row] getUser];
        post.item.text = [[self.mainfeedRows objectAtIndex:indexPath.row] getItem];
        
        PostObject* postObject = [self.mainfeedRows objectAtIndex:indexPath.row];
        post.profilePicture.image = postObject.userProfileImage;
        
        post.postPFObject = postObject.post;
        
        post.postId = [postObject.post valueForKey:@"id"];
        
        NSString* buttonTitle = [NSString stringWithFormat:@"%@", [user valueForKey:@"username"]];
        [post.username setTitle: buttonTitle forState: UIControlStateNormal];
        if([postObject.post valueForKey:@"likes"] == NULL)
        {
            
            post.heartCount.text = @"0";
            
        }
        else
        {
            if(postObject.alreadyLiked == true)
            {
                
                post.heartImage.image = [post.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [post.heartImage setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
                
            }
            post.heartCount.text = [NSString stringWithFormat:@"%@", [postObject.post valueForKey:@"likes"]];
            
        }
        post.deadline.text = postObject.deadline;
        
        return post;
            
    }
    else if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"items"])
    {
    
        ItemsCell* itemsCell = [tableView dequeueReusableCellWithIdentifier:@"ItemsCell" forIndexPath:indexPath];
        //post.index = indexPath.row;
        
        //PFUser* user = [[self.posts objectAtIndex:indexPath.row] getUser];
        //post.item.text = [[self.posts objectAtIndex:indexPath.row] getItem];
        
        ItemsObject* itemsObject = [self.mainfeedRows objectAtIndex:indexPath.row];
        //itemsCell.leftItemImageButton.imageView.image = itemsObject.leftItemImage;
        [itemsCell.leftItemImageButton setBackgroundImage:itemsObject.leftItemImage forState:UIControlStateNormal];
        [itemsCell.rightItemImageButton setBackgroundImage:itemsObject.rightItemImage forState:UIControlStateNormal];

        return itemsCell;

    }
    else
    {
        
        return NULL;
        
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(Post *)post forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"post"])
    {

        CALayer * postBubbleLayer = [post.postBubble layer];
        [postBubbleLayer setMasksToBounds:YES];
        [postBubbleLayer setCornerRadius:5.0];
    
        CGPoint saveCenter = post.profilePicture.center;
        CGRect newFrame = CGRectMake(post.profilePicture.frame.origin.x, post.profilePicture.frame.origin.y, 60, 60);
        post.profilePicture.frame = newFrame;
        post.profilePicture.layer.cornerRadius = 60 / 2.0;
        post.profilePicture.center = saveCenter;
        post.profilePicture.clipsToBounds = YES;
    
        CALayer* helpButtonLayer = [post.helpButton layer];
        [helpButtonLayer setMasksToBounds:YES];
        [helpButtonLayer setCornerRadius:5.0];
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"loadingCell"])
    {
        
        return 568;
        
    }
    else if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"post"])
    {
     
        return 160;
        
    }
    else if([[[self.mainfeedRows objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"items"])
    {
        
        return 160;
        
    }
    else
    {
        
        return 0;
        
    }

}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void) getIndexOfHelpedPost:(NSNotification*) notification
{
    
    self.index = [notification.userInfo[@"index"] integerValue];

}

- (void)directToUserProfile: (NSNotification*) notification
{
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    PostObject* postObject = [self.mainfeedRows objectAtIndex:index];
    self.viewUser = postObject.user;
    
    [self performSegueWithIdentifier:@"View-User-Profile" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"RespondToPostSegue"])
    {
            
        RespondToPost* linkedInHelpBorrowerViewController = (RespondToPost *)segue.destinationViewController;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIndexOfHelpedPost:) name:@"RespondToPost" object:nil];
        
         PostObject* passPostObject = [self.mainfeedRows objectAtIndex:self.index];
        
        linkedInHelpBorrowerViewController.receivedPostObject = passPostObject;
        
    }
    else if([segue.identifier isEqualToString:@"GoToPostDetail"])
    {
        
        PostDetail* postDetail = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        
        PostObject* selectedPostObject = [self.mainfeedRows objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        postDetail.receivedPostObject = selectedPostObject;
        postDetail.currentLocation = self.currentLocation;
        
    }
    else if([segue.identifier isEqualToString:@"View-User-Profile"])
    {
        
        
        UserProfile* tableView = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        PFUser* passUser = self.viewUser;
        // MyPostLenders* tableView = (MyPostLenders*)[self.navigationController.viewControllers objectAtIndex:0];
        tableView.user = passUser;
        
        NSLog(@"I'm in the prepare for segue!");
        
    }
    
    

}

- (IBAction)backButtonPressed:(id)sender {
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    float latitude = self.locationManager.location.coordinate.latitude;
    float longitude = self.locationManager.location.coordinate.longitude;
    
    
    NSString* latitudeString = [NSString stringWithFormat:@"%fw", latitude];
    NSString* longitudeString = [NSString stringWithFormat:@"%fw", longitude];

    NSLog(@"latitidue %f", latitude);
    NSLog(@"longitude %f", longitude);
    
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //NSString *Address = [[NSString alloc]initWithString:locatedAt];
             zipCode = [[NSString alloc]initWithString:placemark.postalCode];
             zipCode = @"90007";
             [self.currentUser setObject:zipCode forKey:@"currentZipcode"];
             [self.currentUser setObject:latitudeString forKey:@"latitude"];
             [self.currentUser setObject:longitudeString forKey:@"longitude"];
             NSLog(@"current zipcode %@",self.currentUser[@"currentZipcode"]);
             
             
             [self pullPostsFromDatabase];
             
             NSLog(@"zip code %@",zipCode);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error); // Error handling must required
         }
     }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint targetPoint = *targetContentOffset;
    CGPoint currentPoint = scrollView.contentOffset;
    
    if (currentPoint.y > 0 && targetPoint.y > currentPoint.y) {

            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.navigationController.navigationBar.alpha = 0.5;
                self.tabBarController.tabBar.alpha = 0.5;
                
            } completion:^(BOOL finished) {
                [self.navigationController.navigationBar setHidden:YES];
                [self.tabBarController.tabBar setHidden:YES];

            }];

    }
    else {

        self.navigationController.navigationBar.alpha = 0.3;
        self.tabBarController.tabBar.alpha = 0.3;
        [self.navigationController.navigationBar setHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.navigationController.navigationBar.alpha = 1.0;
            self.tabBarController.tabBar.alpha = 1.0;
            
            
        } completion:^(BOOL finished) {

            
        }];
        


    }
    
}

- (void)deletePost: (NSNotification*) notification
{
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    [self.mainfeedRows removeObjectAtIndex:index];
    [self.tableView reloadData];
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{

}

- (IBAction)navBarSegmentedControlValueChanged:(id)sender
{
    
    if(self.navBarSegmentedControl.selectedSegmentIndex == 0)
    {

        if([self.posts count] == 0)
        {
            
            [self pullPostsFromDatabase];
            
        }
        else
        {
            
            [self.mainfeedRows removeAllObjects];
            [self.mainfeedRows addObjectsFromArray:self.posts];
            [self.tableView reloadData];
            
        }
        
    }
    else if(self.navBarSegmentedControl.selectedSegmentIndex == 1)
    {

        if([self.items count] == 0)
        {
            
            [self pullItemsFromDatabase];
            
        }
        else
        {
            
            [self.mainfeedRows removeAllObjects];
            [self.mainfeedRows addObjectsFromArray:self.items];
            [self.tableView reloadData];
            
        }
        
    }
    
}

- (void) pullFromDatabase
{
    
    if(self.navBarSegmentedControl.selectedSegmentIndex == 0)
    {
        
        [self pullPostsFromDatabase];
        
    }
    else if(self.navBarSegmentedControl.selectedSegmentIndex == 1)
    {
        
        [self pullItemsFromDatabase];
        
    }
    else
    {
        
        NSLog(@"navBarSegmentedControl not selected");
        
    }
    
    
}

- (void) newPostAdded: (NSNotification*) notification
{
    
    NSDictionary *ud = notification.userInfo;
    NSLog(@"new post added %@", ud);
    
    PFObject* postPFObject = [self convertNSMutableDictionaryToPFObject:ud];
    NSLog(@"PFObject %@", postPFObject);
    PostObject* p = [self createNewPostObject:postPFObject];
    [self.tableView beginUpdates];
    [self.posts insertObject:p atIndex:0];
    [self.mainfeedRows insertObject:p atIndex:0];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    
}

- (PFObject*) convertNSMutableDictionaryToPFObject:(NSDictionary*) nsDictionary {
    NSArray * allKeys = [nsDictionary allKeys];
    PFObject* postObject = [PFObject objectWithoutDataWithClassName:@"Posts" objectId:[nsDictionary objectForKey:@"objectId"]];
    
    for (NSString * key in allKeys)
    {

        if([key isEqualToString:@"user"])
        {
            
            
        }
        else if([key isEqualToString:@"objectId"])
        {
            
            //postObject.objectId = [nsDictionary objectForKey:key];
            
        }
        else
        {

            postObject[key] = [nsDictionary objectForKey:key];
            
        }
        
        
    }
    
    
    NSLog(@"result PFpostobject %@", postObject);
    return postObject;
    
}

- (PostObject*) createNewPostObject: (PFObject*) pfObject
{
    
    PostObject *newPostObject = [[PostObject alloc] init];
    newPostObject.post = pfObject;
    NSLog(@"pfpost %@", pfObject);
    newPostObject.type = @"post";
    newPostObject.deadline = @"now";
    newPostObject.item = pfObject[@"item"];
    NSLog(@"referenceToUserInCreateNewPost %@", pfObject[@"referenceToUser"]);
    newPostObject.user = pfObject[@"referenceToUser"];
    PFFile* profilePictureFile = newPostObject.user[@"profilePicture"];
    NSData* profilePictureData = [profilePictureFile getData];
    newPostObject.userProfileImage = [UIImage imageWithData: profilePictureData];
    newPostObject.deadline = [self getTimeDifference:pfObject[@"deadline"]];
    
    return newPostObject;
    
}

- (NSString*) getTimeDifference: (NSDate*) inputDate
{
    
    NSDate* currentDate = [NSDate date];
    //NSLog(@"current date = %@", currentDate);
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    currentDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    
    NSInteger currentGMTOffset2 = [currentTimeZone secondsFromGMTForDate:inputDate];
    NSInteger nowGMTOffset2 = [nowTimeZone secondsFromGMTForDate:inputDate];
    NSTimeInterval interval2 = nowGMTOffset2 - currentGMTOffset2;
    NSDate* borrowDate = [[NSDate alloc] initWithTimeInterval:interval2 sinceDate:inputDate];
    
    NSLog(@"current date after = %@", currentDate);
    
    NSLog(@"current borrow  date fter = %@", borrowDate);
    
    NSLog(@"borrow date before %@", inputDate);
    //NSDate* borrowDate;
    
    NSTimeInterval secondsBetween = [borrowDate timeIntervalSinceDate:currentDate];
    NSLog(@"seconds difference %f", secondsBetween);
    //NSTimeInterval secondsBetween = [[post valueForKey:@"deadline"] timeIntervalSinceDate: n];
    
    if(secondsBetween <= 0)
    {
        
        return @"ex";
        
    }
    else
    {
        
        int numberOfWeeksElapsed;
        int numberOfDaysElapsed;
        int numberOfHoursElapsed;
        int numberofMinutesElapsed;
        NSString* timeDifferenceInString;
        
        numberOfWeeksElapsed = secondsBetween / 604800;
        if(numberOfWeeksElapsed >= 1)
        {
            
            timeDifferenceInString = [NSString stringWithFormat:@"%dw", numberOfWeeksElapsed];
            return timeDifferenceInString;
            
        }
        else
        {
            
            numberOfDaysElapsed = secondsBetween / 86400;
            NSLog(@"number of days %d", numberOfDaysElapsed);
            if(numberOfDaysElapsed >= 1)
            {
                
                if(numberOfDaysElapsed == 1)
                {
                    //postObject.urgent = true;
                }
                timeDifferenceInString = [NSString stringWithFormat:@"%dd", numberOfDaysElapsed];
                return timeDifferenceInString;
                
            }
            else
            {
                
                //postObject.urgent = true;
                numberOfHoursElapsed = secondsBetween / 3600;
                if(numberOfHoursElapsed >= 1)
                {
                    
                    timeDifferenceInString = [NSString stringWithFormat:@"%dh", numberOfHoursElapsed];
                    return timeDifferenceInString;
                    
                }
                else
                {
                    numberofMinutesElapsed = secondsBetween / 60;
                    if(numberofMinutesElapsed >= 1)
                    {
                        
                        timeDifferenceInString = [NSString stringWithFormat:@"%dm", numberofMinutesElapsed];
                        return timeDifferenceInString;
                        
                    }
                    else
                    {
                        timeDifferenceInString = [NSString stringWithFormat:@"%fs", secondsBetween];
                        //postObject.deadline = timeDifferenceInString;
                        return @"now";
                    }
                    
                }
                
                
            }
            
        }
    }
    
}

- (IBAction)newPostButtonPressed:(id)sender {

    
    if(self.navBarSegmentedControl.selectedSegmentIndex == 0)
    {
    
        [self performSegueWithIdentifier:@"New-Post-Segue" sender:self];
    
    }
    else if(self.navBarSegmentedControl.selectedSegmentIndex == 1)
    {
        
        
        
    }
    
    
}


/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    NSLog(@"scroll begin");

 
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
 
    NSLog(@"scroll end");

 
 
}
*/


@end

