//
//  GameStage.m
//  NextpeerTest
//
//  Created by He jia bin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStage.h"
#import "Nextpeer/Nextpeer.h"

@interface GameStage ()

@end

@implementation GameStage


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
    //TODO 
}


/**
 * @desc    end the game
 * @para    none
 * @return  none
 */
- (void)End
{
    //TODO 
}


/**
 * @desc    exit the game stage
 * @para    sender
 * @return  none
 */
- (IBAction)Exit:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
