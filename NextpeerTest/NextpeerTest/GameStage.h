//
//  GameStage.h
//  NextpeerTest
//
//  Created by He jia bin on 6/4/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"
#import <QuartzCore/CADisplayLink.h>

#define RADIUS  5


@interface GameStage : UIViewController
{
    CADisplayLink* m_tick;
    BOOL m_isInTouch;
    
    int m_lastX;
    int m_lastY;
}

@property (nonatomic, retain) IBOutlet UILabel* _time;
@property (nonatomic, retain) IBOutlet UILabel* _percent;
@property (nonatomic, retain) IBOutlet CanvasView* _glass;


- (IBAction)Exit:(id)sender;

- (void)Start;

- (void)End;

@end
