//
//  ViewController.h
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPopupFriendList.h"


@interface ViewController : UIViewController
{
    FBPopupFriendList* m_fbFriendList;
}


- (IBAction)onSinglePlayer:(id)sender;

- (IBAction)onMutiPlayer:(id)sender;

- (IBAction)ChallengeFriends:(id)sender;

- (IBAction)onSettings:(id)sender;

- (IBAction)onAbout:(id)sender;

@end
