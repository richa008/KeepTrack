//
//  NowPlayingViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/31/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "PopularViewController.h"
#import "Util.h"
#import "TVSeries.h"
#import "TVSeriesEntity.h"
#import "TVSeriesTableViewCell.h"
#import "MoviesTableViewCell.h"
#import "TvSeriesDetailsViewController.h"
#import "MovieDetailsViewController.h"
#import "DataManager.h"
#import "Movie.h"
#import "TVSeriesUtil.h"
#import "MoviesUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PopularViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) NSInteger selectedTvId;
@property (nonatomic) NSInteger selectedMovieId;

@property (strong, nonatomic) NSArray *popular;

@end

@implementation PopularViewController

#define kMovieControl 0
#define kTvControl 1

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [Util changeTableViewDisplayStyle:self.tableView];
    [self getData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self reloadTable];
}

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self reloadTable];
    };
    return completionBlock;
}

-(void) reloadTable
{
    [self.tableView reloadData];
}

/*
 * Gets list of currently popular movies if movies tab is selected.
 * Gets list of currently popular TV series if TV tab is selected
 */
-(void) getData
{
    [self.view bringSubviewToFront:self.spinner];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [Util startAnimating:self.spinner];
    
    if(self.segmentedController.selectedSegmentIndex == kMovieControl)
    {
        SuccessBlock onSuccess = ^(NSArray *results){
            self.popular = results;
            [self.tableView reloadData];
            [Util stopAnimating:self.spinner];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        };
        [[DataManager dataManager] popularMovies:onSuccess withFailure:nil];
        
        UINib *nib = [UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"MovieCell"];
    }
    else
    {
        SuccessBlock onSuccess = ^(NSArray *results){
            self.popular = results;
            [self.tableView reloadData];
            [Util stopAnimating:self.spinner];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        };
        [[DataManager dataManager] popularTvSeries:onSuccess withFailure:nil];
        
        UINib *nib = [UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"TvSeriesCell"];
    }
}

#pragma mark - Table view methods

/*
 * Returns number of sections in table view
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
 * Returns number of rows in a section
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.popular.count - 1);
}

/*
 *  Shows the MovieCell if movies tab is selected
 *  Shows the TvCell if TV tab is selected
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segmentedController.selectedSegmentIndex == kMovieControl)
    {
        return [self showMovieCell:tableView atIndexPath:indexPath];
    }
    
    return [self showTvCell:tableView atIndexPath:indexPath];
}

/*
 * Displays TV Series information in tv cell
 */
-(UITableViewCell *) showTvCell : (UITableView *) tableView atIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"TvSeriesCell";
    TVSeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TVSeries *tv = [self.popular objectAtIndex:indexPath.row];
    if(tv.imagePath){
        NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:tv.imagePath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    cell.titleLabel.attributedText = [Util displayString:tv.name];
    cell = [self addButtonToCell:cell forTvId:tv.tvId.integerValue];
    
    return cell;
}

-(TVSeriesTableViewCell *) addButtonToCell : (TVSeriesTableViewCell *) cell forTvId : (NSInteger) tvId
{
    cell.addButton.tag = tvId;
    UIImage *image;
    if([[DataManager dataManager] isObjectInListForEntity:@"TVSeriesEntity" withId:tvId withIdString:@"tvId"]){
        image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else{
        image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [cell.addButton setImage:image forState:UIControlStateNormal];
    [cell.addButton setTintColor:[Util baseTintColor]];
    [cell.addButton addTarget:self action:@selector(addTvButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



/*
 * Displays Movie information in movie cell
 */
-(UITableViewCell *) showMovieCell : (UITableView *) tableView atIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"MovieCell";
    
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Movie *movie = [self.popular objectAtIndex:indexPath.row];
    if(movie.imagePath){
        NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:movie.imagePath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    cell.titleLabel.attributedText = [Util displayString:movie.title];
    cell = [self addButtonToCell:cell forMovieId:movie.movieId.integerValue];
    
    return cell;
}

-(MoviesTableViewCell *) addButtonToCell : (MoviesTableViewCell *) cell forMovieId : (NSInteger) movieId
{
    cell.addButton.tag = movieId;
    UIImage *image;
    if([[DataManager dataManager] isObjectInListForEntity:@"MovieEntity" withId:movieId withIdString:@"movieId"]){
        image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else{
        image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [cell.addButton setImage:image forState:UIControlStateNormal];
    [cell.addButton setTintColor:[Util baseTintColor]];
    [cell.addButton addTarget:self action:@selector(addMovieButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



/*
 * Segue to details page if cell is selected
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segmentedController.selectedSegmentIndex == kMovieControl)
    {
        Movie *movie = [self.popular objectAtIndex:indexPath.row];
        self.selectedTvId = movie.movieId.integerValue;
        
        [self performSegueWithIdentifier:@"showPopularMovieDetailsSegue" sender:self];
    }
    else
    {
        TVSeries *tv = [self.popular objectAtIndex:indexPath.row];
        self.selectedTvId = tv.tvId.integerValue;
        
        [self performSegueWithIdentifier:@"showPopularTvDetailsSegue" sender:self];
    }
}

/*
 *  Returns height of cell
 */
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

/*
 * Shows the options to add TV serial to the list
 *
 */
-(IBAction)addTvButtonTapped:(UIButton *)sender
{
    NSInteger tvId = sender.tag;
    
    if([[DataManager dataManager] isObjectInListForEntity:@"TVSeriesEntity" withId:tvId withIdString:@"tvId"])
    {
        TVSeriesEntity *tvEntity = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
        if(tvEntity.status.integerValue == WATCHED)
        {
            [self editWatchedTv: tvId];
        }
        else if(tvEntity.status.integerValue == UNWATCHED)
        {
            [self editUnwatchedTv:tvId];
        }
    }
    else
    {
        
        UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] showAddTVOptions:tvId onCompletion:[self completionBlock]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/*
 * Shows options for watched TV
 */
-(void) editWatchedTv : (NSInteger) tvId
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editWatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows options for unwatched TV
 */
-(void) editUnwatchedTv :(NSInteger) tvId
{
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editUnwatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows the options to add movie to the list
 *
 */
-(IBAction)addMovieButtonTapped:(UIButton *)sender
{
    NSInteger movieId = sender.tag;
    if([[DataManager dataManager] isObjectInListForEntity:@"MovieEntity" withId:movieId withIdString:@"movieId"])
    {
        MovieEntity *movieEntity = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
        if(movieEntity.status.integerValue == WATCHED)
        {
            [self editWatchedMovies:movieId];
        }
        else if(movieEntity.status.integerValue == UNWATCHED)
        {
            [self editUnwatchedMovies:movieId];
        }
    }
    else
    {
        UIAlertController *alertController = [[MoviesUtil moviesUtil] showAddMovieOptions:movieId onCompletion:[self completionBlock]];
        [self presentViewController:alertController animated:YES completion:nil];
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

/*
 * Sets the id before navigating to the details page
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPopularTvDetailsSegue"])
    {
        TvSeriesDetailsViewController *details = segue.destinationViewController;
        details.tvId = self.selectedTvId;
    }
    if([segue.identifier isEqualToString:@"showPopularMovieDetailsSegue"])
    {
        MovieDetailsViewController *details = segue.destinationViewController;
        details.movieId = self.selectedTvId;
    }
}

/*
 * Gets data when tabs are changed
 */
- (IBAction)segementedControllerValueChanged:(id)sender
{
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
