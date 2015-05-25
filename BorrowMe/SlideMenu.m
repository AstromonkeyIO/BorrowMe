//
//  SlideMenu.m
//  BorrowMe
//
//  Created by Tom Lee on 5/24/15.
//  Copyright (c) 2015 Tom Lee. All rights reserved.
//

#import "SlideMenu.h"
#import "MenuItemObject.h"
#import "MenuItemCell.h"
#import "MenuItemUserProfileCell.h"

@interface SlideMenu ()

@property (strong, nonatomic) PFUser* currentUser;
@property (strong, nonatomic) NSMutableArray* menuItems;

@end

@implementation SlideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.currentUser = [PFUser currentUser];
    
    self.menuItems = [[NSMutableArray alloc] init];
    
    
    MenuItemObject* newMenuItemObject = [[MenuItemObject alloc] init];
    newMenuItemObject.type = @"UserProfile";
    newMenuItemObject.currentUser = self.currentUser;
    
    PFFile* profilePictureFile = [self.currentUser valueForKey:@"profilePicture"];
    NSData* profilePictureData = [profilePictureFile getData];
    newMenuItemObject.userProfileImage = [UIImage imageWithData: profilePictureData];
    
    newMenuItemObject.username = self.currentUser.username;
    
    [self.menuItems addObject:newMenuItemObject];
    
    MenuItemObject* menuItemObjectSettings = [[MenuItemObject alloc] init];
    menuItemObjectSettings.type = @"Settings";
    
    [self.menuItems addObject:menuItemObjectSettings];
    
    MenuItemObject* menuItemObjectLogout = [[MenuItemObject alloc] init];
    menuItemObjectLogout.type = @"Logout";
    
    [self.menuItems addObject:menuItemObjectLogout];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    
    if(indexPath.row == 0)
    {
        MenuItemCell* menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCellUserProfile" forIndexPath:indexPath];
        
        menuItemCell.userProfileImage.image = [[self.menuItems objectAtIndex:indexPath.row] valueForKey:@"userProfileImage"];
        menuItemCell.usernameLabel.text = [[self.menuItems objectAtIndex:indexPath.row] valueForKey:@"username"];
        return menuItemCell;
        
    }
    else if(indexPath.row == 1)
    {

        MenuItemCell* menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCellSettings" forIndexPath:indexPath];

        return menuItemCell;
    
    }
    else if(indexPath.row == 2)
    {
        
        MenuItemCell* menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCellLogout" forIndexPath:indexPath];
        
        return menuItemCell;
        
    }
    
    return NULL;
    
    //menuItemUserProfileCell.userProfileImage.image
    

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MenuItemCell *)menuItemCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        
        /*
        CALayer * userProfileImageLayer = [menuItemUserProfileCell.userProfileImage layer];
        [userProfileImageLayer setMasksToBounds:YES];
        [postBubbl setCornerRadius:5.0];
        */
        
        CGPoint saveCenter = menuItemCell.userProfileImage.center;
        CGRect newFrame = CGRectMake(menuItemCell.userProfileImage.frame.origin.x, menuItemCell.userProfileImage.frame.origin.y, 55, 55);
        menuItemCell.userProfileImage.frame = newFrame;
        menuItemCell.userProfileImage.layer.cornerRadius = 55 / 2.0;
        menuItemCell.userProfileImage.center = saveCenter;
        menuItemCell.userProfileImage.clipsToBounds = YES;
        /*
        CALayer* helpButtonLayer = [post.helpButton layer];
        [helpButtonLayer setMasksToBounds:YES];
        [helpButtonLayer setCornerRadius:5.0];
        */
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
    
        return 92;
        
    }
    else
    {
        
        return 77;
    
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
