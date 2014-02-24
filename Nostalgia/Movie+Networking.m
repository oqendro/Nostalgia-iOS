//
//  Movie+Networking.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/17/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Movie+Networking.h"
#import "Thumbnail.h"

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

+ (void)updateMovieIfNeeded:(Movie *)movie withPFObject:(PFObject *)PFObject{
    NSComparisonResult comparisonResult = [movie.updatedAt compare:PFObject.updatedAt];
    
    switch (comparisonResult) {
        case NSOrderedAscending: {
            movie.createdAt = PFObject.createdAt;
            movie.updatedAt = PFObject.updatedAt;
            movie.identifier = PFObject.objectId;
            
            movie.title = [PFObject objectForKey:titleKey];
            movie.year = [PFObject objectForKey:yearKey];
            movie.rank = [PFObject objectForKey:rankKey];
            movie.genre = [PFObject objectForKey:genreKey];
            movie.mediaType = movieMediaTypeKey;

            movie.cast = [PFObject objectForKey:movieCastKey];
            movie.director = [PFObject objectForKey:movieDirectorKey];
            
            PFFile *thumbnail = [PFObject objectForKey:thumbnailKey];
            movie.thumbnail.name = thumbnail.name;
            movie.thumbnail.url = thumbnail.url;
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

+ (void)createNewMovieWithPFObject:(PFObject *)movieObject{
 
    Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                                  inManagedObjectContext:SharedAppDelegate.coreDataStack.managedObjectContext];
    newMovie.identifier = movieObject.objectId;
    newMovie.createdAt = movieObject.createdAt;
    newMovie.updatedAt = movieObject.updatedAt;

    newMovie.title = [movieObject objectForKey:titleKey];
    newMovie.year = [movieObject objectForKey:yearKey];
    newMovie.rank = [movieObject objectForKey:rankKey];
    newMovie.genre = [movieObject objectForKey:genreKey];
    newMovie.mediaType = movieMediaTypeKey;

    newMovie.cast = [movieObject objectForKey:movieCastKey];
    newMovie.director = [movieObject objectForKey:movieDirectorKey];
    newMovie.movieDescription = [movieObject objectForKey:movieDescriptionKey];
    
    PFFile *thumbnail = [movieObject objectForKey:thumbnailKey];
    Thumbnail *managedThumbnail = [NSEntityDescription insertNewObjectForEntityForName:@"Thumbnail"
                                                                inManagedObjectContext:SharedAppDelegate.coreDataStack.managedObjectContext];
    managedThumbnail.name = thumbnail.name;
    managedThumbnail.url = thumbnail.url;
    [managedThumbnail addMovieObject:newMovie];
}


@end
