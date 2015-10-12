//
//  MoviesViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/7/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "DataManager.h"
#import "Movie.h"
#import "Util.h"
#import "MoviesUtil.h"
#import "MovieDetailsViewController.h"
#import "EmptyTableViewCell.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *movieStatusControl;
@property (strong, nonatomic) NSArray *moviesSaved;
@property (nonatomic) NSInteger selectedMovieId;

@end

@implementation MoviesViewController

- (void)viewDidLoad
{
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;
    
    [self.moviesTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.moviesTableView.backgroundColor = [UIColor clearColor];
    self.moviesTableView.backgroundView = nil;
    self.moviesTableView.opaque = NO;
    
    [self.moviesTableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.moviesTableView.layer setBorderWidth:0.5f];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getData];
}

-(void) getData
{
    if(self.movieStatusControl.selectedSegmentIndex == WATCHED)
    {
        //Get movies with status watched
        self.moviesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:WATCHED withName:@"status" inEntity:@"MovieEntity"];
    }
    else if(self.movieStatusControl.selectedSegmentIndex == UNWATCHED)
    {
        //Get movies with status unwatched
        self.moviesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:UNWATCHED withName:@"status" inEntity:@"MovieEntity"];
    }
    else
    {
        //Get favorite movies
        self.moviesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:1 withName:@"favorite" inEntity:@"MovieEntity"];
    }
    if(self.moviesSaved.count > 0)
    {
        UINib *nib = [UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil];
        [self.moviesTableView registerNib:nib forCellReuseIdentifier:@"MovieCell"];
    }
    else
    {
        UINib *nib = [UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil];
        [self.moviesTableView registerNib:nib forCellReuseIdentifier:@"EmptyCell"];
    }
    [self.moviesTableView reloadData];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (([self isTableEmpty]) ? 1: self.moviesSaved.count);
}

-(BOOL) isTableEmpty{
    return (self.moviesSaved.count <= 0);
}

-(UITableViewCell *) emptyCellForTableView : (UITableView *) tableView atIndexPath: (NSIndexPath *) indexPath{
    static NSString *cellIdentifier = @"EmptyCell";
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *str;
    if(self.movieStatusControl.selectedSegmentIndex == WATCHED)
    {
        str = @"Search for movie and add to 'Watched' list";
    }
    else if(self.movieStatusControl.selectedSegmentIndex == UNWATCHED)
    {
        str = @"Search for movie and add to 'Want to watch' list";
    }
    else
    {
        str = @"Add your favorite movies from the 'Watched' list to the 'Favorites' list";
    }
    cell.messageLabel.text = str;
    
    return cell;
}

-(MoviesTableViewCell *) addTButtonToCell : (MoviesTableViewCell *) cell forMovie : (MovieEntity *) movie
{
    cell.addButton.tag = movie.movieId.integerValue;
    
    [cell.addButton removeTarget:self action:@selector(editWatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton removeTarget:self action:@selector(editUnwatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton removeTarget:self action:@selector(editFavoritesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.addButton setImage:image forState:UIControlStateNormal];
    [cell.addButton setTintColor:[Util baseTintColor]];
    
    if(self.movieStatusControl.selectedSegmentIndex == WATCHED){
        [cell.addButton addTarget:self action:@selector(editWatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.movieStatusControl.selectedSegmentIndex == UNWATCHED){
        [cell.addButton addTarget:self action:@selector(editUnwatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [cell.addButton addTarget:self action:@selector(editFavoritesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isTableEmpty]){
        return [self emptyCellForTableView:tableView atIndexPath:indexPath];
    }
    
    static NSString *cellIdentifier = @"MovieCell";
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    MovieEntity *movie = [self.moviesSaved objectAtIndex:indexPath.row];
    
    if(movie.imagePath){
        NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:movie.imagePath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    
    cell.titleLabel.attributedText = [Util displayString:movie.title];
    cell = [self addTButtonToCell: cell forMovie: movie];
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isTableEmpty])
    {
        return self.view.frame.size.height;
    }
    return CELL_HEIGHT;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isTableEmpty])
    {
        Movie *movie = [self.moviesSaved objectAtIndex:indexPath.row];
        self.selectedMovieId = movie.movieId.integerValue;
        [self performSegueWithIdentifier:@"ShowListMovieDetails" sender:self];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowListMovieDetails"])
    {
        MovieDetailsViewController *details = segue.destinationViewController;
        details.movieId = self.selectedMovieId;
        details.movieControl = self.movieStatusControl.selectedSegmentIndex;
    }
}


-(IBAction)editWatchedButtonTapped:(UIButton *)sender
{
    NSInteger movieId = sender.tag;
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editWatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)editUnwatchedButtonTapped:(UIButton *)sender
{
    NSInteger movieId = sender.tag;
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editUnwatchedMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)editFavoritesButtonTapped:(UIButton *)sender
{
    NSInteger movieId = sender.tag;
    UIAlertController *alertController = [[MoviesUtil moviesUtil] editFavoriteMovies:movieId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self getData];
    };
    return completionBlock;
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    [self getData];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
