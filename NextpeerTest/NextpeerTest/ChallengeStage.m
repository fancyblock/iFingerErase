//
//  ChallengeStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/12/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeStage.h"
#import "GlobalWork.h"


@interface ChallengeStage ()

@end

@implementation ChallengeStage

@synthesize _tableView;


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
    
    m_fbFriendList = [[FBPopupFriendList alloc] initWithNibName:@"FBPopupFriendList" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * @desc    back to the main menu
 * @para    sender
 * @return  none
 */
- (IBAction)onBack:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU]];
}


/**
 * @desc    create a challenge
 * @para    sender
 * @return  none
 */
- (IBAction)onCreateChallenge:(id)sender
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


//------------------------------------ delegate functions ---------------------------------------

// return the 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO 
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO 
    
    return nil;
}


@end
