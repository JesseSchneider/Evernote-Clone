//
//  ViewNotesViewController.m
//  EWENotes
//
//  Created by Jesse Schneider on 10/8/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "ViewNotesViewController.h"
#import "Notes.h"
#import "AddNoteView.h"
#import "MainViewController.h"
#import "Datasource.h"

@interface ViewNotesViewController ()

@property (nonatomic, strong)UINavigationBar *navBar;
@property (nonatomic, strong)UIButton *editButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UILabel *noteTitle;
@property (nonatomic, strong)UILabel *noteTextField;


@end

@implementation ViewNotesViewController



- (void)loadView {
    self.view = [[UIView alloc]init];
    CGFloat width = self.view.frame.size.width;
    
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,width,64)];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navBar.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navBar];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //checking to see if the text has changed
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(handleDataModelChange:)
        name:NSManagedObjectContextObjectsDidChangeNotification
        object:[Datasource sharedInstance].managedObjectContext];
    
    self.editButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [self.editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editButtonDidFire:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.noteTitle = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 160, 40)];
    self.noteTitle.text = self.note.title;
    
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 20, 40, 40)];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonDidFire:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navBar addSubview:self.editButton];
    [self.navBar addSubview:self.cancelButton];
    [self.navBar addSubview:self.noteTitle];
    
    
    
    self.noteTextField = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 310, 568 - 70)];
    self.noteTextField.enabled = NO;
    self.noteTextField.backgroundColor = [UIColor whiteColor];
    self.noteTextField.numberOfLines = NO;
    self.noteTextField.text = self.note.text;
    self.noteTextField.textAlignment = NSTextAlignmentLeft;
    
    [self.noteTextField sizeToFit];
   
    //self.noteTextField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.noteTextField];
    
}

- (void)setNote:(Notes *)note {
    _note = note;
    if (!note) {
        return;
    }
    if (self.noteTextField) {
        self.noteTextField.text = self.note.text;
    }
    if (self.noteTitle) {
        self.noteTitle.text = self.note.title;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cancelButtonDidFire: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editButtonDidFire: (id)sender {
    
    AddNoteView *editnotes = [[AddNoteView alloc]init];
    editnotes.note = self.note;
    [editnotes setIsSaving:YES];
    
    [self presentViewController:editnotes animated:YES completion:nil];

}

- (void)handleDataModelChange:(NSNotification *)n {
    NSSet *updatedObjects = [[n userInfo] objectForKey:NSUpdatedObjectsKey];
    if (updatedObjects) {
        if ([updatedObjects containsObject:self.note]) {
           
            self.note = self.note;
        }
    }
}


@end
