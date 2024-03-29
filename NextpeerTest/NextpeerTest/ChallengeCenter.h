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

#define WIN_GAME        1
#define LOSE_GAME       2
#define DRAW_GAME       3
#define PENDING_GAME    4


@interface challengeInfo:NSObject

@property (nonatomic, retain) NSString* _opponent;
@property (nonatomic, readwrite) BOOL _isSelfChallenge;
@property (nonatomic, readwrite) float _selfScore;
@property (nonatomic, readwrite) float _opponentScore;
@property (nonatomic, readwrite) BOOL _isDone;
@property (nonatomic, readwrite) BOOL _canceled;
@property (nonatomic, readwrite) BOOL _isRejected;

@property (nonatomic, retain) NSString* _challengeId;
@property (nonatomic, retain) NSDate* _createTime;

@end


@interface historyInfo : NSObject

@property (nonatomic, readwrite) int _winTimes;
@property (nonatomic, readwrite) int _loseTimes;
@property (nonatomic, readwrite) int _drawTimes;
@property (nonatomic, readwrite) int _cancelTimes;
@property (nonatomic, readwrite) int _rejectTimes;

@end



@interface ChallengeCenter : NSObject
{
    NSMutableArray* m_challengeList;
    NSMutableArray* m_playerList;
    
    NSMutableDictionary* m_unreadInfo;
    NSMutableDictionary* m_historyInfo;
}


@property (nonatomic, readonly) NSMutableArray* _challengeList;
@property (nonatomic, readonly) NSMutableArray* _playerList;


+ (ChallengeCenter*)sharedInstance;


- (void)SignUp:(NSString*)userName;

- (void)FetchAllPlayers:(id)sender withCallback:(SEL)callback;

- (void)FetchAllChallenges:(NSString*)fbId withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score withCallbackSender:(id)sender withCallback:(SEL)callback;

- (void)ResponseChallenge:(NSString*)challengeId with:(float)score;

- (void)CancelChallenge:(NSString*)challengeId;

- (void)RejectChallenge:(NSString*)challengeId;

- (void)DismissUnreadInfo:(NSString*)uid;

- (NSArray*)GetUnreadList:(NSString*)uid;

- (historyInfo*)GetHistoryInfo:(NSString*)uid;

- (int)GetGameResult:(challengeInfo*)info;

@end
