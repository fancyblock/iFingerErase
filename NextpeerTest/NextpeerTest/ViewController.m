//
//  ViewController.m
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Nextpeer/Nextpeer.h"

@interface ViewController ()

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
    return NO;
}


- (IBAction)onSinglePlayer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartGame" object:nil];
}


- (IBAction)onMutiPlayer:(id)sender
{
    [Nextpeer launchDashboard];
}


- (IBAction)onSettings:(id)sender
{
    //TODO
}


- (IBAction)onAbout:(id)sender
{
    //TODO
}


@end
