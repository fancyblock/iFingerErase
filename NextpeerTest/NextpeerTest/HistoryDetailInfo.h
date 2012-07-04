//
//  HistoryDetailInfo.h
//  iFingerErase
//
//  Created by He jia bin on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"


@interface historyInfo : NSObject

@property (nonatomic, retain) FBUserInfo* _challenger;
@property (nonatomic, retain) FBUserInfo* _enemy;
@property (nonatomic, readwrite) int _winTimes;
@property (nonatomic, readwrite) int _loseTimes;
@property (nonatomic, readwrite) int _pendingTimes;

@end



@interface HistoryDetailInfo : UITableViewCell
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UIImageView* _imgProfile;
@property (nonatomic, retain) IBOutlet UILabel* _txtName;
@property (nonatomic, retain) IBOutlet UILabel* _txtTimes;
@property (nonatomic, retain) IBOutlet UIButton* _btnDetail;

@property (nonatomic, retain) historyInfo* _info;



- (IBAction)onDetail:(id)sender;


@end
