//
//  ChallengeCellView.m
//  iFingerErase
//
//  Created by He jia bin on 6/21/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeCellView.h"
#import "GlobalWork.h"


@implementation ChallengeCellView

@synthesize _opponentUid;
@synthesize _challengeInfo;
@synthesize _imgChallenger;
@synthesize _txtInfo;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 * @desc    display the detail of this person
 * @para    sender
 * @return  none
 */
- (IBAction)onHistory:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHistory" object:self._opponentUid];
}


/**
 * @desc    challenge the friend
 * @para    sender
 * @return  none
 */
- (IBAction)onPlay:(id)sender
{
    [GlobalWork sharedInstance]._gameMode = CHALLENGE_MODE;
    [GlobalWork sharedInstance]._challengedUser = self._opponentUid;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_GAME] userInfo:nil];
}


/**
 * @desc    accept the challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onAccept:(id)sender
{
    [GlobalWork sharedInstance]._gameMode = ACCEPT_CHALLENGE_MODE;
    [GlobalWork sharedInstance]._challengeInfo = self._challengeInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_GAME] userInfo:nil];
}


/**
 * @desc    reject the challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onReject:(id)sender
{
    [[ChallengeCenter sharedInstance] RejectChallenge:self._challengeInfo._challengeId];
}


/**
 * @desc    revert the challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onRevert:(id)sender
{
    [[ChallengeCenter sharedInstance] CancelChallenge:self._challengeInfo._challengeId];
}


@end
