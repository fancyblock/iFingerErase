//
//  ChallengeHistory.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"


@interface ChallengeHistory : UIViewController<UITableViewDataSource>
{
    BOOL m_isUnreadShow;
    CustomBadge* m_unreadBadge;
    
    NSMutableArray* m_unreadList;
}

@property (nonatomic, retain) IBOutlet UIImageView* _imgSelf;
@property (nonatomic, retain) IBOutlet UIImageView* _imgOpponent;

@property (nonatomic, retain) IBOutlet UILabel* _winTimes;
@property (nonatomic, retain) IBOutlet UILabel* _loseTimes;
@property (nonatomic, retain) IBOutlet UILabel* _drawTimes;
@property (nonatomic, retain) IBOutlet UILabel* _opponentName;

@property (nonatomic, retain) IBOutlet UITableView* _tableView;
@property (nonatomic, retain) IBOutlet UIView* _unreadView;

@property (nonatomic, retain) NSString* _friendUid;


- (IBAction)onBack:(id)sender;
- (IBAction)onUnreadShow:(id)sender;


@end
