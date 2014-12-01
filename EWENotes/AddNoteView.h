//
//  AddNoteView.h
//  EWENotes
//
//  Created by Jesse Schneider on 10/8/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"
@interface AddNoteView : UIViewController

@property (nonatomic, assign) bool isSaving;
@property (nonatomic, strong) Notes *note;
@end

