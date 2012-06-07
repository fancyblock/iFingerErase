//
//  FBPopupLeaderboard.m
//  iDragPaper
//
//  Created by He jia bin on 5/28/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import "FBPopupFriendList.h"


@interface FBPopupFriendList (private)

- (NSString*)scoreToString:(long)score;
- (void)_onProfileComplete;
- (void)_onLoadComplete;

@end

@implementation FBPopupFriendList


@synthesize _leaderboardView;
@synthesize _loadingAni;


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
 * @desc    start load leaderboard
 * @para    none
 * @return  none
 */
- (void)StartLoad
{
    [self._loadingAni startAnimating];
    
    if( [FacebookManager sharedInstance].IsAuthenticated == NO )
    {
        return;
    }
    
    [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
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


//TODO 


//------------------------------- callback function ---------------------------------

// load profile complete
- (void)_onProfileComplete
{
    [[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onLoadComplete)];
}

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
    if( [FacebookManager sharedInstance]._friendList != nil )
    {
        return [[FacebookManager sharedInstance]._friendList count];
    }
    
    return 0;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    NSInteger row = [indexPath row];
    
    NSArray* friendlist = [FacebookManager sharedInstance]._friendList;
    FBUserInfo* userInfo = [friendlist objectAtIndex:row];
    
    cell.textLabel.text = userInfo._name;
    
    if( userInfo._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:userInfo];
    }
    else 
    {
        [cell.imageView setImage:userInfo._pic];
    }
    
    return cell;
}


@end
