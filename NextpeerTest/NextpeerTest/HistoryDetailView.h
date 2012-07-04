//
//  HistoryDetailCellView.h
//  iFingerErase
//
//  Created by He jia bin on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDetailInfo.h"


@interface HistoryDetailView : UIViewController
{
    //TODO
}

@property (nonatomic, retain) historyInfo* _info;
@property (nonatomic, readwrite) SEL _INIT;

@property (nonatomic, retain) IBOutlet UIImageView* _imgMe;
@property (nonatomic, retain) IBOutlet UIImageView* _imgEnemy;
@property (nonatomic, retain) IBOutlet UILabel* _txtMe;
@property (nonatomic, retain) IBOutlet UILabel* _txtEnemy;
@property (nonatomic, retain) IBOutlet UILabel* _txtVSTimes;
@property (nonatomic, retain) IBOutlet UILabel* _txtWinTimes;
@property (nonatomic, retain) IBOutlet UILabel* _txtLoseTimes;
@property (nonatomic, retain) IBOutlet UILabel* _txtPending;


- (void)Initial;

- (IBAction)onClose:(id)sender;


@end
