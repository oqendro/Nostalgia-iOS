//
//  Media.h
//  Nostalgia
//
//  Created by Walter Vargas-Pena on 2/20/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Media : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * favorite;

@end
