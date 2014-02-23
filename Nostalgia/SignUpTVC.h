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

typedef NS_ENUM(NSInteger, SignInResult) {
    SignInResultSignedUp,
    SignInResultLoggedIn,
    SignInResultCancelled,
    SignInResultFailed
};

typedef void (^SignInBlock)(SignInResult result, NSError *error);

@interface SignUpTVC : UITableViewController

@property BOOL hidesCancelButton;
@property (nonatomic, copy) SignInBlock completionBlock;

- (instancetype)initWithCompletionBlock:(SignInBlock)block;

@end

