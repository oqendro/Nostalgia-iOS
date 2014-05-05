//
//  AppDelegate.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 11/27/13.
//  Copyright (c) 2013 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) UIStoryboard *storyboard;

- (void)showCallout;

@end
