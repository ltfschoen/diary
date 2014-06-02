//
//  DiaryEntry.h
//  Diary
//
//  Created by Luke on 2/06/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// define certain compile-time constants for app instead of magic numbers
NS_ENUM(int16_t, DiaryEntryMood){
    DiaryEntryMoodGood = 0,
    DiaryEntryMoodAverage = 1,
    DiaryEntryMoodBad = 2
};

@interface DiaryEntry : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@end
