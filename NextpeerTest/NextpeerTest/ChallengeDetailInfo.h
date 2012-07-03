//
//  ChallengeDetailInfo.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeCenter.h"

@interface ChallengeDetailInfo : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) challengeInfo* _info;
@property (nonatomic, readwrite) SEL _INIT;

@property (nonatomic, retain) IBOutlet UIImageView* _imgChallenger;
@property (nonatomic, retain) IBOutlet UIImageView* _imgEnemy;
@property (nonatomic, retain) IBOutlet UILabel* _txtChallenger;
@property (nonatomic, retain) IBOutlet UILabel* _txtEnemy;
@property (nonatomic, retain) IBOutlet UILabel* _txtChallengerName;
@property (nonatomic, retain) IBOutlet UILabel* _txtEnemyName;
@property (nonatomic, retain) IBOutlet UILabel* _txtChallengerScore;
@property (nonatomic, retain) IBOutlet UILabel* _txtEnemyScore;
@property (nonatomic, retain) IBOutlet UIButton* _btnResult;


- (IBAction)onClose:(id)sender;

- (void)Initial;

@end
