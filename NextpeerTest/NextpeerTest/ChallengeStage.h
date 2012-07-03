//
//  ChallengeStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/12/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPopupFriendList.h"
#import "ChallengeInfo.h"


#define CHALLENGE_INDEX 0
#define INVITE_INDEX    1

@interface ChallengeStage : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
{
    NSMutableArray* m_playerList;
    NSMutableArray* m_friendList;
}

@property (nonatomic, retain) IBOutlet UINavigationBar* _navBar;
@property (nonatomic, retain) IBOutlet UITableView* _tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingIcon;
@property (nonatomic, retain) IBOutlet UIView* _connectFBView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* _btnChallenges;

@property (nonatomic, retain) IBOutlet UIView* _sectionViewPlayer;
@property (nonatomic, retain) IBOutlet UIView* _sectionViewInvite;


- (IBAction)onBack:(id)sender;
- (IBAction)onShowChallenges:(id)sender;

- (IBAction)onConnectFB:(id)sender;
- (IBAction)onPlay:(id)sender;


- (void)Initial;

@end
