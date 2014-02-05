//
//  Thumbnail.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/5/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Thumbnail : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *song;
@end

@interface Thumbnail (CoreDataGeneratedAccessors)

- (void)addSongObject:(Song *)value;
- (void)removeSongObject:(Song *)value;
- (void)addSong:(NSSet *)values;
- (void)removeSong:(NSSet *)values;

@end
