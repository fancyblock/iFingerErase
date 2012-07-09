//
//  Utility.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "Utility.h"


/**
 * @desc    popup a view with animation
 * @para    viewController
 * @return  none
 */
void PopupView( UIView* parent, UIViewController* viewController, SEL init )
{
    [parent addSubview:viewController.view];
    
    viewController.view.transform = CGAffineTransformMake(0.001f, 0, 0, 0.001f, 0, 0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.25f animations:^{viewController.view.transform = CGAffineTransformMake(1.1f, 0, 0, 1.1f, 0, 0);} completion:^(BOOL finished)
     {
         if( init != nil )
         {
             [viewController performSelector:init];
         }
         
         [UIView beginAnimations:nil context:nil];
         [UIView animateWithDuration:0.15f animations:^{ viewController.view.transform = CGAffineTransformMake(0.9f, 0, 0, 0.9f, 0, 0); } completion:^(BOOL finished)
          {
              [UIView beginAnimations:nil context:nil];
              viewController.view.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
              [UIView setAnimationDuration:0.15f];
              [UIView commitAnimations];
          }];
         [UIView commitAnimations];
     }];
    
    [UIView commitAnimations];
         
}


/**
 * @desc    convert time to NSString
 * @para    time
 * @return  string
 */
NSString* TimeToString( float time )
{
    int minutes = (int)( time / 60.0f );
    int seconds = (int)( time - minutes * 60.0f );
    int milliseconds = (int)( ( time - (float)seconds - (float)minutes * 60.0f) * 100.0f );
    
    NSString* txtTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", minutes, seconds, milliseconds];
    
    return txtTime;
}


/**
 * @desc    set image view
 * @para    imgView
 * @para    userInfo
 * @return  none
 */
void SetImageView( UIImageView* imgView, FBUserInfo* userInfo )
{
    if( userInfo._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:userInfo withBlock:^(BOOL succeeded)
        {
            [imgView setImage:userInfo._pic];
        }];
    }
    else 
    {
        [imgView setImage:userInfo._pic];
    }
}

