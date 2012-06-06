//
//  GameStage.m
//  NextpeerTest
//
//  Created by He jia bin on 6/4/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "GameStage.h"
#import "Nextpeer/Nextpeer.h"

@interface GameStage (private)

- (void)gameFrame:(CADisplayLink *)sender;
- (void)erasePoint:(int)x andY:(int)y;
- (void)eraseLine:(int)sx andY:(int)sy toX:(int)dx toY:(int)dy;
- (void)startTiming;
- (void)stopTiming;
- (void)complete;

@end

@implementation GameStage


@synthesize _time;
@synthesize _glass;
@synthesize _percent;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationPortrait );
}


/**
 * @desc    start game
 * @para    none
 * @return  none
 */
- (void)Start
{
    [self._glass Initial];
    
    m_isInTouch = NO;
    m_maxDotCnt = self._glass.frame.size.width * self._glass.frame.size.height;
    m_curDotCnt = 0;
    m_elapsedTime = 0.0f;
    m_isTiming = NO;
    
    m_dataInfo = malloc( m_maxDotCnt );
    for( int i = 0; i < m_maxDotCnt; i++ )
    {
        m_dataInfo[i] = 0x00;
    }
    
    // start the game loop
    self->m_tick = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameFrame:)];		
    self->m_tick.frameInterval = 1;
    [m_tick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


/**
 * @desc    end the game
 * @para    none
 * @return  none
 */
- (void)End
{
    [self stopTiming];
    free( m_dataInfo );
    
    // stop the game loop
    [m_tick invalidate];
}


/**
 * @desc    exit the game stage
 * @para    sender
 * @return  none
 */
- (IBAction)Exit:(id)sender
{
    [self End];
    [self dismissViewControllerAnimated:NO completion:nil];
}


//---------------------------------- private function ------------------------------------


// game frame
- (void)gameFrame:(CADisplayLink*)sender
{
    if( m_maxDotCnt == m_curDotCnt )
    {
        [self complete];
    }
    
    // set the percent label
    float percent = (float)m_curDotCnt * 100.0f / (float)m_maxDotCnt;
    self._percent.text = [NSString stringWithFormat:@"Percent: %.2f%%", percent];
    
    // set the elapsed time
    if( m_isTiming == YES )
    {
        m_elapsedTime += (sender.timestamp/1000000.0f);
    }
    int minutes = (int)(m_elapsedTime / 60.0f);
    int seconds = (int)(m_elapsedTime - minutes * 60.0f);
    int milliseconds = (int)((m_elapsedTime - (float)seconds - (float)minutes * 60.0f) * 100.0f);
    self._time.text = [NSString stringWithFormat:@"Time: %.2d:%.2d:%.2d", minutes, seconds, milliseconds];
    
    [self._glass setNeedsDisplay];
}

// erase point
- (void)erasePoint:(int)x andY:(int)y
{
    if( x < 0 || y < 0 || x >= self._glass.frame.size.width || y >= self._glass.frame.size.height )
    {
        return;
    }
    
    int address = y * self._glass.frame.size.width + x;
    if( m_dataInfo[address] == 0x00 )
    {
        if( m_curDotCnt == 0 )
        {
            [self startTiming];
        }
        
        [self._glass DrawPixel:0xff0f0f toX:x toY:y withAlpha:0xff];
     
        m_dataInfo[address] = 0xff;
        m_curDotCnt++;
    }
}

// erase segment (thicked line)
- (void)eraseLine:(int)sx andY:(int)sy toX:(int)dx toY:(int)dy;
{
    int i, j;
    int left, right, top, bottom;
    
    // vertical line
    if( sx == dx )
    {
        left = sx - RADIUS;
        right = sx + RADIUS;
        
        if( sy < dy )
        {
            for( i = sy; i <= dy; i++ )
            {
                for( j = left; j <= right; j++ )
                {
                    [self erasePoint:j andY:i];
                }
            }
        }
        
        if( sy > dy )
        {
            for( i = dy; i <= sy; i++ )
            {
                for( j = left; j <= right; j++ )
                {
                    [self erasePoint:j andY:i];
                }
            }
        }
    }
    // horizontal line
    else if( sy == dy )
    {
        top = sy - RADIUS;
        bottom = sy + RADIUS;
        
        if( sx < dx )
        {
            for( i = sx; i <= dx; i++ )
            {
                for( j = top; j <= bottom; j++ )
                {
                    [self erasePoint:i andY:j];
                }
            }
        }
        
        if( sx > dx )
        {
            for( i = dx; i <= sx; i++ )
            {
                for( j = top; j <= bottom; j++ )
                {
                    [self erasePoint:i andY:j];
                }
            }
        }
    }
    // oblique line
    else 
    {
        int deltaX = dx - sx;
        int deltaY = dy - sy;
        int incVal = 1;
        
        float k = 0;
        
        if( abs(deltaY) > abs(deltaX) )
        {
            if( sy > dy )
            {
                incVal = -1;
                k = -(float)deltaX/(float)deltaY;
            }
            else 
            {
                incVal = 1;
                k = (float)deltaX/(float)deltaY;
            }
            
            float xPos = (float)sx;
            for( i = sy; i != dy; i += incVal )
            {
                [self erasePoint:(int)(xPos + 0.5f) andY:i];
                
                //TODO 
                
                xPos += k;
            }
        }
        else 
        {
            if( sx > dx )
            {
                incVal = -1;
                k = -(float)deltaY/(float)deltaX;
            }
            else 
            {
                incVal = 1;
                k = (float)deltaY/(float)deltaX;
            }
            
            float yPos = (float)sy;
            for( i = sx; i != dx; i += incVal )
            {
                [self erasePoint:i andY:(int)(yPos + 0.5f)];
                
                //TODO 
                
                yPos += k;
            }
        }
    }
}

// start timing
- (void)startTiming
{
    m_isTiming = YES;
}

// stop timing
- (void)stopTiming
{
    m_isTiming = NO;
}

// finish erase
- (void)complete
{
    [self stopTiming];
    
    //TODO 
}


//---------------------------------- callback function ------------------------------------


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self._glass];
    
    m_lastX = pt.x;
    m_lastY = pt.y;
    
    m_isInTouch = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self._glass];
    
    [self eraseLine:pt.x andY:pt.y toX:m_lastX toY:m_lastY];
    
    m_lastX = pt.x;
    m_lastY = pt.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_isInTouch = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_isInTouch = NO;
}

@end
