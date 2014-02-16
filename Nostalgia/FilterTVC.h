//
//  FilterTVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/14/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FilterType) {
    FilterTypeSong,
    FilterTypeMovie,
    FilterTypeCount
};

@protocol FilterTVCDelegate <NSObject>

- (void)filterTVCDidSelectFilters:(NSArray *)filters;
- (void)filterTVCDidCancel;

@end

@interface FilterTVC : UITableViewController

@property (nonatomic, weak) id <FilterTVCDelegate> delegate;

@end
