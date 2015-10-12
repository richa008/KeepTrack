//
//  TvSeriesViewController.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "TvSeriesViewController.h"
#import "DataManager.h"
#import "TVSeriesTableViewCell.h"
#import "TvSeriesDetailsViewController.h"
#import "Util.h"
#import "TVSeriesUtil.h"
#import "TVSeriesEntity.h"
#import "TVSeries.h"
#import "EmptyTableViewCell.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface TvSeriesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tvSeriesTableView;

@property (strong, nonatomic) NSArray *tvSeriesSaved;
@property (nonatomic) NSInteger selectedTvSeriesId;

@end

@implementation TvSeriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tvSeriesTableView.dataSource = self;
    self.tvSeriesTableView.delegate = self;
    
    [self.tvSeriesTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tvSeriesTableView.backgroundColor = [UIColor clearColor];
    self.tvSeriesTableView.backgroundView = nil;
    self.tvSeriesTableView.opaque = NO;
    
    [self.tvSeriesTableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.tvSeriesTableView.layer setBorderWidth:0.5f];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getData];
}

/*
 * Gets list from core date based on which the selected tab, Watched, Unwatched or Favorite
 */
-(void) getData
{
    if(self.segmentedControl.selectedSegmentIndex == WATCHED)
    {
        self.tvSeriesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:WATCHED withName:@"status" inEntity:@"TVSeriesEntity"];
    }
    else if(self.segmentedControl.selectedSegmentIndex == UNWATCHED)
    {
        self.tvSeriesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:UNWATCHED withName:@"status" inEntity:@"TVSeriesEntity"];
    }
    else
    {
        self.tvSeriesSaved = [[DataManager dataManager] objectArrayFromCoreDataWithValue:1 withName:@"favorite" inEntity:@"TVSeriesEntity"];
    }
    if(self.tvSeriesSaved.count > 0)
    {
        UINib *nib = [UINib nibWithNibName:@"TVSeriesTableViewCell" bundle:nil];
        [self.tvSeriesTableView registerNib:nib forCellReuseIdentifier:@"TvSeriesCell"];
    }
    else
    {
        UINib *nib = [UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil];
        [self.tvSeriesTableView registerNib:nib forCellReuseIdentifier:@"EmptyCell"];
    }
    
    [self.tvSeriesTableView reloadData];
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
    return ((self.tvSeriesSaved.count > 0) ? self.tvSeriesSaved.count: 1);
    
}

-(BOOL) isTableEmpty{
    return (self.tvSeriesSaved.count == 0);
}

-(UITableViewCell *) emptyCellForTableView: (UITableView *) tableView atIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"EmptyCell";
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *str;
    if(self.segmentedControl.selectedSegmentIndex == WATCHED)
    {
        str = @"Search for TV shows and add to 'Watched' list";
    }
    else if(self.segmentedControl.selectedSegmentIndex == UNWATCHED)
    {
        str = @"Search for TV shows and add to 'Want to watch' list";
    }
    else
    {
        str = @"Add your favorite TV shows from the 'Watched' list to the 'Favorites' list";
    }
    cell.messageLabel.text = str;
    return cell;
}

/*
 * If there are no tv shows, displays empty list message
 * If not, shows TV cell
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isTableEmpty])
    {
        return [self emptyCellForTableView:tableView atIndexPath:indexPath];
    }
    static NSString *cellIdentifier = @"TvSeriesCell";
    TVSeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TVSeriesEntity *tv = [self.tvSeriesSaved objectAtIndex:indexPath.row];
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
    
    cell = [self addButtonToCell:cell forTv:tv];
    return cell;
}

-(TVSeriesTableViewCell *) addButtonToCell : (TVSeriesTableViewCell *) cell forTv : (TVSeriesEntity *) tv
{
    cell.addButton.tag = tv.tvId.integerValue;
    
    [cell.addButton removeTarget:self action:@selector(editWatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton removeTarget:self action:@selector(editUnwatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton removeTarget:self action:@selector(editFavoritesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   
    UIImage *image = [[UIImage imageNamed:@"Edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.addButton setImage:image forState:UIControlStateNormal];
    [cell.addButton setTintColor:[Util baseTintColor]];
    
    if(self.segmentedControl.selectedSegmentIndex == WATCHED){
        [cell.addButton addTarget:self action:@selector(editWatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.segmentedControl.selectedSegmentIndex == UNWATCHED){
        [cell.addButton addTarget:self action:@selector(editUnwatchedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [cell.addButton addTarget:self action:@selector(editFavoritesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


/*
 * Returns height for row
 */
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isTableEmpty])
    {
        return self.view.frame.size.height;
    }
    return CELL_HEIGHT;
}

/*
 * Segues to details page if cell is selected
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isTableEmpty])
    {
        TVSeries *tv = [self.tvSeriesSaved objectAtIndex:indexPath.row];
        self.selectedTvSeriesId = tv.tvId.integerValue;
        
        [self performSegueWithIdentifier:@"ShowTvSeriesMyListDetailsSegue" sender:self];
    }
}

/*
 * Passes id while navigating to the details page
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowTvSeriesMyListDetailsSegue"])
    {
        TvSeriesDetailsViewController *details = segue.destinationViewController;
        details.tvId = self.selectedTvSeriesId;
        details.tvControl = self.segmentedControl.selectedSegmentIndex;
    }
}

/*
 * Shows options when edit button is tapped if object is in watched list
 */
-(IBAction)editWatchedButtonTapped:(UIButton *)sender
{
    NSInteger tvId = sender.tag;
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editWatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows options when edit button is tapped if object is in unwatched list
 */
-(IBAction)editUnwatchedButtonTapped:(UIButton *)sender
{
    NSInteger tvId = sender.tag;
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editUnwatchedTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 * Shows options when edit button is tapped if object is in favorites list
 */
-(IBAction)editFavoritesButtonTapped:(UIButton *)sender
{
    NSInteger tvId = sender.tag;
    UIAlertController *alertController = [[TVSeriesUtil tvSeriesUtil] editFavoriteTv:tvId onCompletion:[self completionBlock]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(CompletionBlock) completionBlock{
    CompletionBlock completionBlock = ^(){
        [self getData];
    };
    return completionBlock;
}

/*
 * Gets data when different control is picked
 */
- (IBAction)segmentedControlValueChanged:(id)sender
{
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
