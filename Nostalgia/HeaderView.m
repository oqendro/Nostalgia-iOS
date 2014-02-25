//
//  HeaderView.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/24/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    self.label.textColor = [UIColor whiteColor];
    self.label.font = HelveticaNeueLight18;
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
