//
//  FBPopupLeaderboard.h
//  iDragPaper
//
//  Created by He jia bin on 5/28/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLeaderboard.h"

#define WEEK_LEADERBOARD 1
#define ALL_LEADERBOARD  2

@interface FBPopupLeaderboard : UIViewController<UITableViewDataSource>
{
    FBLeaderboard* m_fbLeaderboard;
    int m_curBoardType;
    
    id m_callbackSender;
    SEL m_callback;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingAni;
@property (nonatomic, retain) IBOutlet UITableView* _leaderboardView;
@property (nonatomic, retain) IBOutlet UIButton* _btnWeek;
@property (nonatomic, retain) IBOutlet UIButton* _btnAll;
@property (nonatomic, retain) IBOutlet UILabel* _labelMode;


- (IBAction)Close:(id)sender;

- (IBAction)Week:(id)sender;

- (IBAction)All:(id)sender;

- (void)StartLoad;

- (void)SetCloseCallback:(id)sender withSelector:(SEL)callback;

@end
