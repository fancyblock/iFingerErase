//
//  ChallengeHistory.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDetailInfo.h"
#import "HistoryDetailView.h"


@interface ChallengeHistory : UIViewController<UITableViewDataSource>
{
    NSMutableArray* m_historyList;
    
    HistoryDetailView* m_detailViewController;
}

@property (nonatomic, retain) IBOutlet UITableView* _tableView;


- (IBAction)onBack:(id)sender;


@end
