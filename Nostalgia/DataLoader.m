//
//  DataLoader.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/7/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "DataLoader.h"
#import "Song+Networking.h"

@implementation DataLoader

+ (void)setupParseWithLaunchOptions:(NSDictionary *)launchOptions{
    [Parse setApplicationId:@"WDw4yF7IQ4zgFEXAAxVcA2JWTUV9KbiqYnsLvNVR"
                  clientKey:@"q1QlNWkF9er5hG6HOUhpj7oQ3FO1nmT3zvIRmSWG"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

+ (void)uploadMusicData{
    /*
     PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
     [testObject setObject:@"bar" forKey:@"foo"];
     [testObject save];
     */
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"MusicRanked" ofType:@"json"];
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    for (NSDictionary *songDict in jsonArray) {
        PFObject *newSong = [PFObject objectWithClassName:@"Song"];
        [newSong setObject:[songDict objectForKey:albumKey] forKey:albumKey];
        [newSong setObject:[songDict objectForKey:artistKey] forKey:artistKey];
        [newSong setObject:[songDict objectForKey:genreKey] forKey:genreKey];
        [newSong setObject:[songDict objectForKey:rankKey] forKey:rankKey];
        [newSong setObject:[songDict objectForKey:thumbnailKey] forKey:thumbnailKey];
        [newSong setObject:[songDict objectForKey:titleKey] forKey:titleKey];
        [newSong setObject:[songDict objectForKey:yearKey] forKey:yearKey];
        [newSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@",error.debugDescription);
            }
        }];

    }
}

+ (void)uploadImages{
    NSMutableArray *allObjects = [NSMutableArray array];
    __block NSUInteger limit = 1000;
    __block NSUInteger skip = 0;
    PFQuery *songQuery = [PFQuery queryWithClassName:@"Song"];
    [songQuery setLimit: 1000];
    [songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [allObjects addObjectsFromArray:objects];
            if (objects.count == limit) {
                // There might be more objects in the table. Update the skip value and execute the query again.
                skip += limit;
                [songQuery setSkip: skip];
                [songQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    [allObjects addObjectsFromArray:objects];
                    for (int i = 0; i < allObjects.count; i++) {
                        PFObject *parseSong = [allObjects objectAtIndex:i];
                        NSString *thumbmailPath = [parseSong objectForKey:@"Photo"];
                        NSMutableString *edited = [thumbmailPath mutableCopy];
                        [edited deleteCharactersInRange:NSRangeFromString(@"{0,18")];
                        [edited deleteCharactersInRange:NSMakeRange(edited.length-4, 4)];
                        NSString *path = [[NSBundle mainBundle] pathForResource:edited ofType:@"jpg"];
                        NSData *imageData = [NSData dataWithContentsOfFile:path];
                        NSAssert(imageData, @"no data for path");
                        NSString *fileName = [parseSong[titleKey] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"," withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"'" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"." withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"&" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"(" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@")" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"\"" withString:@"-"];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"!" withString:@""];
                        fileName = [fileName stringByReplacingOccurrencesOfString:@"+" withString:@""];
                        
                        NSMutableString *mutablefileName = [fileName mutableCopy];
                        if ([[mutablefileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@" -"]) {
                            [mutablefileName deleteCharactersInRange:NSMakeRange(0, 2)];
                        }
                        if ([[mutablefileName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
                            [mutablefileName deleteCharactersInRange:NSMakeRange(0, 1)];
                        }
                        if ([[mutablefileName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
                            [mutablefileName deleteCharactersInRange:NSMakeRange(0, 1)];
                        }
                        
                        fileName = [NSString stringWithFormat:@"%@.jpg",mutablefileName];
                        double delayInSeconds = 2.0 * i;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            PFFile *imageFile = [PFFile fileWithName:fileName data:imageData];
                            [parseSong setObject:imageFile forKey:thumbnailKey];
                            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (error) {
                                    NSLog(@"/%@/ failed %@",imageFile.name,error.debugDescription);
                                    NSAssert(0, @"save image error");
                                }
                                NSLog(@"first whoot");
                                [parseSong setObject:imageFile forKey:thumbnailKey];
                                [parseSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (error) {
                                        NSLog(@"%@ %@",parseSong[@"Title"], error);
                                        NSAssert(0, @"song could not save with file");
                                    }
                                    NSLog(@"final whoot");
                                }];
                            }];

                        });
                    }
                }];
                 }
                 
                 } else {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];

}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        NSLog(@"%f",(float)percentDone/100);
    }];
}

+ (Song *)songForID:(NSString *)songIdentifier{
    NSFetchRequest *songFetch = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    songFetch.predicate = [NSPredicate predicateWithFormat:@"identifier == %@",songIdentifier];
    NSError *error;
    NSArray *songs = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:songFetch
                                                                                                       error:&error];
   
    switch (songs.count) {
        case 1:
            return songs.firstObject;
            break;
        case 0:
            return nil;
            break;
        default:
            NSAssert(0, @"more than one song with same identifier");
            return nil;
            break;
    }
}

@end
