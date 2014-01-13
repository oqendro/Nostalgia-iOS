//
//  Song.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * year;

@end
