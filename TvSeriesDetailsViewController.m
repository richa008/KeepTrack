//
//  TvSeriesDetailsViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/19/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "Util.h"
#import "GenreEntity.h"
#import "TvSeriesDetailsViewController.h"
#import "DataManager.h"
#import "TVSeries.h"
#import "TVSeriesEntity.h"
#import "CastEntity.h"
#import "ProducerEntity.h"
#import "TVSeriesUtil.h"

@interface TvSeriesDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstAirDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastAirDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberSeasonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberEpisodesLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *voteAverageLabel;

@property(strong, nonatomic) TVSeries *tvSeries;
@property(strong, nonatomic) TVSeriesEntity *tvSeriesFromCoreData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (nonatomic) BOOL objectInCoreData;

@end

@implementation TvSeriesDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.titleLabel.textColor = [Util baseTintColor];
    self.textView.textColor = [Util baseTintColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Gets TV Series from core data if the series is already in list
 * If not, makes a web service call to get TV series details
 */
-(void) viewWillAppear:(BOOL)animated
{
    self.objectInCoreData =[[DataManager dataManager] isObjectInListForEntity:@"TVSeriesEntity" withId:self.tvId withIdString:@"tvId"];
    if(self.objectInCoreData)
    {
        self.tvSeriesFromCoreData = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:self.tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
        [self displayDataFromCoreData];
        [self updateAddEditButton];
    }
    else
    {
        SuccessBlock onSuccess = ^(NSArray *results)
        {
            self.tvSeries = [results objectAtIndex:0];
            [self displayData];
            [self updateAddEditButton];
        };
        [[DataManager dataManager] getTvSeriesDetailsById:self.tvId withSuccess:onSuccess withFailure:nil];
    }
}

-(void) updateAddEditButton
{
    UIImage *image;
    if(self.tvSeries)
    {
        image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else if(self.tvSeriesFromCoreData)
    {
        image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(showAddTvOptions:)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

/*
 * Updates text view frame so that textview size is same as text size
 */
-(void) viewDidAppear:(BOOL)animated
{
    [self updateTextViewFrame];
}

/*
 * Displays details from core data
 *
 */
-(void) displayDataFromCoreData
{
    self.titleLabel.text = self.tvSeriesFromCoreData.name;
    self.firstAirDateLabel.text = self.tvSeriesFromCoreData.firstAirDate;
    self.lastAirDateLabel.text = self.tvSeriesFromCoreData.lastAirDate;
    self.numberEpisodesLabel.text = self.tvSeriesFromCoreData.numberOfEpisodes.stringValue;
    self.numberSeasonsLabel.text = self.tvSeriesFromCoreData.numberOfSeasons.stringValue;
    self.voteAverageLabel.text = [Util showVoteAverage: self.tvSeriesFromCoreData.voteAverage.stringValue];
    
    self.textView.text = self.tvSeriesFromCoreData.overview;
    [self updateTextViewFrame];
    
    //Display backdrop image
    if(self.tvSeriesFromCoreData.backdropImage)
    {
        [self displayImage:self.tvSeriesFromCoreData.backdropImage];
    }
    
    //Display genres
    [self displayGenres:[self.tvSeriesFromCoreData.genres allObjects]];
    
    //Display cast
    NSArray *cast = [self.tvSeriesFromCoreData.cast allObjects];
    [self displayCast:cast];
    
    //Display created by
    NSArray *createdBy = [self.tvSeriesFromCoreData.createdBy allObjects];
    [self displayCrew:createdBy];
}

/*
 * Displays details from web service
 *
 */
-(void) displayData
{
    self.titleLabel.text = self.tvSeries.name;
    self.firstAirDateLabel.text = self.tvSeries.firstAirDate;
    self.lastAirDateLabel.text = self.tvSeries.lastAirDate;
    self.numberEpisodesLabel.text = self.tvSeries.noOfEpisodes.stringValue;
    self.numberSeasonsLabel.text = self.tvSeries.noOfSeasons.stringValue;
    self.voteAverageLabel.text = [Util showVoteAverage: self.tvSeries.voteAverage.stringValue];
    
    self.textView.text = self.tvSeries.overview;
    [self updateTextViewFrame];
    
    //Display backdrop image
    if(self.tvSeries.backDropImagePath){
        [self displayImage:self.tvSeries.backDropImagePath];
    }
    
    //Display genres
    [self displayGenres:self.tvSeries.genres];
    
    //Display cast
    [self displayCast:self.tvSeries.cast];
    
    //Display created by
    [self displayCrew:self.tvSeries.createdBy];
}

/*
 * Display backdrop image
 */
-(void) displayImage: (NSString *) backdropPath
{
    NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:backdropPath];
    [self.backdropImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
}

/*
 * Display genres
 */
-(void) displayGenres: (NSArray *) genres
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSInteger count = (genres.count > 3) ? 3: genres.count;
    for(int i = 0; i < count; i++)
    {
        if(self.objectInCoreData){
            GenreEntity *genre = genres[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", genre.name];
            }else{
                [temp appendString:genre.name];
            }
        }
        else{
            Genre *genre = genres[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", genre.genre];
            }else{
                [temp appendString:genre.genre];
            }
        }
    }
    self.genresLabel.text = temp;
}

/*
 * Display cast
 */
-(void) displayCast : (NSArray *) cast
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSInteger count = (cast.count < 8) ? cast.count : 8;
    for(int i = 0; i < count; i++)
    {
        if(self.objectInCoreData){
            CastEntity *c = cast[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }else{
                [temp appendString:c.name];
            }
        }
        else
        {
            Cast *c = cast[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }else{
                [temp appendString:c.name];
            }
        }
    }
    self.castLabel.attributedText = [Util displayString:temp];
}

/*
 * Display crew
 */
-(void) displayCrew: (NSArray *) crew
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSInteger count = (crew.count < 2) ? crew.count : 2;
    for(int i = 0; i < count; i++)
    {
        if(self.objectInCoreData){
            ProducerEntity *c = crew[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }else{
                [temp appendString:c.name];
            }
        }
        else{
            Crew *c = crew[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }else{
                [temp appendString:c.name];
            }
        }
    }
    self.createdByLabel.text = temp;
}


/*
 * Shows add tv shows options when add/edit button is tapped
 */
- (IBAction)showAddTvOptions:(id)sender
{
    if(self.tvSeries)
    {
        [self addTvOptions];
    }
    else if(self.tvSeriesFromCoreData)
    {
        [self addTvToCoreDataOptions];
    }
}

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    return completionBlock;
}

