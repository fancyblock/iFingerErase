//
//  ChallengeCenter.m
//  iFingerErase
//
//  Created by He jia bin on 6/11/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeCenter.h"
#import "Parse/Parse.h"
#import "FacebookManager.h"


@interface ChallengeCenter (private)

- (void)sendChallengeNotification:(PFObject*)data to:(NSString*)fbId;

@end


@implementation ChallengeCenter

static ChallengeCenter* m_inscance;



/**
 * @desc    return the challenge center
 * @para    none
 * @return  singleton
 */
+ (ChallengeCenter*)sharedInstance
{
    if( m_inscance == nil )
    {
        m_inscance = [[ChallengeCenter alloc] init];
    }
    
    return m_inscance;
}


/**
 * @desc    create a challenge to your friend
 * @para    challenger
 * @para    enemy
 * @para    score
 * @return  none
 */
- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score withCallbackSender:(id)sender withCallback:(SEL)callback
{
    PFObject* challengeInfo = [PFObject objectWithClassName:CHALLENGE_INFO];
    
    [challengeInfo setObject:challenger forKey:ID_CHALLENGER];
    [challengeInfo setObject:enemy forKey:ID_ENEMY];
    [challengeInfo setObject:[NSNumber numberWithFloat:score] forKey:ID_SCORE_C];
    [challengeInfo setObject:[NSNumber numberWithBool:NO] forKey:ID_FINISH];
    [challengeInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
     {
         [self sendChallengeNotification:challengeInfo to:enemy withCallbackSender:sender withCallback:callback];
     }];
}


/**
 * @desc    response challenge
 * @para    challenge id
 * @para    score
 * @return  none
 */
- (void)ResponseChallenge:(NSString*)challengeId with:(float)score
{
    //TODO 
}


//------------------------------------ private function ------------------------------------------ 


// send push notification to inform the challenge
- (void)sendChallengeNotification:(PFObject*)data to:(NSString*)fbId withCallbackSender:(id)sender withCallback:(SEL)callback
{
    // push notification
    NSDictionary *pushInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"You've got a new challenge", @"alert",
                          [NSNumber numberWithInt:1], @"badge",
                          data.objectId, KEY_CHALLENGE,
                          nil];
    
    PFPush *push = [[[PFPush alloc] init] autorelease];
    
    [push setChannels:[NSArray arrayWithObjects:[NSString stringWithFormat:@"fb%@", fbId], nil]];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:86400];
    [push setData:pushInfo];
    [push sendPushInBackground];
    
    // post to the wall
    [[FacebookManager sharedInstance] PublishToFriendWall:@"You've got a challenge!"
                                                 withDesc:[NSString stringWithFormat:@"%@ challenge you at iFingerErase.", [FacebookManager sharedInstance]._userInfo._name]
                                                 withName:[FacebookManager sharedInstance]._userInfo._name
                                              withPicture:@"http://www.coconutislandstudio.com/asset/iDragPaper/iDragPaper_FREE_Normal.png" 
                                                 withLink:@"http://fancyblock.sinaapp.com" 
                                                 toFriend:fbId
                                       withCallbackSender:sender 
                                             withCallback:callback];
    
}


@end
