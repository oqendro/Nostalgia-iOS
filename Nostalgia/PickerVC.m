//
//  ViewController.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 11/27/13.
//  Copyright (c) 2013 placeholder. All rights reserved.
//

#import "PickerVC.h"

@interface PickerVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSArray *years;
@property NSNumber *selectedYear;

@end

@implementation PickerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"PICKER_VC_TITLE", @"Title for picker vc pick your age");

    self.years = [self yearsForUser];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                          target:self
                                                                          action:@selector(yearSelected)];
    next.enabled = NO;
    self.navigationItem.rightBarButtonItem = next;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ResultsCVC"]) {
        //
    }
}
- (void)yearSelected{
    [self performSegueWithIdentifier:@"ResultsCVC" sender:nil];
}

- (NSArray *)yearsForUser{
    NSDate *birthdate = nil;//[self.user objectForKey:@"birthDate"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *birthComp = [[NSDateComponents alloc] init];
    birthComp.year = 1987;
    birthComp.month = 5;
    birthComp.day = 11;
    birthdate = [calendar dateFromComponents:birthComp];
    
    NSInteger years = [[calendar components:NSYearCalendarUnit
                                   fromDate:birthdate
                                     toDate:[NSDate date]
                                    options:0] year];
    
    NSMutableArray *yearsArray = [[NSMutableArray alloc] initWithCapacity:years];
    for (int i = 0; i < years+1; i++) {
        NSInteger currentyear = birthComp.year + i;
        [yearsArray addObject:@{@"year": [NSNumber numberWithInteger:currentyear], @"age": [NSNumber numberWithInt:i]}];
    }
    NSMutableArray *reversedYearsArray = [[NSMutableArray alloc] initWithCapacity:years];
    [yearsArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [reversedYearsArray addObject:obj];
    }];

    return reversedYearsArray;
    
}

#pragma mark - UIPicker View Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.years.count;
}

#pragma mark - UIPickerView Delegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UIFont *numberFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    UIFont *textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:8];
    NSLog(@"number %@ font %@",numberFont, textFont);
    NSNumber *age = [[self.years objectAtIndex:row] objectForKey:@"age"];
    NSAttributedString *number = [[NSAttributedString alloc] initWithString:age.stringValue
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor blueColor]}];
    
    NSAttributedString *tect = [[NSAttributedString alloc] initWithString:@" years old"
                                                               attributes:@{NSFontAttributeName: textFont}];
    NSMutableAttributedString *final = [[NSMutableAttributedString alloc] initWithAttributedString:number];
    [final appendAttributedString:tect];
    return [final copy];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.selectedYear = [[self.years objectAtIndex:row] objectForKey:@"year"];
}

@end
