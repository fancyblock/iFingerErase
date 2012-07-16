//
//  ChallengeWin.h
//  iFingerErase
//
//  Created by He jia bin on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeDone : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;
@property (nonatomic, retain) IBOutlet UIImageView* _imgWin;
@property (nonatomic, retain) IBOutlet UIImageView* _imgLose;
@property (nonatomic, retain) IBOutlet UIImageView* _imgDraw;
@property (nonatomic, retain) IBOutlet UIImageView* _stefWin;
@property (nonatomic, retain) IBOutlet UIImageView* _stefLose;

@property (nonatomic, retain) IBOutlet UIImageView* _opponentPic;
@property (nonatomic, retain) IBOutlet UILabel* _opponentName;
@property (nonatomic, retain) IBOutlet UILabel* _opponentScore;
@property (nonatomic, retain) IBOutlet UIImageView* _crown;


- (IBAction)onOk:(id)sender;
- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;

- (void)Initial;

@end
