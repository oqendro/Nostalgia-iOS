//
//  SignUpTVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "SignUpTVC.h"
#import "TextFieldCell.h"
#import "SignUpCell.h"
#import <SHEmailValidator.h>
#import "DatePickerTVC.h"

typedef NS_ENUM(NSInteger, SignUpCellType) {
    SignUpCellTypeUsername,
    SignUpCellTypeFirstName,
    SignUpCellTypeLastName,
    SignUpCellTypeDOB,
    SignUpCellTypeEmail,
    SignUpCellTypePassword,
    SignUpCellTypeSignUpLogin,
    SignUpCellTypeCount
};

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeOne,
    SectionTypeTwo,
    SectionTypeCount
};

static NSInteger numberOfCharactersRequired = 1;

@interface SignUpTVC () <DatePickerTVCDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *localChangeObservers;
@property (nonatomic, strong) TextFieldCell *userNameCell;
@property (nonatomic, strong) TextFieldCell *firstNameCell;
@property (nonatomic, strong) TextFieldCell *lastNameCell;
@property (nonatomic, strong) TextFieldCell *dobCell;
@property (nonatomic, strong) TextFieldCell *emailCell;
@property (nonatomic, strong) TextFieldCell *passwordCell;
@property (nonatomic, strong) SignUpCell *signUpLoginCell;
@property (nonatomic, strong) NSDate *birthDate;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;
@property SignUpTVCMode mode;

@end

static NSString *signUpCellIdentifier = @"SignUpCell";
static NSString *textFieldCellIdentifier = @"TextFieldCell";
#warning USE HUD to disable view when login pushede
@implementation SignUpTVC

- (instancetype)initWithCompletionBlock:(SignInBlock)block{
    self = [super init];
    if (self) {
        if (block) {
            self.completionBlock = block;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.title = NSLocalizedString(@"SIGN_UP_VIEW_CONTROLLER_TITLE", @"Title for sign up view controller");
    [self.tableView registerNib:[UINib nibWithNibName:signUpCellIdentifier bundle:nil]
         forCellReuseIdentifier:signUpCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:textFieldCellIdentifier bundle:nil]
         forCellReuseIdentifier:textFieldCellIdentifier];
    
    if (!self.hidesCancelButton) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelSignUp)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupUI];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DatePickerTVC"]) {
        UINavigationController *navController = segue.destinationViewController;
        DatePickerTVC *datePickerTVC = (DatePickerTVC *)navController.topViewController;
        datePickerTVC.delegate = self;
    }
}

