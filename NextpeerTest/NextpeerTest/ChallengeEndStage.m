//
//  ChallengeEndStage.m
//  iFingerErase
//
//  Created by He jia bin on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeEndStage.h"

@interface ChallengeEndStage ()

@end

@implementation ChallengeEndStage


@synthesize _txtScore;
@synthesize _imgFriendIcon;
@synthesize _txtFriendName;


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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)onChallenge:(id)sender
{
    //TODO 
}

- (IBAction)onDiscard:(id)sender
{
    //TODO 
}

@end
