//
//  MoviesSearchViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/9/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MoviesSearchViewController.h"
#import "MovieDetailsViewController.h"
#import "Util.h"
#import "MoviesUtil.h"
#import "MoviesTableViewCell.h"
#import "DataManager.h"
#import "Movie.h"
#import "MovieEntity.h"
#import <Restkit/Restkit.h>

@interface MoviesSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *moviesSearchTableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) NSArray *movies; // Array of type movie
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) NSInteger movieId;


@end

@implementation MoviesSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviesSearchTableView.dataSource = self;
    self.moviesSearchTableView.delegate = self;
    self.searchBar.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil];
    [self.moviesSearchTableView registerNib:nib forCellReuseIdentifier:@"MovieCell"];
    
    UIImage *image = [[UIImage imageNamed:@"Go"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchButton setImage:image forState:UIControlStateNormal];
    [self.searchButton setTintColor:[Util baseTintColor]];
    
    [Util changeTableViewDisplayStyle:self.moviesSearchTableView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self reloadTable];
}

- (void) hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
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
    [cell.addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MovieCell";
    
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    if(movie.imagePath)
    {
        NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:movie.imagePath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    cell.titleLabel.attributedText = [Util displayString:movie.title];
    cell = [self addButtonToCell:cell forMovieId:movie.movieId.integerValue];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    self.movieId = movie.movieId.integerValue;
    
    [self performSegueWithIdentifier:@"ShowMovieDetailsSegue" sender:self];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowMovieDetailsSegue"])
    {
        MovieDetailsViewController *details = segue.destinationViewController;
        details.movieId = self.movieId;
        details.navigatedFromSearch = YES;
    }
}

-(IBAction)addButtonTapped:(UIButton *)sender
{
    NSUInteger movieId = sender.tag;
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

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self reloadTable];
    };
    return completionBlock;
}

-(void) reloadTable
{
    [self.moviesSearchTableView reloadData];
}

-(void) editWatchedMovies : (NSUInteger) movieId
{
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editWatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) editUnwatchedMovies :(NSUInteger) movieId
{
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editUnwatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self searchMovies];
    [self hideKeyboard];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel button clicked");
    [self hideKeyboard];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchMovies];
    [self hideKeyboard];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString
{
    [self searchMovies];
}

-(void) searchMovies
{
    [self.view bringSubviewToFront:self.spinner];
    [Util startAnimating:self.spinner];
    NSLog(@"Search button clicked");
    SuccessBlock onSuccess = ^(NSArray *results){
        self.movies = results;
        [self.moviesSearchTableView reloadData];
        [Util stopAnimating:self.spinner];
    };
    
    [[DataManager dataManager] searchMoviesByTitle:self.searchBar.text withSuccess:onSuccess withFailure:nil];
}

@end
