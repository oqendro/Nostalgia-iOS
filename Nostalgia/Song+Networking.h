//
//  Song+Networking.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Song.h"
#import "Thumbnail.h"

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

@interface Song (Networking)

+ (void)loadSongsForYear:(NSNumber *)year withBlock:(void (^)(NSArray *songs, NSError *error))block;
+ (void)loadSongsWithBlock:(void (^)(NSArray *songs, NSError *error))block;
//+ (NSURLSessionDataTask *)songsModifiedAfterDate:(NSDate *)date withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
