//
//  InfoTVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/22/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "InfoTVC.h"
#import "SignUpTVC.h"

@interface InfoTVC () //<UIAlertViewDelegate>

@property NSString *userName;
@property NSString *password;

@end

@implementation InfoTVC

- (id)initFromStoryboard{
    self = [SharedAppDelegate.storyboard instantiateViewControllerWithIdentifier:infoVCSegueIdentifier];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Info";
    self.textView.editable = NO;
    self.textView.backgroundColor = [UIColor darkGrayColor];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
    NSError *error;
    NSAttributedString *infoString = [[NSAttributedString alloc] initWithData:htmlData
                                                                      options:options
                                                           documentAttributes:nil
                                                                        error:&error];
    if (error) {
        NSLog(@"%@",error.debugDescription);
    }
    self.textView.attributedText = infoString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 [PFUser logOut];
 PFUser *currentUser = [PFUser currentUser]; // this will now be nil
*/
#pragma mark - Convenience

- (void)toggleLogin:(UIBarButtonItem *)logutBarButtonItem{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"is auth");
        [PFUser logOut];
        [logutBarButtonItem setTitle:@"Login"];
    } else {
        SignUpTVC *signUpTVC = [[SignUpTVC alloc] initWithCompletionBlock:^(SignInResult result, NSError *error) {
            switch (result) {
                case SignInResultSignedUp:
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    self.navigationItem.rightBarButtonItem.title = @"Logout";
                    break;
                case SignInResultLoggedIn:
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    self.navigationItem.rightBarButtonItem.title = @"Logout";
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
                case SignInResultCancelled:
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    break;
                default:
                    break;
            }
        }];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:signUpTVC];
        [self presentViewController:navVC animated:YES completion:NULL];
        
    }
}

- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password{
    [PFUser logInWithUsernameInBackground:userName
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            self.navigationItem.rightBarButtonItem.title = @"Logout";
                                        } else {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"Title for error alert view")
                                                                                            message:error.localizedFailureReason
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:nil
                                                                                  otherButtonTitles:NSLocalizedString(@"OK", @"OK text for alert view confirmations"), nil];
                                            [alert show];
                                        }
                                    }];
}

@end
