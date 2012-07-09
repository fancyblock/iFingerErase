//
//  InviteFriends.m
//  iFingerErase
//
//  Created by He jia bin on 7/9/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "InviteFriends.h"
#import "FacebookManager.h"


@interface InviteFriends ()

@end

@implementation InviteFriends

@synthesize _tableView;
@synthesize _friendList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self._tableView reloadData];
}


/**
 * @desc    back to the prior controllerView
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


//--------------------------------- delegate functions -------------------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._friendList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    FBUserInfo* user = [self._friendList objectAtIndex:index];
    
    cell.textLabel.text = user._name;
    
    if( user._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:user withBlock:^(BOOL succeeded)
        {
            [self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }];
    }
    else 
    {
        [cell.imageView setImage:user._pic];
    }
    
    return cell;
}

// did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    FBUserInfo* user = [self._friendList objectAtIndex:index];
    
    [[FacebookManager sharedInstance] PublishToFriendWall:@"Check this game out !"
                                                 withDesc:[NSString stringWithFormat:@"%@ invite you to play this game.", [FacebookManager sharedInstance]._userInfo._name]
                                                 withName:[FacebookManager sharedInstance]._userInfo._name
                                              withPicture:@"http://www.coconutislandstudio.com/asset/iDragPaper/iDragPaper_FREE_Normal.png" 
                                                 withLink:@"http://fancyblock.sinaapp.com" 
                                                 toFriend:user._uid
                                       withCallbackSender:nil 
                                             withCallback:nil];
    
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
