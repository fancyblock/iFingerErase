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
#define ID_CANCEL       @"cancel"
#define ID_REJECT       @"reject"

#define KEY_CHALLENGE   @"challenge_id"

#define CHALLENGE_UPDATED   @"challenge_updated"


@interface challengeInfo:NSObject
{
}

@property (nonatomic, retain) NSString* _opponent;
@property (nonatomic, readwrite) BOOL _isSelfChallenge;
@property (nonatomic, readwrite) float _selfScore;
@property (nonatomic, readwrite) float _opponentScore;
@property (nonatomic, readwrite) BOOL _isDone;
@property (nonatomic, readwrite) BOOL _canceled;
@property (nonatomic, readwrite) BOOL _isRejected;

@property (nonatomic, retain) NSString* _challengeId;

@end



@interface ChallengeCenter : NSObject
{
    NSMutableArray* m_challengeList;
    NSMutableArray* m_playerList;
}


@property (nonatomic, readonly) NSMutableArray* _challengeList;
@property (nonatomic, readonly) NSMutableArray* _playerList;


+ (ChallengeCenter*)sharedInstance;


- (void)SignUp:(NSString*)userName;

- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)ResponseChallenge:(NSString*)challengeId with:(float)score;

- (void)FetchAllPlayers:(id)sender withCallback:(SEL)callback;

- (void)FetchAllChallenges:(NSString*)fbId withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)CancelChallenge:(NSString*)challengeId;

- (void)RejectChallenge:(NSString*)challengeId;


@end
