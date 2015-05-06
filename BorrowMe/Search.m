//
//  PMBMasterTableViewController.m
//  BorrowMe
//
//  Created by Tom Lee on 5/5/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Search.h"
#import "UserProfile.h"
#import "UserSearchResult.h"
#import "UserSearchResultObject.h"

@interface Search () <UISearchDisplayDelegate>

// the items to be searched
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) NSMutableArray* users;

//@property (nonatomic, strong) NSMutableArray*
// the current search results
@property (nonatomic, strong) NSMutableArray *searchResults;
//@property (nonatomic, copy) NSArray *searchResults;
@end

@implementation Search

#pragma mark - NSCoding

// set some initial searchable items

#pragma mark - UISearchDisplayDelegate


- (void)viewDidLoad
{
    self.users = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];

}
// register a cell reuse identifier for the search results table view

-(void)searchDisplayController:(UISearchDisplayController *)controller
 didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"SearchResultsTableViewUITableViewCell"];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"%@", searchString);
    searchString = [searchString lowercaseString];
    if(![searchString isEqualToString:@""])
    {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString: searchString];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* users, NSError *error) {
        if (users) {
            [self.searchResults removeAllObjects];
            
            for(int i = 0; i < [users count]; i++)
            {
                
                PFUser* user = [users objectAtIndex:i];
                UserSearchResultObject* newUser = [[UserSearchResultObject alloc] init];
                newUser.user = user;
                newUser.userId = user.objectId;
                newUser.username = user.username;
                PFFile* profilePictureFile = [user valueForKey:@"profilePicture"];
                NSData* profilePictureData = [profilePictureFile getData];
                newUser.userProfileImage = [UIImage imageWithData: profilePictureData];
                [self.searchResults addObject:newUser];
                
            }

            [self.tableView reloadData];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else
        {
            NSLog(@"failed");
            
        }
    }];
    }
    return YES;
    
    
    /*
    NSLog(@"%@", searchString);
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString: searchString];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            PFUser *user = (PFUser *)object;
            NSLog(@"Username: %@", user[@"username"]);
            [self.searchResults removeAllObjects];
            
            //[self.searchResults addObject:user.username];
            
            [self.searchResults addObject:user];
            [self.tableView reloadData];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else
        {
            NSLog(@"failed");
            
        }
    }];
    
    return YES;
    */
    
    
}
/*
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"%@", searchString);
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo: searchString];
    //[query includeKey:@"username"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            PFUser *user = (PFUser *)object;
            NSLog(@"Username: %@", user[@"username"]);
            [self.searchResults removeAllObjects];
            [self.searchResults addObject:user.username];
            [self.tableView reloadData];
            
        }
        else
        {
            NSLog(@"failed");
            
        }
    }];
    
    //[self.tableView reloadData];
}
*/

#pragma mark - UITableViewDataSource

// check if displaying search results

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {

    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    }
    NSLog(@"search results %@", self.searchResults);
    return [self.searchResults count];

}

// check if displaying search results
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[self searchDisplayController] isActive]) {
       UserSearchResult *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"UserSearchResult"
                                               forIndexPath:indexPath];
        
        UserSearchResultObject* userSearchResultObject = [self.searchResults objectAtIndex:indexPath.row];
        cell.username.text = userSearchResultObject.username;
        cell.userProfileImage.image = userSearchResultObject.userProfileImage;
        
        return cell;
        
    } else {
        UserSearchResult *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"UserSearchResult"
                                               forIndexPath:indexPath];
        
        UserSearchResultObject* userSearchResultObject = [self.searchResults objectAtIndex:indexPath.row];
        cell.username.text = userSearchResultObject.username;
        cell.userProfileImage.image = userSearchResultObject.userProfileImage;
        
        return cell;
        
    }
    
    
    /*
    if ([[self searchDisplayController] isActive]) {
        UITableViewCell *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"
                                               forIndexPath:indexPath];
        PFUser* user = [self.searchResults objectAtIndex:indexPath.row];
        NSString* username = user.username;
        cell.textLabel.text = username;
        NSLog(@"yo");
        return cell;
        
    } else {
        UITableViewCell *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"
                                               forIndexPath:indexPath];
        PFUser* user = [self.searchResults objectAtIndex:indexPath.row];
        NSString* username = user.username;
        cell.textLabel.text = username;
        NSLog(@"yo2");

        return cell;
        
    }
    */
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserSearchResultObject* userSearchResultObject = [self.searchResults objectAtIndex:indexPath.row];
    if(userSearchResultObject.user != NULL)
    {
        
        return 75;
        
    }
    else
    {
        
        return 75;
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UserSearchResult *)userSearchResult forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserSearchResultObject* userSearchResultObject = [self.searchResults objectAtIndex:indexPath.row];
    
    if(userSearchResultObject.user != NULL)
    {

        CGPoint saveCenter = userSearchResult.userProfileImage.center;
        CGRect newFrame = CGRectMake(userSearchResult.userProfileImage.frame.origin.x, userSearchResult.userProfileImage.frame.origin.y, 50, 50);
        userSearchResult.userProfileImage.frame = newFrame;
        userSearchResult.userProfileImage.layer.cornerRadius = 50 / 2.0;
        userSearchResult.userProfileImage.center = saveCenter;
        userSearchResult.userProfileImage.clipsToBounds = YES;
        
    }
    
    
    
}


/*
#pragma mark - UITableViewDelegate

// manually perform detail segue after selecting a search result
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self searchDisplayController] isActive]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"detailSegue" sender:cell];
    }
}

#pragma mark - UIViewController
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"View-User-Profile"])
    {
        /*
        UserProfile* userProfile = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        PFUser* selectedUser = [self.searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        userProfile.user = selectedUser;
        
        //postDetail.receivedPostObject = selectedPostObject;
        */
        UserProfile* userProfile = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        UserSearchResultObject* selectedUserObject = [self.searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        userProfile.user = selectedUserObject.user;
        
    }
    /*
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    id item = nil;
    if ([[self searchDisplayController] isActive]) {
        NSIndexPath *indexPath
        = [[[self searchDisplayController] searchResultsTableView] indexPathForCell:cell];
        item = [[self searchResults] objectAtIndex:[indexPath row]];
    } else {
        NSIndexPath *indexPath
        = [[self tableView] indexPathForCell:cell];
        item = [[self items] objectAtIndex:[indexPath row]];
    }
    
    UIViewController *detail
    = (UIViewController *)[segue destinationViewController];
    [[detail navigationItem] setTitle:item];
    */
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
@end
