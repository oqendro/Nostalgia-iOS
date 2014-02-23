//
//  AppDelegate.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 11/27/13.
//  Copyright (c) 2013 placeholder. All rights reserved.
//

#import "AppDelegate.h"
#import "DataLoader.h"
#import "SignUpTVC.h"
#import "TimeMachineTVC.h"
#import "FavoritesCVC.h"
#import "InfoTVC.h"

@implementation AppDelegate

- (void)setupInitialVC{
    UITabBarController *tabBarController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    UITabBarItem *timeMachineTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TIME_MACHINE_TITLE", @"Title for time machine view controller")
                                                                        image:[UIImage imageNamed:@"798-filter-gray"]
                                                                          tag:0];
    UITabBarItem *favoritesTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"FAVORITES_TITLE", @"Title for favorites View Controller")
                                                                      image:[UIImage imageNamed:@"726-star-gray"]
                                                                        tag:1];
    UITabBarItem *infoTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"INFO_TITLE", @"Title of detail view controllers that says Info")
                                                                    image:[UIImage imageNamed:@"724-info-gray"]
                                                                    tag:1];

    TimeMachineTVC *timeMachineVC = (TimeMachineTVC *)[tabBarController.viewControllers[0] topViewController];
    timeMachineVC.user = [PFUser currentUser];
    timeMachineVC.tabBarItem = timeMachineTabBarItem;
    
    FavoritesCVC *favoritesVC = (FavoritesCVC *)tabBarController.viewControllers[1];
    favoritesVC.tabBarItem = favoritesTabbarItem;

    InfoTVC *infoTVC = (InfoTVC *)[tabBarController.viewControllers[2] topViewController];
    infoTVC.tabBarItem = infoTabbarItem;
    if ([PFUser currentUser]) {
        [self changeRootVCWithTabBarController:tabBarController];
    } else{
        
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        SignUpTVC *signUpVC = (SignUpTVC *)navVC.topViewController;
        signUpVC.hidesCancelButton = YES;
        SignInBlock block = ^ void (SignInResult result, NSError *error) {
            switch (result) {
                case SignInResultSignedUp:
                    [self changeRootVCWithTabBarController:tabBarController];
                    break;
                case SignInResultLoggedIn:
                    [self changeRootVCWithTabBarController:tabBarController];
                    break;
                case SignInResultFailed: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"Title for error alert view")
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK text for alert view confirmations"), nil];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        };
        signUpVC.completionBlock = block;
    }
}

- (void)changeRootVCWithTabBarController:(UITabBarController *)tabBarController{
    [UIView transitionWithView:SharedAppDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        SharedAppDelegate.window.rootViewController = tabBarController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:NULL];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *defaults = @{songsPreferenceKey: @YES, moviesPreferenceKey: @YES};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	_coreDataStack = [[DCTCoreDataStack alloc] initWithStoreFilename:@"Nostalgia"];
    [DataLoader setupParseWithLaunchOptions:launchOptions];
    [self setupInitialVC];
 
    return YES;
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
}


@end
