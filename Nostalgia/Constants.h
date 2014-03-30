//
//  Constants.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "AppDelegate.h"

#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

#define HelveticaNeueLight24 [UIFont fontWithName:@"HelveticaNeue-Light" size:24]
#define HelveticaNeueLight18 [UIFont fontWithName:@"HelveticaNeue-Light" size:18]
#define HelveticaNeueLight14 [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
#define HelveticaNeueLight12 [UIFont fontWithName:@"HelveticaNeue-Light" size:12];

extern NSString *const firstLaunchKey;

extern NSString *const songsPreferenceKey;
extern NSString *const moviesPreferenceKey;

extern NSString *const resultsCVCSegueIdentifier;
extern NSString *const songDetailSegueIdentifier;
extern NSString *const movieDetailSegueIdentifier;
extern NSString *const favoritesCVCSegueIdentifier;
extern NSString *const infoVCSegueIdentifier;
