//
//  Movie+Networking.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/17/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Movie+Networking.h"
#import "Thumbnail.h"
#warning DUPES ARE BEING CREATED
@implementation Movie (Networking)

+ (void)loadMoviesForYears:(NSArray *)years withBlock:(void (^)(NSArray *movies, NSError *error))block{
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Movie"];
    [movieQuery whereKey:@"Year" containedIn:years];
    [movieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self updateMoviesWithPFArray:objects usingContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }];
}

+ (void)loadMoviesWithBlock:(void (^)(NSArray *, NSError *))block{
    PFQuery *MovieQuery = [PFQuery queryWithClassName:@"Movie"];
    [MovieQuery setLimit: 1000];
    [MovieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self updateMoviesWithPFArray:objects usingContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }];
}

+ (void)updateMoviesWithPFArray:(NSArray *)PFArray usingContext:(NSManagedObjectContext *)localContext {
    [PFArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PFObject *pfMovie = obj;
        Movie *movie = [self movieForIdentifier:pfMovie.objectId usingContext:localContext];
        if (movie) {
            [self updateMovieIfNeeded:movie withPFObject:pfMovie];
        } else {
            [self createNewMovieWithPFObject:pfMovie usingContext:localContext];
        }
    }];
}

+ (Movie *)movieForIdentifier:(NSString *)identifier usingContext:(NSManagedObjectContext *)localContext {
    __block NSArray *movies;
    NSError *error;
    NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = identifierPredicate;
    
    movies = [localContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.debugDescription);
    }
    if (movies.count > 1) {
        NSLog(@"ERROR IN Movie NETWORKING");
    }
    return movies.lastObject;
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

+ (void)createNewMovieWithPFObject:(PFObject *)movieObject usingContext:(NSManagedObjectContext *)localContext {
 
    Movie *newMovie = [Movie MR_createInContext:localContext];
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
    Thumbnail *managedThumbnail = [Thumbnail MR_createInContext:localContext];
    managedThumbnail.name = thumbnail.name;
    managedThumbnail.url = thumbnail.url;
    [managedThumbnail addMovieObject:newMovie];
}


@end
