//
//  ChallengeEndStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeEndStage.h"
#import "ChallengeCenter.h"
#import "Utility.h"

@interface ChallengeEndStage (private)

- (void)challengeFriend;

@end

@implementation ChallengeEndStage


@synthesize _txtScore;
@synthesize _challengeFriendList;
@synthesize _loadingMask;


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
    
    [self Initial];
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


- (IBAction)onChallenge:(id)sender
{
    [self._loadingMask setHidden:NO];
    
    [self challengeFriend];
}

- (IBAction)onDiscard:(id)sender
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


/**
 * @desc    initial the ui according to the info
 * @para    none
 * @return  none
 */
- (void)Initial
{
    NSString* txtTime = TimeToString( [GlobalWork sharedInstance]._elapseTime );
    
    self._txtScore.text = [NSString stringWithFormat:@"You spend %@", txtTime];
    
    [self._loadingMask setHidden:YES];
}


//------------------------------------- private function ----------------------------------------


// challenge friend
- (void)challengeFriend
{
    NSMutableArray* friendList = [GlobalWork sharedInstance]._challengedUsers;
    
    if( [friendList count] > 0 )
    {
        FBUserInfo* friend = [friendList objectAtIndex:0];
        
        [[ChallengeCenter sharedInstance] CreateChallenge:[FacebookManager sharedInstance]._userInfo._uid 
                                                 toFriend:friend._uid
                                                     with:[GlobalWork sharedInstance]._elapseTime
                                       withCallbackSender:self 
                                             withCallback:@selector(challengeFriend)];
        
        [friendList removeObject:friend];
    }
    else
    {
        [self._loadingMask setHidden:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
    }
}


// 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[GlobalWork sharedInstance]._challengedUsers count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    int index = [indexPath row];
    
    FBUserInfo* user = [[GlobalWork sharedInstance]._challengedUsers objectAtIndex:index];
    
    cell.textLabel.text = user._name;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    if( user._pic != nil )
    {
        [cell.imageView setImage:user._pic];
    }
    else 
    {
        [[FacebookManager sharedInstance] LoadPicture:user withBlock:^(BOOL succeeded)
        {
            [self._challengeFriendList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }

    return cell;
}


@end
