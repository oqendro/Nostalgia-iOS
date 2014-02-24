//
//  Movie.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/24/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Media.h"

@class Thumbnail;

@interface Movie : Media

@property (nonatomic, retain) NSString * cast;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * movieDescription;
@property (nonatomic, retain) Thumbnail *thumbnail;

@end
