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
@synthesize _loadingMask;
@synthesize _txtName;
@synthesize _imgProfile;


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
    [self._loadingMask setHidden:NO];
    
    [self challengeFriend];
}


/**
 * @desc    initial the ui according to the info
 * @para    none
 * @return  none
 */
- (void)Initial
{
    NSString* txtTime = TimeToString( [GlobalWork sharedInstance]._elapseTime );
    
    self._txtScore.text = [NSString stringWithFormat:@"%@", txtTime];
    
    FBUserInfo* user = [[FacebookManager sharedInstance] GetFBUserInfo:[GlobalWork sharedInstance]._challengedUser];
    
    self._txtName.text = user._name;
    
    if( user._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:user withBlock:^(BOOL succeeded)
        {
            if( succeeded == YES )
            {
                [self._imgProfile setImage:user._pic];
            }
        }];
    }
    else 
    {
        [self._imgProfile setImage:user._pic];
    }
    
    [self._loadingMask setHidden:YES];
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
    [self._loadingMask setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


@end
