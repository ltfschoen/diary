//
//  CoreDataStack.h
//  Diary
//
//  Created by Luke on 2/06/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

// new class method returning the type (i.e. CoreDataStack) of its instance
+ (instancetype)defaultStack;

// properties and methods of standard and reusable Core Data stack
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
