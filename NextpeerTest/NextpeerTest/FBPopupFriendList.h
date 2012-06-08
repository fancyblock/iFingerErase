//
//  FBPopupLeaderboard.h
//  iDragPaper
//
//  Created by He jia bin on 5/28/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"

#define WEEK_LEADERBOARD 1
#define ALL_LEADERBOARD  2

@interface FBPopupFriendList : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id m_callbackSender;
    SEL m_callback;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingAni;
@property (nonatomic, retain) IBOutlet UITableView* _leaderboardView;


- (IBAction)Close:(id)sender;

- (void)StartLoad;

- (void)SetCloseCallback:(id)sender withSelector:(SEL)callback;

@end
