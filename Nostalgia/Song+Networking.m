//
//  Song+Networking.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "Song+Networking.h"

@implementation Song (Networking)

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
        };
        NSError *saveError;
        [[CoreDataManager sharedBackgroundThreadContext] save:&saveError];
        if (saveError) {
            NSLog(@"%@",saveError.debugDescription);
        }
        [[CoreDataManager sharedMainThreadContext] performBlock:^{
            NSError *error;
            [[CoreDataManager sharedMainThreadContext] save:&error];
            if (error) {
                NSLog(@"%@",error.debugDescription);
            }
        }];
    }];

}

+ (Song *)songForIdentifier:(NSString *)identifier{
    __block NSArray *songs;
    [[CoreDataManager sharedBackgroundThreadContext] performBlockAndWait:^{
        NSError *error;
        NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
        request.predicate = identifierPredicate;

        songs = [[CoreDataManager sharedBackgroundThreadContext] executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"%@",error.debugDescription);
        }
    }];
    if (songs.count > 1) {
        NSLog(@"ERROR IN SONG NETWORKING");
    }
    return songs.lastObject;
}

+ (void)updateSongIfNeeded:(Song *)song withPFObject:(PFObject *)PFObject{
    NSComparisonResult comparisonResult = [song.updatedAt compare:PFObject.updatedAt];
    switch (comparisonResult) {
        case NSOrderedAscending: {
            [[CoreDataManager sharedBackgroundThreadContext] performBlock:^{
                song.album = [PFObject objectForKey:albumKey];
                song.artist = [PFObject objectForKey:artistKey];
                song.createdAt = [PFObject objectForKey:createdAtKey];
                song.genre = [PFObject objectForKey:genreKey];
                song.identifier = PFObject.objectId;
                song.rank = [PFObject objectForKey:rankKey];
                song.title = [PFObject objectForKey:titleKey];
                song.updatedAt = PFObject.updatedAt;
                song.year = [PFObject objectForKey:yearKey];
            }];
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
    [[CoreDataManager sharedBackgroundThreadContext] performBlock:^{
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song"
                                                      inManagedObjectContext:[CoreDataManager sharedBackgroundThreadContext]];
        newSong.album = [songObject objectForKey:albumKey];
        newSong.artist = [songObject objectForKey:artistKey];
        newSong.createdAt = songObject.createdAt;
        newSong.genre = [songObject objectForKey:genreKey];
        newSong.identifier = songObject.objectId;
        newSong.rank = [songObject objectForKey:rankKey];
        newSong.title = [songObject objectForKey:titleKey];
        newSong.updatedAt = songObject.updatedAt;
        newSong.year = [songObject objectForKey:yearKey];
    }];
}

@end
