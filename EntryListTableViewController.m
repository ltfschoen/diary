//
//  EntryListTableViewController.m
//  Diary
//
//  Created by Luke on 14/06/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "EntryListTableViewController.h"
#import "DiaryEntry.h"

// tell compiler that we conform to the NSFetchedResultsController Delegate Protocol
@interface EntryListTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation EntryListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections.
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows in the section of tableview.
    // where each section in tableview is represented by a sectionInfo Object that conforms to the NSFetchedResultsSectionInfo Protocol
    // grab specific sectionInfo Object and return from it the numberOfObjects in that section
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}

#pragma mark - Fetch Request method

// use method to create a fetch request so the fetch request can be tested independently of actually fetching data
- (NSFetchRequest *)entryListFetchRequest {
    
    // create and return homogenous fetch request (i.e. need more than one fetch request to retrieve multiple entries)
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DiaryEntry"];
    
    // create an array of sort descriptors with only one entry (date) in the array (no predicate required)
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // grab the Object that want to delete
    DiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // grab the Core Data Stack
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    // delete Object using the deleteObject method on Managed Object Context
    [[coreDataStack managedObjectContext] deleteObject:entry];
    
    // save Context
    [coreDataStack saveContext];
}

#pragma mark - Fetch Results Controller method

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // grab the section info from the Fetch Results Controller
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

// override the property getter
- (NSFetchedResultsController *)fetchedResultsController {
    
    // use lazy loading to only create a Fetch Results Controller when it is accessed
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    // grab Fetch Request
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    // create Fetch Results Controller
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    // set the Delegate on the Fetch Results Controller
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // allow animation of delete row using Batch Approach to defer reload
    [self.tableView beginUpdates];
}

// remove the Cell from the TableView
// this method called whenever row is inserted, deleted, changed, moved
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    // switch 'type' depending on what passed in
    switch (type) {
            // case where new tableView cell has been inserted
            // pass in array of parameter newIndexPath
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            // case where tableView cell has been deleted
            // fetch results as specified indexPath
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// implement method from NSFetchedResultsDelegate Protocol to prevent app crashing on animation when Deleting table view rows and only one shown, which causes the entire section to be deleted inadvertently
// note: this method called whenever section is created or deleted
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
            // sections are represented by NSIndexedSet Class, so we use this to create them
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// implement methods in FetchedResultsController Delegate Protocol
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // reload tableView data without animations when this method called (whenever tableView changes)
    //[self.tableView reloadData];
    [self.tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure each individual cell for display
    DiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.body;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
