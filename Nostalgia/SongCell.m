//
//  MusicCell.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 1/26/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.labelBackgroundView.alpha = .6;
    self.labelBackgroundView.backgroundColor = [UIColor blackColor];
    
    self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:.6].CGColor;
    self.layer.borderWidth = 0;
    
    self.ratingLabel.backgroundColor = [UIColor clearColor];
    self.ratingLabel.textColor = [UIColor whiteColor];
    self.ratingLabelContainerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    self.ratingLabelContainerView.layer.cornerRadius = self.ratingLabelContainerView.frame.size.width / 2;
    self.ratingLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.layer.borderWidth = 3;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
