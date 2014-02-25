//
//  ResultsCVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "ResultsCVC.h"
#import "Song+Networking.h"
#import "Movie+Networking.h"
#import "SongCell.h"
#import "MovieCell.h"
#import "HeaderView.h"
#import <UIImageView+AFNetworking.h>
#import "SongDetailVC.h"
#import "FilterTVC.h"

@interface ResultsCVC () <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout, FilterTVCDelegate>
{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

static NSString *songCellIdentifier = @"SongCell";
static NSString *movieCellIdentifier = @"MovieCell";
static NSString *headerViewIdentifier = @"HeaderView";

@implementation ResultsCVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"798-filter-white"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(filterBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = filter;
    
    self.title = NSLocalizedString(@"RESULTS_TITLE", @"Title for results View Controller");
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundView = backgroundView;
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:songCellIdentifier bundle:nil]
          forCellWithReuseIdentifier:songCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:movieCellIdentifier bundle:nil]
          forCellWithReuseIdentifier:movieCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:headerViewIdentifier bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerViewIdentifier];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:songsPreferenceKey] boolValue]) {
        [Song loadSongsForYear:self.year withBlock:^(NSArray *songs, NSError *error) {
            NSLog(@"songs %lu for %@",(unsigned long)songs.count, self.year);
        }];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:moviesPreferenceKey] boolValue]) {
        [Movie loadMoviesForYear:self.year withBlock:^(NSArray *songs, NSError *error) {
            NSLog(@"movies %lu for %@",(unsigned long)songs.count, self.year);
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SongDetailVC"]) {
        NSIndexPath *path = [self.collectionView indexPathForCell:sender];
        Song *selectedSong = [self.fetchedResultsController objectAtIndexPath:path];
        SongDetailVC *detailVC = segue.destinationViewController;
        detailVC.song = selectedSong;
    }
}

#pragma mark - Convenience Methods

- (void)filterBarButtonPressed:(UIBarButtonItem *)filterBarButton{
    FilterTVC *filterTVC = [[FilterTVC alloc] initWithStyle:UITableViewStylePlain];
    filterTVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:filterTVC]
                       animated:YES
                     completion:NULL];
}

- (NSArray *)filters{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *filters = [NSArray array];
    if ([[defaults objectForKey:songsPreferenceKey] boolValue]) {
        filters = [filters arrayByAddingObject:@"Song"];
    }
    if ([[defaults objectForKey:moviesPreferenceKey] boolValue]) {
        filters = [filters arrayByAddingObject:@"Movie"];
    }
    return filters;
}

#pragma mark - UICollectionVIew DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([media.mediaType isEqualToString:songMediaTypeKey]) {
        SongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:songCellIdentifier forIndexPath:indexPath];
        [self configureSongCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        MovieCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:movieCellIdentifier forIndexPath:indexPath];
        [self configureMovieCell:movieCell atIndexPath:indexPath];
        return movieCell;
    }
    
#warning change to rating
 //   cell.ratingLabel.text = song.rank.stringValue;
//    return cell;
}

- (void)configureSongCell:(SongCell *)songCell atIndexPath:(NSIndexPath *)indexPath{
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];

    songCell.bottomLabel.text = song.title;
    NSURL *imageURL = [NSURL URLWithString:song.thumbnail.url];
    [songCell.imageView setImageWithURL:imageURL
                       placeholderImage:[UIImage imageNamed:@"767-photo-1-white"]];
}

- (void)configureMovieCell:(MovieCell *)movieCell atIndexPath:(NSIndexPath *)indexPath{
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    movieCell.bottomLabel.text = movie.title;
    NSURL *imageURL = [NSURL URLWithString:movie.thumbnail.url];
    [movieCell.imageView setImageWithURL:imageURL
                       placeholderImage:[UIImage imageNamed:@"767-photo-1-white"]];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                          withReuseIdentifier:headerViewIdentifier
                                                                                 forIndexPath:indexPath];
    NSString *title = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] name];
    UILabel *titleLabel = (UILabel *)[header viewWithTag:187];
    titleLabel.text = title;
    return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout

#warning put in constants
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = [self.fetchedResultsController objectAtIndexPath: indexPath];
    if ([media.mediaType isEqualToString:songMediaTypeKey]) {
        return CGSizeMake(100, 100);
    } else {
        return CGSizeMake(100, 156);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(320, 44);
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *songFetch = [NSFetchRequest fetchRequestWithEntityName:@"Media"];
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"year == %@",self.year];
    
    NSMutableArray *filterPredicatesArray = [[NSMutableArray alloc] init];
    for (NSString *mediaType in [self filters]) {
        NSPredicate *mediaTypePredicate = [NSPredicate predicateWithFormat:@"mediaType == %@",mediaType];
        [filterPredicatesArray addObject:mediaTypePredicate];
    }
    NSPredicate *filtersPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:filterPredicatesArray];
    songFetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filtersPredicates, yearPredicate]];
    
    NSSortDescriptor *titleSD = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSSortDescriptor *mediaTypeSD = [NSSortDescriptor sortDescriptorWithKey:@"mediaType" ascending:YES];
    songFetch.sortDescriptors = @[mediaTypeSD, titleSD];
    
    NSFetchedResultsController *FRC = [[NSFetchedResultsController alloc] initWithFetchRequest:songFetch
                                                                          managedObjectContext:SharedAppDelegate.coreDataStack.managedObjectContext
                                                                            sectionNameKeyPath:@"mediaType"
                                                                                     cacheName:nil];
    FRC.delegate = self;
    self.fetchedResultsController = FRC;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        
        if ([self shouldReloadCollectionViewToPreventKnownIssue] || self.collectionView.window == nil) {
            // This is to prevent a bug in UICollectionView from occurring.
            // The bug presents itself when inserting the first object or deleting the last object in a collection view.
            // http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
            // This code should be removed once the bug has been fixed, it is tracked in OpenRadar
            // http://openradar.appspot.com/12954582
            [self.collectionView reloadData];
            
        } else {
            
            [self.collectionView performBatchUpdates:^{
                
                for (NSDictionary *change in _objectChanges)
                {
                    [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                        
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        switch (type)
                        {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeMove:
                                [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

- (BOOL)shouldReloadCollectionViewToPreventKnownIssue {
    __block BOOL shouldReload = NO;
    for (NSDictionary *change in _objectChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSIndexPath *indexPath = obj;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeDelete:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeUpdate:
                    shouldReload = NO;
                    break;
                case NSFetchedResultsChangeMove:
                    shouldReload = NO;
                    break;
            }
        }];
    }
    
    return shouldReload;
}

#pragma mark - FilterTVC Delegate

- (void)filterTVCDidCancel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)filterTVCDidSelectFilters:(NSArray *)filters {
    NSMutableArray *filterPredicatesArray = [[NSMutableArray alloc] init];
    for (NSString *mediaType in filters) {
        NSPredicate *mediaTypePredicate = [NSPredicate predicateWithFormat:@"mediaType == %@",mediaType];
        [filterPredicatesArray addObject:mediaTypePredicate];
    }
    NSPredicate *filtersPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:filterPredicatesArray];
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"year == %@",self.year];
    self.fetchedResultsController.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filtersPredicates, yearPredicate]];
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
