//
//  GlobalWork.h
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookManager.h"


#define SINGLE_MODE     1
#define MUTI_MODE       2
#define CHALLENGE_MODE  3

#define STAGE_MAINMENU      1
#define STAGE_GAME          2
#define STAGE_END           3
#define STAGE_CHALLENGE_END 4


@interface GlobalWork : NSObject
{
    //TODO
}

+ (GlobalWork*)sharedInstance;


@property (nonatomic, readwrite) int _gameMode;
@property (nonatomic, retain) FBUserInfo* _challengedUser;
@property (nonatomic, readwrite) float _elapseTime;


@end
