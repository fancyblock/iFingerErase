//
//  CanvasView.m
//  NextpeerTest
//
//  Created by He jia bin on 6/5/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context;
	context = UIGraphicsGetCurrentContext();
    
	CGImageRef image = CGBitmapContextCreateImage( m_buffer );
	CGContextDrawImage( context, m_bufferBound, image );
	CGImageRelease( image );
}


/**
 * @desc    return the graphic buffer
 * @para    none
 * @return  buffer pointer
 */
- (void*)_pBuffer
{
    return m_pBuffer;
}


/**
 * @desc    draw pixel
 * @para    color
 * @para    x
 * @para    y
 * @return  none
 */
- (void)DrawPixel:(int)color toX:(int)x toY:(int)y
{
    unsigned int address = 0;
	address = ( (m_height - y - 1) * m_width + x ) * 4;
	
	Byte r = color>>16 & 0x0000ff;
    Byte g = color>>8 & 0x0000ff;
    Byte b = color & 0x0000ff;
	
	((Byte*)m_pBuffer)[address] = 0xff;
	((Byte*)m_pBuffer)[address+1] = r;
	((Byte*)m_pBuffer)[address+2] = g;
	((Byte*)m_pBuffer)[address+3] = b;
}


/**
 * @desc    initial the canvas
 * @para    none
 * @return  none
 */
- (void)Initial
{
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    CGColorSpaceRef colorSpace;
	void* bitmapData;
	int bitmapByteCount;
	int bitmapBytesPerRow;
	
	bitmapBytesPerRow = 4 * width;
	bitmapByteCount = bitmapBytesPerRow * height;
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	bitmapData = malloc( bitmapByteCount );
	if( bitmapData == NULL )
	{
		fprintf( stderr, "Memory not alloc" );
		return;
	}
	
	m_buffer = CGBitmapContextCreate( bitmapData, width, height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst );
	
	if( m_buffer == nil )
	{
		free( bitmapData );
		fprintf( stderr, "Context not Create" );
		return;
	}
	
	CGColorSpaceRelease( colorSpace );
	
	m_pBuffer = CGBitmapContextGetData( m_buffer );
	m_bufferBound = CGRectMake( 0, 0, width, height );
    
    m_width = width;
    m_height = height;
    
}


//------------------------------------- private function ---------------------------------------



@end