- (void)setupUI{
    self.userNameCell.textField.returnKeyType = UIReturnKeyNext;
    self.userNameCell.textField.enablesReturnKeyAutomatically = YES;
    self.userNameCell.textField.delegate = self;
    self.firstNameCell.textField.returnKeyType = UIReturnKeyNext;
    self.firstNameCell.textField.enablesReturnKeyAutomatically = YES;
    self.firstNameCell.textField.delegate = self;
    self.lastNameCell.textField.returnKeyType = UIReturnKeyNext;
    self.lastNameCell.textField.enablesReturnKeyAutomatically = YES;
    self.lastNameCell.textField.delegate = self;
    self.emailCell.textField.returnKeyType = UIReturnKeyNext;
    self.emailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailCell.textField.enablesReturnKeyAutomatically = YES;
    self.emailCell.textField.delegate = self;
    self.passwordCell.textField.returnKeyType = UIReturnKeyDone;
    self.passwordCell.textField.enablesReturnKeyAutomatically = YES;
    self.passwordCell.textField.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.mode) {
        case SignUpTVCModeSignUp: {
            switch (section) {
                case SectionTypeOne:
                    return SignUpCellTypeCount-1;
                    break;
                case SectionTypeTwo:
                    return 1;
                default:
                    return 0;
                    break;
            }
        }
            break;
        case SignUpTVCModeLogin: {
            switch (section) {
                case SectionTypeOne:
                    return 2;
                    break;
                case SectionTypeTwo:
                    return 1;
                default:
                    return 0;
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case SectionTypeOne:
            cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier forIndexPath:indexPath];
            [self configureCell:(TextFieldCell *)cell atIndexPath:indexPath];
            break;
        case SectionTypeTwo: {
            cell = [tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier forIndexPath:indexPath];
            self.signUpLoginCell = (SignUpCell *)cell;
            if (self.mode == SignUpTVCModeSignUp) {
                self.signUpLoginCell.label.text = NSLocalizedString(@"SIGN_UP_TEXT", @"Text of toggle button that indicates sign up VC will toggle to sing up mode");
            } else {
                self.signUpLoginCell.label.text = NSLocalizedString(@"LOGIN_TEXT", @"Text of toggle button that indicates sign up VC will toggle to login mode");
            }
            self.signUpLoginCell.label.enabled = NO;
            self.signUpLoginCell.userInteractionEnabled = NO;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == SectionTypeTwo) {
        return 44;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == SectionTypeTwo) {
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.toggleButton = toggleButton;
        switch (self.mode) {
            case SignUpTVCModeSignUp:
                [self.toggleButton setTitle:NSLocalizedString(@"LOGIN_TEXT", @"Text of toggle button that indicates sign up VC will toggle to login mode") forState:UIControlStateNormal];
                break;
            case SignUpTVCModeLogin:
                [self.toggleButton setTitle:NSLocalizedString(@"SIGN_UP_TEXT", @"Text of toggle button that indicates sign up VC will toggle to sing up mode") forState:UIControlStateNormal];
            default:
                break;
        }
        [self.toggleButton addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventTouchUpInside];
        return self.toggleButton;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:SectionTypeOne]]) {
        [self performSegueWithIdentifier:@"DatePickerTVC" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:SectionTypeTwo]]) {
        switch (self.mode) {
            case SignUpTVCModeSignUp:
                [self signUpUser];
                break;
            case SignUpTVCModeLogin:
                [self loginUser];
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:SectionTypeOne]] ||
        [indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:SectionTypeTwo]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Convenience

- (void)toggleMode:(UIButton *)button{
    NSIndexPath *firstNameIndexPath = [NSIndexPath indexPathForRow:SignUpCellTypeFirstName inSection:0];
    NSIndexPath *lastNameIndexPath = [NSIndexPath indexPathForRow:SignUpCellTypeLastName inSection:0];
    NSIndexPath *dateOfBirthIndexPath = [NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:0];
    NSIndexPath *emailIndexPath = [NSIndexPath indexPathForRow:SignUpCellTypeEmail inSection:0];
    NSArray *indexPaths = @[firstNameIndexPath,lastNameIndexPath,dateOfBirthIndexPath,emailIndexPath];
    NSIndexPath *signUpLoginIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];

    switch (self.mode) {
        case SignUpTVCModeSignUp: {
            self.mode = SignUpTVCModeLogin;
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:@[signUpLoginIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
            break;
        case SignUpTVCModeLogin: {
            self.mode = SignUpTVCModeSignUp;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadRowsAtIndexPaths:@[signUpLoginIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
            break;
        default:
            break;
    }
}

#warning PUT IN CONSTANTS
- (void)signUpUser{
    PFUser *user = [PFUser user];
    user.username = self.userNameCell.textField.text;
    user.password = self.passwordCell.textField.text;
    user.email = self.emailCell.textField.text;
    
    user[@"firstName"] = self.firstNameCell.textField.text;
    user[@"lastName"] = self.lastNameCell.textField.text;
    user[@"birthDate"] = self.birthDate;
    
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.completionBlock(SignInResultSignedUp, nil);
        } else {
            self.completionBlock(SignInResultFailed, error);
        }
    }];
}

- (void)loginUser{
    [PFUser logInWithUsernameInBackground:self.userNameCell.textField.text password:self.passwordCell.textField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (!error) {
                                            self.completionBlock(SignInResultLoggedIn, nil);
                                        } else {
                                            self.completionBlock(SignInResultFailed, error);
                                        }
                                    }];
}

