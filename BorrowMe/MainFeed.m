//
//  MainFeed.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "MainFeed.h"
#import "Post.h"
#import "RespondToPost.h"

@implementation MainFeed

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
    self.currentUser = [PFUser currentUser];
    //[self pullFromDatabase];
    //[self.tableView reloadData];
    
//    
//    self.navBar = self.navigationController.navigationBar;
//    [self.navBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navBar setShadowImage:[UIImage new]];
//    self.navBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.currentUser = [PFUser currentUser];
    NSLog(@"current user %@", self.currentUser);
    
    self.posts = [[NSMutableArray alloc] init];
    [self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    
    [self performSegueWithIdentifier:@"NewPostSegue" sender:self];    
    
}

- (void) pullFromDatabase
{

    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            
            // The find succeeded.
            // Do something with the found objects
            
            if([self.posts count] != 0)
            {
                [self.posts removeAllObjects];
            }
            
            for (PFObject *post in posts) {
                // This does not require a network access.
                //PFUser* user = post[@"user"];
                
                PFUser* user = (PFUser*)[[[post relationForKey:@"user"] query] getFirstObject];
                NSLog(@"%@", user);
                
                PostObject* postObject = [[PostObject alloc] init];
                [postObject setUserObject:user];
                [postObject setItemObject: [post valueForKey:@"item"]];
                [postObject setPostObject: post];
                [self.posts addObject:postObject];
                
            }
            NSLog(@"posts array %@", self.posts);
            
            //[self.posts addObjectsFromArray:posts];
            

            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
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
    
    return [self.posts count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Post* post = [tableView dequeueReusableCellWithIdentifier:@"Post" forIndexPath:indexPath];
    CALayer * postBubbleLayer = [post.postBubble layer];
    [postBubbleLayer setMasksToBounds:YES];
    [postBubbleLayer setCornerRadius:5.0];
    
    CGPoint saveCenter = post.profilePicture.center;
    CGRect newFrame = CGRectMake(post.profilePicture.frame.origin.x, post.profilePicture.frame.origin.y, 80, 80);
    post.profilePicture.frame = newFrame;
    post.profilePicture.layer.cornerRadius = 80 / 2.0;
    post.profilePicture.center = saveCenter;
    post.profilePicture.clipsToBounds = YES;
    
    PFUser* user = [[self.posts objectAtIndex:indexPath.row] getUser];
    post.item.text = [[self.posts objectAtIndex:indexPath.row] getItem];
 
    PFFile* profilePictureFile = [user valueForKey:@"profilePicture"];
    NSData* profilePictureData = [profilePictureFile getData];
    post.profilePicture.image = [UIImage imageWithData: profilePictureData];
    
    
    NSString* buttonTitle = [NSString stringWithFormat:@"%@", [user valueForKey:@"username"]];
    [post.username setTitle: buttonTitle forState: UIControlStateNormal];
    
    CALayer* helpButtonLayer = [post.helpButton layer];
    [helpButtonLayer setMasksToBounds:YES];
    [helpButtonLayer setCornerRadius:5.0];
    
    [[post.helpButton layer] setBorderWidth:2.0f];
    [[post.helpButton layer] setBorderColor:[UIColor colorWithRed: 102.0/255.0 green: 255.0/255.0 blue:102.0/255.0 alpha: 1.0].CGColor];
    
    
    /*
    CALayer * helpButtonLayer = [post.helpButton layer];
    [helpButtonLayer setMasksToBounds:YES];
    [helpButtonLayer setCornerRadius:10.0];
    */
    
    //[[self.askButton layer] setBorderWidth:2.0f];
    //[[self.askButton layer] setBorderColor:[UIColor colorWithRed: 102.0/255.0 green: 204.0/255.0 blue:255.0/255.0 alpha: 1.0].CGColor];
    

    return post;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 160;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"RespondToPostSegue"])
    {
            
        RespondToPost* linkedInHelpBorrowerViewController = (RespondToPost *)segue.destinationViewController;

         PostObject* passPostObject = [self.posts objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        linkedInHelpBorrowerViewController.receivedPostObject = passPostObject;
        
    }

}

- (IBAction)backButtonPressed:(id)sender {
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
