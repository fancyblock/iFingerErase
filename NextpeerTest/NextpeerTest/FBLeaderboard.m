//
//  FBLeaderboard.m
//  iDragPaper
//
//  Created by He jia bin on 5/22/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import "FBLeaderboard.h"
#import "Parse/Parse.h"


@implementation LeaderboardItem

@synthesize _name;
@synthesize _uid;
@synthesize _mark;
@synthesize _fbUser;

@end


@interface FBLeaderboard(private)

- (void)_onProfileComplete;
- (void)_onFriendListComplete;

- (void)requestScore;

@end

@implementation FBLeaderboard


/**
 * @desc    return the leaderboard list
 * @para    none
 * @return  list
 */
- (NSMutableArray*)_leaderbaord
{
    return m_leaderboard;
}


/**
 * @desc    load week leaderbaord
 * @para    sender
 * @para    callback
 * @return  none
 */
- (void)LoadWeekLeaderboard:(id)sender withCallback:(SEL)callback
{
    if( [FacebookManager sharedInstance].IsAuthenticated == NO )
    {
        return;
    }
    
    m_callbackSender = sender;
    m_callback = callback;
    
    if( [FacebookManager sharedInstance]._friendList == nil )
    {
        [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
    }
    else 
    {
        [self requestScore];
    }
}


/**
 * @desc    load all leaderbaord
 * @para    sender
 * @para    callback
 * @return  none
 */
- (void)LoadAllLeaderbaord:(id)sender withCallback:(SEL)callback
{
    if( [FacebookManager sharedInstance].IsAuthenticated == NO )
    {
        return;
    }
    
    m_callbackSender = sender;
    m_callback = callback;
    
    if( [FacebookManager sharedInstance]._friendList == nil )
    {
        [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
    }
    else 
    {
        [self requestScore];
    } 
}


/**
 * @desc    submit score
 * @para    mark
 * @para    name
 * @para    uid
 * @para    type
 * @return  none
 */
- (void)SubmitMark:(int)mark withName:(NSString*)name andUID:(NSString*)uid withScoreType:(NSString*)type
{
    PFQuery* query = [PFQuery queryWithClassName:type];
    
    [query whereKey:@"uid" equalTo:uid];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             PFObject *gameScore = nil;
             
             if( [objects count] == 0 )
             {
                 gameScore = [PFObject objectWithClassName:type];
             }
             else 
             {
                 gameScore = [objects objectAtIndex:0];
                 
                 int oldMark = [[gameScore valueForKey:@"mark"] longValue];
                 
                 if( mark >= oldMark )
                 {
                     return;
                 }
             }
             
             [gameScore setObject:[NSNumber numberWithLong:mark] forKey:@"mark"];
             [gameScore setObject:name forKey:@"name"];
             [gameScore setObject:uid forKey:@"uid"];
             [gameScore saveEventually];
         }
     }];
}


/**
 * @desc    judge if the week is this week
 * @para    date
 * @return  
 */
- (BOOL)IsThisWeek:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit flags = NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents* dateInfo = [calendar components:flags fromDate:date];
    NSDateComponents* curDateInfo = [calendar components:flags fromDate:[NSDate date]];
    [calendar release];
    
    if( [dateInfo week] != [curDateInfo week] )
    {
        return NO;
    }
    
    return YES;
}


//------------------------------- private function -------------------------------


// request score
- (void)requestScore
{
    PFQuery* query = [PFQuery queryWithClassName:LEADERBOARD_SCORE];
    
    int count = [[FacebookManager sharedInstance]._friendList count];
    FBUserInfo* userInfo;
    NSMutableArray* uids = [[NSMutableArray alloc] init];
    for( int i = 0; i < count; i++ )
    {
        userInfo = [[FacebookManager sharedInstance]._friendList objectAtIndex:i];
        
        [uids addObject:userInfo._uid];
    }
    [uids addObject:[FacebookManager sharedInstance]._userInfo._uid];
    
    [query whereKey:@"uid" containedIn:uids];
    [uids release];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             int i;
             int count;
             LeaderboardItem* item = nil;
             
             // create or clean m_leaderboard
             if( m_leaderboard == nil )
             {
                 m_leaderboard = [[NSMutableArray alloc] init];
             }
             else 
             {
                 count = [m_leaderboard count];
                 
                 for( i = 0; i < count; i++ )
                 {
                     item = [m_leaderboard objectAtIndex:i];
                     
                     [item release];
                 }
                 
                 [m_leaderboard removeAllObjects];
             }
             
             count = [objects count];
             for( i = 0; i < count; i++ )
             {
                 item = [[LeaderboardItem alloc] init];
                 
                 item._name = [[objects objectAtIndex:i] objectForKey:@"name"];
                 item._uid = [[objects objectAtIndex:i] objectForKey:@"uid"];
                 item._mark = [[[objects objectAtIndex:i] objectForKey:@"mark"] longValue];
                 
                 int fbFriendLen = [[FacebookManager sharedInstance]._friendList count];
                 FBUserInfo* fbUserInfo = nil;
                 for( int j = 0; j < fbFriendLen; j++ )
                 {
                     fbUserInfo = [[FacebookManager sharedInstance]._friendList objectAtIndex:j];
                     
                     if( [fbUserInfo._uid isEqualToString:item._uid] )
                     {
                         item._fbUser = fbUserInfo;
                         
                         break;
                     }
                 }
                 if( item._fbUser == nil )
                 {
                     item._fbUser = [FacebookManager sharedInstance]._userInfo;
                 }
                 
                 [m_leaderboard addObject:item];
             }
             
             // sort the leaderboard
             [m_leaderboard sortUsingComparator:^NSComparisonResult( id obj1, id obj2 )
              {
                  LeaderboardItem* item1 = obj1;
                  LeaderboardItem* item2 = obj2;
                  
                  if( item1._mark < item2._mark )
                  {
                      return NSOrderedAscending;
                  }
                  
                  if( item1._mark > item2._mark )
                  {
                      return NSOrderedDescending;
                  }
                  
                  return NSOrderedSame;
              }];
             
             [m_callbackSender performSelector:m_callback];
         }
     }];

}


//------------------------------ callback function -------------------------------


// callback when profile complete
- (void)_onProfileComplete
{
    [[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onFriendListComplete)];
    
    NSString* channel = [NSString stringWithFormat:@"fb%@", [FacebookManager sharedInstance]._userInfo._uid];
    
    [PFPush subscribeToChannelInBackground:channel];
}


// callback when friendlist complete
- (void)_onFriendListComplete
{
    [self requestScore];
}


@end
