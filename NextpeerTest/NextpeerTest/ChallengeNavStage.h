//
//  ChallengeNavStage.h
//  iFingerErase
//
//  Created by He jia bin on 7/2/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeStage.h"
#import "ChallengeHistory.h"

@interface ChallengeNavStage : UINavigationController
{
    ChallengeStage* m_challengeControllerView;
    
    ChallengeHistory* m_viewHistory;
}

- (id)initial;
- (void)Initial;

- (void)PushHistoryView:(NSString*)uid;

@end
