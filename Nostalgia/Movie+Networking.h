//
//  Movie+Networking.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/17/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Movie.h"

static NSString *albumKey = @"Album";
static NSString *artistKey = @"Artist";
static NSString *genreKey = @"Genre";
static NSString *rankKey = @"Rank";
static NSString *thumbnailKey = @"Thumbnail";
static NSString *titleKey = @"Title";
static NSString *yearKey = @"Year";
static NSString *objectIDKey = @"objectId";
static NSString *createdAtKey = @"createdAt";
static NSString *updatedAtKey = @"updatedAt";


@interface Movie (Networking)

+ (void)loadMoviesForYear:(NSNumber *)year withBlock:(void (^)(NSArray *songs, NSError *error))block;
+ (void)loadMoviesWithBlock:(void (^)(NSArray *songs, NSError *error))block;
//+ (NSURLSessionDataTask *)songsModifiedAfterDate:(NSDate *)date withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
