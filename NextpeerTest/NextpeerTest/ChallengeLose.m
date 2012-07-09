//
//  ChallengeLose.m
//  iFingerErase
//
//  Created by He jia bin on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeLose.h"
#import "GlobalWork.h"
#import "Utility.h"
#import "ChallengeCenter.h"


@interface ChallengeLose ()

@end

@implementation ChallengeLose

@synthesize _txtScore;

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
 * @desc    initial the ui
 * @para    none
 * @return  none
 */
- (void)Initial
{
    challengeInfo* info = [GlobalWork sharedInstance]._challengeInfo;
    
    self._txtScore.text = TimeToString( info._selfScore );
    
    [[ChallengeCenter sharedInstance] ResponseChallenge:[GlobalWork sharedInstance]._challengeInfo._challengeId with:[GlobalWork sharedInstance]._challengeInfo._selfScore];
}


/**
 * @desc    return back to the main screen
 * @para    sender
 * @return  none
 */
- (IBAction)onOk:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


@end
