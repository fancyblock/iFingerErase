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

@synthesize _challengeId;
@synthesize _createTime;
@synthesize _opponent;
@synthesize _isSelfChallenge;
@synthesize _selfScore;
@synthesize _opponentScore;
@synthesize _isDone;
@synthesize _canceled;
@synthesize _isRejected;

@end


@implementation historyInfo

@synthesize _winTimes;
@synthesize _loseTimes;
@synthesize _drawTimes;
@synthesize _cancelTimes;
@synthesize _rejectTimes;

@end


@interface ChallengeCenter (private)

- (void)sendChallengeNotification:(PFObject*)data to:(NSString*)fbId;
- (void)updateUnreadInfo;
- (void)updateHistoryInfo;

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
 * @desc    return the player list
 * @para    none
 * @return  player list
 */
- (NSMutableArray*)_playerList
{
    return m_playerList;
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
    m_playerList = [[NSMutableArray alloc] init];
    m_unreadInfo = [[NSMutableDictionary alloc] init];
    m_historyInfo = [[NSMutableDictionary alloc] init];
    
    return self;
}


/**
 * @desc    sign up a new account
 * @para    user name
 * @return  none
 */
- (void)SignUp:(NSString*)userName
{
    PFQuery* query = [PFQuery queryWithClassName:@"UserInfo"];
    
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
    {
        if( error == nil )
        {
            if( [objects count] == 0 )
            {
                // sign up
                PFObject* newUser = [PFObject objectWithClassName:@"UserInfo"];
                [newUser setObject:userName forKey:@"username"];
                [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
                 {
                     if( succeeded == YES )
                     {
                         NSLog( @"Sign up a new user on iFingerErase succeeded !" );
                     }
                 }];
            }
        }
    }];
}


/**
 * @desc    fetch all players
 * @para    sender
 * @para    callback
 * @return  none
 */
- (void)FetchAllPlayers:(id)sender withCallback:(SEL)callback
{
    PFQuery* query = [PFQuery queryWithClassName:@"UserInfo"];
    
    int count = [[FacebookManager sharedInstance]._friendList count];
    FBUserInfo* userInfo;
    NSMutableArray* uids = [[NSMutableArray alloc] init];
    for( int i = 0; i < count; i++ )
    {
        userInfo = [[FacebookManager sharedInstance]._friendList objectAtIndex:i];
        
        [uids addObject:userInfo._uid];
    }
    
    [query whereKey:@"username" containedIn:uids];
    [uids release];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             [m_playerList removeAllObjects];
             
             int num = [objects count];
             for( int i = 0; i < num; i++ )
             {
                 PFObject* player = [objects objectAtIndex:i];
                 [m_playerList addObject:[player objectForKey:@"username"]];
             }
             
             if( sender != nil && callback != nil )
             {
                 [sender performSelector:callback];
             }
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
                 
                 NSString* challengeId = [challenge objectForKey:ID_CHALLENGER];
                 
                 if( [challengeId isEqualToString:fbId] )
                 {
                     info._isSelfChallenge = YES;
                     
                     info._opponent = [[challenge objectForKey:ID_ENEMY] retain];
                     info._selfScore = [[challenge objectForKey:ID_SCORE_C] floatValue];
                     info._opponentScore = [[challenge objectForKey:ID_SCORE_E] floatValue];
                 }
                 else 
                 {
                     info._isSelfChallenge = NO;
                     
                     info._opponent = [[challenge objectForKey:ID_CHALLENGER] retain];
                     info._selfScore = [[challenge objectForKey:ID_SCORE_E] floatValue];
                     info._opponentScore = [[challenge objectForKey:ID_SCORE_C] floatValue];
                 }
                 
                 info._isDone = [[challenge objectForKey:ID_FINISH] boolValue];
                 info._canceled = [[challenge objectForKey:ID_CANCEL] boolValue];
                 info._isRejected = [[challenge objectForKey:ID_REJECT] boolValue];
                 info._challengeId = [challenge.objectId retain];
                 
                 info._createTime = [challenge createdAt];
                 
                 [m_challengeList addObject:info];
                 
             }
             
             [self updateUnreadInfo];
             [self updateHistoryInfo];
             
             // invoke callback
             if( sender != nil && callback != nil )
             {
                 [sender performSelector:callback];
             }
         }
     }];
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
    PFObject* PFchallengeInfo = [PFObject objectWithClassName:CHALLENGE_INFO];
    
    [PFchallengeInfo setObject:challenger forKey:ID_CHALLENGER];
    [PFchallengeInfo setObject:enemy forKey:ID_ENEMY];
    [PFchallengeInfo setObject:[NSNumber numberWithFloat:score] forKey:ID_SCORE_C];
    [PFchallengeInfo setObject:[NSNumber numberWithFloat:-1.0f] forKey:ID_SCORE_E];
    [PFchallengeInfo setObject:[NSNumber numberWithBool:NO] forKey:ID_FINISH];
    [PFchallengeInfo setObject:[NSNumber numberWithBool:NO] forKey:ID_CANCEL];
    [PFchallengeInfo setObject:[NSNumber numberWithBool:NO] forKey:ID_REJECT];
    [PFchallengeInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
     {
         // add the info to local list
         challengeInfo* info = [[challengeInfo alloc] init];
         
         info._challengeId = [PFchallengeInfo.objectId retain];
         info._isSelfChallenge = YES;
         info._opponent = enemy;
         info._selfScore = score;
         info._opponentScore = -1.0f;
         info._isDone = NO;
         info._canceled = NO;
         
         [m_challengeList addObject:info];
         [info release];
         
         [self updateHistoryInfo];
         
         [self sendChallengeNotification:PFchallengeInfo to:enemy withCallbackSender:sender withCallback:callback];
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
            info._selfScore = score;
            info._isDone = NO;
            
            break;
        }
    }
    
    [self updateHistoryInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_UPDATED object:nil];
    
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:challengeId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
     {
         if( error == nil && object != nil )
         {
             [object setObject:[NSNumber numberWithFloat:score] forKey:ID_SCORE_E];
             
             [object saveInBackground];
         }
     }];
}


