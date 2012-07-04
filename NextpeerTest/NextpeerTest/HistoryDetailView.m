//
//  HistoryDetailCellView.m
//  iFingerErase
//
//  Created by He jia bin on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryDetailView.h"

@interface HistoryDetailView ()

@end

@implementation HistoryDetailView

@synthesize _info;
@synthesize _INIT;

@synthesize _imgMe;
@synthesize _txtMe;
@synthesize _imgEnemy;
@synthesize _txtEnemy;
@synthesize _txtPending;
@synthesize _txtVSTimes;
@synthesize _txtWinTimes;
@synthesize _txtLoseTimes;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self._INIT = @selector(Initial);
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


/**
 * @desc    initial 
 * @para    none
 * @return  none
 */
- (void)Initial
{
    self._txtMe.text = self._info._challenger._name;
    self._txtEnemy.text = self._info._enemy._name;
    
    self._txtVSTimes.text = [NSString stringWithFormat:@"%d", ( self._info._winTimes + self._info._loseTimes + self._info._pendingTimes )];
    self._txtWinTimes.text = [NSString stringWithFormat:@"%d", self._info._winTimes];
    self._txtLoseTimes.text = [NSString stringWithFormat:@"%d", self._info._loseTimes];
    self._txtPending.text = [NSString stringWithFormat:@"%d", self._info._pendingTimes];
    
    if( self._info._challenger._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:self._info._challenger withBlock:^(BOOL succeeded)
        {
            [self._imgMe setImage:self._info._challenger._pic];
        }];
    }
    else 
    {
        [self._imgMe setImage:self._info._challenger._pic];
    }
    
    if( self._info._enemy._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:self._info._enemy withBlock:^(BOOL succeeded)
         {
             [self._imgEnemy setImage:self._info._enemy._pic];
         }];
    }
    else 
    {
        [self._imgEnemy setImage:self._info._enemy._pic];
    }
}


/**
 * @desc    close the view
 * @para    sender
 * @return  none
 */
- (IBAction)onClose:(id)sender
{
    [self.view removeFromSuperview];
}

@end
