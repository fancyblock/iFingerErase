//
//  ChallengeEndStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeEndStage.h"

@interface ChallengeEndStage (private)

- (void)challengeFriend:(FBUserInfo*)friend withTime:(float)time;

@end

@implementation ChallengeEndStage


@synthesize _txtScore;
@synthesize _imgFriendIcon;
@synthesize _txtFriendName;


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
    
    [self Initial];
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


- (IBAction)onChallenge:(id)sender
{
    [self challengeFriend:[GlobalWork sharedInstance]._challengedUser withTime:[GlobalWork sharedInstance]._elapseTime];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}

- (IBAction)onDiscard:(id)sender
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


/**
 * @desc    initial the ui according to the info
 * @para    none
 * @return  none
 */
- (void)Initial
{
    int minutes = (int)([GlobalWork sharedInstance]._elapseTime / 60.0f);
    int seconds = (int)([GlobalWork sharedInstance]._elapseTime - minutes * 60.0f);
    int milliseconds = (int)(([GlobalWork sharedInstance]._elapseTime - (float)seconds - (float)minutes * 60.0f) * 100.0f);
    NSString* txtTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", minutes, seconds, milliseconds];
    
    self._txtScore.text = [NSString stringWithFormat:@"You spend %@", txtTime];
    self._txtFriendName.text = [GlobalWork sharedInstance]._challengedUser._name;
    
    if( [GlobalWork sharedInstance]._challengedUser._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:[GlobalWork sharedInstance]._challengedUser]; 
    }
    else 
    {
        [self._imgFriendIcon setImage:[GlobalWork sharedInstance]._challengedUser._pic];
    }
}


//------------------------------------- private function ----------------------------------------


// challenge friend
- (void)challengeFriend:(FBUserInfo*)friend withTime:(float)time
{
    //TODO 
}

@end
