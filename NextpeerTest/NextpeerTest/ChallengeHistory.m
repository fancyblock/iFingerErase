//
//  ChallengeHistory.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeHistory.h"
#import "ChallengeCenter.h"
#import "Utility.h"


@interface ChallengeHistory (private)

- (void)_onShowDetail:(NSNotification*)notification;

@end

@implementation ChallengeHistory

@synthesize _tableView;


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
    
    m_historyList = [[NSMutableArray alloc] init];
    
    m_detailViewController = [[HistoryDetailView alloc] initWithNibName:@"HistoryDetailView" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onShowDetail:) name:@"PopupHistoryDetail" object:nil];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [m_historyList removeAllObjects];
    [m_historyList release];
    
    [m_detailViewController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopupHistoryDetail" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * @desc    
 * @para    animated
 * @return  none
 */
- (void)viewDidAppear:(BOOL)animated
{
    [m_historyList removeAllObjects];
    
    NSArray* challengeList = [ChallengeCenter sharedInstance]._challengeList;
    NSString* selfUid = [FacebookManager sharedInstance]._userInfo._uid;
    NSString* againstUid = nil;
    
    int count = [challengeList count];
    for( int i = 0; i < count; i++ )
    {
        challengeInfo* cInfo = [challengeList objectAtIndex:i];
        BOOL isWin;
        
        if( [cInfo._challenger isEqualToString:selfUid] )
        {
            if( cInfo._score_c < cInfo._score_e )
            {
                isWin = YES;
            }
            else 
            {
                isWin = NO;
            }
            
            againstUid = cInfo._enemy;
        }
        else 
        {
            if( cInfo._score_c < cInfo._score_e )
            {
                isWin = NO;
            }
            else 
            {
                isWin = YES;
            }
            
            againstUid = cInfo._challenger;
        }
        
        historyInfo* hInfo = nil;
        for( int j = 0; j < [m_historyList count]; j++ )
        {
            historyInfo* tInfo = [m_historyList objectAtIndex:j];
            
            if( [tInfo._enemy._uid isEqualToString:againstUid] )
            {
                hInfo = tInfo;
                
                break;
            }
        }
        
        if( hInfo == nil )
        {
            hInfo = [[historyInfo alloc] init];
            [m_historyList addObject:hInfo];
            
            hInfo._challenger = [[FacebookManager sharedInstance] GetFBUserInfo:selfUid];
            hInfo._enemy = [[FacebookManager sharedInstance] GetFBUserInfo:againstUid];
            hInfo._loseTimes = 0;
            hInfo._winTimes = 0;
        }
        
        if( cInfo._isDone )
        {
            if( isWin )
            {
                hInfo._winTimes++;
            }
            else 
            {
                hInfo._loseTimes++;
            }
        }
        else 
        {
            hInfo._pendingTimes++;
        }
    }
    
    [self._tableView reloadData];
}


/**
 * @desc    back to the prior
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//---------------------------------- delegate functions --------------------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_historyList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    HistoryDetailInfo* cellView = nil;
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"HistoryDetailInfo" owner:self options:nil];
    cellView = [nibs objectAtIndex:0];
    
    historyInfo* hInfo = [m_historyList objectAtIndex:index];
    cellView._info = hInfo;
    
    cellView._txtName.text = hInfo._enemy._name;
    cellView._txtTimes.text = [NSString stringWithFormat:@"%d", ( hInfo._loseTimes + hInfo._winTimes + hInfo._pendingTimes )];
    
    if( hInfo._enemy._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:hInfo._enemy withBlock:^(BOOL succeeded)
        {
            [self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    else 
    {
        [cellView._imgProfile setImage:hInfo._enemy._pic];
    }
    
    return cellView;
}


//----------------------------------- private function -------------------------------------------

// popup the history detail
- (void)_onShowDetail:(NSNotification*)notification
{
    historyInfo* info = [notification object];
    
    m_detailViewController._info = info;
    
    PopupView( self.view, m_detailViewController, m_detailViewController._INIT );
}

@end
