//
//  ChallengeInfo.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeInfo.h"
#import "ChallengeCenter.h"
#import "FacebookManager.h"
#import "ChallengingInfoView.h"
#import "Utility.h"


@interface ChallengeInfo (private)

- (void)_onChallengeInfoComplete;
- (void)_onChallengeClosed;
- (void)_onShowDetail:(NSNotification*)notification;

@end

@implementation ChallengeInfo

@synthesize _tableView;
@synthesize _loadingView;
@synthesize _beChallengedHeader;
@synthesize _selfChallengeHeader;


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
    
    m_selfChallenges = [[NSMutableArray alloc] init];
    m_beChallenged = [[NSMutableArray alloc] init];
    
    m_challengeDetail = [[ChallengeDetailInfo alloc] initWithNibName:@"ChallengeDetailInfo" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [m_selfChallenges removeAllObjects];
    [m_beChallenged removeAllObjects];
    
    [m_selfChallenges release];
    [m_beChallenged release];
    
    [m_challengeDetail release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog( @"ChallengeInfo show" );
    
    [self._loadingView startAnimating];
    
    // load challenge info form parse
    NSString* uid = [FacebookManager sharedInstance]._userInfo._uid;
    [[ChallengeCenter sharedInstance] FetchAllChallenges:uid withCallbackSender:self withCallback:@selector(_onChallengeInfoComplete)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onChallengeClosed) name:CHALLENGE_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onShowDetail:) name:@"PopupDetail" object:nil];
}


// call when the view has been transitioned out of the screen
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHALLENGE_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopupDetail" object:nil];
}


/**
 * @desc    back to prior view
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 * @desc    show history
 * @para    sender
 * @return  none
 */
- (IBAction)onHistory:(id)sender
{
    [self.navigationController PushHistoryView];
}


//--------------------------------------- delegate function -------------------------------------------


// return the number of the sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowNumber = 0;
    
    if( section == CHALLENGE_MYSELF )
    {
        rowNumber = [m_selfChallenges count];
    }
    else if( section == CHALLENGE_FROM_FRIEND )
    {
        rowNumber = [m_beChallenged count];
    }
    else 
    {
        return 0;
    }
    
    rowNumber = rowNumber == 0 ? 1 : rowNumber;
    
    return rowNumber;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int index = [indexPath row];
    
    challengeInfo* info = nil;
    FBUserInfo* userInfo = nil;
    
    UITableViewCell* cellView = nil;
    ChallengingInfoView* challengeCellView = nil;
    
    if( section == CHALLENGE_MYSELF )
    {
        if( [m_selfChallenges count] > 0 )
        {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ChallengingInfoView" owner:self options:nil];
            challengeCellView = [nibs objectAtIndex:0];
            
            info = [m_selfChallenges objectAtIndex:index];
            challengeCellView._challengeInfo = info;
            
            userInfo = [[FacebookManager sharedInstance] GetFBUserInfo:info._enemy];
            
            challengeCellView._txtName.text = userInfo._name;
            
            [challengeCellView._acceptPart setHidden:YES];
            if( info._score_e >= 0 )
            {
                [challengeCellView._waitPart setHidden:YES];
            }
            else 
            {
                [challengeCellView._donePart setHidden:YES];
            }
            
            if( userInfo._pic == nil )
            {
                [[FacebookManager sharedInstance] LoadPicture:userInfo withBlock:^(BOOL succeeded)
                {
                    [self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            }
            else 
            {
                [challengeCellView._imgView setImage:userInfo._pic];
            }
            
            cellView = challengeCellView;
        }
        else 
        {
            cellView = [[UITableViewCell alloc] init];
            cellView.textLabel.text = @"You haven't challenge any one";
        }
    }
    
    if( section == CHALLENGE_FROM_FRIEND )
    {
        if( [m_beChallenged count] > 0 )
        {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ChallengingInfoView" owner:self options:nil];
            challengeCellView = [nibs objectAtIndex:0];
            
            info = [m_beChallenged objectAtIndex:index];
            challengeCellView._challengeInfo = info;
            
            userInfo = [[FacebookManager sharedInstance] GetFBUserInfo:info._challenger];
            
            challengeCellView._txtName.text = userInfo._name;
            
            [challengeCellView._waitPart setHidden:YES];
            [challengeCellView._donePart setHidden:YES];
            
            if( userInfo._pic == nil )
            {
                [[FacebookManager sharedInstance] LoadPicture:userInfo withBlock:^(BOOL succeeded)
                 {
                     [self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                 }];
            }
            else 
            {
                [challengeCellView._imgView setImage:userInfo._pic];
            }
            
            cellView = challengeCellView;
        }
        else 
        {
            cellView = [[UITableViewCell alloc] init];
            cellView.textLabel.text = @"No one challenge you";
        }
    }

    return cellView;
}


// return the section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = nil;
    
    if( section == CHALLENGE_MYSELF )
    {
        header = self._selfChallengeHeader;
    }
    
    if( section == CHALLENGE_FROM_FRIEND )
    {
        header = self._beChallengedHeader;
    }
    
    return header;
}


//---------------------------------------- callback function -------------------------------------------

// callback when challenge info fetch complete
- (void)_onChallengeInfoComplete
{
    [self._loadingView stopAnimating];
    
    [m_selfChallenges removeAllObjects];
    [m_beChallenged removeAllObjects];
    
    NSString* selfUid = [FacebookManager sharedInstance]._userInfo._uid;
    
    NSArray* challengeList = [ChallengeCenter sharedInstance]._challengeList;
    
    int count = [challengeList count];
    for( int i = 0; i < count; i++ )
    {
        challengeInfo* info = [challengeList objectAtIndex:i];
        
        if( info._isDone == NO )
        {
            if( [info._challenger isEqualToString:selfUid] == YES )
            {
                [m_selfChallenges addObject:info];
            }
            else 
            {
                [m_beChallenged addObject:info];
            }
        }
    }
    
    [self._tableView reloadData];
}


// callback when challenge closed
- (void)_onChallengeClosed
{
    [self _onChallengeInfoComplete];
    
    [self._tableView reloadData];
}


// show the challenge detail
- (void)_onShowDetail:(NSNotification*)notification
{
    challengeInfo* info = [notification object];
    
    m_challengeDetail._info = info;
    PopupView( self.view, m_challengeDetail, m_challengeDetail._INIT );
}


@end
