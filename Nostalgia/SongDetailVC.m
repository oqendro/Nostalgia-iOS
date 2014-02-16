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
@import MessageUI;

@interface SongDetailVC () <UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *ratingContainerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *toggleInfoButton;
@property (strong, nonatomic) AMRatingControl *ratingControl;

@end

static NSString *songAttributeCellIdentifier = @"SongAttributeCell";
#warning LOCALIZE
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
    self.title = NSLocalizedString(@"INFO_TITLE",@"Title of detail view controllers that says Info");
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"702-share-white"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(showShareActionSheet:)];
    self.navigationItem.rightBarButtonItem = share;
    
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

#pragma mark - Convenience Methods

- (void)showShareActionSheet:(UIBarButtonItem *)shareBarButtonItem{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email",@"Text", nil];
    
    [actionSheet showFromBarButtonItem:shareBarButtonItem animated:YES];
}

- (void)configureView{
    self.titleLabel.text = self.song.title;
    [self.ratingControl setRating:2.5];
}

#warning PUT IN CONSTANTS & add html and pics
- (void)shareAsText{
    if ([MFMessageComposeViewController canSendText]) {
        NSString *first = [PFUser currentUser][@"firstName"];
        NSString *last = [PFUser currentUser][@"lastName"];

        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        NSString *textBody = [NSString stringWithFormat:@"%@ %@ wanted to share %@ by %@ with you", first, last, self.song.title, self.song.artist];
        NSString *linkToApp = @"www.nostaligia.com";
        messageVC.body = [NSString stringWithFormat:@"%@ \n %@",textBody, linkToApp];
        [self presentViewController:messageVC animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device cannot send text"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)shareAsEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        NSString *first = [PFUser currentUser][@"firstName"];
        NSString *last = [PFUser currentUser][@"lastName"];
        NSString *textBody = [NSString stringWithFormat:@"%@ %@ wanted to share %@ by %@ with you", first, last, self.song.title, self.song.artist];
        NSString *linkToApp = @"www.nostaligia.com";
        [mailVC setMessageBody:[NSString stringWithFormat:@"%@ \n %@",textBody, linkToApp] isHTML:NO];
        [self presentViewController:mailVC animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device cannot send email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
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

#pragma mark - UIActionSheet Delegte 

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self shareAsEmail];
            break;
        case 1:
            [self shareAsText];
            break;
        default:
            break;
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

#pragma mark - MFMessageComposeViewControllerDelegate delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
}
#pragma mark - MFMailComposeViewControllerDelegate delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
}
@end
