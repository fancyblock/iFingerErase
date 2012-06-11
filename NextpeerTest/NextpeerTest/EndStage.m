//
//  EndStage.m
//  NextpeerTest
//
//  Created by He jia bin on 6/6/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "EndStage.h"
#import "GlobalWork.h"

@interface EndStage ()

@end

@implementation EndStage

@synthesize _score;


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
    
    [self Initial];
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
 * @desc    
 * @para    sender
 * @return  none
 */
- (IBAction)_onOk:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchStage" object:[NSNumber numberWithInt:STAGE_MAINMENU] userInfo:nil];
}


/**
 * @desc    
 * @para    none
 * @return  none
 */
- (void)Initial
{
    int minutes = (int)([GlobalWork sharedInstance]._elapseTime / 60.0f);
    int seconds = (int)([GlobalWork sharedInstance]._elapseTime - minutes * 60.0f);
    int milliseconds = (int)(([GlobalWork sharedInstance]._elapseTime - (float)seconds - (float)minutes * 60.0f) * 100.0f);
    NSString* txtTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", minutes, seconds, milliseconds];
    
    self._score.text = [NSString stringWithFormat:@"You spend %@", txtTime];
}

@end
