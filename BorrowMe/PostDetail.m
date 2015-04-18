//
//  PostDetail.m
//  BorrowMe
//
//  Created by Tom Lee on 4/17/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "PostDetail.h"

@implementation PostDetail

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

    self.postDetails = [[NSMutableArray alloc] init];
    
    [self.postDetails addObject:self.receivedPostObject];
    
    PostObject* aboutPost = [[PostObject alloc] init];
    aboutPost.type = @"postDetail";
    
    [self.postDetails addObject:aboutPost];
    
    NSLog(@"received my post object %@", self.receivedPostObject);

/*
    
    self.view.backgroundColor = [UIColor whiteColor];
*/
    
}


/*
- (void) pullFromDatabase
{
    
    PFQuery* queryResponses = [[self.receivedMyPostObject.myPostPFObject relationForKey:@"responses"] query];
    [queryResponses orderByDescending:@"createdAt"];
    
    //NSLog(@"responses %@", queryResponses);
    [queryResponses findObjectsInBackgroundWithBlock:^(NSArray *responses, NSError *error) {
        
        //NSLog(@"%@", error);
        
        if (!error) {
            
            [self.responses removeAllObjects];
            
            for (PFObject *response in responses) {
                
                //[self.receivedMyPostObject.responses addObject:response];
                Response* newResponse = [[Response alloc] init];
                PFUser* user = (PFUser*)[[[response relationForKey:@"user"] query] getFirstObject];
                newResponse.user = user;
                
                PFFile* profilePictureFile = [user valueForKey:@"profilePicture"];
                NSData* profilePictureData = [profilePictureFile getData];
                newResponse.userProfile = [UIImage imageWithData: profilePictureData];
                
                PFFile* itemImageFile = [response valueForKey:@"itemImage"];
                NSData* itemImageData = [itemImageFile getData];
                //newResponse.itemImageData = itemImageData;
                newResponse.itemImage = [UIImage imageWithData: itemImageData];
                
                //NSLog(@"response user looppppp   %@", user);
                //NSLog(@"item image in the loop   %@", itemImageData);
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
*/



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
    
    return [self.postDetails count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
        
        Post* post = [tableView dequeueReusableCellWithIdentifier:@"Post" forIndexPath:indexPath];
        
        PostObject* postObject = [self.postDetails objectAtIndex:indexPath.row];
        
        post.index = indexPath.row;
        
        
        PFUser* user = postObject.user;
        post.item.text = postObject.item;
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
            
            post.heartCount.text = [NSString stringWithFormat:@"%@", [postObject.post valueForKey:@"likes"]];
            
        }
        post.deadline.text = postObject.deadline;
        
        return post;
        
    }
    else
    {
        AboutPost* aboutPost = [tableView dequeueReusableCellWithIdentifier:@"AboutPost" forIndexPath:indexPath];

        [aboutPost setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [aboutPost.container.layer setMasksToBounds:YES];
        [aboutPost.container.layer setCornerRadius:5.0];
        
        [aboutPost.aboutPostSelector setTitle:@"About Post"forSegmentAtIndex:0];
        [aboutPost.aboutPostSelector setTitle:@"Map"forSegmentAtIndex:1];
        
        [aboutPost.note.layer setMasksToBounds:YES];
        [aboutPost.note.layer setCornerRadius:10.0];
        
        return aboutPost;
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(Post *)post forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        
        CALayer * postBubbleLayer = [post.postBubble layer];
        [postBubbleLayer setMasksToBounds:YES];
        [postBubbleLayer setCornerRadius:5.0];
        
        CGPoint saveCenter = post.profilePicture.center;
        CGRect newFrame = CGRectMake(post.profilePicture.frame.origin.x, post.profilePicture.frame.     origin.y, 60, 60);
        post.profilePicture.frame = newFrame;
        post.profilePicture.layer.cornerRadius = 60 / 2.0;
        post.profilePicture.center = saveCenter;
        post.profilePicture.clipsToBounds = YES;
        
        CALayer* helpButtonLayer = [post.helpButton layer];
        
        [helpButtonLayer setMasksToBounds:YES];
        [helpButtonLayer setCornerRadius:5.0];
        
        [post setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    else if(indexPath.row == 1)
    {

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        
        return 160;
        
    }
    else
    {
        
        return 400;
        
    }
    
}

- (void) getIndexOfHelpedPost:(NSNotification*) notification
{
    
    self.index = [notification.userInfo[@"index"] integerValue];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"RespondToPostSegue"])
    {
        
        RespondToPost* linkedInHelpBorrowerViewController = (RespondToPost*)segue.destinationViewController;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIndexOfHelpedPost:) name:@"RespondToPost" object:nil];
        
        PostObject* passPostObject = [self.postDetails objectAtIndex:self.index];        
        linkedInHelpBorrowerViewController.receivedPostObject = passPostObject;
        
    }
    
}

- (IBAction)dismissPostDetail:(id)sender {

    [self dismissViewControllerAnimated:true completion:nil];
    
}


@end
