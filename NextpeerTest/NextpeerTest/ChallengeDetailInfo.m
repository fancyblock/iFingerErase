//
//  ChallengeDetailInfo.m
//  iFingerErase
//
//  Created by He jia bin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeDetailInfo.h"
#import "FacebookManager.h"
#import "Utility.h"

@interface ChallengeDetailInfo ()

@end

@implementation ChallengeDetailInfo

@synthesize _info;
@synthesize _INIT;

@synthesize _imgEnemy;
@synthesize _txtEnemy;
@synthesize _btnResult;
@synthesize _txtEnemyName;
@synthesize _imgChallenger;
@synthesize _txtChallenger;
@synthesize _txtEnemyScore;
@synthesize _txtChallengerName;
@synthesize _txtChallengerScore;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
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
 * @desc    close the popup
 * @para    sender
 * @return  none
 */
- (IBAction)onClose:(id)sender
{
    [self.view removeFromSuperview];    
}


/**
 * @desc    init
 * @para    none
 * @return  none
 */
- (void)Initial
{
    NSLog( @"Init" );
    
    FBUserInfo* challenger = [[FacebookManager sharedInstance] GetFBUserInfo:self._info._challenger];
    FBUserInfo* enemy = [[FacebookManager sharedInstance] GetFBUserInfo:self._info._enemy];
    
    self._txtChallenger.text = challenger._name;
    self._txtEnemy.text = enemy._name;
    
    self._txtChallengerName.text = challenger._name;
    self._txtEnemyName.text = enemy._name;
    
    self._txtChallengerScore.text = TimeToString( self._info._score_c );
    if( self._info._score_e < 0 )
    {
        self._txtEnemyScore.text = @"???";
    }
    else 
    {
        self._txtEnemyScore.text = TimeToString( self._info._score_e );
    }
    
    // set picture
    if( challenger._pic == nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:challenger withBlock:^(BOOL succeeded)
        {
            [self._imgChallenger setImage:challenger._pic];
        }];
        
    }
    else 
    {
        [self._imgChallenger setImage:challenger._pic];
    }
    
    if( enemy._pic = nil )
    {
        [[FacebookManager sharedInstance] LoadPicture:enemy withBlock:^(BOOL succeed)
        {
            [self._imgEnemy setImage:enemy._pic];
        }];
    }
    else 
    {
        [self._imgEnemy setImage:enemy._pic];
    }
    
    if( self._info._score_e < 0 )
    {
        [self._btnResult setTitle:@"Pending" forState:UIControlStateDisabled];
    }
    else 
    {
        //TODO
    }
    
}


@end
