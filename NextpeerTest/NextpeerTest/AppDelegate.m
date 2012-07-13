//
//  AppDelegate.m
//  NextpeerTest
//
//  Created by He jia bin on 5/30/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookManager.h"
#import "ViewController.h"
#import "GlobalWork.h"

@interface AppDelegate(private)

- (void)startGame;
- (void)endGame;
- (void)switchToView:(UIViewController*)destView withCallback:(SEL)callback;

- (void)_onProfileComplete;
- (void)_onStartGameDone;
- (void)_onSwitchStage:(NSNotification*)notification;

@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    m_curUIView = self.viewController.view;
    
    // clean the badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // initial the game view controllers
    m_gameViewController = [[GameStage alloc] initWithNibName:@"GameStage" bundle:nil];
    m_endViewController = [[EndStage alloc] initWithNibName:@"EndStage" bundle:nil];
    m_challengeEndController = [[ChallengeEndStage alloc] initWithNibName:@"ChallengeEndStage" bundle:nil];
    m_challengeController = [[ChallengeNavStage alloc] initial];
    m_challengeDoneController = [[ChallengeDone alloc] initWithNibName:@"ChallengeDone" bundle:nil];
    
    // initial the Parse
    [Parse setApplicationId:@"zKzUtc34Q5C5oiir18xXaVmr0bZURwkpCtPvMVhX"
                  clientKey:@"xE3b5ABct9BQpNitOnAxVuARVBao9jZYEuWLkCJW"];
    
    // regisit for push notification
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    // initial the NextPeer
    [Nextpeer initializeWithProductKey:NEXTPEER_KEY andDelegates:[NPDelegatesContainer containerWithNextpeerDelegate:self tournamentDelegate:self]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onSwitchStage:) name:@"SwitchStage" object:nil];
    
    [FacebookManager sharedInstance];
    
    return YES;
}

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:deviceToken];
    [PFPush subscribeToChannelInBackground:@""];
    
    if( [FacebookManager sharedInstance].IsAuthenticated )
    {
        [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
    }
}

- (void)_onProfileComplete
{
    NSString* channel = [NSString stringWithFormat:@"fb%@", [FacebookManager sharedInstance]._userInfo._uid];
    
    [PFPush subscribeToChannelInBackground:channel];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    //[PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [m_gameViewController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SwitchStage" object:nil];
}


/**
 * @desc    start the game
 */
- (void)startGame
{
    [self switchToView:m_gameViewController withCallback:@selector(_onStartGameDone)];
}


/**
 * @desc    end the game
 */
- (void)endGame
{
    //TODO 
}


// switch to the dest view
- (void)switchToView:(UIViewController*)destView withCallback:(SEL)callback
{
    destView.view.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:destView.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.6f animations:^{m_curUIView.alpha = 0.0f;} completion:^(BOOL finished)
     {
         [destView Initial];
         [UIView beginAnimations:nil context:nil];
         [UIView animateWithDuration:0.5f animations:^{ destView.view.alpha = 1.0f; } completion:^(BOOL finished)
          {
              [m_curUIView removeFromSuperview];
              m_curUIView = destView.view;
              
              //TODO 
              
              if( callback != nil )
              {
                  [self performSelector:callback];
              }
          }];
         [UIView commitAnimations];
     }];
    [UIView commitAnimations];
}


// on switch stage
- (void)_onSwitchStage:(NSNotification*)notification
{
    NSNumber* numberObj = [notification object];
    int type = [numberObj intValue];
    
    if( type == STAGE_MAINMENU )
    {
        [self switchToView:self.viewController withCallback:nil];
    }
    
    if( type == STAGE_GAME )
    {
        [self startGame];
    }
    
    if( type == STAGE_END )
    {
        [self switchToView:m_endViewController withCallback:nil];
    }
    
    if( type == STAGE_CHALLENGE_END )
    {
        [self switchToView:m_challengeEndController withCallback:nil];
    }
    
    if( type == STAGE_CHALLENGE )
    {
        [self switchToView:m_challengeController withCallback:nil];
    }
    
    if( type == STAGE_CHALLENGE_DONE )
    {
        [self switchToView:m_challengeDoneController withCallback:nil];
    }
    
}


// callback on gameStage animation complete
- (void)_onStartGameDone
{
    [m_gameViewController Start:[GlobalWork sharedInstance]._gameMode];
}


////////////////////////////////////////////////////////////
///
/// @note   This method will be called when a tournament is about to start.
///         The tournament start container will give you some details on the tournament which is about to be played.
///         For example the tournament uuid, name and time.
////////////////////////////////////////////////////////////
-(void)nextpeerDidTournamentStartWithDetails:(NPTournamentStartDataContainer *)tournamentContainer
{
    [GlobalWork sharedInstance]._gameMode = MUTI_MODE;
    [self startGame];
    
    NSLog( @"Tourname Started" );
}


////////////////////////////////////////////////////////////
///
/// @note   This method is invoked whenever the current tournament has finished.
///         In here you can place some cleanup code. For example, 
///			you can use this method to recycle the game scene.
///
////////////////////////////////////////////////////////////
-(void)nextpeerDidTournamentEnd
{
    [m_gameViewController End];
    [self switchToView:self.viewController withCallback:nil];
    
    NSLog( @"Tourname Ended" );
}


////////////////////////////////////////////////////////////
///
/// @note  This method will be called when Nextpeer has received a buffer from another player.
///		   You can use these buffers to create custom notifications and events while engaging the other players
///        that are currently playing. The container that is passed contains the sending user's name and image as well
///        as the message being sent.
///
////////////////////////////////////////////////////////////
-(void)nextpeerDidReceiveTournamentCustomMessage:(NPTournamentCustomMessageContainer*)message
{
    //TODO 
}


////////////////////////////////////////////////////////////
///
/// @note   This method is invoked whenever the current tournament has finished 
///			and the platform gathered the information from all the players.
///         It might take some time between the call to NextpeerDelegate's nextpeerDidTournamentEnd call to this,
///         as the platform retrieving the last result of each player. 
////////////////////////////////////////////////////////////
-(void)nextpeerDidReceiveTournamentResults:(NPTournamentEndDataContainer*)tournamentContainer
{
    //TODO 
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url  // Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
{
    return [[FacebookManager sharedInstance].Facebook handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2) // no equiv. notification. return NO if the application can't open for some reason
{
    return [[FacebookManager sharedInstance].Facebook handleOpenURL:url];
}


@end
