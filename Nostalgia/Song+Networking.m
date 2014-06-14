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
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self updateSongsWithPFArray:objects usingContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }];
}

+ (void)loadSongsWithBlock:(void (^)(NSArray *, NSError *))block{
    PFQuery *songQuery = [PFQuery queryWithClassName:@"Song"];
    [songQuery setLimit: 1000];
    [songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self updateSongsWithPFArray:objects usingContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }];
}

+ (void)updateSongsWithPFArray:(NSArray *)PFArray usingContext:(NSManagedObjectContext *)localContext {
    
    [PFArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PFObject *pfSong = obj;
        Song *song = [self songForIdentifier:pfSong.objectId usingContext:localContext];
        if (song) {
            [self updateSongIfNeeded:song withPFObject:pfSong];
        } else {
            [self createNewSongWithPFObject:pfSong usingContext:localContext];
        }
    }];
}

+ (Song *)songForIdentifier:(NSString *)identifier usingContext:(NSManagedObjectContext *)localContext {
    __block NSArray *songs;
    NSError *error;
    NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    songs = [Song MR_findAllWithPredicate:identifierPredicate inContext:localContext];
    if (error) {
        NSLog(@"%@",error.debugDescription);
    }
    if (songs.count > 1) {
        NSAssert(0, @"More than 1 song found for identifier");
    }
    return songs.lastObject;
}

+ (void)updateSongIfNeeded:(Song *)song withPFObject:(PFObject *)PFObject {
    
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
            song.rating = [PFObject objectForKey:ratingKey];
            
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

+ (void)createNewSongWithPFObject:(PFObject *)songObject usingContext:(NSManagedObjectContext *)localContext {
    
    Song *newSong = [Song MR_createInContext:localContext];
    newSong.identifier = songObject.objectId;
    newSong.createdAt = songObject.createdAt;
    newSong.updatedAt = songObject.updatedAt;

    newSong.genre = [songObject objectForKey:genreKey];
    newSong.rank = [songObject objectForKey:rankKey];
    newSong.title = [songObject objectForKey:titleKey];
    newSong.year = [songObject objectForKey:yearKey];
    newSong.mediaType = songMediaTypeKey;
    newSong.rating = [songObject objectForKey:ratingKey];

    newSong.album = [songObject objectForKey:albumKey];
    newSong.artist = [songObject objectForKey:artistKey];
    
    PFFile *thumbnail = [songObject objectForKey:thumbnailKey];
    Thumbnail *managedThumbnail = [Thumbnail MR_createInContext:localContext];
    managedThumbnail.name = thumbnail.name;
    managedThumbnail.url = thumbnail.url;
    [managedThumbnail addSongObject:newSong];
}

@end
