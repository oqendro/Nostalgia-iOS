//
//  ResultsCVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
typedef NS_OPTIONS(NSUInteger, ResultsCVCFilterOptions) {
    ResultsCVCFilterOption00s = 1 << 0,
    ResultsCVCFilterOption90s = 1 << 1,
    ResultsCVCFilterOption80s = 1 << 2,
    ResultsCVCFilterOption70s = 1 << 3,
};
*/
typedef NS_ENUM(NSUInteger, ResultsCVCFilterOptions) {
    ResultsCVCFilterOption00s,
    ResultsCVCFilterOption90s,
    ResultsCVCFilterOption80s,
    ResultsCVCFilterOption70s,
};
@interface ResultsCVC : UICollectionViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) ResultsCVCFilterOptions filterOptions;

- (id)initFromDefaultStoryboardWithYears:(NSArray *)years;

@end
