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
@property (weak, nonatomic) IBOutlet UIView *transparencyView;
@property (strong, nonatomic) IBOutlet UIButton *toggleInfoButton;
@property (strong, nonatomic) AMRatingControl *ratingControl;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBAr;
@property (nonatomic, weak) UIBarButtonItem *favBarButtonItem;

@property BOOL infoShown;

@end

static NSString *songAttributeCellIdentifier = @"SongAttributeCell";
#warning LOCALIZE
@implementation SongDetailVC

#pragma mark - UIViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    [self view];
    self.ratingLabel.font = HelveticaNeueLight12;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"INFO_TITLE",@"Title of detail view controllers that says Info");
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"702-share-white"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(showShareActionSheet:)];
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"724-info-gray"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(infoButtonPressed:)];
    UIBarButtonItem *favorites = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"726-star-gray"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleFavorite:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    
    self.favBarButtonItem = favorites;
    [self.toolBAr setItems:@[flexSpace, share, flexSpace, info, flexSpace, favorites, flexSpace] animated:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.transparencyView.backgroundColor = [UIColor clearColor];
    self.ratingContainerView.backgroundColor= [UIColor clearColor];
    
    [self.toggleInfoButton setImage:[UIImage imageNamed:@"724-info-white"]
                           forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    self.tableView.alpha = 0;
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
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)configureView{
    self.titleLabel.text = self.song.title;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.song.thumbnail.url]
                   placeholderImage:[UIImage imageNamed:@"767-photo-1-white"]];
    
    if (self.song.favorite.boolValue) {
        self.favBarButtonItem.image = [UIImage imageNamed:@"726-star-filled-gray"];
    } else {
        self.favBarButtonItem.image = [UIImage imageNamed:@"726-star-gray"];
    }
    
    
    //ratings
    if ([PFUser currentUser]) {
        self.ratingControl.enabled = YES;
        self.ratingLabel.text = @"Tap a Star to Rate";
    } else {
        self.ratingControl.enabled = NO;
        self.ratingLabel.text = @"Must Sign in to Rate";
    }
    [self refreshLikes];
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

- (void)toggleFavorite:(UIBarButtonItem *)favBarButton{
    if (self.song.favorite.boolValue) {
        self.song.favorite = @NO;
        [favBarButton setImage:[UIImage imageNamed:@"726-star-gray"]];
    } else {
        self.song.favorite = @YES;
        [favBarButton setImage:[UIImage imageNamed:@"726-star-filled-gray"]];
    }
    NSError *error;
    [[NSManagedObjectContext MR_defaultContext] save:&error];
    if (error) {
        NSLog(@"%@",error.debugDescription);
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

- (IBAction)infoButtonPressed:(UIBarButtonItem *)sender {
    if (self.infoShown) {
        [UIView animateWithDuration:.25
                         animations:^{
                             self.transparencyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                             [sender setImage:[UIImage imageNamed:@"724-info-gray"]];
                             self.tableView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             self.infoShown = NO;
                         }];
    } else {
        [UIView animateWithDuration:.25
                         animations:^{
                             self.transparencyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
                             [sender setImage:[UIImage imageNamed:@"767-photo-1-gray"]];
                             self.tableView.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             self.infoShown = YES;
                         }];
    }
}

- (void)refreshLikes{
    NSDictionary *params = @{@"songID": self.song.identifier};
    [PFCloud callFunctionInBackground:@"averageStarsForSongId" withParameters:params block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@",error.debugDescription);
        }
        NSNumber *averageRating = object;
        self.ratingControl.rating = averageRating.integerValue;
    }];
}

#pragma mark - Getters

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)
                                              style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.rowHeight = 41;
    _tableView.center = self.imageView.center;
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
    __block SongDetailVC *weakSelf = self;
    _ratingControl.editingDidEndBlock = ^(NSUInteger rating) {
        PFQuery *query = [PFQuery queryWithClassName:@"Song" predicate:[NSPredicate predicateWithFormat:@"objectId = %@",weakSelf.song.identifier]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"count %lu",(unsigned long)objects.count);
            PFObject *songFound = objects.lastObject;
            PFObject *rating = [PFObject objectWithClassName:@"Rating"];
            [rating setObject:songFound forKey:@"song"];
            NSLog(@"user is %@",[PFUser currentUser]);
            [rating setObject:[PFUser currentUser] forKey:@"user"];
            [rating saveEventually:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"%@",error.debugDescription);
                }
                if (succeeded) {
                    NSLog(@"YAYYY");
                }
            }];
        }];
    };
    
    return _ratingControl;
}

#pragma mark - UITableView Datasource

typedef NS_ENUM(NSInteger, SongAttributeType) {
    SongAttributeTypeYearReleased,
    SongAttributeTypeGenre,
    SongAttributeTypeArtist,
    SongAttributeTypeAlbum,
    SongAttributeTypeRank,
    SongAttributeTypeRating,
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
        case SongAttributeTypeRating:
            cell.textLabel.text = @"Rating";
            cell.detailTextLabel.text = @"100";
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
    switch (result) {
        case MessageComposeResultCancelled:
            //
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewControllerDelegate delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            //
            break;
        case MFMailComposeResultFailed:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            //
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
