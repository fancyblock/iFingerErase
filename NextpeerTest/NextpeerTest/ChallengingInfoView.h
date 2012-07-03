//
//  ChallengingInfoView.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeCenter.h"

@interface ChallengingInfoView : UITableViewCell
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UIImageView* _imgView;
@property (nonatomic, retain) IBOutlet UILabel* _txtName;

@property (nonatomic, retain) IBOutlet UIView* _waitPart;
@property (nonatomic, retain) IBOutlet UIView* _donePart;
@property (nonatomic, retain) IBOutlet UIView* _acceptPart;


@property (nonatomic, retain) challengeInfo* _challengeInfo;


- (IBAction)onAccept:(id)sender;
- (IBAction)onWatch:(id)sender;
- (IBAction)onCloseChallenge:(id)sender;


@end