/**
 * @desc    cancel challenge
 * @para    challengeId
 * @return  none
 */
- (void)CancelChallenge:(NSString*)challengeId
{
    //delete from the local
    challengeInfo* info = nil;
    int count = [m_challengeList count];
    for( int i = 0; i < count; i++ )
    {
        info = [m_challengeList objectAtIndex:i];
        
        if( [info._challengeId isEqualToString:challengeId] )
        {
            info._canceled = YES;
            break;
        }
    }
    
    [self updateHistoryInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_UPDATED object:nil];
    
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:challengeId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
    {
        if( error == nil && object != nil )
        {
            [object setObject:[NSNumber numberWithBool:YES] forKey:ID_CANCEL];
            [object saveEventually];
        }
    }];
    
}


/**
 * @desc    reject a challenge
 * @para    challengeId
 * @return  none
 */
- (void)RejectChallenge:(NSString*)challengeId
{
    //reject from the local
    challengeInfo* info = nil;
    int count = [m_challengeList count];
    for( int i = 0; i < count; i++ )
    {
        info = [m_challengeList objectAtIndex:i];
        
        if( [info._challengeId isEqualToString:challengeId] )
        {
            info._isRejected = YES;
            break;
        }
    }
    
    [self updateHistoryInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHALLENGE_UPDATED object:nil];
    
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:challengeId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
    {
        if( error == nil && object != nil )
        {
            [object setObject:[NSNumber numberWithBool:YES] forKey:ID_REJECT];
            [object saveEventually];
        }
    }];
    
}


/**
 * @desc    return the history info of specific friend
 * @para    uid
 * @return  historInfo
 */
- (historyInfo*)GetHistoryInfo:(NSString*)uid
{
    return [m_historyInfo objectForKey:uid];
}


/**
 * @desc    return the unread list of specific friend
 * @para    uid
 * @return  unread list
 */
- (NSArray*)GetUnreadList:(NSString*)uid
{
    return [m_unreadInfo objectForKey:uid];
}


/**
 * @desc    dismiss all the unread info
 * @para    uid     your friends' uid
 * @return  none
 */
