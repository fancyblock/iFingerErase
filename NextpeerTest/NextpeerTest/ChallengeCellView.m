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


@synthesize _imgChallenger;
@synthesize _imgEnemy;
@synthesize _txtInfo;
@synthesize _btnAction;
@synthesize _btnMore;
@synthesize _btnCloseCase;
@synthesize _challengeInfo;
@synthesize _txtStatus;


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


- (IBAction)_onAccept:(id)sender
{
    [GlobalWork sharedInstance]._gameMode = ACCEPT_CHALLENGE_MODE;
    [GlobalWork sharedInstance]._challengeInfo = self._challengeInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_GAME] userInfo:nil];
}


- (IBAction)_onDetail:(id)sender
{
    //TODO 
}


- (IBAction)_onClose:(id)sender
{
    [[ChallengeCenter sharedInstance] CloseChallenge:self._challengeInfo._challengeId];
}

@end
