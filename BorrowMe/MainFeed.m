//
//  MainFeed.m
//  BorrowMe
//
//  Created by Tom Lee on 2/1/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "MainFeed.h"
#import "Post.h"

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
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];    
    self.posts = [[NSMutableArray alloc] init];
    [self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

}

- (void) pullFromDatabase
{

    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query includeKey:@"User"];
    [query includeKey:@"User.username"];
    
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            
            // The find succeeded.
            // Do something with the found objects
            if([self.posts count] != 0)
            {
                [self.posts removeAllObjects];
            }
            [self.posts addObjectsFromArray:posts];
            
            /*
            for (PFObject *post in self.posts) {
                // This does not require a network access.
                PFUser* user = post[@"user"];
                [user fetchIfNeeded];
                //NSLog(@"Helllllloooooo: %@", user);
                NSLog(@"Helllllloooooo: %@", user.username);
                
            }
            */
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
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
    CGRect newFrame = CGRectMake(post.profilePicture.frame.origin.x, post.profilePicture.frame.origin.y, 60, 60);
    post.profilePicture.frame = newFrame;
    post.profilePicture.layer.cornerRadius = 60 / 2.0;
    post.profilePicture.center = saveCenter;
    post.profilePicture.clipsToBounds = YES;
    
    post.userId = [[self.posts objectAtIndex:indexPath.row] valueForKey:@"userId"];
    post.item.text = [[self.posts objectAtIndex:indexPath.row] valueForKey:@"item"];
    
    
    NSLog(@"user class %@ !!!!!!!",[[self.posts objectAtIndex:indexPath.row] objectForKey:@"user"]);
    
    /*
    NSString* username = [[[self.posts objectAtIndex:indexPath.row] objectForKey:@"user"] valueForKey:@"username"];
    
    [post.username setTitle: username forState: UIControlStateNormal];
    */
    
    return post;
    /*
    int firstIndex = indexPath.row;
    
    
    if(firstIndex == 0)
    {
        TELIndividualNewsFeedHeaderSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderSection" forIndexPath:indexPath];
        
        CGPoint saveCenter = cell.creatorProfile.center;
        CGRect newFrame = CGRectMake(cell.creatorProfile.frame.origin.x, cell.creatorProfile.frame.origin.y, 70, 70);
        cell.creatorProfile.frame = newFrame;
        cell.creatorProfile.layer.cornerRadius = 70 / 2.0;
        cell.creatorProfile.center = saveCenter;
        cell.creatorProfile.clipsToBounds = YES;
        
        PFFile* creatorProfileFile = [[self.comments objectAtIndex:indexPath.row] valueForKey:@"creatorProfile"];
        NSData* creatorProfileData = [creatorProfileFile getData];
        cell.creatorProfile.image = [UIImage imageWithData:creatorProfileData];
        
        cell.creatorName.text = [NSString stringWithFormat:@" by %@", [[self.comments objectAtIndex:indexPath.row]valueForKey:@"creatorName"]];
        cell.title.text =[[self.comments objectAtIndex:indexPath.row] valueForKey:@"title"];
        PFFile* imageFile = [[self.comments objectAtIndex:indexPath.row] valueForKey:@"image"];
        NSData* imageData = [imageFile getData];
        cell.image.image = [UIImage imageWithData:imageData];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        TELCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment" forIndexPath:indexPath];
        
        CGPoint saveCenter = cell.commentorProfile.center;
        CGRect newFrame = CGRectMake(cell.commentorProfile.frame.origin.x, cell.commentorProfile.frame.origin.y, 44, 44);
        cell.commentorProfile.frame = newFrame;
        cell.commentorProfile.layer.cornerRadius = 44 / 2.0;
        cell.commentorProfile.center = saveCenter;
        cell.commentorProfile.clipsToBounds = YES;
        
        PFFile* commentorProfileFile = [[self.comments objectAtIndex:indexPath.row] valueForKey:@"commentorProfile"];
        NSData* commentorProfileData = [commentorProfileFile getData];
        cell.commentorProfile.image = [UIImage imageWithData:commentorProfileData];
        
        cell.commentorName.text = [[self.comments objectAtIndex:indexPath.row]valueForKey:@"commentorName"];
        
        
        cell.content.text = [[self.comments objectAtIndex:indexPath.row] valueForKey:@"content"];
        CALayer * l = [cell.content layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }
     */
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 100;
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
    
    if([segue.identifier isEqualToString:@"PostCommentSegue"])
    {
        /*
        
        TELPostCommentViewController* linkedInTableViewController = (TELPostCommentViewController *)segue.destinationViewController;
        
        
        PFObject *passNewsFeedObject = self.receivedNewsFeedObject;
        linkedInTableViewController.receivedNewsFeedObject = passNewsFeedObject;
         */
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
