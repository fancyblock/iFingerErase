//
//  ChallengeWin.h
//  iFingerErase
//
//  Created by He jia bin on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeWin : UIViewController
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UILabel* _txtScore;


- (IBAction)onOk:(id)sender;
- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;

- (void)Initial;

@end
