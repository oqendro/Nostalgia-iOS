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

static NSInteger numberOfCharactersRequired = 1;

@interface SignUpTVC () <DatePickerTVCDelegate, UITextFieldDelegate>

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
            self.signUpCell.label.text = NSLocalizedString(@"SIGN_UP_BUTTON_TITLE", @"Title for sign up button in sign up view controller");
            self.signUpCell.label.enabled = NO;
        }
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:SignUpCellTypeDOB inSection:SectionTypeOne]]) {
        [self performSegueWithIdentifier:@"DatePickerTVC" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:SectionTypeTwo]]) {
        [self signUp];
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
    if (weakSelf.firstNameCell.textField.text.length >= numberOfCharactersRequired &&
        weakSelf.lastNameCell.textField.text.length >= numberOfCharactersRequired &&
        weakSelf.birthDate &&
        weakSelf.emailCell.textField.text.length >= numberOfCharactersRequired &&
        weakSelf.passwordCell.textField.text.length >= numberOfCharactersRequired &&
        [[SHEmailValidator validator] validateSyntaxOfEmailAddress:weakSelf.emailCell.textField.text withError:&error]) {
        
        weakSelf.signUpCell.label.enabled = YES;
        weakSelf.signUpCell.userInteractionEnabled = YES;
        weakSelf.signUpCell.backgroundColor = [UIColor orangeColor];
    } else {
        weakSelf.signUpCell.label.enabled = NO;;
        weakSelf.signUpCell.userInteractionEnabled = NO;
        weakSelf.signUpCell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)signUp{
    TimeMachineTVC *timeMachineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeMachineTVC"];
    timeMachineVC.user  = @{@"birthDate": self.birthDate};
    [self.navigationController setViewControllers:@[timeMachineVC] animated:YES];
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
        [self signUp];
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
