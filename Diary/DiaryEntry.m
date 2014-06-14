//
//  DiaryEntry.m
//  Diary
//
//  Created by Luke on 2/06/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

@dynamic body;
@dynamic date;
@dynamic imageData;
@dynamic mood;
@dynamic location;

- (NSString *)sectionName {
    // create instance that represents
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
