//
//  SongDetailVC.m
//  Nostalgia
//
//  Created by Walter M. Vargas-Pena on 2/11/14.
//  Copyright (c) 2014 placeholder. All rights reserved.
//

#import "SongDetailVC.h"
#import <UIImageView+AFNetworking.h>
#import "Thumbnail.h"
#import <AMRatingControl.h>

@interface SongDetailVC () <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *ratingContainerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *toggleInfoButton;
@property (strong, nonatomic) AMRatingControl *ratingControl;

@end

static NSString *songAttributeCellIdentifier = @"SongAttributeCell";

@implementation SongDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.ratingContainerView.backgroundColor = [UIColor lightGrayColor];
    
    [self.toggleInfoButton setImage:[UIImage imageNamed:@"724-info-white"]
                           forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:songAttributeCellIdentifier bundle:nil]
         forCellReuseIdentifier:songAttributeCellIdentifier];
    [self.imageView setImageWithURL:[NSURL URLWithString:self.song.thumbnail.url]
                   placeholderImage:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView{
    self.titleLabel.text = self.song.title;
    [self.ratingControl setRating:2.5];
}

- (IBAction)infoButtonPressed:(id)sender {
    
    if (self.imageView.superview == self.containerView) {
        [UIView transitionFromView:self.imageView
                            toView:self.tableView
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            [self.toggleInfoButton setImage:[UIImage imageNamed:@"767-photo-1-white"]
                                                   forState:UIControlStateNormal];
                        }];

    } else {
        [UIView transitionFromView:self.tableView
                            toView:self.imageView
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            [self.toggleInfoButton setImage:[UIImage imageNamed:@"724-info-white"]
                                                   forState:UIControlStateNormal];
                        }];
    }

}

#pragma mark - Getters

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)
                                              style:UITableViewStylePlain];
    _tableView.allowsSelection = NO;
    self.tableView.layer.borderWidth = 2;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView.dataSource = self;
    return _tableView;
}

- (UIImageView *)imageView{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleThumbnail.jpg"]];
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(5, 5);
    _imageView.layer.shadowOpacity = .5;
    _imageView.layer.shadowRadius = 1.0;
    _imageView.clipsToBounds = NO;
    [self.containerView addSubview:_imageView];
    _imageView.center = CGPointMake(self.containerView.frame.size.width / 2, self.containerView.frame.size.height / 2);
    return _imageView;
}

- (AMRatingControl *)ratingControl{
    if (_ratingControl) {
        return _ratingControl;
    }
    _ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointZero
                                                    emptyColor:[UIColor darkGrayColor]
                                                    solidColor:[UIColor yellowColor]
                                                    andMaxRating:5];;
    [_ratingControl setRating:2.5];
    [self.ratingContainerView addSubview:_ratingControl];
    _ratingControl.center = CGPointMake(self.ratingContainerView.frame.size.width / 2, self.ratingContainerView.frame.size.height / 2);
    return _ratingControl;
}

#pragma mark - UITableView Datasource

typedef NS_ENUM(NSInteger, SongAttributeType) {
    SongAttributeTypeYearReleased,
    SongAttributeTypeGenre,
    SongAttributeTypeArtist,
    SongAttributeTypeAlbum,
    SongAttributeTypeRank,
    SongAttributeTypeCount
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SongAttributeTypeCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songAttributeCellIdentifier forIndexPath:indexPath];

    switch (indexPath.row) {
        case SongAttributeTypeYearReleased:
            cell.textLabel.text = @"Year Released";
            cell.detailTextLabel.text = self.song.year.stringValue;
            break;
        case SongAttributeTypeGenre:
            cell.textLabel.text = @"Genre";
            cell.detailTextLabel.text = self.song.genre;
            break;
        case SongAttributeTypeArtist:
            cell.textLabel.text = @"Artist";
            cell.detailTextLabel.text = self.song.artist;
            break;
        case SongAttributeTypeAlbum:
            cell.textLabel.text = @"Album";
            cell.detailTextLabel.text = self.song.album;
            break;
        case SongAttributeTypeRank:
            cell.textLabel.text = @"Rank";
            cell.detailTextLabel.text = self.song.rank.stringValue;
            break;
        default:
            break;
    }
    return cell;
}
@end
