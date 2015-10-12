//
//  MovieDetailsViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/10/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataManager.h"
#import "Util.h"
#import "MoviesUtil.h"
#import "Movie.h"
#import "GenreEntity.h"
#import "CastEntity.h"
#import "ProducerEntity.h"
#import "DirectorEntity.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *producerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieOverviewTextView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;
@property (weak, nonatomic) IBOutlet UILabel *generesLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;

@property (nonatomic) BOOL objectInCoreData;

@property(strong, nonatomic) Movie *movie;
@property(strong, nonatomic) MovieEntity *movieFromCoreData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.movieOverviewTextView.delegate = self;
    self.titleLabel.textColor = [Util baseTintColor];
    self.movieOverviewTextView.textColor = [Util baseTintColor];
}

/*
 * Checks if movie exists in core data. If YES, gets movie details from core data
 * If NO, gets movie from web service
 */
-(void) viewWillAppear:(BOOL)animated
{
    [self getData];
    [self updateAddEditButton];
}

-(void) updateAddEditButton
{
    UIImage *image;
    if(self.movie)
    {
        image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else if(self.movieFromCoreData)
    {
        image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(showAddMovieOptions:)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}


-(void) getData
{
    self.objectInCoreData = [[DataManager dataManager] isObjectInListForEntity:@"MovieEntity" withId:self.movieId withIdString:@"movieId"];
    if(self.objectInCoreData){
        self.movieFromCoreData = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:self.movieId withName:@"movieId" inEntity:@"MovieEntity"];
        [self displayMovieFromCoreData];
        
    }
    else{
        SuccessBlock onSuccess = ^(NSArray *results)
        {
            self.movie = [results objectAtIndex:0];
            [self displayData];
            [self updateAddEditButton];
        };
        [[DataManager dataManager] getMovieDetailsByMovieId :self.movieId withSuccess:onSuccess withFailure:nil];
        
    }
}

/*
 * Updates text view frame so that textview size is same as text size
 */
-(void) viewDidAppear:(BOOL)animated
{
    [self updateTextViewFrame];
}

/*
 * Display backdrop image
 */
-(void) displayImage: (NSString *) backdropImagePath{
    NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString: backdropImagePath];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
}

/*
 * Display genres
 */
-(void) displayGenres: (NSArray *) genres{
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSInteger count = (genres.count > 3) ? 3: genres.count;
    for(int i = 0; i < count; i++)
    {
        //Core data
        if(self.objectInCoreData){
            GenreEntity *genre = genres[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", genre.name];
            }
            else{
                [temp appendString:genre.name];
            }
            //Webservice
        }else{
            Genre *genre = genres[i];
            if(i < (count - 1))
            {
                [temp appendFormat:@"%@, ", genre.genre];
            }
            else
            {
                [temp appendString:genre.genre];
            }
        }
    }
    self.generesLabel.text = temp;
}

/*
 * Display cast
 */
-(void) displayCast: (NSArray *) cast{
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSInteger count = (cast.count < 8) ? cast.count : 8;
    for(int i = 0; i < count; i++)
    {
        //Core data
        if(self.objectInCoreData){
            CastEntity *c = cast[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }
            else{
                [temp appendString:c.name];
            }
            //Web service
        }else{
            Cast *c = cast[i];
            if(i < (count - 1)){
                [temp appendFormat:@"%@, ", c.name];
            }
            else{
                [temp appendString:c.name];
            }
        }
    }
    //NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.lineSpacing = 3;
    //NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    self.castLabel.attributedText = [Util displayString:temp];
}

-(void) displayMovieFromCoreData
{
    self.titleLabel.text = self.movieFromCoreData.title;
    self.releaseDateLabel.text = self.movieFromCoreData.releaseDate;
    self.votesLabel.text = [Util showVoteAverage: self.movieFromCoreData.voteAverage.stringValue];
    
    self.movieOverviewTextView.text = self.movieFromCoreData.overview;
    [self updateTextViewFrame];
    
    //Display backdrop image
    if(self.movieFromCoreData.backDropImagePath){
        [self displayImage:self.movieFromCoreData.backDropImagePath];
    }
    
    //Display genres
    NSArray *genres = [self.movieFromCoreData.genres allObjects];
    [self displayGenres:genres];
    
    //Display cast
    NSArray *cast = [self.movieFromCoreData.cast allObjects];
    [self displayCast:cast];
    
    //Display crew
    self.directorNameLabel.text = self.movieFromCoreData.director.name;
    self.producerNameLabel.text = self.movieFromCoreData.producer.name;
}

-(void) displayData
{
    self.titleLabel.text = self.movie.title;
    self.releaseDateLabel.text = self.movie.releaseDate;
    self.votesLabel.text = [Util showVoteAverage: self.movie.voteAverage.stringValue];
    
    self.movieOverviewTextView.text = self.movie.overview;
    [self updateTextViewFrame];
    
    //Display backdrop image
    if(self.movie.backDropImagePath){
        [self displayImage:self.movie.backDropImagePath];
    }
    
    //Display genres
    [self displayGenres:self.movie.genres];
    
    //Display cast
    [self displayCast:self.movie.cast];
    
    //Display crew
    for(int i = 0; i < self.movie.crew.count; i++){
        Crew *cast = self.movie.crew[i];
        if([cast.job isEqualToString:@"Director"]){
            self.directorNameLabel.text = cast.name;
        }
        if([cast.job isEqualToString:@"Producer"]){
            self.producerNameLabel.text = cast.name;
        }
    }
    
}


- (IBAction)showAddMovieOptions:(id)sender
{
    if(self.movie)
    {
        [self addMovieOptions];
    }
    else if(self.movieFromCoreData)
    {
        [self addMovieToCoreDataOptions];
    }
}

-(void) editWatchedMovies : (NSInteger) movieId
{
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editWatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) editUnwatchedMovies :(NSInteger) movieId
{
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editUnwatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) editFavoriteMovies: (NSInteger) movieId
{
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editFavoriteMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) addMovieToCoreDataOptions
{
    NSInteger movieId = self.movieFromCoreData.movieId.integerValue;
    if(self.navigatedFromSearch)
    {
        if(self.movieFromCoreData.status.integerValue == WATCHED)
        {
            [self editWatchedMovies:movieId];
        }
        else if(self.movieFromCoreData.status.integerValue == UNWATCHED)
        {
            [self editUnwatchedMovies:movieId];
        }
    }
    else
    {
        if(self.movieControl == WATCHED)
        {
            [self editWatchedMovies:movieId];
        }
        else if(self.movieControl == UNWATCHED)
        {
            [self editUnwatchedMovies:movieId];
        }
        else
        {
            [self editFavoriteMovies:movieId];
        }
    }
}

- (CGFloat) updateTextViewFrame
{
    CGRect frame = self.movieOverviewTextView.frame;
    frame.size.height = self.movieOverviewTextView.contentSize.height;
    self.movieOverviewTextView.frame = frame;
    CGFloat height = ceilf([self.movieOverviewTextView sizeThatFits:self.movieOverviewTextView.contentSize].height);
    
    self.textViewHeightConstraint.constant = (height);
    return height;
}

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    return completionBlock;
}

//Move to util
-(void) addMovieOptions
{
    
    UIAlertController *alertController = [[MoviesUtil moviesUtil] showAddMovieOptions:self.movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
