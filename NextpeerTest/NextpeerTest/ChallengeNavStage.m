//
//  ChallengeNavStage.m
//  iFingerErase
//
//  Created by He jia bin on 7/2/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeNavStage.h"

@interface ChallengeNavStage ()

@end

@implementation ChallengeNavStage

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * @desc    constructor
 * @para    none
 * @return  self
 */
- (id)initial
{
    m_challengeControllerView = [[ChallengeStage alloc] initWithNibName:@"ChallengeStage" bundle:nil];
    
    [self initWithRootViewController:m_challengeControllerView];
    self.navigationBarHidden = YES;
    
    m_viewChallenge = [[ChallengeInfo alloc] initWithNibName:@"ChallengeInfo" bundle:nil];
    m_viewHistory = [[ChallengeHistory alloc] initWithNibName:@"ChallengeHistory" bundle:nil];
    
    return self;
}


/**
 * @desc    initial
 * @para    none
 * @return  none
 */
- (void)Initial
{
    [m_challengeControllerView Initial];
}


/**
 * @desc    push challenge info view
 * @para    none
 * @return  none
 */
- (void)PushChallengeInfoView
{
    [self pushViewController:m_viewChallenge animated:YES];
}


/**
 * @desc    push history view
 * @para    none
 * @return  none
 */
- (void)PushHistoryView
{
    [self pushViewController:m_viewHistory animated:YES];
}


@end
