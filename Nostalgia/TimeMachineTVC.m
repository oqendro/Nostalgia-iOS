//
//  TimeMachineTVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "TimeMachineTVC.h"
#import "ResultsCVC.h"

@interface TimeMachineTVC ()

@property (nonatomic, strong) NSArray *selectableYears;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSNumber *selectedYear;
@end


@implementation TimeMachineTVC


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
    self.title = NSLocalizedString(@"TIME_MACHINE_TITLE", @"Title for time machine view controller");
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showResults)];
    next.enabled = NO;
    self.navigationItem.rightBarButtonItem = next;
    self.selectableYears = [self yearsForUser];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ResultsCVC"]) {
        ResultsCVC *destinationVC = segue.destinationViewController;
        destinationVC.year = [[self.selectableYears objectAtIndex:[self.tableView indexPathForSelectedRow].row] objectForKey:@"year"];
#warning DATA fix
        destinationVC.managedObjectContext = SharedAppDelegate.coreDataStack.managedObjectContext;
    }
}

#pragma mark - Convenience

- (void)showResults{
    [self performSegueWithIdentifier:@"ResultsCVC" sender:nil];
}

#warning PUT IN CONSTANTS
- (NSArray *)yearsForUser{
    NSDate *birthdate = [self.user objectForKey:@"birthDate"];
    NSDateComponents *myBirthdayComp = [[NSDateComponents alloc] init];
    myBirthdayComp.year = 1987;
    myBirthdayComp.month = 5;
    myBirthdayComp.day = 11;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    birthdate = [calendar dateFromComponents:myBirthdayComp];
    
    NSDateComponents *birthComp = [calendar components:NSYearCalendarUnit fromDate:birthdate];
    
    NSInteger years = [[calendar components:NSYearCalendarUnit
                                   fromDate:birthdate
                                     toDate:[NSDate date]
                                    options:0] year];
    
    NSMutableArray *yearsArray = [[NSMutableArray alloc] initWithCapacity:years];
    for (int i = 0; i < years+1; i++) {
        NSInteger currentyear = birthComp.year + i;
        [yearsArray addObject:@{@"year": [NSNumber numberWithInteger:currentyear], @"age": [NSNumber numberWithInt:i]}];
    }
    
    NSMutableArray *reversedArray = [[NSMutableArray alloc] initWithCapacity:yearsArray.count];
    [yearsArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [reversedArray addObject:obj];
    }];
    
    return reversedArray;
    
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
#warning LOCALIZE
    return @"Select the year you would like to return to...";
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [self.fetchedResultsController sectionIndexTitleForSectionName:sectionInfo.name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectableYears.count;
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureTableViewCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSNumber *age = [[self.selectableYears objectAtIndex:indexPath.row] objectForKey:@"age"];
    NSMutableAttributedString *ageString = [[NSMutableAttributedString alloc] initWithString:age.stringValue attributes:@{NSFontAttributeName:HelveticaNeueLight18, NSForegroundColorAttributeName: [UIColor blueColor]}];
#warning LOCALIZE
    [ageString appendAttributedString:[[NSAttributedString alloc] initWithString:@" years old"]];
    cell.textLabel.attributedText = ageString;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
//    NSFetchRequest *
//    _fetchedResultsController = [NSFetchedResultsController alloc] initWithFetchRequest:] managedObjectContext:<#(NSManagedObjectContext *)#> sectionNameKeyPath:<#(NSString *)#> cacheName:<#(NSString *)#>
    return nil;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureTableViewCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
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
