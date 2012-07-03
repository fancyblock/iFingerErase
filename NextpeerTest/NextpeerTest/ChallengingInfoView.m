//
//  ChallengingInfoView.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengingInfoView.h"
#import "GlobalWork.h"

@implementation ChallengingInfoView

@synthesize _imgView;
@synthesize _txtName;

@synthesize _waitPart;
@synthesize _donePart;
@synthesize _acceptPart;

@synthesize _challengeInfo;



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
 * @desc    watch the challenge info
 * @para    sender
 * @return  none
 */
- (IBAction)onWatch:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopupDetail" object:self._challengeInfo userInfo:nil];
}


/**
 * @desc    close the challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onCloseChallenge:(id)sender
{
    [[ChallengeCenter sharedInstance] CloseChallenge:self._challengeInfo._challengeId];
}


@end
