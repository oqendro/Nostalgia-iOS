//
//  SongDetailVC.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#warning TODO make this class handle both movies and songs 
@interface MediaDetailVC : UIViewController

@property (nonatomic, strong) Song *song;

- (IBAction)infoButtonPressed:(id)sender;

@end
