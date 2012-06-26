//
//  ChallengeEndStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalWork.h"

@interface ChallengeEndStage : UIViewController<UITableViewDataSource>
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;
@property (nonatomic, retain) IBOutlet UITableView* _challengeFriendList;
@property (nonatomic, retain) IBOutlet UIView* _loadingMask;


- (IBAction)onChallenge:(id)sender;

- (IBAction)onDiscard:(id)sender;

- (void)Initial;


@end
