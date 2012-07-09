//
//  ChallengeStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/12/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeStage.h"
#import "GlobalWork.h"
#import "ChallengeCenter.h"
#import "FacebookManager.h"
#import "ChallengeCellView.h"
#import "FacebookManager.h"


@interface ChallengeStage (private)

- (void)_onProfileComplete;
- (void)_onPlayerInfoComplete;
- (void)_onFriendsComplete;
- (void)_onReloadData;
- (void)_onAuthDone;
- (void)_onChallengeInfoComplete;
- (void)_onShowHistory:(NSNotification*)notification;

- (void)loadChallengeInfo;

@end

@implementation ChallengeStage

@synthesize _navBar;
@synthesize _tableView;
@synthesize _loadingMask;
@synthesize _loadingIcon;
@synthesize _connectFBView;


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
    
    m_friendList = [[NSMutableArray alloc] init];
    m_playerList = [[NSMutableArray alloc] init];
    m_challengeDic = [[NSMutableDictionary alloc] init];
    m_inviteFriendsView = [[InviteFriends alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onReloadData) name:CHALLENGE_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onShowHistory:) name:@"ShowHistory" object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [m_friendList release];
    [m_playerList release];
    [m_challengeDic release];
    [m_inviteFriendsView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHALLENGE_UPDATED object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * @desc    initial
 * @para    none
 * @return  none
 */
- (void)Initial
{
    if( [FacebookManager sharedInstance].IsAuthenticated )
    {
        [self loadChallengeInfo];
    }
    else 
    {
        [self._connectFBView setHidden:NO];
    }
}


/**
 * @desc    back to the main menu
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU]];
}


/**
 * @desc    auth to the facebook 
 * @para    sender
 * @return  none
 */
- (IBAction)onConnectFB:(id)sender
{
    [[FacebookManager sharedInstance] Authenticate:self withCallback:@selector(_onAuthDone)];
}


/**
 * @desc    invite friends
 * @para    sender
 * @return  none
 */
- (IBAction)onInviteFriends:(id)sender
{
    m_inviteFriendsView._friendList = m_friendList;
    
    [self presentModalViewController:m_inviteFriendsView animated:YES];
}


//------------------------------------ private functions ----------------------------------------


// load challenge info
- (void)loadChallengeInfo
{
    [self._connectFBView setHidden:YES];
    
    [self._loadingMask setHidden:NO];
    [self._loadingIcon startAnimating];
    // get all the challenge info
    [m_playerList removeAllObjects];
    [m_friendList removeAllObjects];
    [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
}


//------------------------------------ delegate functions ---------------------------------------

// return the 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cnt = [m_playerList count];
    
    return ( cnt == 0 ? 1 : cnt );
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    UITableViewCell* cellView = nil;
    ChallengeCellView* challengeCellView = nil;
    NSArray* nibs = nil;
    
    FBUserInfo* user = nil;
    
    if( [m_playerList count] == 0 )
    {
        cellView = [[UITableViewCell alloc] init];
        
        cellView.textLabel.text = @"No friend played iFingerErase";
    }
    else 
    {
        nibs = [[NSBundle mainBundle] loadNibNamed:@"ChallengeCellView" owner:self options:nil];
        challengeCellView = [nibs objectAtIndex:0];
        cellView = challengeCellView;
        
        user = [m_playerList objectAtIndex:index];
        
        UITableViewCell* viewPlay = [nibs objectAtIndex:1];
        UITableViewCell* viewReaction = [nibs objectAtIndex:2];
        UITableViewCell* viewWait = [nibs objectAtIndex:3];
        
        challengeInfo* cInfo = [m_challengeDic objectForKey:user._uid];
        
        if( cInfo == nil )
        {
            [cellView addSubview:viewPlay];
        }
        
        if( cInfo != nil )
        {
            if( cInfo._isSelfChallenge )
            {
                [cellView addSubview:viewWait];
            }
            else 
            {
                [cellView addSubview:viewReaction];
            }
        }
        
        challengeCellView._challengeInfo = cInfo;
        challengeCellView._opponentUid = user._uid;
    }
    
    if( user != nil )
    {
        challengeCellView._txtInfo.text = user._name;
        
        if( user._pic == nil )
        {
            [[FacebookManager sharedInstance] LoadPicture:user withBlock:^(BOOL succeeded)
             {
                 NSArray* path = [NSArray arrayWithObject:indexPath];
                 
                 [self._tableView reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
             }];
        }
        else 
        {
            [challengeCellView._imgChallenger setImage:user._pic];
        }
    }
    
    return cellView;
}

// two sections, players & noplayers
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//------------------------------------ callback function -----------------------------------------

// auth done
- (void)_onAuthDone
{
    [self loadChallengeInfo];
}

// callback when the icon load complete
- (void)_onReloadData
{
    [self _onChallengeInfoComplete];
}


// callback when callback complete
- (void)_onProfileComplete
{
    [[ChallengeCenter sharedInstance] SignUp:[FacebookManager sharedInstance]._userInfo._uid];
    [[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onFriendsComplete)];
}


// callback when friend complete
- (void)_onFriendsComplete
{
    [[ChallengeCenter sharedInstance] FetchAllPlayers:self withCallback:@selector(_onPlayerInfoComplete)];
}


// callback when challenge info complete
- (void)_onPlayerInfoComplete
{
    NSArray* friendlist = [FacebookManager sharedInstance]._friendList;
    int count = [friendlist count];
    NSArray* allPlayer = [ChallengeCenter sharedInstance]._playerList;
    
    for( int i = 0; i < count; i++ )
    {
        FBUserInfo* user = [friendlist objectAtIndex:i];
        
        if( [allPlayer containsObject:user._uid] )
        {
            [m_playerList addObject:user];
        }
        else 
        {
            [m_friendList addObject:user];
        }
    }
    
    [[ChallengeCenter sharedInstance] FetchAllChallenges:[FacebookManager sharedInstance]._userInfo._uid withCallbackSender:self withCallback:@selector(_onChallengeInfoComplete)];
}

// callback when challenge info complete
- (void)_onChallengeInfoComplete
{
    [m_challengeDic removeAllObjects];
    
    NSArray* challengeList = [ChallengeCenter sharedInstance]._challengeList;
    int count = [challengeList count];
    
    for( int i = 0; i < count; i++ )
    {
        challengeInfo* info = [challengeList objectAtIndex:i];
        
        if( info._canceled == NO && info._opponentScore < 0 && info._isRejected == NO )
        {
            [m_challengeDic setObject:[info retain] forKey:info._opponent];
        }
    }
    
    [self._loadingMask setHidden:YES];
    [self._loadingIcon stopAnimating];
    [self._tableView reloadData];
}


// show history
- (void)_onShowHistory:(NSNotification*)notification
{
    NSString* friendsUid = [notification object];
    
    [self.navigationController PushHistoryView:friendsUid];
}


@end
