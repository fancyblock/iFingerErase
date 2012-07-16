//
//  ChallengeHistory.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeHistory.h"
#import "ChallengeCenter.h"
#import "Utility.h"
#import "FacebookManager.h"


@interface ChallengeHistory (private)

- (void)dismissUnreadInfo;

@end

@implementation ChallengeHistory

@synthesize _winTimes;
@synthesize _loseTimes;
@synthesize _drawTimes;
@synthesize _opponentName;

@synthesize _imgSelf;
@synthesize _imgOpponent;
@synthesize _friendUid;

@synthesize _tableView;
@synthesize _unreadView;
@synthesize _btnUnread;


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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_isUnreadShow = NO;
    [self._unreadView setFrame:CGRectMake( 71, -372, 249, 403 )];
    
    m_unreadList = [[NSMutableArray alloc] initWithArray:[[ChallengeCenter sharedInstance] GetUnreadList:self._friendUid]];
    [self._tableView reloadData];
    
    // set the badge
    int unreadCnt = [m_unreadList count];
    if( unreadCnt > 0 )
    {
        NSString* badgeNum = [[NSString alloc] initWithFormat:@"%d", unreadCnt];
        m_unreadBadge = [CustomBadge customBadgeWithString:badgeNum];
        [self.view addSubview:m_unreadBadge];
        [m_unreadBadge setCenter:CGPointMake( 215, 26 )];
        
        [self._btnUnread setEnabled:YES];
    }
    else 
    {
        m_unreadBadge = nil;
        [self._btnUnread setEnabled:NO];
    }
}


/**
 * @desc    
 * @para    animated
 * @return  none
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    FBUserInfo* selfInfo = [FacebookManager sharedInstance]._userInfo;
    FBUserInfo* opponentInfo = [[FacebookManager sharedInstance] GetFBUserInfo:self._friendUid];
    
    SetImageView( self._imgSelf, selfInfo );
    SetImageView( self._imgOpponent, opponentInfo );
    
    historyInfo* hInfo = [[ChallengeCenter sharedInstance] GetHistoryInfo:opponentInfo._uid];
    
    self._opponentName.text = opponentInfo._name;
    
    self._winTimes.text = [NSString stringWithFormat:@"%d", hInfo._winTimes];
    self._loseTimes.text = [NSString stringWithFormat:@"%d", hInfo._loseTimes];
    //self._drawTimes.text = ;
    
}
 

/**
 * @desc    disappear
 * @para    animated
 * @return  none
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if( m_unreadBadge != nil )
    {
        [m_unreadBadge removeFromSuperview];
        m_unreadBadge = nil;
    }
    
    [m_unreadList removeAllObjects];
    [m_unreadList release];
}


/**
 * @desc    back to the prior
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_UPDATED object:nil];
}


/**
 * @desc    show or hide the unread view
 * @para    sender
 * @return  none
 */
- (IBAction)onUnreadShow:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.45f];
    
    if( m_isUnreadShow == YES )
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self._unreadView setFrame:CGRectMake( 71, -372, 249, 403 )];
        m_isUnreadShow = NO;
    }
    else if( m_isUnreadShow == NO )
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self._unreadView setFrame:CGRectMake( 71, 0, 249, 403 )];
        m_isUnreadShow = YES;
        
        [self dismissUnreadInfo];
    }
    
    [UIView commitAnimations];
}


//---------------------------------- delegate functions --------------------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_unreadList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    challengeInfo* cInfo = [m_unreadList objectAtIndex:index];
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    //[cell setFrame:CGRectMake( 0, 0, 207, 20 )];
    [cell.textLabel setFont:[UIFont fontWithName:@"System" size:3]];
    
    NSString* opponentName = [[FacebookManager sharedInstance] GetFBUserInfo:self._friendUid]._name;
    
    if( cInfo._canceled )
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ cancel the challenge", opponentName];
    }
    
    if( cInfo._isRejected )
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ reject your challenge", opponentName];
    }
    
    if( cInfo._selfScore > 0 && cInfo._opponentScore > 0 )
    {
        if( cInfo._selfScore < cInfo._opponentScore )
        {
            cell.textLabel.text = @"You win";
        }
        
        if( cInfo._selfScore > cInfo._opponentScore )
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ win", opponentName];
        }
    }
    
    return cell;
}


//----------------------------------- private function -------------------------------------------


// dismiss all the unread info
- (void)dismissUnreadInfo
{
    if( m_unreadBadge != nil )
    {
        [m_unreadBadge removeFromSuperview];
        m_unreadBadge = nil;
    }
    
    [[ChallengeCenter sharedInstance] DismissUnreadInfo:self._friendUid];
}


@end
