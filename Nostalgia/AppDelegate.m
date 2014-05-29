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
#import <UIAlertView+BlocksKit.h>

typedef NS_ENUM(NSInteger, SideBarOption) {
    SideBarOption00s,
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

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _storyboard = self.window.rootViewController.storyboard;

    NSDictionary *defaults = @{songsPreferenceKey: @YES, moviesPreferenceKey: @YES};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Nostalgia"];
    [DataLoader setupParseWithLaunchOptions:launchOptions];
    [self setupInitialVC];
 
    return YES;
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

- (NSArray *)twoThousands {
    return @[@2000, @2001, @2002, @2003, @2004, @2005, @2006, @2007, @2008, @2009];
}
- (NSArray *)nineties {
    return @[@1990, @1991, @1992, @1993, @1994, @1995, @1996, @1997, @1998, @1999];
}
- (NSArray *)eighties {
    return @[@1980, @1981, @1982, @1983, @1984, @1985, @1986, @1987, @1988, @1989];
}
- (NSArray *)seventies {
    return @[@1970, @1971, @1972, @1973, @1974, @1975, @1976, @1977, @1978, @1979];
}

- (ResultsCVC *)resultsCVC{
    if (_resultsCVC) {
        return _resultsCVC;
    }
    ResultsCVC *aResultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
    aResultsCVC.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    [self addSideBarButtonItemToViewController:aResultsCVC];
    _resultsCVC = aResultsCVC;
    return _resultsCVC;
}

#pragma mark - RNFrostedSideBar

- (void)showCallout{
    NSArray *images;
    NSArray *colors;
    
    images = @[
               [UIImage imageNamed:@"00s"],
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
               [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
               [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
               [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
               [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
               ];

    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    callout.itemSize = CGSizeMake(60, 60);
    callout.delegate = self;
    [callout showInViewController:self.window.rootViewController animated:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    switch (index) {
        case SideBarOption00s: {
            NSLog(@"switch 00's");
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
//                self.resultsCVC.filterOptions = self.resultsCVC.filterOptions & ResultsCVCFilterOption00s;
            self.resultsCVC.filterOptions = ResultsCVCFilterOption00s;
            [self changeRootVCWithViewController:self.resultsCVC];
        }
            break;
        case SideBarOption90s: {
            NSLog(@"switch 90's");
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            self.resultsCVC.filterOptions = ResultsCVCFilterOption90s;
            [self changeRootVCWithViewController:self.resultsCVC];
        }            break;
        case SideBarOption80s: {
            NSLog(@"switch 80's");
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            self.resultsCVC.filterOptions = ResultsCVCFilterOption80s;
            [self changeRootVCWithViewController:self.resultsCVC];
        }
            break;
        case SideBarOption70s: {
            NSLog(@"switch 70's");
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            self.resultsCVC.filterOptions = ResultsCVCFilterOption70s;
            [self changeRootVCWithViewController:self.resultsCVC];
        }
            break;
        case SideBarOptionFavorites: {
            if ([PFUser currentUser]) {
                [self.optionIndices removeAllIndexes];
                [self.optionIndices addIndex:index];
                [sidebar dismissAnimated:YES];
                FavoritesCVC *favoritesCVC = [[FavoritesCVC alloc] initFromStoryboard];
                [self addSideBarButtonItemToViewController:favoritesCVC];
                [self changeRootVCWithViewController:favoritesCVC];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOT_AVAILABLE_TITLE", nil)
                                                                message:NSLocalizedString(@"SIGNIN_REQUIRED_MESSAGE", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
            [self addSideBarButtonItemToViewController:favoritesCVC];
            [self changeRootVCWithViewController:favoritesCVC];
        }
            break;
        case SideBarOptionLoginLogout: {
            [self.optionIndices removeAllIndexes];
            [self.optionIndices addIndex:index];
            if ([PFUser currentUser]) {
                [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"LOGOUT", nil)
                                               message:NSLocalizedString(@"LOGOUT_MESSAGE", nil)
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@[NSLocalizedString(@"LOGOUT", nil), NSLocalizedString(@"CANCEL", comment)]
                                               handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                   switch (buttonIndex) {
                                                       case 0: {
                                                           [PFUser logOut];
                                                       }
                                                           break;
                                                       default:
                                                           break;
                                                   }
                                               }];
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
                            [self.optionIndices addIndex:ResultsCVCFilterOption00s];
                            self.resultsCVC.filterOptions = ResultsCVCFilterOption00s;
                            [self changeRootVCWithViewController:self.resultsCVC];
                        }
                            break;
                        case SignInResultSignedUp: {
                            [self.optionIndices removeAllIndexes];
                            [self.optionIndices addIndex:ResultsCVCFilterOption00s];
                            self.resultsCVC.filterOptions = ResultsCVCFilterOption00s;
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
    [sidebar dismissAnimated:YES];

}

#pragma mark - Setup/Nav

- (void)setupInitialVC{
    self.optionIndices = [NSMutableIndexSet indexSet];

    if ([PFUser currentUser]) {
        [self.optionIndices addIndex:ResultsCVCFilterOption00s];
        self.resultsCVC.filterOptions = ResultsCVCFilterOption00s;
        [self changeRootVCWithViewController:self.resultsCVC];
    } else {
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        SignUpTVC *signUpVC = (SignUpTVC *)navVC.topViewController;
        // add ability to skip sign up
        UIBarButtonItem *skipSignUp = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SKIP_LOGIN", @"Title of skip login button")
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showCallout)];
        signUpVC.navigationItem.rightBarButtonItem = skipSignUp;
        
        signUpVC.hidesCancelButton = YES;
        SignInBlock block = ^ void (SignInResult result, NSError *error) {
            switch (result) {
                case SignInResultSignedUp: {
                    ResultsCVC *resultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
                    resultsCVC.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
                    [self addSideBarButtonItemToViewController:resultsCVC];
                    [self changeRootVCWithViewController:resultsCVC];
                }
                    break;
                case SignInResultLoggedIn: {
                    ResultsCVC *resultsCVC = [[ResultsCVC alloc] initFromDefaultStoryboardWithYears:[self nineties]];
                    resultsCVC.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
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
    if (viewController == navController.topViewController) {
        return;
    }

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
