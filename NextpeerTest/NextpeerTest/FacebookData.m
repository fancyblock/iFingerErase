//
//  FacebookData.m
//  FFLT
//
//  Created by He jia bin on 5/7/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import "FacebookData.h"

// userInfo struct
@implementation FBUserInfo

@synthesize _uid;
@synthesize _name;
@synthesize _pic;


/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    _pic = [[UIImage alloc] initWithData:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FB_IMAGE_LOAD_FINISHED object:self];
}


@end


// callbackInfo struct
@implementation CallbackInfo

@synthesize _callbackSender;
@synthesize _callback;

@end
