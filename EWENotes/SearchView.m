//
//  SearchView.m
//  EWENotes
//
//  Created by Jesse Schneider on 10/9/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "SearchView.h"
#import "MainViewController.h"
#import "Datasource.h"
#import <CoreData/CoreData.h>
#import "Notes.h"
#import "ViewNotesViewController.h"

@interface SearchView()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate> {
    BOOL isSearching;
}



@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UISearchDisplayController *searchBarController;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *notesMatched;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation SearchView
-(void)loadView
{
    
    self.view = [[UIView alloc]init];
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.keyboardType = UIKeyboardTypeURL;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.placeholder = NSLocalizedString(@"Look up notes", @"Look up notes");
    self.searchBar.backgroundColor = [UIColor greenColor];
    
    self.searchBar.delegate = self;
    
    
    [self.view addSubview:self.searchBar];
    
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error: %@",error);
        abort();
    }

}

-(void) searchThroughChacheData{
    
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:[_fetchedResultsController fetchedObjects]];
    
    self.notesMatched = [temp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title contains  %@",self.searchBar.text]];
    [self.tableView reloadData];
    
    
}

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil ) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:[Datasource sharedInstance].managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastViewDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[Datasource sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate  = self;
    
    return _fetchedResultsController;
    
}

    

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
   
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchThroughChacheData];
    }
    else {
        self.notesMatched = nil;
        isSearching = NO;
        [self.tableView reloadData];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    self.tableView.frame = CGRectMake(0, 64, width, self.view.frame.size.height - 64);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return self.notesMatched.count;
    }
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    return [secInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(isSearching) {
        return @"Notes Matched";
    }
    return [[[self.fetchedResultsController sections]objectAtIndex:section]name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(isSearching){
        if (indexPath.section == 0) {
            Notes *notes = [self.notesMatched objectAtIndex:indexPath.row];
            
            cell.textLabel.text = notes.title;
            
        } else {
            if (!cell) {
                //create a cell only if one couldn't be reused
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            }
            Notes *notes = [self.fetchedResultsController objectAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = notes.title;
            return cell;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewNotesViewController *viewNotes = [[ViewNotesViewController alloc]init];
    if (isSearching) {
        viewNotes.note = (Notes *) [self.notesMatched objectAtIndex:indexPath.row];
    } else {
    
    viewNotes.note = (Notes *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    }
    [self presentViewController:viewNotes animated:YES completion:nil];
}

@end
