//
//  ChallengeCenter.h
//  iFingerErase
//
//  Created by He jia bin on 6/11/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"


#define CHALLENGE_INFO  @"challengeInfo"

#define ID_CHALLENGER   @"challenger"
#define ID_ENEMY        @"enemy"
#define ID_SCORE_C      @"score_c"
#define ID_SCORE_E      @"score_e"
#define ID_FINISH       @"isCompleted"

#define KEY_CHALLENGE   @"challenge_id"

#define CHALLENGE_CLOSED     @"challenge_closed"


@interface challengeInfo:NSObject
{
}

@property (nonatomic, retain) NSString* _challenger;
@property (nonatomic, retain) NSString* _enemy;
@property (nonatomic, readwrite) float _score_c;
@property (nonatomic, readwrite) float _score_e;
@property (nonatomic, readwrite) BOOL _isDone;

@property (nonatomic, retain) NSString* _challengeId;

@end



@interface ChallengeCenter : NSObject
{
    NSMutableArray* m_challengeList;
}


@property (nonatomic, readonly) NSMutableArray* _challengeList;


+ (ChallengeCenter*)sharedInstance;


- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)ResponseChallenge:(NSString*)challengeId with:(float)score;

- (void)FetchAllChallenges:(NSString*)fbId withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)CloseChallenge:(NSString*)challengeId;


@end
