//
//  ResultsCVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsCVC : UICollectionViewController

@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
