//
//  MovieDetailVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 5/7/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailVC : UIViewController

@property (nonatomic, strong) Movie *movie;

- (IBAction)infoButtonPressed:(id)sender;

@end
