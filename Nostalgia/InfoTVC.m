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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#warning LOCALIZE
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(toggleLogin:)];
    self.navigationItem.rightBarButtonItem = logout;
    [[PFUser currentUser] addObserver:self
                           forKeyPath:@"isAuthenticated"
                              options:0
                              context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"osberse");
    if ([keyPath isEqualToString:@"isAuthenticated"]) {
        NSLog(@"whoops");
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

//#pragma mark - UIAlertView Delegate
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//        case 0:
//            NSLog(@"did dimiss 0");
//            break;
//        case 1:
//            NSLog(@"did dismiss 1");
//            break;
//        default:
//            break;
//    }
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
