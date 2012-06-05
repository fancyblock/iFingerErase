//
//  CanvasView.h
//  NextpeerTest
//
//  Created by He jia bin on 6/5/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>

@interface CanvasView : UIView
{
    CGContextRef m_buffer;
	CGRect m_bufferBound;
	void* m_pBuffer;
    
    int m_width;
    int m_height;
}

@property (nonatomic, readonly) void* _pBuffer;


- (void)Initial;

- (void)DrawPixel:(int)color toX:(int)x toY:(int)y;

@end
