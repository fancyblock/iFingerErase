//
//  ChallengeCenter.h
//  iFingerErase
//
//  Created by He jia bin on 6/11/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHALLENGE_INFO  @"challengeInfo"

#define ID_CHALLENGER   @"challenger"
#define ID_ENEMY        @"enemy"
#define ID_SCORE_C      @"score_c"
#define ID_SCORE_E      @"score_e"
#define ID_FINISH       @"isCompleted"

#define KEY_CHALLENGE   @"challenge_id"


// challenge info
struct challengeInfo 
{
    NSString* _challenger;
    NSString* _enemy;
    float _score_c;
    float _score_e;
};



@interface ChallengeCenter : NSObject
{
    //TODO 
}


//TODO 


+ (ChallengeCenter*)sharedInstance;


- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)ResponseChallenge:(NSString*)challengeId with:(float)score;


@end
