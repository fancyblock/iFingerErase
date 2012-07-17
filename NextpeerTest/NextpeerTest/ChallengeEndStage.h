//
//  ChallengeEndStage.h
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalWork.h"
#import "MBProgressHUD.h"

@interface ChallengeEndStage : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;

@property (nonatomic, retain) IBOutlet UIImageView* _opponentPic;
@property (nonatomic, retain) IBOutlet UILabel* _opponentName;
@property (nonatomic, retain) IBOutlet UIImageView* _imgChallenge;
@property (nonatomic, retain) IBOutlet UIImageView* _imgWin;
@property (nonatomic, retain) IBOutlet UIImageView* _imgLose;
@property (nonatomic, retain) IBOutlet UIImageView* _imgDraw;
@property (nonatomic, retain) IBOutlet UILabel* _opponentScore;
@property (nonatomic, retain) IBOutlet UIImageView* _crown;
@property (nonatomic, retain) IBOutlet UILabel* _txtBannerInfo;


- (IBAction)onChallenge:(id)sender;
- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;

- (void)Initial;


@end
