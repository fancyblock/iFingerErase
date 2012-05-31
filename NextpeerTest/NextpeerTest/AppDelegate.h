//
//  AppDelegate.h
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nextpeer/Nextpeer.h"

#define NEXTPEER_KEY    @"670eb38993b782f75bca7178ca19dc9927adbe79"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NextpeerDelegate, NPTournamentDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
