//
//  NewEntryViewController.m
//  Diary
//
//  Created by Luke on 3/06/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "NewEntryViewController.h"
#import "DiaryEntry.h"
#import "CoreDataStack.h"

@interface NewEntryViewController ()

@end

@implementation NewEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertDiaryEntry {
    
    // grab Core Data Stack
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    // create new diary entry instance
    // insert new entity into Managed Object Context (Core Data Stack environment)
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    // configure new diary entry
    entry.body = self.textField.text;
    
    // since DiaryEntry class has been setup to scalar properties, all integers, floats, and dates are represented by scalar properties (not Objects), so calculate seconds that have passed since 1970 to determine todays date and save this into our entry
    entry.date = [[NSDate date] timeIntervalSince1970];
    
    // save Core Data Stack (Managed Object Context) with new entities
    [coreDataStack saveContext];
}

#pragma mark - IBActions for Buttons

- (IBAction)doneWasPressed:(id)sender {
    
    // call diary entry method before dismiss and done pressed
    [self insertDiaryEntry];
    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}


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
