//
//  Movie+Networking.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/17/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Movie.h"
#import "Media+Keys.h"

static NSString *movieCastKey = @"Cast";
static NSString *movieDirectorKey = @"Director";
static NSString *movieDescriptionKey = @"Description";
static NSString *movieMediaTypeKey = @"Movie";

@interface Movie (Networking)

+ (void)loadMoviesForYear:(NSNumber *)year withBlock:(void (^)(NSArray *songs, NSError *error))block;
+ (void)loadMoviesWithBlock:(void (^)(NSArray *songs, NSError *error))block;
//+ (NSURLSessionDataTask *)songsModifiedAfterDate:(NSDate *)date withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
