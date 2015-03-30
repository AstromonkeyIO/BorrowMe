//
//  UserProfile.m
//  BorrowMe
//
//  Created by Tom Lee on 3/26/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentUser = [PFUser currentUser];
    
  self.navBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if(self.user == NULL)
    {
        self.user = [PFUser currentUser];
    }
    
    self.currentUser = [PFUser currentUser];
    self.myPosts = [[NSMutableArray alloc] init];
    [self pullFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; [refreshControl addTarget:self action:@selector(pullFromDatabase) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}


- (void) pullFromDatabase
{
    
    NSLog(@"I'm in pull from db");
    
    PFQuery* queryMyPosts = [[self.currentUser relationForKey:@"posts"] query];
    NSLog(@"%@", queryMyPosts);
    [queryMyPosts findObjectsInBackgroundWithBlock:^(NSArray *myPosts, NSError *error) {
        
        NSLog(@"%@", error);
        
        if (!error) {
            
            NSLog(@"my Posts %@", myPosts);
            if([myPosts count] > 0)
            {
                
                [self.myPosts removeAllObjects];
                
            }
            
            
            for (PFObject *myPost in myPosts) {
                
                
                MyPostObject* newMyPost = [[MyPostObject alloc] init];
                [newMyPost initialize];
                
                PFUser* user = (PFUser*)[[[myPost relationForKey:@"user"] query] getFirstObject];
                
                newMyPost.myPostPFObject = myPost;
                
                newMyPost.item = [myPost valueForKey:@"item"];
                
                NSArray* responses = [[[myPost relationForKey:@"responses"] query] findObjects];
                
                //NSLog(@"these are responses count   !!!!  %lu", (unsigned long)[responses count]);
                [newMyPost.responses addObjectsFromArray:responses];
                
                for(PFObject* response in responses)
                {
                    
                    PFUser* user = (PFUser*)[[[response relationForKey:@"user"] query] getFirstObject];
                    //NSLog(@"response user looppppp   %@", user);
                    //post.profilePicture.image = [UIImage imageWithData: profilePictureData];
                    
                    [newMyPost.lenders addObject:user];
                    
                }
                
                [self.myPosts addObject:newMyPost];
                
            }
            
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
    
    return [self.myPosts count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                    PFFile* profilePictureFile = [[myPostObject.lenders objectAtIndex:0] valueForKey:@"profilePicture"];
                    NSData* profilePictureData = [profilePictureFile getData];
                    myPost.lenderPicture1.image = [UIImage imageWithData: profilePictureData];
                }
                else if([myPostObject.lenders objectAtIndex:1] && lenderIndex == 1)
                {
                    PFFile* profilePictureFile = [[myPostObject.lenders objectAtIndex:1] valueForKey:@"profilePicture"];
                    NSData* profilePictureData = [profilePictureFile getData];
                    myPost.lenderPicture2.image = [UIImage imageWithData: profilePictureData];
                }
                else if([myPostObject.lenders objectAtIndex:2] && lenderIndex == 2)
                {
                    PFFile* profilePictureFile = [[myPostObject.lenders objectAtIndex:2] valueForKey:@"profilePicture"];
                    NSData* profilePictureData = [profilePictureFile getData];
                    myPost.lenderPicture3.image = [UIImage imageWithData: profilePictureData];
                }
                else if([myPostObject.lenders objectAtIndex:3] && lenderIndex == 3)
                {
                    PFFile* profilePictureFile = [[myPostObject.lenders objectAtIndex:3] valueForKey:@"profilePicture"];
                    NSData* profilePictureData = [profilePictureFile getData];
                    myPost.lenderPicture4.image = [UIImage imageWithData: profilePictureData];
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[[self.myPosts objectAtIndex:indexPath.row] lenders] count] > 0)
    {
        
        return 92;
        
    }
    else if([[[self.myPosts objectAtIndex:indexPath.row] lenders] count] == 0)
    {
        
        return 45;
        
    }
    else
    {
        
        return 0;
        
    }
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[self.myPosts objectAtIndex:indexPath.row ] myPostPFObject] deleteInBackground];
        [self.myPosts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"GoToMyPostLenders"])
    {
        
        MyPostObject* passMyPostObject = [self.myPosts objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        MyPostLenders* tableView = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        
        // MyPostLenders* tableView = (MyPostLenders*)[self.navigationController.viewControllers objectAtIndex:0];
        tableView.receivedMyPostObject = passMyPostObject;
        
        
    }
    
}
*/
@end
