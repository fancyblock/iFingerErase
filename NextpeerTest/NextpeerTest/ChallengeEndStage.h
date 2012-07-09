//
//  ChallengeEndStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalWork.h"

@interface ChallengeEndStage : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;
@property (nonatomic, retain) IBOutlet UIView* _loadingMask;
@property (nonatomic, retain) IBOutlet UIImageView* _imgProfile;
@property (nonatomic, retain) IBOutlet UILabel* _txtName;


- (IBAction)onChallenge:(id)sender;

- (void)Initial;


@end
