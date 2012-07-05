//
//  ChallengeWin.m
//  iFingerErase
//
//  Created by He jia bin on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeWin.h"
#import "GlobalWork.h"
#import "Utility.h"
#import "ChallengeCenter.h"
#import "FacebookManager.h"


@interface ChallengeWin ()

@end

@implementation ChallengeWin

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
    
    self._txtScore.text = TimeToString( info._score_e );
    
    [[ChallengeCenter sharedInstance] ResponseChallenge:[GlobalWork sharedInstance]._challengeInfo._challengeId with:[GlobalWork sharedInstance]._challengeInfo._score_e];
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


/**
 * @desc    post info to the wall
 * @para    sender
 * @return  none
 */
- (IBAction)onFacebook:(id)sender
{
    NSString* enemyName = [[FacebookManager sharedInstance] GetFBUserInfo:[GlobalWork sharedInstance]._challengeInfo._challenger]._name;
    float score = [GlobalWork sharedInstance]._challengeInfo._score_e;
    
    [[FacebookManager sharedInstance] PublishToWall:@"I Win"
                                           withDesc:[NSString stringWithFormat:@"I beat %@ with %.2f !", enemyName, score]
                                           withName:@"iFingerErase"
                                        withPicture:@"http://www.coconutislandstudio.com/asset/iDragPaper/iDragPaper_Normal.png"
                                           withLink:@"http://fancyblock.sinaapp.com"];
}


/**
 * @desc    post info to the wall
 * @para    sender
 * @return  none
 */
- (IBAction)onTwitter:(id)sender
{
    //TODO 
}


@end
