//
//  FacebookData.h
//  FFLT
//
//  Created by He jia bin on 5/7/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define FB_IMAGE_LOAD_FINISHED @"fb_image_load_finished"

typedef void (^LoadPicBlock)(BOOL succeeded);


// user info struct
@interface FBUserInfo : NSObject <FBRequestDelegate>

@property (nonatomic, retain) NSString* _uid;
@property (nonatomic, retain) NSString* _name;
@property (nonatomic, retain) UIImage* _pic;
@property (nonatomic, readwrite) LoadPicBlock _callback;

@end


// callback info
@interface CallbackInfo : NSObject

@property (nonatomic, retain) id _callbackSender;
@property (nonatomic) SEL _callback;

@end
