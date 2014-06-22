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
#import "Song+Networking.h"
#import <BlocksKit+UIKit.h>

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
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ratingTapGR;
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
    self.ratingLabel.textColor = [UIColor whiteColor];
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

- (void)showRatingPopup {
    UIAlertView *ratingAV = [UIAlertView bk_alertViewWithTitle:@"Rate"message:@"Rate the song according to your liking."];
    [ratingAV addButtonWithTitle:NSLocalizedString(@"CANCEL", nil)];
    AMRatingControl *ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointZero
                                                                    emptyColor:[UIColor darkGrayColor]
                                                                    solidColor:[UIColor yellowColor]
                                                                  andMaxRating:5];
    __block AMRatingControl *weakControl = ratingControl;
    [ratingControl setRating:0];
    [ratingAV setValue:ratingControl forKey:@"accessoryView"];

    __block SongDetailVC *weakSelf = self;
     ratingControl.editingDidEndBlock = ^(NSUInteger rating) {
     PFObject *pfSong = [PFObject objectWithoutDataWithClassName:@"Song" objectId:weakSelf.song.identifier];
     [pfSong fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
         if (!error) {
             PFObject *rating = [PFObject objectWithClassName:@"SongRating"];
             [rating setObject:[PFUser currentUser] forKey:@"user"];
             [rating setObject:[NSNumber numberWithInteger:weakControl.rating] forKey:@"stars"];
             [rating setObject:object forKey:@"song"];
             [rating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (!error) {
                     NSLog(@"title %@ now has been added a rating of %@",[[rating objectForKey:@"song"] objectForKey:titleKey], [rating objectForKey:@"stars"]);
                     [weakSelf updateSong];
                 } else {
                     NSLog(@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                 }
             }];
         } else {
             NSLog(@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
         }
        }];
         [ratingAV dismissWithClickedButtonIndex:-1 animated:YES];
     };
    [ratingAV show];
}

- (void)updateSong {
    PFObject *pfSong = [PFObject objectWithoutDataWithClassName:@"Song" objectId:self.song.identifier];
    [pfSong fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [Song updateSongIfNeeded:self.song withPFObject:object];
            [self.song.managedObjectContext save:nil];
            [self configureView];
        } else {
            NSLog(@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
        }
    }];
}

- (void)showShareActionSheet:(UIBarButtonItem *)shareBarButtonItem{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email",@"Text", nil];
    
    [actionSheet showInView:self.view];
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
    self.ratingControl.rating = self.song.rating.integerValue;
    self.ratingLabel.textAlignment = NSTextAlignmentCenter;
    [self.ratingTapGR addTarget:self action:@selector(showRatingPopup)];
    
    if ([PFUser currentUser]) {
        self.ratingTapGR.enabled = YES;
        self.ratingLabel.text = @"Tap to Rate";
    } else {
        self.ratingTapGR.enabled = NO;
        self.ratingLabel.text = @"Must Sign in to Rate";
    }
}

- (void)shareAsText{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        
        NSString *textBody;
        if ([PFUser currentUser]) {
            NSString *first = [PFUser currentUser][@"firstName"];
            NSString *last = [PFUser currentUser][@"lastName"];
             textBody = [NSString stringWithFormat:@"%@ %@ would like to share %@ by %@ with you", first, last, self.song.title, self.song.artist];
        } else {
            textBody = [NSString stringWithFormat:@"Check out %@ by %@", self.song.title, self.song.artist];
        }
        messageVC.subject = @"Someone shared a song with you!";
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
        NSString *textBody;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppStoreBadge" ofType:@"png"];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"Share" ofType:@"html"];
        NSError *error;
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"*!*@*#*$"
                                                           withString:base64];

        if ([PFUser currentUser]) {
            NSString *first = [PFUser currentUser][@"firstName"];
            NSString *last = [PFUser currentUser][@"lastName"];
            textBody = [NSString stringWithFormat:@"%@ %@ would like to share %@ by %@ with you on Looking Back.", first, last, self.song.title, self.song.artist];
        } else {
            textBody = [NSString stringWithFormat:@"Check out %@ by %@.", self.song.title, self.song.artist];
        }
        htmlString =[htmlString stringByReplacingOccurrencesOfString:@"!@#$%^&*()_+"
                                                          withString:textBody];
        [mailVC setMessageBody:htmlString isHTML:YES];
        mailVC.subject = @"Someone shared a song with you!";
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
    [_ratingControl setRating:self.song.rating.integerValue];
    [self.ratingContainerView addSubview:_ratingControl];
    _ratingControl.center = CGPointMake(self.ratingContainerView.frame.size.width / 2, self.ratingContainerView.frame.size.height / 2);
    [_ratingControl addTarget:self action:@selector(showRatingPopup) forControlEvents:UIControlEventTouchUpInside];
    _ratingControl.enabled = NO;
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
