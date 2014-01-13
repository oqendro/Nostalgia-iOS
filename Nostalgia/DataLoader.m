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
    
//    [Song songsWithBlock:^(NSArray *posts, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error.debugDescription);
//        }
//        NSLog(@"%@",posts);
//    }];
    
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

@end
