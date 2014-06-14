//
//  Song+Networking.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Song.h"
#import "Thumbnail.h"
#import "Media+Keys.h"

static NSString *albumKey = @"Album";
static NSString *artistKey = @"Artist";
static NSString *songMediaTypeKey = @"Song";

@interface Song (Networking)

+ (void)loadSongsForYears:(NSArray *)years withBlock:(void (^)(NSArray *songs, NSError *error))block;
+ (void)updateSongIfNeeded:(Song *)song withPFObject:(PFObject *)PFObject;

//+ (void)loadSongsWithBlock:(void (^)(NSArray *songs, NSError *error))block;
//+ (NSURLSessionDataTask *)songsModifiedAfterDate:(NSDate *)date withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
