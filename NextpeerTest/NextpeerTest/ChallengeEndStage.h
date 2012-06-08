//
//  ChallengeEndStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeEndStage : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;
@property (nonatomic, retain) IBOutlet UIImageView* _imgFriendIcon;
@property (nonatomic, retain) IBOutlet UILabel* _txtFriendName;


- (IBAction)onChallenge:(id)sender;

- (IBAction)onDiscard:(id)sender;


@end
