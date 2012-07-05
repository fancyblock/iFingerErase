//
//  AppDelegate.h
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nextpeer/Nextpeer.h"
#import "GameStage.h"
#import "EndStage.h"
#import "Parse/Parse.h"
#import "ChallengeEndStage.h"
#import "EndStage.h"
#import "ChallengeNavStage.h"
#import "ChallengeWin.h"
#import "ChallengeLose.h"


#define NEXTPEER_KEY    @"670eb38993b782f75bca7178ca19dc9927adbe79"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NextpeerDelegate, NPTournamentDelegate>
{
    GameStage* m_gameViewController;
    EndStage* m_endViewController;
    ChallengeEndStage* m_challengeEndController;
    ChallengeNavStage* m_challengeController;
    ChallengeWin* m_challengeWin;
    ChallengeLose* m_challengeLose;
    
    UIView* m_curUIView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
