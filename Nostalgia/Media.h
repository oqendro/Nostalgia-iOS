//
//  Media.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/14/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Media : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * identifier;

@end
