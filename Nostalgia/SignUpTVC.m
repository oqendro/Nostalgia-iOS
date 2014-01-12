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

typedef NS_ENUM(NSInteger, SignUpCellType) {
    SignUpCellTypeFirstName,
    SignUpCellTypeLastName,
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

@interface SignUpTVC ()

@property (nonatomic, strong) NSMutableArray *localChangeObservers;

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
                SignUpCell *signUpCell = (SignUpCell *)cell;
                [signUpCell.signUpButton setTitle:NSLocalizedString(@"SIGN_UP_BUTTON_TITLE", @"Title for sign up button in sign up view controller")
                                         forState:UIControlStateNormal];
                [signUpCell.signUpButton addTarget:self action:@selector(signUpButtonTouched) forControlEvents:UIControlEventTouchUpInside];
            }
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void)configureCell:(TextFieldCell *)cell atIndexPath:(NSIndexPath *)path{
    [self addNotificationToTextField:cell.textField];
    switch (path.row) {
            case SignUpCellTypeFirstName:
            cell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
            break;
            case SignUpCellTypeLastName:
            cell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
            break;
            case SignUpCellTypeEmail:
            cell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
            break;
            case SignUpCellTypePassword:
            cell.textField.placeholder = NSLocalizedString(@"FIRST_NAME_CELL_TITLE", @"Label title for first name in sign up view controller");
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
                                                                    //
                                                                }];
    if (!self.localChangeObservers) {
        self.localChangeObservers = [[NSMutableArray alloc] init];
    }
    [self.localChangeObservers addObject:observer];
}

- (void)validatefields{
    BOOL valid = YES;
    
    NSArray *cells = [self.tableView visibleCells];
    for (TextFieldCell *cell in cells) {
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        switch (path.row) {
                case SignUpCellTypeFirstName:
                valid = cell.textField.text.length > 1 ? YES:NO;
                NSLog(@"valid %i",valid);
                break;
                case SignUpCellTypeLastName:
                break;
                case SignUpCellTypeEmail:
                break;
                case SignUpCellTypePassword:
                break;
            default:
                break;
        }
    }
}

- (void)dealloc{
    for (NSObject *observer in self.localChangeObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}
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
