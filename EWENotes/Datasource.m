//
//  Datasource.m
//  EWENotes
//
//  Created by Jesse Schneider on 10/6/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "Datasource.h"
#import "Section.h"
#import "Notes.h"
#import "AppDelegate.h"
#import "AddNoteView.h"

@interface Datasource ()

@end

@implementation Datasource


+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

-(instancetype) init {
    self = [super init];
    if (self) {
    
    self.managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return self;
}



- (void) addNewNote:(NSString *)title andNote: (NSString *)notes {
    Notes *note = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    note.title = title;
    note.text = notes;
    [note setLastViewDate: [NSDate date]];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Erorr: %@",error);
    }
    
}



@end
