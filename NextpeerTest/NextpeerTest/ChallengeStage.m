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


@interface ChallengeStage (private)

- (void)_onProfileComplete;
- (void)_onChallengeInfoComplete;
- (void)_onFriendsComplete;
- (void)_onReloadData;

@end

@implementation ChallengeStage

@synthesize _tableView;
@synthesize _loadingIcon;


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
    
    m_fbFriendList = [[FBPopupFriendList alloc] initWithNibName:@"FBPopupFriendList" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onReloadData) name:FB_IMAGE_LOAD_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onReloadData) name:CHALLENGE_CLOSED object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_IMAGE_LOAD_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHALLENGE_CLOSED object:nil];
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
    [self._loadingIcon startAnimating];
    
    // get all the challenge info
    [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
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
 * @desc    create a challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onCreateChallenge:(id)sender
{
    [self.view addSubview:m_fbFriendList.view];
    [m_fbFriendList StartLoad];
    
    m_fbFriendList.view.transform = CGAffineTransformMake(0.001f, 0, 0, 0.001f, 0, 0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.25f animations:^{m_fbFriendList.view.transform = CGAffineTransformMake(1.1f, 0, 0, 1.1f, 0, 0);} completion:^(BOOL finished)
     {
         [UIView beginAnimations:nil context:nil];
         [UIView animateWithDuration:0.15f animations:^{ m_fbFriendList.view.transform = CGAffineTransformMake(0.9f, 0, 0, 0.9f, 0, 0); } completion:^(BOOL finished)
          {
              [UIView beginAnimations:nil context:nil];
              m_fbFriendList.view.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
              [UIView setAnimationDuration:0.15f];
              [UIView commitAnimations];
          }];
         [UIView commitAnimations];
     }];
    [UIView commitAnimations];
}


//------------------------------------ delegate functions ---------------------------------------

// return the 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( [ChallengeCenter sharedInstance]._challengeList == nil )
    {
        return 0;
    }
    
    return [[ChallengeCenter sharedInstance]._challengeList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ChallengeCellView" owner:self options:nil];
    ChallengeCellView* cellView = [nibs objectAtIndex:0];
    
    NSArray* challengeList = [ChallengeCenter sharedInstance]._challengeList;
    challengeInfo* info = [challengeList objectAtIndex:index];
    
    cellView._challengeInfo = info;
    
    // display the icon
    FBUserInfo* challenger = [[FacebookManager sharedInstance] GetFBUserInfo:info._challenger];
    FBUserInfo* enemy = [[FacebookManager sharedInstance] GetFBUserInfo:info._enemy];
    
    if( challenger._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:challenger];
    }
    else 
    {
        [cellView._imgChallenger setImage:challenger._pic];
    }
    
    if( enemy._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:enemy];
    }
    else 
    {
        [cellView._imgEnemy setImage:enemy._pic];
    }
    
    if( info._isDone )
    {
        [cellView._btnAction setHidden:YES];
        [cellView._btnCloseCase setHidden:YES];
        
        // judge the result
        if( [info._challenger isEqualToString:[FacebookManager sharedInstance]._userInfo._uid] )
        {
            if( info._score_c < info._score_e )
            {
                cellView._txtStatus.text = @"You Win";
            }
            else 
            {
                cellView._txtStatus.text = @"You Lose";
            }
        }
        else
        {
            if( info._score_c < info._score_e )
            {
                cellView._txtStatus.text = @"You Lose";
            }
            else 
            {
                cellView._txtStatus.text = @"You Win";
            }
        }
    }
    else 
    {
        [cellView._txtStatus setHidden:YES];
        
        // your challenge
        if( [info._challenger isEqualToString:[FacebookManager sharedInstance]._userInfo._uid] )
        {
            [cellView._btnAction setHidden:YES];
        }
        // challenge form your friend
        else 
        {
            [cellView._btnCloseCase setHidden:YES];
        }
    }
    
    return cellView;
}


//------------------------------------ callback function -----------------------------------------


// callback when the icon load complete
- (void)_onReloadData
{
    [self._loadingIcon stopAnimating];
    [self._tableView reloadData];
}


// callback when callback complete
- (void)_onProfileComplete
{
    [[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onFriendsComplete)];
}


// callback when friend complete
- (void)_onFriendsComplete
{
    [[ChallengeCenter sharedInstance] FetchAllChallenges:[FacebookManager sharedInstance]._userInfo._uid withCallbackSender:self withCallback:@selector(_onChallengeInfoComplete)];
}


// callback when challenge info complete
- (void)_onChallengeInfoComplete
{
    //TODO 
    
    [self._loadingIcon stopAnimating];
    [self._tableView reloadData];
}


@end
