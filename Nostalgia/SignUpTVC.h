//
//  SignUpTVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SignUpTVCMode) {
    SignUpTVCModeSignUp,
    SignUpTVCModeLogin
};

@interface SignUpTVC : UITableViewController

@property SignUpTVCMode mode;

@end
