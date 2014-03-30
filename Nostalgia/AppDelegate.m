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
#import "ResultsCVC.h"
#import "FavoritesCVC.h"
#import "InfoTVC.h"
#import <RNFrostedSidebar.h>

typedef NS_ENUM(NSInteger, SideBarOption) {
    SideBarOption90s,
    SideBarOption80s,
    SideBarOption70s,
    SideBarOptionFavorites,
    SideBarOptionInfo,
    SideBarOptionLoginLogout
};

@interface AppDelegate () <RNFrostedSidebarDelegate>

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) ResultsCVC *resultsCVC;
@property BOOL resultsCVCVisible;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _storyboard = self.window.rootViewController.storyboard;

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

#pragma mark - Convenience

- (NSArray *)yearsForIndexSex:(NSMutableIndexSet *)indexSet{
    NSMutableArray *years = [NSMutableArray new];
    if ([indexSet containsIndex:SideBarOption90s]) {
        [years addObjectsFromArray:[self nineties]];
    }
    if ([indexSet containsIndex:SideBarOption80s]) {
        [years addObjectsFromArray:[self eighties]];
    }
    if ([indexSet containsIndex:SideBarOption70s]) {
        [years addObjectsFromArray:[self seventies]];
    }
    
    return years;
}

- (NSArray *)nineties{
    return @[@1990, @1991, @1992, @1993, @1994, @1995, @1996, @1997, @1998, @1999];
}
- (NSArray *)eighties{
    return @[@1980, @1981, @1982, @1983, @1984, @1985, @1986, @1987, @1988, @1989];
}
- (NSArray *)seventies{
    return @[@1970, @1971, @1972, @1973, @1974, @1975, @1976, @1977, @1978, @1979];
}

- (ResultsCVC *)resultsCVC{
    if (_resultsCVC) {
        return _resultsCVC;
    }
    ResultsCVC *aResultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
    aResultsCVC.managedObjectContext = self.coreDataStack.managedObjectContext;
    [self addSideBarButtonItemToViewController:aResultsCVC];
    _resultsCVC = aResultsCVC;
    self.resultsCVCVisible = YES;
    return _resultsCVC;
}

#pragma mark - RNFrostedSideBar

