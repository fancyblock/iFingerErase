//
//  ChallengeCellView.h
//  iFingerErase
//
//  Created by He jia bin on 6/21/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeCenter.h"
#import "FacebookManager.h"


@interface ChallengeCellView : UITableViewCell
{
    //TODO 
}

@property (nonatomic, retain) NSString* _opponentUid;
@property (nonatomic, retain) challengeInfo* _challengeInfo;

@property (nonatomic, retain) IBOutlet UIImageView* _imgChallenger;
@property (nonatomic, retain) IBOutlet UILabel* _txtInfo;
@property (nonatomic, retain) IBOutlet UIView* _background;

@property (nonatomic, retain) IBOutlet UIButton* _btnWin;
@property (nonatomic, retain) IBOutlet UIButton* _btnLose;
@property (nonatomic, retain) IBOutlet UIButton* _btnDraw;


- (IBAction)onHistory:(id)sender;
- (IBAction)onPlay:(id)sender;
- (IBAction)onAccept:(id)sender;
- (IBAction)onReject:(id)sender;
- (IBAction)onRevert:(id)sender;


@end
