//
//  FilterTVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/14/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "FilterTVC.h"

@interface FilterTVC ()

@property NSUserDefaults *defaults;

@end


@implementation FilterTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"FILTER", @"Title for filter barbutton item");
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(cancel)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Convenience

- (void)cancel{
    [self.delegate filterTVCDidCancel];
}

- (void)done{
    NSArray *filters = [NSArray array];
    if ([[self.defaults objectForKey:songsPreferenceKey] boolValue]) {
        filters = [filters arrayByAddingObject:@"Song"];
    }
    if ([[self.defaults objectForKey:moviesPreferenceKey] boolValue]) {
        filters = [filters arrayByAddingObject:@"Movie"];
    }

    [self.delegate filterTVCDidSelectFilters:filters];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return FilterTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case FilterTypeSong:
            cell.textLabel.text = @"Songs";
            if ([[self.defaults objectForKey:songsPreferenceKey] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType= UITableViewCellAccessoryNone;
            }
            break;
        case FilterTypeMovie:
            cell.textLabel.text = @"Movies";
            if ([[self.defaults objectForKey:moviesPreferenceKey] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType= UITableViewCellAccessoryNone;
            }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case FilterTypeSong:
            if ([[self.defaults objectForKey:songsPreferenceKey] boolValue]) {
                [self.defaults setObject:@NO forKey:songsPreferenceKey];
            } else {
                [self.defaults setObject:@YES forKey:songsPreferenceKey];
            }
            break;
        case FilterTypeMovie:
            if ([[self.defaults objectForKey:moviesPreferenceKey] boolValue]) {
                [self.defaults setObject:@NO forKey:moviesPreferenceKey];
            } else {
                [self.defaults setObject:@YES forKey:moviesPreferenceKey];
            }
            break;
        default:
            break;
    }
    if ([self.defaults synchronize]) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        NSLog(@"did not save");
    }
}

@end