/*
 * Shows edit options if the object is in the Watched list
 */
-(void) editWatchedTv : (NSInteger) tvId
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editWatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows edit options if the object is in the UnWatched list
 */
-(void) editUnwatchedTv :(NSInteger) tvId
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editUnwatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows edit options if the object is in the Favorite list
 */
-(void) editFavoriteTv: (NSInteger) tvId
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editFavoriteTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows edit options if the object is in core data
 */
-(void) addTvToCoreDataOptions
{
    NSInteger tvId = self.tvSeriesFromCoreData.tvId.integerValue;
    if(self.navigatedFromSearch)
    {
        if(self.tvSeriesFromCoreData.status.integerValue == WATCHED)
        {
            [self editWatchedTv:tvId];
        }
        else if(self.tvSeriesFromCoreData.status.integerValue == UNWATCHED)
        {
            [self editUnwatchedTv:tvId];
        }
    }
    else
    {
        if(self.tvControl == WATCHED)
        {
            [self editWatchedTv:tvId];
        }
        else if(self.tvControl == UNWATCHED)
        {
            [self editUnwatchedTv:tvId];
        }
        else
        {
            [self editFavoriteTv:tvId];
        }
    }
}

/*
 * Shows add options
 */
-(void) addTvOptions
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] showAddTVOptions:self.tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Updates height of text view based on the height of the text content
 */
- (CGFloat)updateTextViewFrame
{
    CGRect frame = self.textView.frame;
    frame.size.height = self.textView.contentSize.height;
    self.textView.frame = frame;
    CGFloat height = ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
    self.textViewHeightConstraint.constant = (height);
    
    return height;
}


@end
