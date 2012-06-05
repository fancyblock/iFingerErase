//
//  FBLeaderboard.h
//  iDragPaper
//
//  Created by He jia bin on 5/22/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookManager.h"

#define LEADERBOARD_SCORE       @"GameScore_Leaderboard"


@interface LeaderboardItem : NSObject

@property (nonatomic, retain) NSString* _name;
@property (nonatomic, retain) NSString* _uid;
@property (nonatomic, readwrite) long _mark;
@property (nonatomic, retain) FBUserInfo* _fbUser;

@end


@interface FBLeaderboard : NSObject
{
    id m_callbackSender;
    SEL m_callback;
    
    NSMutableArray* m_leaderboard;
}

@property (nonatomic, retain, readonly) NSMutableArray* _leaderbaord;


- (void)LoadWeekLeaderboard:(id)sender withCallback:(SEL)callback;

- (void)LoadAllLeaderbaord:(id)sender withCallback:(SEL)callback;

- (BOOL)IsThisWeek:(NSDate*)date;

- (void)SubmitMark:(int)mark withName:(NSString*)name andUID:(NSString*)uid withScoreType:(NSString*)type;

@end
