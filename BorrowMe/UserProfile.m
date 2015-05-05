//
//  UserProfile.m
//  BorrowMe
//
//  Created by Tom Lee on 3/26/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "UserProfile.h"
#import "UserCell.h"
#import "UserObject.h"
#import "ReviewObject.h"
#import "ReviewCell.h"
#import "LoadingCell.h"

@implementation UserProfile

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    //self.navBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if(self.user == NULL)
    {
        self.user = [PFUser currentUser];
        NSLog(@"user %@", self.user);
    }
    
    
    [self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0];
    
    
}


- (void) pullFromDatabase
{
    
    self.reviews = [[NSMutableArray alloc] init];
    
    UserObject* userObject = [[UserObject alloc] init];
    userObject.user = self.user;
    PFFile* profilePictureFile = [self.user valueForKey:@"profilePicture"];
    NSData* profilePictureData = [profilePictureFile getData];
    userObject.userProfile = [UIImage imageWithData: profilePictureData];
    userObject.username = [self.user valueForKey:@"username"];
    userObject.averageRating = @"";
    
    [self.reviews addObject:userObject];
    ReviewObject* loadingCell = [[ReviewObject alloc] init];
    [self.reviews addObject:loadingCell];
    
    NSLog(@"inside reviews array %@", self.reviews);
    
    NSMutableArray* tempReviews = [[NSMutableArray alloc] init];
    
    __block float totalRating = 0;
    NSLog(@"userr   %@", self.user);
    PFQuery* queryReviews = [[self.user relationForKey:@"reviews"] query];
    [queryReviews orderByDescending:@"createdAt"];
    //NSLog(@"queryReviews   %@", queryReviews);
    [queryReviews findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError *error) {

        if (!error)
        {
            
            //if([reviews count] > 0) {
            [self.reviews removeAllObjects];
            //}
            
            for (PFObject *review in reviews)
            {
                
                ReviewObject* reviewObject = [[ReviewObject alloc] init];
                
                PFUser* user = (PFUser*)[[[review relationForKey:@"user"] query] getFirstObject];
                
                reviewObject.user = user;
                reviewObject.username = user.username;
                PFFile* profilePictureFile = [user valueForKey:@"profilePicture"];
                NSData* profilePictureData = [profilePictureFile getData];
                reviewObject.userProfile = [UIImage imageWithData: profilePictureData];
                
                reviewObject.reviewPFObject = review;
                reviewObject.rating = [review valueForKey:@"rating"];
                reviewObject.review = [review valueForKey:@"review"];
                float reviewRating = [reviewObject.rating floatValue];
                totalRating += reviewRating;

                //[self.reviews addObject:reviewObject];
                [tempReviews addObject:reviewObject];
                
                
            }
          
            NSLog(@"totalRating %f", totalRating);
            NSLog(@"reviews count %d", [reviews count]);
            float averageRating = totalRating/[reviews count];
            int roundedAverageRating = roundf(averageRating);
            
            NSLog(@"averageRating %f", averageRating);
            
            UserObject* userObject = [[UserObject alloc] init];
            userObject.user = self.user;
            PFFile* profilePictureFile = [self.user valueForKey:@"profilePicture"];
            NSData* profilePictureData = [profilePictureFile getData];
            userObject.userProfile = [UIImage imageWithData: profilePictureData];
            userObject.username = [self.user valueForKey:@"username"];
            userObject.averageRating = [NSString stringWithFormat:@"%d", roundedAverageRating];
            
            [self.reviews addObject:userObject];
            
            [self.reviews addObjectsFromArray:tempReviews];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                NSLog(@"reviewss  %@", self.reviews);
                [self.refreshControl endRefreshing];
            });
            
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.reviews count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        
        NSLog(@"user cell created !!");
        UserCell* userCell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
        
        [userCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        UserObject* userObject = [self.reviews objectAtIndex:indexPath.row];
        

        
        CGPoint saveCenter = userCell.userProfilePictureButton.center;
        CGRect newFrame = CGRectMake(userCell.userProfilePictureButton.frame.origin.x, userCell.userProfilePictureButton.frame.origin.y, 90, 90);
        userCell.userProfilePictureButton.frame = newFrame;
        userCell.userProfilePictureButton.layer.cornerRadius = 90 / 2.0;
        userCell.userProfilePictureButton.center = saveCenter;
        userCell.userProfilePictureButton.clipsToBounds = YES;
        
        
        
        CALayer* ratingLayer = [userCell.rating layer];
        [ratingLayer setMasksToBounds:YES];
        [ratingLayer setCornerRadius:5.0];
        
        
        CALayer* backgroundViewLayer = [userCell.container layer];
        [backgroundViewLayer setMasksToBounds:YES];
        [backgroundViewLayer setCornerRadius:10.0];
        

        /*
        userCell.backgroundView.layer.masksToBounds = NO;
        userCell.backgroundView.layer.cornerRadius = 8; // if you like rounded corners
        userCell.backgroundView.layer.shadowOffset = CGSizeMake(-15, 20);
        userCell.backgroundView.layer.shadowRadius = 5;
        userCell.backgroundView.layer.shadowOpacity = 0.5;
        */
        
        [userCell.userProfilePictureButton setBackgroundImage:userObject.userProfile forState:UIControlStateNormal];
        userCell.username.text = userObject.username;
        userCell.rating.text = userObject.averageRating;
        userCell.heartImage.image = [userCell.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userCell.heartImage setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
        if([userCell.rating.text isEqualToString:@""])
        {
            
            //userCell.rating.backgroundColor = [UIColor colorWithRed: 102.0/255.0 green: 102.0/255.0 blue:102.0/255.0 alpha: 0.5];
            userCell.rating.hidden = YES;
            
            
        }
        else
        {
            
            userCell.rating.hidden = NO;
            int ratingInInt = [userCell.rating.text intValue];
            if(ratingInInt <= 2)
            {
                
                userCell.heartImage.image = [userCell.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [userCell.heartImage setTintColor:[UIColor colorWithRed: 255.0/255.0 green: 0.0/255.0 blue:0.0/255.0 alpha: 0.5]];

                //userCell.rating.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 0.0/255.0 blue:0.0/255.0 alpha: 0.5];

            }
            else if(ratingInInt == 3)
            {
                

                //userCell.rating.backgroundColor = [UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0];
                
                
            }
            else {
                
                userCell.heartImage.image = [userCell.heartImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [userCell.heartImage setTintColor:[UIColor colorWithRed: 0.0/255.0 green: 255.0/255.0 blue:0.0/255.0 alpha: 0.5]];
                 //userCell.rating.backgroundColor = [UIColor colorWithRed: 0.0/255.0 green: 255.0/255.0 blue:0.0/255.0 alpha: 0.5];
                
            }
            
        
        }
        
        return userCell;

    }
    else
    {
        
        ReviewObject* reviewObject = [self.reviews objectAtIndex:indexPath.row];
        if(reviewObject.reviewPFObject == NULL)
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
            
            CALayer* loadingBoxLayer = [loadingCell.loadingBox layer];
            [loadingBoxLayer setMasksToBounds:YES];
            [loadingBoxLayer setCornerRadius:10.0];
            
            return loadingCell;
            
        }
        
        NSLog(@"review cell created !!");
        ReviewCell* reviewCell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
        reviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //ReviewObject* reviewObject = [self.reviews objectAtIndex:indexPath.row];
        [reviewCell.userProfilePicture setBackgroundImage:reviewObject.userProfile forState:UIControlStateNormal];
        [reviewCell.userName setTitle:reviewObject.username forState:UIControlStateNormal];
        reviewCell.review.text = [NSString stringWithFormat:@" %@ says \"%@\"", reviewObject.username ,reviewObject.review];
        reviewCell.score.text = reviewObject.rating;
        
        
        int ratingInInt = [reviewCell.score.text intValue];
        if(ratingInInt == 1)
        {
            
            reviewCell.heartImage1.hidden = NO;
            reviewCell.heartImage1.image = [reviewCell.heartImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            
        }
        else if(ratingInInt == 2)
        {
            
            reviewCell.heartImage1.hidden = NO;
            reviewCell.heartImage1.image = [reviewCell.heartImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage2.hidden = NO;
            reviewCell.heartImage2.image = [reviewCell.heartImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            
            
        }
        else if(ratingInInt == 3)
        {
            
            //reviewCell.score.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 0.0/255.0 blue:0.0/255.0 alpha: 0.5];
            reviewCell.heartImage1.hidden = NO;
            reviewCell.heartImage1.image = [reviewCell.heartImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage2.hidden = NO;
            reviewCell.heartImage2.image = [reviewCell.heartImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage3.hidden = NO;
            reviewCell.heartImage3.image = [reviewCell.heartImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            
            
        }
        else if(ratingInInt == 4)
        {
            
            //reviewCell.score.backgroundColor = [UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0];
            reviewCell.heartImage1.hidden = NO;
            reviewCell.heartImage1.image = [reviewCell.heartImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage2.hidden = NO;
            reviewCell.heartImage2.image = [reviewCell.heartImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage3.hidden = NO;
            reviewCell.heartImage3.image = [reviewCell.heartImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage4.hidden = NO;
            reviewCell.heartImage4.image = [reviewCell.heartImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage4 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            
            
        }
        else if(ratingInInt == 5){
            
            //reviewCell.score.backgroundColor = [UIColor colorWithRed: 0.0/255.0 green: 255.0/255.0 blue:0.0/255.0 alpha: 0.5];
            reviewCell.heartImage1.hidden = NO;
            reviewCell.heartImage1.image = [reviewCell.heartImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage1 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage2.hidden = NO;
            reviewCell.heartImage2.image = [reviewCell.heartImage2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage2 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage3.hidden = NO;
            reviewCell.heartImage3.image = [reviewCell.heartImage3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage3 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage4.hidden = NO;
            reviewCell.heartImage4.image = [reviewCell.heartImage4.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage4 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            reviewCell.heartImage5.hidden = NO;
            reviewCell.heartImage5.image = [reviewCell.heartImage5.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [reviewCell.heartImage5 setTintColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0]];
            
        }
        
        
        
        return reviewCell;
        
    }
    /*
    else
    {
        return NULL;
    }
    */
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(ReviewCell *) reviewCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReviewObject* reviewObject = [self.reviews objectAtIndex:indexPath.row];

    if(indexPath.row != 0 && reviewObject.reviewPFObject != NULL)
    {
        
 
        CGPoint saveCenter = reviewCell.userProfilePicture.center;
        CGRect newFrame = CGRectMake(reviewCell.userProfilePicture.frame.origin.x, reviewCell.userProfilePicture.frame.origin.y, 40, 40);
        reviewCell.userProfilePicture.frame = newFrame;
        reviewCell.userProfilePicture.layer.cornerRadius = 40 / 2.0;
        reviewCell.userProfilePicture.center = saveCenter;
        reviewCell.userProfilePicture.clipsToBounds = YES;
        
        CALayer* backgroundViewLayer = [reviewCell.container layer];
        [backgroundViewLayer setMasksToBounds:YES];
        [backgroundViewLayer  setCornerRadius:5.0];
        
        CALayer* scoreLayer = [reviewCell.score layer];
        [scoreLayer setMasksToBounds:YES];
        [scoreLayer  setCornerRadius:5.0];
        
        [reviewCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReviewObject* reviewObject = [self.reviews objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0)
    {
        
        return 323;
        
    }
    else
    {
        if(reviewObject.reviewPFObject == NULL)
        {
            
            return 300;
            
        }
        else
        {

            return 141;
            
        }
        
    }
    
}

- (IBAction)backButtonPressed:(id)sender
{

    [self dismissViewControllerAnimated:true completion:nil];
    
}


- (IBAction)writeReviewButtonPressed:(id)sender {
    
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    /*
    if([segue.identifier isEqualToString:@"GoToMyPostLenders"])
    {
        

        
    }
    */
    
}

@end
