//
//  ChallengeInfo.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeDetailInfo.h"

#define CHALLENGE_MYSELF        0
#define CHALLENGE_FROM_FRIEND   1


@interface ChallengeInfo : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* m_selfChallenges;
    NSMutableArray* m_beChallenged;
    
    ChallengeDetailInfo* m_challengeDetail;
}

@property (nonatomic, retain) IBOutlet UITableView* _tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _loadingView;
@property (nonatomic, retain) IBOutlet UIView* _selfChallengeHeader;
@property (nonatomic, retain) IBOutlet UIView* _beChallengedHeader;


- (IBAction)onBack:(id)sender;
- (IBAction)onHistory:(id)sender;

@end
