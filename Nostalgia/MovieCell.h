//
//  MovieCell.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/24/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIView *labelBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *ratingLabelContainerView;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@end
