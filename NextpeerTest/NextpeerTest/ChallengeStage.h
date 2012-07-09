//
//  ChallengeStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/12/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriends.h"


@interface ChallengeStage : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
{
    NSMutableArray* m_playerList;
    NSMutableArray* m_friendList;
    NSMutableDictionary* m_challengeDic;
    
    InviteFriends* m_inviteFriendsView;
}

@property (nonatomic, retain) IBOutlet UINavigationBar* _navBar;
@property (nonatomic, retain) IBOutlet UITableView* _tableView;
@property (nonatomic, retain) IBOutlet UIView* _loadingMask;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingIcon;
@property (nonatomic, retain) IBOutlet UIView* _connectFBView;


- (IBAction)onBack:(id)sender;

- (IBAction)onConnectFB:(id)sender;

- (IBAction)onInviteFriends:(id)sender;


- (void)Initial;

@end
