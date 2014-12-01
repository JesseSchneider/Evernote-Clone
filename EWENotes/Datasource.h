//
//  Datasource.h
//  EWENotes
//
//  Created by Jesse Schneider on 10/6/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Datasource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (void) addNewNote:(NSString *)title andNote: (NSString *)notes;




@end
