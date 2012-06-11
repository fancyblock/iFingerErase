//
//  ChallengeCenter.m
//  iFingerErase
//
//  Created by He jia bin on 6/11/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeCenter.h"
#import "Parse/Parse.h"

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
- (void)CreateChallenge:(NSString*)challenger toFriend:(NSString*)enemy with:(float)score
{
    PFObject* challengeInfo = [PFObject objectWithClassName:CHALLENGE_INFO];
    
    [challengeInfo setObject:challenger forKey:ID_CHALLENGER];
    [challengeInfo setObject:enemy forKey:ID_ENEMY];
    [challengeInfo setObject:[NSNumber numberWithFloat:score] forKey:ID_SCORE_C];
    [challengeInfo setObject:[NSNumber numberWithBool:NO] forKey:ID_FINISH];
    [challengeInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
     {
         //TODO 
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


@end
