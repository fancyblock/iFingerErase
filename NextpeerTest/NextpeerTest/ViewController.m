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
    
    m_fbFriendList = [[FBPopupFriendList alloc] initWithNibName:@"FBPopupFriendList" bundle:nil];
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


- (IBAction)onSinglePlayer:(id)sender
{
    [GlobalWork sharedInstance]._gameMode = SINGLE_MODE;
    
    NSDictionary* para = [NSDictionary dictionaryWithObject:STAGE_GAME forKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:nil userInfo:para];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:nil userInfo:para];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"StartGame" object:nil];
}


- (IBAction)onMutiPlayer:(id)sender
{
    [Nextpeer launchDashboard];
}


- (IBAction)ChallengeFriends:(id)sender
{
    if( [FacebookManager sharedInstance].IsAuthenticated == YES )
    {
        [self.view addSubview:m_fbFriendList.view];
        [m_fbFriendList StartLoad];
        
        m_fbFriendList.view.transform = CGAffineTransformMake(0.001f, 0, 0, 0.001f, 0, 0);
        
        [UIView beginAnimations:nil context:nil];
        [UIView animateWithDuration:0.25f animations:^{m_fbFriendList.view.transform = CGAffineTransformMake(1.1f, 0, 0, 1.1f, 0, 0);} completion:^(BOOL finished)
         {
             [UIView beginAnimations:nil context:nil];
             [UIView animateWithDuration:0.15f animations:^{ m_fbFriendList.view.transform = CGAffineTransformMake(0.9f, 0, 0, 0.9f, 0, 0); } completion:^(BOOL finished)
              {
                  [UIView beginAnimations:nil context:nil];
                  m_fbFriendList.view.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
                  [UIView setAnimationDuration:0.15f];
                  [UIView commitAnimations];
              }];
             [UIView commitAnimations];
         }];
        [UIView commitAnimations];
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
