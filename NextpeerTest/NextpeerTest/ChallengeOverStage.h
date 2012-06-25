//
//  ChallengeOverStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeOverStage : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtTitle;
@property (nonatomic, retain) IBOutlet UIImageView* _imgChallenger;
@property (nonatomic, retain) IBOutlet UIImageView* _imgPlayer;
@property (nonatomic, retain) IBOutlet UILabel* _txtScoreChallenger;
@property (nonatomic, retain) IBOutlet UILabel* _txtScorePlayer;


- (IBAction)_onOk:(id)sender;

- (void)Initial;

@end
