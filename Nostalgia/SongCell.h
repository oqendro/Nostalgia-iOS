//
//  MusicCell.h
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIView *labelBackgroundView;
@end
