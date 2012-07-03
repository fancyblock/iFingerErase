//
//  Utility.h
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>


// popup a view with animation
void PopupView( UIView* parent, UIViewController* viewController, SEL init );

// convert time to the NSString
NSString* TimeToString( float time );
