//
//  MainViewController.m
//  EWENotes
//
//  Created by Jesse Schneider on 10/3/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "MainViewController.h"
#import <CoreData/CoreData.h>
#import "Datasource.h"
#import "Notes.h"
#import "AddNoteView.h"
#import "ViewNotesViewController.h"
#import "SearchView.h"
@interface MainViewController () <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (nonatomic, strong)UINavigationBar *navBar;
@property (nonatomic, strong)UIBarButtonItem *addNoteButton;
@property (nonatomic, strong)UIBarButtonItem *searchButton;
@property (nonatomic, strong)UIBarButtonItem *editButton;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIToolbar *bottomBar;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainViewController

- (void)loadView {
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGFloat width = self.view.frame.size.width;
    
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,width,64)];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navBar.backgroundColor = [UIColor greenColor];
    
    self.bottomBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,524, width,44)];
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.bottomBar.backgroundColor = [UIColor grayColor];
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_navBar];
    [self.view addSubview:_bottomBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.addNoteButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonFired:)];
     self.searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonFired:)];
     self.editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dots"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonFired:)];
    
    
    [self.bottomBar setItems:[NSArray arrayWithObjects: self.addNoteButton,flexibleSpace, self.searchButton,self.editButton,nil]];
    
    
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error: %@",error);
        abort();
    }
    
    
    
    // Do any additional setup after loading the view.
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    self.tableView.frame = CGRectMake(0, 64, width, self.view.frame.size.height);
    
}

- (void)addButtonFired: (id)sender {
    AddNoteView *newNotes = [[AddNoteView alloc]init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:newNotes animated:YES completion:nil];
    
}

- (void)searchButtonFired: (id)sender {
    SearchView *seachNotes = [[SearchView alloc]init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:seachNotes animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Fetched Results Controller section


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
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[Datasource sharedInstance].managedObjectContext sectionNameKeyPath:@"lastViewDate" cacheName:nil];
    _fetchedResultsController.delegate  = self;

    return _fetchedResultsController;

}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            Notes *changedNotes = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedNotes.title;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



#pragma mark- TableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    return [secInfo numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell)
    {
        //create a cell only if one couldn't be reused
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    Notes *notes = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = notes.title;
    return cell;
    
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections]objectAtIndex:section]name];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Notes *noteToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[Datasource sharedInstance].managedObjectContext deleteObject: noteToDelete];
        
        NSError *error = nil;
        if (![[Datasource sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"%@",error);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewNotesViewController *viewNotes = [[ViewNotesViewController alloc]init];
    viewNotes.note = (Notes *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self presentViewController:viewNotes animated:YES completion:nil];
}




@end
