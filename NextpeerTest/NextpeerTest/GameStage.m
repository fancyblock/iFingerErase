//
//  GameStage.m
//  NextpeerTest
//
//  Created by He jia bin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStage.h"
#import "Nextpeer/Nextpeer.h"

@interface GameStage (private)

- (void)gameFrame;

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
    return NO;
}


/**
 * @desc    start game
 * @para    none
 * @return  none
 */
- (void)Start
{
    [self._glass Initial];
    
    // start the game loop
    self->m_tick = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameFrame)];		
    self->m_tick.frameInterval = 2;		
    [m_tick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


/**
 * @desc    end the game
 * @para    none
 * @return  none
 */
- (void)End
{
    // stop the game loop
    [m_tick removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_tick release];
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
- (void)gameFrame
{
    //TODO 
    
    [self._glass setNeedsDisplay];
}

@end
