//
//  Song+Networking.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Song+Networking.h"

@implementation Song (Networking)

+ (void)loadSongsForYears:(NSArray *)years withBlock:(void (^)(NSArray *songs, NSError *error))block{
    PFQuery *songQuery = [PFQuery queryWithClassName:@"Song"];
    [songQuery whereKey:@"Year" containedIn:years];
    [songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *song in objects) {
            Song *managedSong = [self songForIdentifier:song.objectId];
            if (managedSong) {
                [self updateSongIfNeeded:managedSong withPFObject:song];
            } else {
                [self createNewSongWithPFObject:song];
            }
        }
        if (block) {
            block(objects, error);
        }
        NSError *saveError;
        [[NSManagedObjectContext MR_defaultContext] save:&saveError];
        if (saveError) {
            NSLog(@"%@",error.debugDescription);
        }

    }];
}

+ (void)loadSongsWithBlock:(void (^)(NSArray *, NSError *))block{
    PFQuery *songQuery = [PFQuery queryWithClassName:@"Song"];
    [songQuery setLimit: 1000];
    [songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *song in objects) {
            Song *managedSong = [self songForIdentifier:song.objectId];
            if (managedSong) {
                [self updateSongIfNeeded:managedSong withPFObject:song];
            } else {
                [self createNewSongWithPFObject:song];
            }
        }
        if (block) {
            block(objects, error);
        }
    }];
}

+ (Song *)songForIdentifier:(NSString *)identifier{
    __block NSArray *songs;
    NSError *error;
    NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    request.predicate = identifierPredicate;

    songs = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.debugDescription);
    }
    if (songs.count > 1) {
        NSLog(@"ERROR IN SONG NETWORKING");
    }
    return songs.lastObject;
}

+ (void)updateSongIfNeeded:(Song *)song withPFObject:(PFObject *)PFObject{
    NSComparisonResult comparisonResult = [song.updatedAt compare:PFObject.updatedAt];
    switch (comparisonResult) {
        case NSOrderedAscending: {
            song.identifier = PFObject.objectId;
            song.updatedAt = PFObject.updatedAt;
            song.createdAt = PFObject.createdAt;
            song.mediaType = songMediaTypeKey;
            
            song.year = [PFObject objectForKey:yearKey];
            song.genre = [PFObject objectForKey:genreKey];
            song.rank = [PFObject objectForKey:rankKey];
            song.title = [PFObject objectForKey:titleKey];

            song.album = [PFObject objectForKey:albumKey];
            song.artist = [PFObject objectForKey:artistKey];
            
            PFFile *thumbnail = [PFObject objectForKey:thumbnailKey];
            song.thumbnail.name = thumbnail.name;
            song.thumbnail.url = thumbnail.url;
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

+ (void)createNewSongWithPFObject:(PFObject *)songObject{
    
    Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song"
                                                  inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    newSong.identifier = songObject.objectId;
    newSong.createdAt = songObject.createdAt;
    newSong.updatedAt = songObject.updatedAt;

    newSong.genre = [songObject objectForKey:genreKey];
    newSong.rank = [songObject objectForKey:rankKey];
    newSong.title = [songObject objectForKey:titleKey];
    newSong.year = [songObject objectForKey:yearKey];
    newSong.mediaType = songMediaTypeKey;

    newSong.album = [songObject objectForKey:albumKey];
    newSong.artist = [songObject objectForKey:artistKey];
    
    PFFile *thumbnail = [songObject objectForKey:thumbnailKey];
    Thumbnail *managedThumbnail = [NSEntityDescription insertNewObjectForEntityForName:@"Thumbnail"
                                                                inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    managedThumbnail.name = thumbnail.name;
    managedThumbnail.url = thumbnail.url;
    [managedThumbnail addSongObject:newSong];
}

@end
