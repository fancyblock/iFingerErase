//
//  ChallengeCellView.h
//  iFingerErase
//
//  Created by He jia bin on 6/21/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeCenter.h"

@interface ChallengeCellView : UITableViewCell
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UIImageView* _imgChallenger;
@property (nonatomic, retain) IBOutlet UIImageView* _imgEnemy;
@property (nonatomic, retain) IBOutlet UILabel* _txtInfo;
@property (nonatomic, retain) IBOutlet UIButton* _btnAction;
@property (nonatomic, retain) IBOutlet UIButton* _btnMore;
@property (nonatomic, retain) IBOutlet UIButton* _btnCloseCase;
@property (nonatomic, retain) IBOutlet UILabel* _txtStatus;

@property (nonatomic, retain) challengeInfo* _challengeInfo;


- (IBAction)_onAccept:(id)sender;
- (IBAction)_onDetail:(id)sender;
- (IBAction)_onClose:(id)sender;

@end
