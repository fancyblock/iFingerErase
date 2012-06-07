//
//  FBPopupLeaderboard.m
//  iDragPaper
//
//  Created by He jia bin on 5/28/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import "FBPopupLeaderboard.h"
#import "FBLeadboardCellView.h"
#import "GameSettingsDataSource.h"


@interface FBPopupLeaderboard (private)

- (NSString*)scoreToString:(long)score;
- (void)_onLoadComplete;

@end

@implementation FBPopupLeaderboard


@synthesize _leaderboardView;
@synthesize _loadingAni;
@synthesize _btnAll;
@synthesize _btnWeek;
@synthesize _labelMode;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onIconLoadComplete) name:FB_IMAGE_LOAD_FINISHED object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_IMAGE_LOAD_FINISHED object:nil];
    
    [m_fbLeaderboard release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * @desc    close
 * @para    sender
 * @return  none
 */
- (IBAction)Close:(id)sender
{
    [self.view removeFromSuperview];
    
    if( m_callback != nil && m_callbackSender != nil )
    {
        [m_callbackSender performSelector:m_callback];
    }
}


/**
 * @desc    show week leaderboard
 * @para    sender
 * @return  none
 */
- (IBAction)Week:(id)sender
{
    [self._loadingAni startAnimating];
    
    [self._btnWeek setEnabled:NO];
    [self._btnAll setEnabled:YES];
    m_curBoardType = WEEK_LEADERBOARD;
    
    [m_fbLeaderboard LoadWeekLeaderboard:self withCallback:@selector(_onLoadComplete)];
}


/**
 * @desc    show all leaderboard
 * @para    sender
 * @return  none
 */
- (IBAction)All:(id)sender
{
    [self._loadingAni startAnimating];
    
    [self._btnWeek setEnabled:YES];
    [self._btnAll setEnabled:NO];
    m_curBoardType = ALL_LEADERBOARD;
    
    [m_fbLeaderboard LoadAllLeaderbaord:self withCallback:@selector(_onLoadComplete)];
}


/**
 * @desc    start load leaderboard
 * @para    none
 * @return  none
 */
- (void)StartLoad
{
    [self._loadingAni startAnimating];
    
    if( m_fbLeaderboard == nil )
    {
        m_fbLeaderboard = [[FBLeaderboard alloc] init];
    }
    
    if( [GameSettingsDataSource sharedDataSource].gameMode == NORMAL )
    {
        self._labelMode.text = @"Normal Mode";
    }
    
    if( [GameSettingsDataSource sharedDataSource].gameMode == CLASSIC )
    {
        self._labelMode.text = @"Classic Mode";
    }
    
    [self Week:nil];
}


/**
 * @desc    set close callback
 * @para    sender
 * @para    callback
 * @return  none
 */
- (void)SetCloseCallback:(id)sender withSelector:(SEL)callback
{
    m_callbackSender = sender;
    m_callback = callback;
}


//------------------------------- private function ----------------------------------


// convert score from long to NSStirng
- (NSString*)scoreToString:(long)score
{
    // make time string
	long minutes = score / (100 * 60);
	long seconds = score / 100 - minutes * 60;
	long centiseconds = score - seconds * 100 - minutes * (100 * 60);
	
	NSString* scoreText = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", minutes, seconds, centiseconds];
    
    return scoreText;
}


//------------------------------- callback function ---------------------------------


// callback when load leaderboard complete
- (void)_onLoadComplete
{
    [self._loadingAni stopAnimating];
    
    [self._leaderboardView reloadData];
}

// callback when profile icon load complete
- (void)_onIconLoadComplete
{
    [self._leaderboardView reloadData];
}


//------------------------------- delegate function ---------------------------------


// return the row count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( m_fbLeaderboard._leaderbaord != nil )
    {
        return [m_fbLeaderboard._leaderbaord count];
    }
    
    return 0;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBLeadboardCellView* cell = nil;
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"FBLeadboardCellView" owner:self options:nil];
    cell = (FBLeadboardCellView*)[nibs objectAtIndex:0];
    
    NSInteger row = [indexPath row];
    
    LeaderboardItem* item = [m_fbLeaderboard._leaderbaord objectAtIndex:row];
    
    cell._index.text = [NSString stringWithFormat:@"%d", row + 1];
    cell._name.text = item._name;
    cell._score.text = [self scoreToString:item._mark];
    
    if( item._fbUser._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:item._fbUser];
    }
    else 
    {
        [cell._prifileIcon setImage:item._fbUser._pic];
    }
    
    // set crown
    if( row == 0 )
    {
        [cell._crown setHidden:NO];
    }
    else {
        [cell._crown setHidden:YES];
    }
    
    [cell._yellowBackground setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}


@end
