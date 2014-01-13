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
#import "TimeMachineTVC.h"
#import "DatePickerTVC.h"
#import <SHEmailValidator.h>

typedef NS_ENUM(NSInteger, SignUpCellType) {
    SignUpCellTypeFirstName,
    SignUpCellTypeLastName,
    SignUpCellTypeDOB,
    SignUpCellTypeEmail,
    SignUpCellTypePassword,
    SignUpCellTypeSignUp,
    SignUpCellTypeCount
};

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeOne,
    SectionTypeTwo,
    SectionTypeCount
};

@interface SignUpTVC () <DatePickerTVCDelegate>

@property (nonatomic, strong) NSMutableArray *localChangeObservers;
@property (nonatomic, strong) TextFieldCell *firstNameCell;
@property (nonatomic, strong) TextFieldCell *lastNameCell;
@property (nonatomic, strong) TextFieldCell *dobCell;
@property (nonatomic, strong) TextFieldCell *emailCell;
@property (nonatomic, strong) TextFieldCell *passwordCell;
@property (nonatomic, strong) SignUpCell *signUpCell;
@property (nonatomic, strong) NSDate *birthDate;

@end

@implementation SignUpTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SIGN_UP_VIEW_CONTROLLER_TITLE", @"Title for sign up view controller");
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
- (void)showTimeMachine{
    TimeMachineTVC *timeMachine = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeMachineTVC"];
    [self.navigationController setViewControllers:@[timeMachine] animated:YES];
}

- (void)signUpButtonTouched{
    [self showTimeMachine];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *signUpCellIdentifier = @"SignUpCell";
    static NSString *textFieldCellIdentifier = @"TextFieldCell";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case SectionTypeOne:
            cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier forIndexPath:indexPath];
            [self configureCell:(TextFieldCell *)cell atIndexPath:indexPath];
            break;
        case SectionTypeTwo: {
            cell = [tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier forIndexPath:indexPath];
            self.signUpCell = (SignUpCell *)cell;
            [self.signUpCell.signUpButton setTitle:NSLocalizedString(@"SIGN_UP_BUTTON_TITLE", @"Title for sign up button in sign up view controller")
                                         forState:UIControlStateNormal];
            [self.signUpCell.signUpButton addTarget:self action:@selector(signUpButtonTouched) forControlEvents:UIControlEventTouchUpInside];
            self.signUpCell.signUpButton.enabled = NO;
        }
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:SectionTypeOne]]) {
        [self performSegueWithIdentifier:@"DatePickerTVC" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:SectionTypeOne]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Convenience

- (void)configureCell:(TextFieldCell *)cell atIndexPath:(NSIndexPath *)path{
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        [self addNotificationToTextField:cell.textField];
    }
    
    switch (path.row) {
        case SignUpCellTypeFirstName:
            self.firstNameCell = cell;
            self.firstNameCell.label.text = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
            self.firstNameCell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
            break;
        case SignUpCellTypeLastName:
            self.lastNameCell = cell;
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
            self.emailCell.label.text = NSLocalizedString(@"EMAIL_CELL_TITLE", @"Label title for email in sign up view controller");
            self.emailCell.textField.placeholder = NSLocalizedString(@"EMAIL_NAME_CELL_TITLE", @"Label title for email in sign up view controller");
            break;
        case SignUpCellTypePassword:
            self.passwordCell = cell;
            self.passwordCell.label.text = NSLocalizedString(@"PASSWORD_CELL_TITLE", @"Label title for password in sign up view controller");
            self.passwordCell.textField.placeholder = NSLocalizedString(@"PASSWORD_NAME_CELL_TITLE", @"Label title for password in sign up view controller");
            break;
        default:
            break;
    }
}

- (void)addNotificationToTextField:(UITextField *)textField{
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                                    object:textField
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *note) {
                                                                    [self validatefields];
                                                                }];
    if (!self.localChangeObservers) {
        self.localChangeObservers = [[NSMutableArray alloc] init];
    }
    [self.localChangeObservers addObject:observer];
}

- (void)validatefields{
    self.signUpCell.signUpButton.enabled = YES;
    BOOL valid = YES;
    valid = self.firstNameCell.textField.text.length > 1 ? YES:NO;
    if (!valid) {
        self.signUpCell.signUpButton.enabled = NO;
    }
    valid = self.lastNameCell.textField.text.length > 1 ? YES:NO;
    if (!valid) {
        self.signUpCell.signUpButton.enabled = NO;
    }
    valid = self.birthDate ? YES:NO;
    if (!valid) {
        self.signUpCell.signUpButton.enabled = NO;
    }
    NSError *emailError;
    valid = [[SHEmailValidator validator] validateSyntaxOfEmailAddress:self.emailCell.textField.text withError:&emailError];
    if (!valid) {
        self.signUpCell.signUpButton.enabled = NO;
        [self.emailCell.textField setTextColor:[UIColor redColor]];
    } else {
        self.emailCell.textField.textColor = [UIColor blackColor];
    }
    valid = self.passwordCell.textField.text.length > 1 ? YES:NO;
    if (!valid) {
        self.signUpCell.signUpButton.enabled = NO;
    }
    

}

- (void)dealloc{
    for (NSObject *observer in self.localChangeObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
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
        [self validatefields];
    }];
}

- (void)datePickerDidCancel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
