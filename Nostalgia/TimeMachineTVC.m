//
//  TimeMachineTVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "TimeMachineTVC.h"

@interface TimeMachineTVC ()

@property (nonatomic, strong) NSArray *selectableYears;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property NSInteger paddingCellCount;

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
    if (isiPhone5) {
        self.paddingCellCount = 10;
    } else {
        self.paddingCellCount = 5;
    }
    
    self.title = NSLocalizedString(@"TIME_MACHINE_TITLE", @"Title for time machine view controller");
    self.selectableYears = [self yearsForUser];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Convenience

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
    return yearsArray;
    
}

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [self.fetchedResultsController sectionIndexTitleForSectionName:sectionInfo.name];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectableYears.count + self.paddingCellCount;
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
    NSInteger paddingHalf = self.paddingCellCount /2;
    if (indexPath.row < paddingHalf) {
        return;
    }
    if (indexPath.row > paddingHalf + self.selectableYears.count - 1) {
        return;
    }
    NSLog(@"%@",indexPath);
    cell.textLabel.text = [[[self.selectableYears objectAtIndex:indexPath.row] objectForKey:@"age"] description];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *vis = self.tableView.indexPathsForVisibleRows;
    NSLog(@"Visible %i",vis.count/2);
    if (vis.count %2 == 1) {
        [self.tableView selectRowAtIndexPath:vis[vis.count/2] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
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
