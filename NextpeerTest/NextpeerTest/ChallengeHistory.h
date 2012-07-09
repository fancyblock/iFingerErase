//
//  ChallengeHistory.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChallengeHistory : UIViewController<UITableViewDataSource>
{
    NSMutableArray* m_historyList;
}

@property (nonatomic, retain) IBOutlet UIImageView* _imgSelf;
@property (nonatomic, retain) IBOutlet UIImageView* _imgOpponent;
@property (nonatomic, retain) IBOutlet UILabel* _txtSelfName;
@property (nonatomic, retain) IBOutlet UILabel* _txtOpponentName;

@property (nonatomic, retain) IBOutlet UILabel* _winTimes;
@property (nonatomic, retain) IBOutlet UILabel* _loseTimes;
@property (nonatomic, retain) IBOutlet UILabel* _cancelTimes;
@property (nonatomic, retain) IBOutlet UILabel* _rejectTimes;
@property (nonatomic, retain) IBOutlet UILabel* _allTimes;

@property (nonatomic, retain) IBOutlet UITableView* _tableView;

@property (nonatomic, retain) NSString* _friendUid;


- (IBAction)onBack:(id)sender;


@end
