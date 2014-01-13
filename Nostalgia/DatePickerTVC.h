//
//  DatePickerTVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/12/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerTVCDelegate <NSObject>

- (void)datePickerDidFinishWithDate:(NSDate *)birthdate;
- (void)datePickerDidCancel;

@end

@interface DatePickerTVC : UITableViewController

@property (nonatomic, weak) id <DatePickerTVCDelegate> delegate;

@end