- (void)showCallout{
    NSArray *images;
    NSArray *colors;
    if ([PFUser currentUser]) {
        NSLog(@"cuurent user %@",[[PFUser currentUser] objectForKey:@"firstName"]);
        images = @[
                   [UIImage imageNamed:@"90s"],
                   [UIImage imageNamed:@"80s"],
                   [UIImage imageNamed:@"70s"],
                   [UIImage imageNamed:@"726-star-filled-white"],
                   [UIImage imageNamed:@"724-info-white"],
                   [UIImage imageNamed:@"769-male-white"],
                    ];
        colors = @[
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                   [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                   [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                   ];

    } else {
        images = @[
                   [UIImage imageNamed:@"90s"],
                   [UIImage imageNamed:@"80s"],
                   [UIImage imageNamed:@"70s"],
                   [UIImage imageNamed:@"726-star-filled-white"],
                   [UIImage imageNamed:@"724-info-white"],
                   [UIImage imageNamed:@"769-male-white"],
                   ];
        colors = @[
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                   [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                   [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                   [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                   ];
    }
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    callout.itemSize = CGSizeMake(60, 60);
    callout.delegate = self;
    [callout showInViewController:self.window.rootViewController animated:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index{
    switch (index) {
        case SideBarOption90s: {
            if (self.resultsCVCVisible) {
                //modify fetch
                if (itemEnabled) {
                    [self.optionIndices addIndex:index];
                } else {
                    [self.optionIndices removeIndex:index];
                }
                self.resultsCVC.years = [self yearsForIndexSex:self.optionIndices];
            } else {
                [self.optionIndices removeAllIndexes];
                [self.optionIndices addIndex:index];
                // set Results VC
                [sidebar dismissAnimated:YES];
                self.resultsCVCVisible = YES;
                self.resultsCVC.years = [self nineties];
                [self changeRootVCWithViewController:self.resultsCVC];
            }
        }
            break;
        case SideBarOption80s: {
            if (self.resultsCVCVisible) {
                //modify fetch
                if (itemEnabled) {
                    [self.optionIndices addIndex:index];
                } else {
                    [self.optionIndices removeIndex:index];
                }
                self.resultsCVC.years = [self yearsForIndexSex:self.optionIndices];
            } else {
                [self.optionIndices removeAllIndexes];
                [self.optionIndices addIndex:index];
                // set Results VC
                [sidebar dismissAnimated:YES];
                self.resultsCVCVisible = YES;
                self.resultsCVC.years = [self eighties];
                [self changeRootVCWithViewController:self.resultsCVC];
            }
        }
            break;
        case SideBarOption70s: {
            if (self.resultsCVCVisible) {
                //modify fetch
                if (itemEnabled) {
                    [self.optionIndices addIndex:index];
                } else {
                    [self.optionIndices removeIndex:index];
                }
                self.resultsCVC.years = [self yearsForIndexSex:self.optionIndices];
            } else {
                [self.optionIndices removeAllIndexes];
                [self.optionIndices addIndex:index];
                // set Results VC
                [sidebar dismissAnimated:YES];
                self.resultsCVCVisible = YES;
                self.resultsCVC.years = [self seventies];
                [self changeRootVCWithViewController:self.resultsCVC];
            }
        }
            break;
        case SideBarOptionFavorites: {
            if ([PFUser currentUser]) {
                [self.optionIndices removeAllIndexes];
                [self.optionIndices addIndex:index];
                [sidebar dismissAnimated:YES];
                self.resultsCVCVisible = NO;
                FavoritesCVC *favoritesCVC = [[FavoritesCVC alloc] initFromStoryboard];
                [self addSideBarButtonItemToViewController:favoritesCVC];
                [self changeRootVCWithViewController:favoritesCVC];
            } else {
#warning LOCALIZE
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Available"
                                                                message:@"You must sign in to be able to use the Favorites feature."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case SideBarOptionInfo: {
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            [sidebar dismissAnimated:YES];
            InfoTVC *favoritesCVC = [[InfoTVC alloc] initFromStoryboard];
            self.resultsCVCVisible = NO;
            [self addSideBarButtonItemToViewController:favoritesCVC];
            [self changeRootVCWithViewController:favoritesCVC];
        }
            break;
        case SideBarOptionLoginLogout: {
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            if ([PFUser currentUser]) {
                NSLog(@"lougout");
            } else {
                SignUpTVC *signupTVC = [[SignUpTVC alloc] initWithCompletionBlock:^(SignInResult result, NSError *error) {
                    switch (result) {
                        case SignInResultCancelled:
                            //
                            break;
                        case SignInResultFailed:
                            break;
                        case SignInResultLoggedIn: {
                            [self.optionIndices removeAllIndexes];
                            [self.optionIndices addIndex:index];
                            // set Results VC
                            self.resultsCVC.years = [self nineties];
                            [self changeRootVCWithViewController:self.resultsCVC];
                        }
                            break;
                        case SignInResultSignedUp: {
                            [self.optionIndices removeAllIndexes];
                            [self.optionIndices addIndex:index];
                            // set Results VC
                            self.resultsCVC.years = [self nineties];
                            [self changeRootVCWithViewController:self.resultsCVC];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                signupTVC.hidesCancelButton = YES;
                [self changeRootVCWithViewController:signupTVC];
                [self addSideBarButtonItemToViewController:signupTVC];
                [sidebar dismissAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
    NSLog(@"%@",self.resultsCVC.years);
}

#pragma mark - Setup/Nav

- (void)setupInitialVC{
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:SideBarOption90s];

    if ([PFUser currentUser]) {
        [self changeRootVCWithViewController:self.resultsCVC];
    } else {
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        SignUpTVC *signUpVC = (SignUpTVC *)navVC.topViewController;
        [self addSideBarButtonItemToViewController:signUpVC];
        signUpVC.hidesCancelButton = YES;
        SignInBlock block = ^ void (SignInResult result, NSError *error) {
            switch (result) {
                case SignInResultSignedUp: {
                    ResultsCVC *resultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
                    resultsCVC.managedObjectContext = self.coreDataStack.managedObjectContext;
                    [self addSideBarButtonItemToViewController:resultsCVC];
                    [self changeRootVCWithViewController:resultsCVC];
                }
                    break;
                case SignInResultLoggedIn: {
                    ResultsCVC *resultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
                    resultsCVC.managedObjectContext = self.coreDataStack.managedObjectContext;
                    [self addSideBarButtonItemToViewController:resultsCVC];
                    [self changeRootVCWithViewController:resultsCVC];
                }
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

- (void)changeRootVCWithViewController:(UIViewController *)viewController{
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [navController setViewControllers:@[viewController] animated:NO];
}

- (void)addSideBarButtonItemToViewController:(UIViewController *)viewController{
    UIBarButtonItem *sideCalloutBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"729-top-list-white"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showCallout)];
    viewController.navigationItem.leftBarButtonItem = sideCalloutBarButtonItem;
}

- (BOOL)isTopViewController:(Class)class{
    UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
    NSLog(@"its %@",navVC.topViewController);
    if ([navVC.topViewController isKindOfClass:class]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)topViewController{
    UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
    return navVC.topViewController;
}
@end
