//
//  PMBMasterTableViewController.m
//  BorrowMe
//
//  Created by Tom Lee on 5/5/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "Search.h"
#import "UserProfile.h"

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
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo: searchString];

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
}

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


#pragma mark - UITableViewDataSource

// check if displaying search results

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {

    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    }
    NSLog(@"search results %@", self.searchResults);
    return [self.searchResults count];
    //return 0;
}

// check if displaying search results
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"searchedResults %@", self.searchResults);

    if ([[self searchDisplayController] isActive]) {
        UITableViewCell *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"
                                               forIndexPath:indexPath];
        //NSString* username = [self.searchResults objectAtIndex:indexPath.row];
        PFUser* user = [self.searchResults objectAtIndex:indexPath.row];
        NSString* username = user.username;
        cell.textLabel.text = username;
        NSLog(@"yo");
        return cell;
        
    } else {
        UITableViewCell *cell
        = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"
                                               forIndexPath:indexPath];
        //NSString* username = [self.searchResults objectAtIndex:indexPath.row];
        PFUser* user = [self.searchResults objectAtIndex:indexPath.row];
        NSString* username = user.username;
        cell.textLabel.text = username;
        NSLog(@"yo2");

        return cell;
        
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
        
        UserProfile* userProfile = [[(UINavigationController*)segue.destinationViewController viewControllers]lastObject];
        PFUser* selectedUser = [self.searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        userProfile.user = selectedUser;
        
        //postDetail.receivedPostObject = selectedPostObject;
        
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
