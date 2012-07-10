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


@end

@implementation ChallengeHistory

@synthesize _winTimes;
@synthesize _loseTimes;
@synthesize _cancelTimes;
@synthesize _rejectTimes;
@synthesize _allTimes;

@synthesize _imgSelf;
@synthesize _imgOpponent;
@synthesize _txtSelfName;
@synthesize _txtOpponentName;
@synthesize _friendUid;

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


/**
 * @desc    
 * @para    animated
 * @return  none
 */
- (void)viewDidAppear:(BOOL)animated
{
    FBUserInfo* selfInfo = [FacebookManager sharedInstance]._userInfo;
    FBUserInfo* opponentInfo = [[FacebookManager sharedInstance] GetFBUserInfo:self._friendUid];
    
    self._txtSelfName.text = selfInfo._name;
    self._txtOpponentName.text = opponentInfo._name;
    
    SetImageView( self._imgSelf, selfInfo );
    SetImageView( self._imgOpponent, opponentInfo );
    
    historyInfo* hInfo = [[ChallengeCenter sharedInstance] GetHistoryInfo:opponentInfo._uid];
    
    self._winTimes.text = [NSString stringWithFormat:@"%d", hInfo._winTimes];
    self._loseTimes.text = [NSString stringWithFormat:@"%d", hInfo._loseTimes];
    self._cancelTimes.text = [NSString stringWithFormat:@"%d", hInfo._cancelTimes];
    self._rejectTimes.text = [NSString stringWithFormat:@"%d", hInfo._rejectTimes];
    self._allTimes.text = [NSString stringWithFormat:@"%d", ( hInfo._winTimes + hInfo._loseTimes + hInfo._cancelTimes + hInfo._rejectTimes ) ];
    
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
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    //TODO 
    
    return nil;
}


//----------------------------------- private function -------------------------------------------



@end
