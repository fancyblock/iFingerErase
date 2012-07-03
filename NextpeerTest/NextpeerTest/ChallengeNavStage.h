//
//  ChallengeNavStage.h
//  iFingerErase
//
//  Created by He jia bin on 7/2/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeStage.h"
#import "ChallengeInfo.h"
#import "ChallengeHistory.h"

@interface ChallengeNavStage : UINavigationController
{
    ChallengeStage* m_challengeControllerView;
    
    ChallengeInfo* m_viewChallenge;
    ChallengeHistory* m_viewHistory;
}

- (id)initial;
- (void)Initial;

- (void)PushChallengeInfoView;
- (void)PushHistoryView;

@end
