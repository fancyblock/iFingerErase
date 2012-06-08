//
//  GlobalWork.m
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalWork.h"

@implementation GlobalWork

static GlobalWork* m_singleton = nil;


@synthesize _gameMode;
@synthesize _challengedUser;



/**
 * @desc    return the singleton of this class
 * @para    none
 * @return  singleton
 */
+ (GlobalWork*)sharedInstance
{
    if( m_singleton == nil )
    {
        m_singleton = [[GlobalWork alloc] init];
    }
    
    return m_singleton;
}

@end