- (void)DismissUnreadInfo:(NSString*)uid
{
    NSMutableArray* unreadList = [m_unreadInfo objectForKey:uid];
    
    if( unreadList == nil || [unreadList count] == 0 )
    {
        return;
    }
    
    challengeInfo* cInfo = [unreadList lastObject];
        
    cInfo._isDone = YES;
        
    PFQuery* query = [PFQuery queryWithClassName:@"challengeInfo"];
    [query whereKey:@"objectId" equalTo:cInfo._challengeId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
     {
         if( error == nil )
         {
             [object setObject:[NSNumber numberWithBool:YES] forKey:ID_FINISH];
             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
              {
                  [unreadList removeLastObject];
                  
                  [self DismissUnreadInfo:uid];
              }];
         }
     }];
    
}


/**
 * @desc    judge the challenge result
 * @para    challengeInfo
 * @return  result
 */
- (int)GetGameResult:(challengeInfo*)info
{
    int result = PENDING_GAME;
    
    // win 
    if( info._selfScore > 0 && info._opponentScore > 0 && info._selfScore < info._opponentScore )
    {
        result = WIN_GAME;
    }
    
    // lose
    if( info._selfScore > 0 && info._opponentScore > 0 && info._selfScore > info._opponentScore )
    {
        result = LOSE_GAME;
    }
    
    // draw
    if( info._selfScore > 0 && info._opponentScore > 0 && info._selfScore == info._opponentScore )
    {
        result = DRAW_GAME;
    }
    
    return result;
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
    
}


// update the unread info
- (void)updateUnreadInfo
{
    int i;
    
    // clean the unread info
    NSArray* allKeys = [m_unreadInfo allKeys];
    for( i = 0; i < [allKeys count]; i++ )
    {
        [[m_unreadInfo objectForKey:[allKeys objectAtIndex:i]] removeAllObjects];
    }
    [m_unreadInfo removeAllObjects];
    
    int count = [m_challengeList count];
    for( i = 0; i < count; i++ )
    {
        challengeInfo* cInfo = [m_challengeList objectAtIndex:i];
        
        if( cInfo._isDone )
        {
            continue;
        }
        
        BOOL isUnread = NO;
        
        // your friend accept your challenge
        if( cInfo._isSelfChallenge == YES && cInfo._opponentScore > 0 )
        {
            isUnread = YES;
        }
        
        // your friend canceled his challenge
        if( cInfo._isSelfChallenge == NO && cInfo._canceled == YES )
        {
            isUnread = YES;
        }
        
        // your friend rejected your challenge
        if( cInfo._isSelfChallenge == YES && cInfo._isRejected == YES )
        {
            isUnread = YES;
        }
        
        // add unread challenge to the dictionary
        if( isUnread )
        {
            NSMutableArray* unreadInfo = [m_unreadInfo objectForKey:cInfo._opponent];
            
            if( unreadInfo == nil )
            {
                unreadInfo = [[NSMutableArray alloc] init];
                
                [m_unreadInfo setObject:unreadInfo forKey:cInfo._opponent];
            }
            
            [unreadInfo addObject:cInfo];
        }
        
    }
    
}


// update history info
- (void)updateHistoryInfo
{
    int i;
    historyInfo* hInfo = nil;
    
    [m_historyInfo removeAllObjects];
    for( i = 0; i < [m_playerList count]; i++ )
    {
        NSString* user = [m_playerList objectAtIndex:i];
        
        hInfo = [[historyInfo alloc] init];
        hInfo._loseTimes = 0;
        hInfo._rejectTimes = 0;
        hInfo._winTimes = 0;
        
        [m_historyInfo setObject:hInfo forKey:user];
    }
    
    int count = [m_challengeList count];
    for( i = 0; i < count; i++ )
    {
        challengeInfo* cInfo = [m_challengeList objectAtIndex:i];
        hInfo = [m_historyInfo objectForKey:cInfo._opponent];
        
        int result = [self GetGameResult:cInfo];
        
        if( result == WIN_GAME )
        {
            hInfo._winTimes++;
        }
        
        if( result == LOSE_GAME )
        {
            hInfo._loseTimes++;
        }
        
        if( result == DRAW_GAME )
        {
            hInfo._drawTimes++;
        }
        
    }
    
}


//----------------------------------- callback function -------------------------------------------


@end
