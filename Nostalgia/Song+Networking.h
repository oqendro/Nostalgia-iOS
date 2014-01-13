//
//  Song+Networking.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Song.h"

static NSString *albumKey = @"album";
static NSString *artistKey = @"artist";
static NSString *genreKey = @"genre";
static NSString *rankKey = @"rank";
static NSString *thumbnailKey = @"thumbnail";
static NSString *titleKey = @"title";
static NSString *yearKey = @"year";
static NSString *objectIDKey = @"objectId";
static NSString *createdAtKey = @"createdAt";
static NSString *updatedAtKey = @"updatedAt";

@interface Song (Networking)

+ (void)loadSongsWithBlock:(void (^)(NSArray *songs, NSError *error))block;
//+ (NSURLSessionDataTask *)songsModifiedAfterDate:(NSDate *)date withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
