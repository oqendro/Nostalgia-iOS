//
//  Movie+Networking.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/17/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Movie+Networking.h"

@implementation Movie (Networking)

+ (void)loadMoviesForYear:(NSNumber *)year withBlock:(void (^)(NSArray *movies, NSError *error))block{
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Movie"];
    [movieQuery whereKey:@"Year" equalTo:year];
    [movieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *movie in objects) {
            Movie *managedMovie = [self movieForIdentifier:movie.objectId];
            if (managedMovie) {
                [self updateMovieIfNeeded:managedMovie withPFObject:movie];
            } else {
                [self createNewMovieWithPFObject:movie];
            }
        }
        if (block) {
            block(objects, error);
        }
        NSError *saveError;
        [SharedAppDelegate.coreDataStack.managedObjectContext save:&saveError];
        if (saveError) {
            NSLog(@"%@",error.debugDescription);
        }
        
    }];
}

+ (void)loadMoviesWithBlock:(void (^)(NSArray *, NSError *))block{
    PFQuery *MovieQuery = [PFQuery queryWithClassName:@"Movie"];
    [MovieQuery setLimit: 1000];
    [MovieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *movie in objects) {
            Movie *managedMovie = [self movieForIdentifier:movie.objectId];
            if (managedMovie) {
                [self updateMovieIfNeeded:managedMovie withPFObject:movie];
            } else {
                [self createNewMovieWithPFObject:movie];
            }
        }
        if (block) {
            block(objects, error);
        }
    }];
}

+ (Movie *)movieForIdentifier:(NSString *)identifier{
    __block NSArray *Movies;
    NSError *error;
    NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = identifierPredicate;
    
    Movies = [SharedAppDelegate.coreDataStack.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.debugDescription);
    }
    if (Movies.count > 1) {
        NSLog(@"ERROR IN Movie NETWORKING");
    }
    return Movies.lastObject;
}
#warning TODO
+ (void)updateMovieIfNeeded:(Movie *)movie withPFObject:(PFObject *)PFObject{
    NSComparisonResult comparisonResult = [movie.updatedAt compare:PFObject.updatedAt];
    switch (comparisonResult) {
        case NSOrderedAscending: {
//            movie.album = [PFObject objectForKey:albumKey];
//            movie.artist = [PFObject objectForKey:artistKey];
            movie.createdAt = [PFObject objectForKey:createdAtKey];
//            movie.genre = [PFObject objectForKey:genreKey];
            movie.identifier = PFObject.objectId;
//            movie.rank = [PFObject objectForKey:rankKey];
            movie.title = [PFObject objectForKey:titleKey];
            movie.updatedAt = PFObject.updatedAt;
            movie.year = [PFObject objectForKey:yearKey];
//            PFFile *thumbnail = [PFObject objectForKey:thumbnailKey];
//            movie.thumbnail.name = thumbnail.name;
//            movie.thumbnail.url = thumbnail.url;
        }
            break;
        case NSOrderedDescending:
            return;
            break;
        case NSOrderedSame:
            return;
            break;
        default:
            break;
    }
}

+ (void)createNewMovieWithPFObject:(PFObject *)MovieObject{
    
    Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                                  inManagedObjectContext:SharedAppDelegate.coreDataStack.managedObjectContext];
//    newMovie.album = [MovieObject objectForKey:albumKey];
//    newMovie.artist = [MovieObject objectForKey:artistKey];
    newMovie.createdAt = MovieObject.createdAt;
//    newMovie.genre = [MovieObject objectForKey:genreKey];
    newMovie.identifier = MovieObject.objectId;
//    newMovie.rank = [MovieObject objectForKey:rankKey];
    newMovie.title = [MovieObject objectForKey:titleKey];
    newMovie.updatedAt = MovieObject.updatedAt;
    newMovie.year = [MovieObject objectForKey:yearKey];
    newMovie.mediaType = @"Movie";
    
//    PFFile *thumbnail = [MovieObject objectForKey:thumbnailKey];
//    Thumbnail *managedThumbnail = [NSEntityDescription insertNewObjectForEntityForName:@"Thumbnail"
//                                                                inManagedObjectContext:SharedAppDelegate.coreDataStack.managedObjectContext];
//    managedThumbnail.name = thumbnail.name;
//    managedThumbnail.url = thumbnail.url;
//    [managedThumbnail addMovieObject:newMovie];
}


@end
