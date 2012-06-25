//
//  ViewController.m
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ViewController.h"
#import "Nextpeer/Nextpeer.h"
#import "FacebookManager.h"
#import "GlobalWork.h"


@interface ViewController (private)

- (void)_onFBAutoDone;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationPortrait );
}


- (void)Initial
{
    //TODO 
}


- (IBAction)onSinglePlayer:(id)sender
{
    [GlobalWork sharedInstance]._gameMode = SINGLE_MODE;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_GAME]];
}


- (IBAction)onMutiPlayer:(id)sender
{
    [Nextpeer launchDashboard];
}


- (IBAction)ChallengeFriends:(id)sender
{
    if( [FacebookManager sharedInstance].IsAuthenticated == YES )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_CHALLENGE]];
    }
    else 
    {
        [[FacebookManager sharedInstance] Authenticate:self withCallback:@selector(_onFBAutoDone)];
    }
}


- (IBAction)onSettings:(id)sender
{
    //TEMP
}


- (IBAction)onAbout:(id)sender
{
    //TODO
}

//--------------------------------- private function -------------------------------------


- (void)_onFBAutoDone
{
    [self ChallengeFriends:nil];
}


@end
