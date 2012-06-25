//
//  ChallengeStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/12/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPopupFriendList.h"

@interface ChallengeStage : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    FBPopupFriendList* m_fbFriendList;
}

@property (nonatomic, retain) IBOutlet UITableView* _tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingIcon;


- (IBAction)onBack:(id)sender;

- (IBAction)onCreateChallenge:(id)sender;

- (void)Initial;

@end
