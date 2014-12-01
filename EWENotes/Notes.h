//
//  Notes.h
//  EWENotes
//
//  Created by Jesse Schneider on 10/5/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastViewDate;
@property (nonatomic, retain) Section *whichSection;

@end
