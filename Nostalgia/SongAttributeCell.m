//
//  SongAttributeCell.m
//  Nostalgia
//
//  Created by Walter Vargas-Pena on 2/20/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "SongAttributeCell.h"

@implementation SongAttributeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textLabel.font = HelveticaNeueLight18;
    self.detailTextLabel.font = HelveticaNeueLight18;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];
}

@end
