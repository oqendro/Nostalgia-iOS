//
//  ResultsCVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsCVC : UICollectionViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)initFromDefaultStoryboardWithYears:(NSArray *)years;
/*
    pass in array of years to show
*/

@property (nonatomic, strong) NSArray *years;

/*
- (void)addYearsToShow:(NSArray *)years;
- (void)removeYearsToShow:(NSArray *)years;
 */
@end
