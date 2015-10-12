//
//  TvSeriesSearchViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "TvSeriesSearchViewController.h"
#import "Util.h"
#import "TVSeriesUtil.h"
#import "TVSeries.h"
#import "TVSeriesEntity.h"
#import "TVSeriesTableViewCell.h"
#import "TvSeriesDetailsViewController.h"
#import "DataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TvSeriesSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tvSearchTableView;
@property (nonatomic, strong) NSArray *tvSeries; // Array of type tvSeries
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) NSInteger tvId;

@end

@implementation TvSeriesSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tvSearchTableView.dataSource = self;
    self.tvSearchTableView.delegate = self;
    self.searchBar.delegate = self;
    
    //Register TvSeriesCell
    UINib *nib = [UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil];
    [self.tvSearchTableView registerNib:nib forCellReuseIdentifier:@"TvSeriesCell"];
    
    UIImage *image = [[UIImage imageNamed:@"Go"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchButton setImage:image forState:UIControlStateNormal];
    
    [Util changeTableViewDisplayStyle:self.tvSearchTableView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self reloadTable];
}

/*
 * hides keyboard
 */
- (void) hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

/*
 * Returns number of sections
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
 * Returns number of rows in section
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tvSeries.count;
}

/*
 * Returns TV series cell
 */

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TvSeriesCell";
    
    TVSeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TVSeries *tv = [self.tvSeries objectAtIndex:indexPath.row];
    if(tv.imagePath)
    {
        NSString *imageUrl = [[Util imageBaseUrl] stringByAppendingString:tv.imagePath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    else
    {
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
    [cell.addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

/*
 * Navigates to details page on selecting a row
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVSeries *tv = [self.tvSeries objectAtIndex:indexPath.row];
    self.tvId = tv.tvId.integerValue;
    
    [self performSegueWithIdentifier:@"ShowTvSeriesDetailsSegue" sender:self];
}

/*
 * Returns cell height
 */
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

/*
 * Segues to details page
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowTvSeriesDetailsSegue"])
    {
        TvSeriesDetailsViewController *details = segue.destinationViewController;
        details.tvId = self.tvId;
        details.navigatedFromSearch = YES;
    }
}

/*
 * Shows add options when add button is tapped
 */
-(IBAction)addButtonTapped:(UIButton *)sender
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

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self reloadTable];
    };
    return completionBlock;
}

-(void) reloadTable
{
    [self.tvSearchTableView reloadData];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Performs search when search button is tapped
 */
- (IBAction)searchButtonTapped:(id)sender
{
    [self searchTvSeries];
    [self hideKeyboard];
}

/*
 * Hides keyboard when cancel button is tapped
 */
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel button clicked");
    [self hideKeyboard];
}

/*
 * Performs search when enter is clicked
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchTvSeries];
    [self hideKeyboard];
}

/*
 *  Performs search on every letter when words are entered in the search bar
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString
{
    [self searchTvSeries];
}

/*
 * Calls webservice to get TV series based on keyword entered in search field
 */
-(void) searchTvSeries
{
    [self.view bringSubviewToFront:self.spinner];
    [Util startAnimating:self.spinner];
    
    NSLog(@"Search button clicked");
    SuccessBlock onSuccess = ^(NSArray *results){
        self.tvSeries = results;
        [self.tvSearchTableView reloadData];
        [Util stopAnimating:self.spinner];
    };
    
    [[DataManager dataManager] searchTsSeriesByTitle:self.searchBar.text withSuccess:onSuccess withFailure:nil];
}


@end