- (void)cancelSignUp{
    self.completionBlock (SignInResultCancelled, nil);
}

- (void)configureCell:(TextFieldCell *)cell atIndexPath:(NSIndexPath *)path{
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        [self addNotificationToTextField:cell.textField];
    }
    switch (self.mode) {
        case SignUpTVCModeSignUp: {
            switch (path.row) {
                case SignUpCellTypeUsername:
                    self.userNameCell = cell;
                    self.userNameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    self.userNameCell.label.text = NSLocalizedString(@"USER_NAME_CELL_TITLE", @"Label title for username in sign up view controller");
                    self.userNameCell.textField.placeholder = NSLocalizedString(@"USER_NAME_CELL_TITLE", @"Label title for username in sign up view controller");
                    break;
                case SignUpCellTypeFirstName:
                    self.firstNameCell = cell;
                    self.firstNameCell.label.text = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
                    self.firstNameCell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
                    break;
                case SignUpCellTypeLastName:
                    self.lastNameCell = cell;
                    self.lastNameCell.textField.userInteractionEnabled = YES;
                    self.lastNameCell.label.text = NSLocalizedString(@"LAST_NAME_CELL_TITLE", @"Label title for last name in sign up view controller");
                    self.lastNameCell.textField.placeholder = NSLocalizedString(@"LAST_NAME_CELL_TITLE", @"Label title for last name in sign up view controller");
                    break;
                case SignUpCellTypeDOB:
                    self.dobCell = cell;
                    self.dobCell.textField.userInteractionEnabled = NO;
                    self.dobCell.label.text = NSLocalizedString(@"BIRTHDAY_CELL_TITLE", @"Label title for birthday cell in sign up view controller");
                    cell.textField.placeholder = NSLocalizedString(@"SELECT_BIRTHDAY_CELL_DETAIL_TEXT", @"Text that says please select your birthday in sign up view controller");
                    break;
                case SignUpCellTypeEmail:
                    self.emailCell = cell;
                    self.emailCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    self.emailCell.label.text = NSLocalizedString(@"EMAIL_CELL_TITLE", @"Label title for email in sign up view controller");
                    self.emailCell.textField.placeholder = NSLocalizedString(@"EMAIL_NAME_CELL_TITLE", @"Label title for email in sign up view controller");
                    break;
                case SignUpCellTypePassword:
                    self.passwordCell = cell;
                    self.passwordCell.label.text = NSLocalizedString(@"PASSWORD_CELL_TITLE", @"Label title for password in sign up view controller");
                    self.passwordCell.textField.secureTextEntry = YES;
                    self.passwordCell.textField.placeholder = NSLocalizedString(@"PASSWORD_NAME_CELL_TITLE", @"Label title for password in sign up view controller");
                    break;
                default:
                    break;
            }
        }
            break;
        case SignUpTVCModeLogin: {
            switch (path.row) {
                case SignUpCellTypeUsername:
                    self.userNameCell = cell;
                    self.userNameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    self.userNameCell.label.text = NSLocalizedString(@"USER_NAME_CELL_TITLE", @"Label title for username in sign up view controller");
                    self.userNameCell.textField.placeholder = NSLocalizedString(@"USER_NAME_CELL_TITLE", @"Label title for username in sign up view controller");
                    break;
                case 1:
                    self.passwordCell = cell;
                    self.passwordCell.label.text = NSLocalizedString(@"PASSWORD_CELL_TITLE", @"Label title for password in sign up view controller");
                    self.passwordCell.textField.secureTextEntry = YES;
                    self.passwordCell.textField.placeholder = NSLocalizedString(@"PASSWORD_NAME_CELL_TITLE", @"Label title for password in sign up view controller");
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}

- (void)addNotificationToTextField:(UITextField *)textField{
    __weak SignUpTVC *weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                                    object:textField
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *note) {
                                                                    [weakSelf validatefieldsWithWeakSelf:weakSelf];
                                                                }];
    if (!self.localChangeObservers) {
        self.localChangeObservers = [[NSMutableArray alloc] init];
    }
    [self.localChangeObservers addObject:observer];
}

