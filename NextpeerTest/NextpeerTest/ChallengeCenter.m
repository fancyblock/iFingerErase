//
//  ChallengeCenter.m
//  iFingerErase
//
//  Created by He jia bin on 6/11/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeCenter.h"
#import "FacebookManager.h"


@implementation challengeInfo

@synthesize _score_e;
@synthesize _score_c;
@synthesize _isDone;
@synthesize _enemy;
@synthesize _challenger;
@synthesize _challengeId;

@end


@interface ChallengeCenter (private)

- (void)sendChallengeNotification:(PFObject*)data to:(NSString*)fbId;

@end


@implementation ChallengeCenter

static ChallengeCenter* m_inscance;


/**
 * @desc    return the challengelist
 * @para    none
 * @return  challengelist
 */
- (NSMutableArray*)_challengeList
{
    return m_challengeList;
}


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
 * @desc    initial
 * @para    none
 * @return  self
 */
- (id)init
{
    [super init];
    
    m_challengeList = [[NSMutableArray alloc] init];
    
    return self;
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
    //update from the local
    challengeInfo* info = nil;
    int count = [m_challengeList count];
    for( int i = 0; i < count; i++ )
    {
        info = [m_challengeList objectAtIndex:i];
        
        if( [info._challengeId isEqualToString:challengeId] )
        {
            info._score_e = score;
            info._isDone = YES;
            
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_CLOSED object:nil];
    
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:challengeId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
     {
         if( error == nil && object != nil )
         {
             [object setObject:[NSNumber numberWithFloat:score] forKey:ID_SCORE_E];
             [object setObject:[NSNumber numberWithBool:YES] forKey:ID_FINISH];
             
             [object saveInBackground];
         }
     }];
}


/**
 * @desc    get all the challenges from this fb user
 * @para    fbId    facebook uid
 * @return  none
 */
- (void)FetchAllChallenges:(NSString*)fbId withCallbackSender:(id)sender withCallback:(SEL)callback
{
    PFQuery* query1 = [PFQuery queryWithClassName:@"challengeInfo"];
    PFQuery* query2 = [PFQuery queryWithClassName:@"challengeInfo"];
    
    [query1 whereKey:@"challenger" equalTo:fbId];
    [query2 whereKey:@"enemy" equalTo:fbId];
    
    PFQuery* query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query1, query2, nil]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             [m_challengeList removeAllObjects];
             
             PFObject *challenge = nil;
             
             int count = [objects count];
             for( int i = 0; i < count; i++ )
             {
                 challenge = [objects objectAtIndex:i];
                 
                 challengeInfo* info = [[challengeInfo alloc] init];
                 
                 info._challenger = [[challenge objectForKey:ID_CHALLENGER] retain];
                 info._enemy = [[challenge objectForKey:ID_ENEMY] retain];
                 info._isDone = [[challenge objectForKey:ID_FINISH] boolValue];
                 info._score_c = [[challenge objectForKey:ID_SCORE_C] floatValue];
                 info._score_e = [[challenge objectForKey:ID_SCORE_E] floatValue];
                 
                 info._challengeId = [challenge.objectId retain];
                 
                 [m_challengeList addObject:info];
                 
             }
             
             // invoke callback
             if( sender != nil && callback != nil )
             {
                 [sender performSelector:callback];
             }
         }
     }];
}



/**
 * @desc    close challenge
 * @para    challengeId
 * @return  none
 */
- (void)CloseChallenge:(NSString*)challengeId
{
    //delete from the local
    challengeInfo* info = nil;
    int count = [m_challengeList count];
    for( int i = 0; i < count; i++ )
    {
        info = [m_challengeList objectAtIndex:i];
        
        if( [info._challengeId isEqualToString:challengeId] )
        {
            [m_challengeList removeObject:info];
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_CLOSED object:nil];
    
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:challengeId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
    {
        if( error == nil && object != nil )
        {
            [object deleteInBackground];
        }
    }];
    
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
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
     {
         [sender performSelector:callback];
     }];
    //[push sendPushInBackground];
    
    /*
    // post to the wall
    [[FacebookManager sharedInstance] PublishToFriendWall:@"You've got a challenge!"
                                                 withDesc:[NSString stringWithFormat:@"%@ challenge you at iFingerErase.", [FacebookManager sharedInstance]._userInfo._name]
                                                 withName:[FacebookManager sharedInstance]._userInfo._name
                                              withPicture:@"http://www.coconutislandstudio.com/asset/iDragPaper/iDragPaper_FREE_Normal.png" 
                                                 withLink:@"http://fancyblock.sinaapp.com" 
                                                 toFriend:fbId
                                       withCallbackSender:sender 
                                             withCallback:callback];
     */
    
}


//----------------------------------- callback function -------------------------------------------


@end
