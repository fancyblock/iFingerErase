//
//  ChallengeOverStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeOverStage.h"
#import "ChallengeCenter.h"
#import "GlobalWork.h"
#import "FacebookManager.h"
#import "Utility.h"


@interface ChallengeOverStage (private)

- (NSString*)timeToString:(float)time;
- (void)updateProfileImg;

@end

@implementation ChallengeOverStage

@synthesize _txtTitle;
@synthesize _imgPlayer;
@synthesize _imgChallenger;
@synthesize _txtScorePlayer;
@synthesize _txtScoreChallenger;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateProfileImg) 
                                                 name:FB_IMAGE_LOAD_FINISHED 
                                               object:nil];
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
 * @desc    initial the ui
 * @para    none
 * @return  none
 */
- (void)Initial
{
    challengeInfo* info = [GlobalWork sharedInstance]._challengeInfo;
    
    [self updateProfileImg];
    
    self._txtScoreChallenger.text = [self timeToString:info._score_c];
    self._txtScorePlayer.text = [self timeToString:info._score_e];
    
    // judge the result
    if( info._score_e < info._score_c )
    {
        self._txtTitle.text = @"You Win";
    }
    else 
    {
        self._txtTitle.text = @"You Lose";
    }
    
    // send the result to the server
    [[ChallengeCenter sharedInstance] ResponseChallenge:info._challengeId with:info._score_e];
    
}


/**
 * @desc    back to the main menu
 * @para    sender
 * @return  none
 */
- (IBAction)_onOk:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


//--------------------------------- private function ---------------------------------

// convert from time to string
- (NSString*)timeToString:(float)time
{
    NSString* txtTime = TimeToString( time );
    
    return txtTime;
}


// update profile image
- (void)updateProfileImg
{
    challengeInfo* info = [GlobalWork sharedInstance]._challengeInfo;
    
    FBUserInfo* challenger = [[FacebookManager sharedInstance] GetFBUserInfo:info._challenger];
    FBUserInfo* player = [[FacebookManager sharedInstance] GetFBUserInfo:info._enemy];
    
    if( challenger._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:challenger];
    }
    else 
    {
        [self._imgChallenger setImage:challenger._pic];
    }
    
    if( player._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:player];
    }
    else 
    {
        [self._imgPlayer setImage:player._pic];
    }
}


@end