- (void)validatefieldsWithWeakSelf:(SignUpTVC *)weakSelf{
    NSError *error;
    switch (weakSelf.mode) {
        case SignUpTVCModeSignUp: {
            if (weakSelf.userNameCell.textField.text.length >= numberOfCharactersRequired &&
                weakSelf.firstNameCell.textField.text.length >= numberOfCharactersRequired &&
                weakSelf.lastNameCell.textField.text.length >= numberOfCharactersRequired &&
                weakSelf.birthDate &&
                weakSelf.emailCell.textField.text.length >= numberOfCharactersRequired &&
                weakSelf.passwordCell.textField.text.length >= numberOfCharactersRequired &&
                [[SHEmailValidator validator] validateSyntaxOfEmailAddress:weakSelf.emailCell.textField.text withError:&error]) {
                
                weakSelf.signUpLoginCell.label.enabled = YES;
                weakSelf.signUpLoginCell.userInteractionEnabled = YES;
                weakSelf.signUpLoginCell.backgroundColor = [UIColor orangeColor];
            } else {
                weakSelf.signUpLoginCell.label.enabled = NO;;
                weakSelf.signUpLoginCell.userInteractionEnabled = NO;
                weakSelf.signUpLoginCell.backgroundColor = [UIColor whiteColor];
            }
        }
            break;
        case SignUpTVCModeLogin: {
            if (weakSelf.userNameCell.textField.text.length >= numberOfCharactersRequired &&
                weakSelf.passwordCell.textField.text.length >= numberOfCharactersRequired) {
                weakSelf.signUpLoginCell.label.enabled = YES;
                weakSelf.signUpLoginCell.userInteractionEnabled = YES;
                weakSelf.signUpLoginCell.backgroundColor = [UIColor orangeColor];
            } else {
                weakSelf.signUpLoginCell.label.enabled = NO;;
                weakSelf.signUpLoginCell.userInteractionEnabled = NO;
                weakSelf.signUpLoginCell.backgroundColor = [UIColor whiteColor];
            }
        }
            break;
        default:
            break;
    }
}


- (void)dealloc{
    for (NSObject *observer in self.localChangeObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

#pragma mark - UITextfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.firstNameCell.textField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.firstNameCell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
    if (textField == self.lastNameCell.textField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.lastNameCell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
    if (textField == self.dobCell.textField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.dobCell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
    if (textField == self.emailCell.textField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.emailCell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
    if (textField == self.passwordCell.textField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.passwordCell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (self.mode) {
        case SignUpTVCModeSignUp: {
            if (textField == self.userNameCell.textField) {
                [self.firstNameCell.textField becomeFirstResponder];
            }
            if (textField == self.firstNameCell.textField) {
                [self.lastNameCell.textField becomeFirstResponder];
            }
            if (textField == self.lastNameCell.textField) {
                [self performSegueWithIdentifier:@"DatePickerTVC" sender:nil];
            }
            if (textField == self.dobCell.textField) {
            }
            if (textField == self.emailCell.textField) {
                [self.passwordCell.textField becomeFirstResponder];
            }
            if (textField == self.passwordCell.textField) {
                [textField resignFirstResponder];
                [self signUpUser];
            }
        }
            break;
        case SignUpTVCModeLogin: {
            if (textField == self.userNameCell.textField) {
                [self.passwordCell.textField becomeFirstResponder];
            }
            if (textField == self.passwordCell.textField) {
                [textField resignFirstResponder];
                [self loginUser];
            }
        }
        default:
            break;
    }
    return YES;
}

#pragma mark - DatePicker Delegate

- (void)datePickerDidFinishWithDate:(NSDate *)birthdate{
    if (birthdate) {
        self.birthDate = birthdate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        self.dobCell.textField.text = [dateFormatter stringFromDate:birthdate];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self validatefieldsWithWeakSelf:self];
        [self.emailCell.textField becomeFirstResponder];
    }];
}

- (void)datePickerDidCancel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
