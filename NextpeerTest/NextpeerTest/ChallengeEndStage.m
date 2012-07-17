//
//  ChallengeEndStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeEndStage.h"
#import "ChallengeCenter.h"
#import "Utility.h"

@interface ChallengeEndStage (private)

- (void)challengeFriend;
- (void)_onSendChallengeDone;

@end

@implementation ChallengeEndStage


@synthesize _txtScore;
@synthesize _opponentPic;
@synthesize _opponentName;
@synthesize _crown;
@synthesize _imgWin;
@synthesize _imgDraw;
@synthesize _imgLose;
@synthesize _imgChallenge;
@synthesize _opponentScore;
@synthesize _txtBannerInfo;


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


- (IBAction)onChallenge:(id)sender
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
    // set elapse time
    NSString* txtTime = TimeToString( [GlobalWork sharedInstance]._elapseTime );
    self._txtScore.text = [NSString stringWithFormat:@"%@", txtTime];
    
    // set challenger info
    FBUserInfo* user = [[FacebookManager sharedInstance] GetFBUserInfo:[GlobalWork sharedInstance]._challengedUser];
    self._opponentName.text = user._name;
    SetImageView( self._opponentPic, user );
    
    if( [GlobalWork sharedInstance]._gameMode == ACCEPT_CHALLENGE_MODE )
    {
        self._txtBannerInfo.text = @"";
        [self._imgChallenge setHidden:YES];
        
        challengeInfo* info = [GlobalWork sharedInstance]._challengeInfo;
        
        // Win
        if( info._selfScore < info._opponentScore )
        {
            [self._imgWin setHidden:NO];
            [self._imgLose setHidden:YES];
            [self._imgDraw setHidden:YES];
            
            [self._crown setHidden:YES];
        }
        // Lose
        else if( info._selfScore > info._opponentScore )
        {
            [self._imgWin setHidden:YES];
            [self._imgLose setHidden:NO];
            [self._imgDraw setHidden:YES];
            
            [self._crown setHidden:NO];
        }
        // Draw game
        else 
        {
            [self._imgWin setHidden:YES];
            [self._imgLose setHidden:YES];
            [self._imgDraw setHidden:NO];
            
            [self._crown setHidden:YES];
        }
        
        // set the opponent info 
        FBUserInfo* opponent = [[FacebookManager sharedInstance] GetFBUserInfo:info._opponent];
        self._opponentName.text = opponent._name;
        self._opponentScore.text = TimeToString( info._opponentScore );
        SetImageView( self._opponentPic, opponent );
        
        [[ChallengeCenter sharedInstance] ResponseChallenge:[GlobalWork sharedInstance]._challengeInfo._challengeId with:[GlobalWork sharedInstance]._challengeInfo._selfScore];
    }
    
    if( [GlobalWork sharedInstance]._gameMode == CHALLENGE_MODE )
    {
        self._txtBannerInfo.text = @"Score has been sent to";
        [self._imgChallenge setHidden:NO];
        self._opponentScore.text = @"??:??:??";
        [self._imgDraw setHidden:YES];
        [self._imgLose setHidden:YES];
        [self._imgWin setHidden:YES];
        [self._crown setHidden:YES];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self challengeFriend];
    }
}


//------------------------------------- private function ----------------------------------------


// challenge friend
- (void)challengeFriend
{
    NSString* friendUid = [GlobalWork sharedInstance]._challengedUser;
    
    if( friendUid != nil )
    {
        [[ChallengeCenter sharedInstance] CreateChallenge:[FacebookManager sharedInstance]._userInfo._uid 
                                                 toFriend:friendUid
                                                     with:[GlobalWork sharedInstance]._elapseTime
                                       withCallbackSender:self 
                                             withCallback:@selector(_onSendChallengeDone)];
    }
}


// on challenge done
- (void)_onSendChallengeDone
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}


/**
 * @desc    post info to the wall
 * @para    sender
 * @return  none
 */
- (IBAction)onFacebook:(id)sender
{
    NSString* enemyName = [[FacebookManager sharedInstance] GetFBUserInfo:[GlobalWork sharedInstance]._challengeInfo._opponent]._name;
    float score = [GlobalWork sharedInstance]._challengeInfo._selfScore;
    
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
