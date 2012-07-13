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


- (IBAction)onChallenge:(id)sender;
- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;

- (void)Initial;


@end
