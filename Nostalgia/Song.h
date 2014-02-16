//
//  Song.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/14/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Media.h"

@class Thumbnail;

@interface Song : Media

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) Thumbnail *thumbnail;

@end
