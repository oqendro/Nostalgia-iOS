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

@interface SongDetailVC ()

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@end

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
	// Do any additional setup after loading the view.
    [self.imageView setImageWithURL:[NSURL URLWithString:self.song.thumbnail.url]
                   placeholderImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButtonPressed:(id)sender {
    [UIView transitionFromView:self.imageView
                        toView:self.tableView
                      duration:.25
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        NSLog(@"from %@",self.imageView);
                    }];

}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)
                                              style:UITableViewStylePlain];
    [self.containerView addSubview:_tableView];
    return _tableView;
}

- (UIImageView *)imageView{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [self.containerView addSubview:_imageView];
    return _imageView;
}
@end
