//
//  MyPostLenders.m
//  BorrowMe
//
//  Created by Tom Lee on 3/9/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "MyPostLenders.h"
#import "MyPostLender.h"
#import "MyPostItem.h"
#import "Response.h"
#import <MessageUI/MessageUI.h>

@implementation MyPostLenders


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
    self.currentUser = [PFUser currentUser];
    self.responses = [[NSMutableArray alloc] init];
    
    
    NSLog(@"received my post object %@", self.receivedMyPostObject);
    
    //[self.responses addObject:self.receivedMyPostObject.item];
    [self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    /*
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizer];
    */
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTextDialog:) name:@"RespondToLender" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void) pullFromDatabase
{
    
    PFQuery* queryResponses = [[self.receivedMyPostObject.myPostPFObject relationForKey:@"responses"] query];
    NSLog(@"responses %@", queryResponses);
    [queryResponses findObjectsInBackgroundWithBlock:^(NSArray *responses, NSError *error) {
        
        NSLog(@"%@", error);
        
        if (!error) {
            
            
            for (PFObject *response in responses) {
                
                //[self.receivedMyPostObject.responses addObject:response];
                Response* newResponse = [[Response alloc] init];
                PFUser* user = (PFUser*)[[[response relationForKey:@"user"] query] getFirstObject];
                PFFile* itemImageFile = [response valueForKey:@"itemImage"];
                NSData* itemImageData = [itemImageFile getData];

                
                NSLog(@"response user looppppp   %@", user);
                NSLog(@"item image in the loop   %@", itemImageData);
                newResponse.user = user;
                newResponse.itemImageData = itemImageData;
                [self.responses addObject:newResponse];
                
            }
            
            
            NSLog(@"responses after pull from database  %@", self.responses);
            
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
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
    
    return [self.responses count];
    
}

- (void)singleTapOnTableViewCell:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"single tap!");
    
}

- (void)doubleTapOnTableViewCell:(UITapGestureRecognizer *) recognizer
{
    NSLog(@"double tap");
    /*
    [[self.responses objectAtIndex: indexPath.row ] deleteInBackground];
    [self.responses removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 /*
    if(indexPath.row == 0) {
        
        MyPostItem* myPostItem = [tableView dequeueReusableCellWithIdentifier:@"MyPostItem" forIndexPath:indexPath];
        CALayer * myPostItemLayer = [myPostItem.item layer];
        [myPostItemLayer setMasksToBounds:YES];
        [myPostItemLayer setCornerRadius:5.0];
        
        myPostItem.item.text = [self.responses objectAtIndex:indexPath.row];
        
        return myPostItem;
        
    }
    else {
 */
        MyPostLender* myPostLender = [tableView dequeueReusableCellWithIdentifier:@"MyPostLender" forIndexPath:indexPath];
        myPostLender.selectionStyle = UITableViewCellSelectionStyleNone;
    
        CALayer * borderLayer = [myPostLender.border layer];
        [borderLayer setMasksToBounds:YES];
        [borderLayer setCornerRadius:10.0];
    
        CALayer * messageButtonLayer = [myPostLender.messageButton layer];
        [messageButtonLayer setMasksToBounds:YES];
        [messageButtonLayer setCornerRadius:5.0];
    
    
        /*
        CGPoint saveCenter = myPostLender.profileImage.center;
        CGRect newFrame = CGRectMake(myPostLender.profileImage.frame.origin.x, myPostLender.profileImage.frame.origin.y, 50, 50);
        
        myPostLender.profileImage.frame = newFrame;
        myPostLender.profileImage.layer.cornerRadius = 50 / 2.0;
        myPostLender.profileImage.center = saveCenter;
        myPostLender.profileImage.clipsToBounds = YES;
        */
        CGPoint saveCenter = myPostLender.userProfileButton.center;
        CGRect newFrame = CGRectMake(myPostLender.userProfileButton.frame.origin.x, myPostLender.userProfileButton.frame.origin.y, 50, 50);
    
        myPostLender.userProfileButton.frame = newFrame;
        myPostLender.userProfileButton.layer.cornerRadius = 50 / 2.0;
        myPostLender.userProfileButton.center = saveCenter;
        myPostLender.userProfileButton.clipsToBounds = YES;
    
    

        Response* response = [self.responses objectAtIndex:indexPath.row];
        PFFile* profilePictureFile = [response.user valueForKey:@"profilePicture"];
        NSData* profilePictureData = [profilePictureFile getData];
    
        myPostLender.profileImage.image = [UIImage imageWithData: profilePictureData];
        myPostLender.itemImage.image = [UIImage imageWithData: response.itemImageData];
        myPostLender.username.text = [response.user valueForKey:@"username"];
        myPostLender.index = indexPath.row;
    
    
        [myPostLender.usernameButton setTitle:[response.user valueForKey:@"username"] forState:UIControlStateNormal];
        [myPostLender.userProfileButton setBackgroundImage:myPostLender.profileImage.image
                        forState:UIControlStateNormal];

    
    
        return myPostLender;
        
    //}
    /*
    
    if([[[self.myPosts objectAtIndex:indexPath.row] lenders] count] > 0)
    {
        
        MyPost* myPost = [tableView dequeueReusableCellWithIdentifier:@"MyPost" forIndexPath:indexPath];
        CALayer * myPostItemLayer = [myPost.item layer];
        [myPostItemLayer setMasksToBounds:YES];
        [myPostItemLayer setCornerRadius:5.0];
        
        CGPoint saveCenter = myPost.lenderPicture1.center;
        CGRect newFrame = CGRectMake(myPost.lenderPicture1.frame.origin.x, myPost.lenderPicture1.frame.origin.y, 40, 40);
        
        myPost.lenderPicture1.frame = newFrame;
        myPost.lenderPicture1.layer.cornerRadius = 40 / 2.0;
        myPost.lenderPicture1.center = saveCenter;
        myPost.lenderPicture1.clipsToBounds = YES;
        
        myPost.lenderPicture2.frame = newFrame;
        myPost.lenderPicture2.layer.cornerRadius = 40 / 2.0;
        myPost.lenderPicture2.center = saveCenter;
        myPost.lenderPicture2.clipsToBounds = YES;
        
        myPost.lenderPicture3.frame = newFrame;
        myPost.lenderPicture3.layer.cornerRadius = 40 / 2.0;
        myPost.lenderPicture3.center = saveCenter;
        myPost.lenderPicture3.clipsToBounds = YES;
        
        myPost.lenderPicture4.frame = newFrame;
        myPost.lenderPicture4.layer.cornerRadius = 40 / 2.0;
        myPost.lenderPicture4.center = saveCenter;
        myPost.lenderPicture4.clipsToBounds = YES;
        
        //PFUser* user = [[self.posts objectAtIndex:indexPath.row] getUser];
        
        MyPostObject* myPostObject = [self.myPosts objectAtIndex:indexPath.row];
        myPost.item.text = myPostObject.item;
        
        if([myPostObject.lenders count] > 0)
        {
            int lenderIndex = 0;
            
            do {
                
                
                NSLog(@"I'm in the lender loop");
                if([myPostObject.lenders objectAtIndex:0] && lenderIndex == 0)
                {
                    myPost.lenderPicture1.image = [UIImage imageWithData: [myPostObject.lenders objectAtIndex:0]];
                }
                else if([myPostObject.lenders objectAtIndex:1] && lenderIndex == 1)
                {
                    myPost.lenderPicture2.image = [UIImage imageWithData: [myPostObject.lenders objectAtIndex:1]];
                }
                else if([myPostObject.lenders objectAtIndex:2] && lenderIndex == 2)
                {
                    myPost.lenderPicture3.image = [UIImage imageWithData: [myPostObject.lenders objectAtIndex:2]];
                }
                else if([myPostObject.lenders objectAtIndex:3] && lenderIndex == 3)
                {
                    myPost.lenderPicture4.image = [UIImage imageWithData: [myPostObject.lenders objectAtIndex:3]];
                }
                
                lenderIndex++;
                
            }while(lenderIndex < [myPostObject.lenders count]);
            
            NSInteger remainingLenders = [myPostObject.lenders count] - (lenderIndex + 1);
            
            if(remainingLenders >= 1)
            {
                myPost.addtionalLenders.text = [NSString stringWithFormat:@"+%ld", (long)remainingLenders];
            }
            else
            {
                myPost.addtionalLenders.hidden = YES;
            }
            
            
        }
        
        
        return myPost;
        
        
    }
    else if([[[self.myPosts objectAtIndex:indexPath.row] lenders] count] == 0)
    {
        
        MyPostNoLenders* myPostNoLenders = [tableView dequeueReusableCellWithIdentifier:@"MyPostNoLenders" forIndexPath:indexPath];
        CALayer * myPostItemLayer = [myPostNoLenders.item layer];
        [myPostItemLayer setMasksToBounds:YES];
        [myPostItemLayer setCornerRadius:5.0];
        
        MyPostObject* myPostObject = [self.myPosts objectAtIndex:indexPath.row];
        myPostNoLenders.item.text = myPostObject.item;
        
        return myPostNoLenders;
        
    }
    else
    {
        
        return NULL;
        
    }
    
     */
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   return 440;
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    self.tableView.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void) showTextDialog: (NSNotification*) notification {
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    
    Response* response = [self.responses objectAtIndex:index];
    PFUser* user = response.user;
    
    NSString* recipientPhoneNumber = user[@"phone"];
    NSString* item = self.receivedMyPostObject.item;
    
    
    NSString* textMessageContent = [NSString stringWithFormat:@"Hello from Neighbors! %@ would like to borrow your %@", user[@"username"], item];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = textMessageContent;
        controller.recipients = [NSArray arrayWithObjects:recipientPhoneNumber, nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}




/*
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error"
                                                           delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
            [alert show];
            [alert release];
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[self.myPosts objectAtIndex:indexPath.row ] myPostPFObject] deleteInBackground];
        [self.myPosts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
*/
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
/*
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 
 if([segue.identifier isEqualToString:@"RespondToPostSegue"])
 {
 
 RespondToPost* linkedInHelpBorrowerViewController = (RespondToPost *)segue.destinationViewController;
 
 PostObject* passPostObject = [self.posts objectAtIndex:self.tableView.indexPathForSelectedRow.row];
 
 linkedInHelpBorrowerViewController.receivedPostObject = passPostObject;
 
 }
 
 }
 */
- (IBAction)backButtonPressed:(id)sender {
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
