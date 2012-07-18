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
#import "HistoryInfoCellView.h"


const int BADGE_POS_X     = 215;
const int BADGE_POS_Y     = 26; 

const int CELL_HEIGHT     = 64;

const int MESSAGE_VIEW_WIDTH      = 249;
const int MESSAGE_VIEW_HEIGHT     = 403;

const int MESSAGE_VIEW_X          = 71;
const int MESSAGE_VIEW_BTN_HEIGHT = 38;

const int MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT = 372;


@interface ChallengeHistory (private)

- (void)dismissUnreadInfo;

@end

@implementation ChallengeHistory

@synthesize _winTimes;
@synthesize _loseTimes;
@synthesize _drawTimes;
@synthesize _opponentName;
@synthesize _selfName;

@synthesize _imgSelf;
@synthesize _imgOpponent;
@synthesize _friendUid;

@synthesize _tableView;
@synthesize _unreadView;
@synthesize _btnUnread;
@synthesize _btnRollUp;


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
    
    m_unreadList = [[NSMutableArray alloc] initWithArray:[[ChallengeCenter sharedInstance] GetUnreadList:self._friendUid]];
    [self._tableView reloadData];
    
    // set the badge
    int unreadCnt = [m_unreadList count];
    if( unreadCnt > 0 )
    {
        NSString* badgeNum = [[NSString alloc] initWithFormat:@"%d", unreadCnt];
        m_unreadBadge = [CustomBadge customBadgeWithString:badgeNum];
        [self.view addSubview:m_unreadBadge];
        [m_unreadBadge setCenter:CGPointMake( BADGE_POS_X, BADGE_POS_Y )];
        
        [self._btnUnread setHidden:NO];
        [self._btnRollUp setHidden:YES];
        [self._unreadView setHidden:NO];
        
    }
    else 
    {
        m_unreadBadge = nil;
        [self._unreadView setHidden:YES];
    }
    
    // set the table view height
    int tableViewHeight = unreadCnt * CELL_HEIGHT;
    if( tableViewHeight <= 0 || tableViewHeight > MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT )
    {
        tableViewHeight = MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT;
    }
    
    [self._tableView setFrame:CGRectMake( 0, MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT - tableViewHeight, MESSAGE_VIEW_WIDTH, tableViewHeight )];
    [self._unreadView setFrame:CGRectMake( MESSAGE_VIEW_X, -MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT, MESSAGE_VIEW_WIDTH, MESSAGE_VIEW_HEIGHT )];
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
    self._selfName.text = selfInfo._name;
    
    self._winTimes.text = [NSString stringWithFormat:@"%d", hInfo._winTimes];
    self._loseTimes.text = [NSString stringWithFormat:@"%d", hInfo._loseTimes];
    //self._drawTimes.text = ;
    //TODO 
    
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
    if( m_isUnreadShow == YES )
    {
        [self._btnUnread setHidden:NO];
        [self._btnRollUp setHidden:YES];
    }
    
    if( m_isUnreadShow == NO )
    {
        [self._btnUnread setHidden:YES];
        [self._btnRollUp setHidden:NO];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.45f];
    
    // set the table view height
    int unreadCnt = [m_unreadList count];
    int tableViewHeight = unreadCnt * CELL_HEIGHT;
    if( tableViewHeight <= 0 || tableViewHeight > MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT )
    {
        tableViewHeight = MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT;
    }
    
    if( m_isUnreadShow == YES )
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self._unreadView setFrame:CGRectMake( MESSAGE_VIEW_X, -MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT, MESSAGE_VIEW_WIDTH, MESSAGE_VIEW_HEIGHT )];
        m_isUnreadShow = NO;
    }
    else if( m_isUnreadShow == NO )
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self._unreadView setFrame:CGRectMake( MESSAGE_VIEW_X, -( MESSAGE_VIEW_MAX_TABLEVIEW_HEIGHT - tableViewHeight ), MESSAGE_VIEW_WIDTH, MESSAGE_VIEW_HEIGHT )];
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
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"HistoryInfoCellView" owner:self options:nil];
    HistoryInfoCellView* cell = [nibs objectAtIndex:0];
    
    FBUserInfo* selfInfo = [FacebookManager sharedInstance]._userInfo;
    FBUserInfo* opponentInfo = [[FacebookManager sharedInstance] GetFBUserInfo:cInfo._opponent];
    
    cell._title.text = [NSString stringWithFormat:@"%@ vs %@", selfInfo._name, opponentInfo._name];
    cell._time.text = [cInfo._createTime description];
    
    // cancel the challenge
    if( cInfo._canceled )
    {
        cell._result.text = [NSString stringWithFormat:@"%@ canceled the challenge", opponentInfo._name];
    }
    
    // reject the challenge
    if( cInfo._isRejected )
    {
        cell._result.text = [NSString stringWithFormat:@"%@ rejected your challenge", opponentInfo._name];
    }
    
    // accept the challenge
    if( cInfo._selfScore > 0 && cInfo._opponentScore > 0 )
    {
        // win the challenge
        if( cInfo._selfScore < cInfo._opponentScore )
        {
            cell._result.text = @"You win";
        }
        
        // lose the challenge
        if( cInfo._selfScore > cInfo._opponentScore )
        {
            cell._result.text = @"You lose";
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
