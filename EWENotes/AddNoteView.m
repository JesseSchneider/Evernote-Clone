//
//  AddNoteView.m
//  EWENotes
//
//  Created by Jesse Schneider on 10/8/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "AddNoteView.h"

#import "Datasource.h"
#import "AppDelegate.h"

@interface AddNoteView () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong)UINavigationBar *navBar;
@property (nonatomic, strong)UIButton *savedButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UITextField *titleTextField;
@property (nonatomic, strong)UITextView *noteTextField;




@end
@implementation AddNoteView

- (void)loadView {
    self.view = [[UIView alloc]init];
    
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGFloat width = self.view.frame.size.width;
    
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,width,64)];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navBar.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
[self.view addSubview:_navBar];
   
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.savedButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
    [self.savedButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.savedButton addTarget:self action:@selector(savedButtonDidFire:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 20, 40, 40)];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonDidFire:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navBar addSubview:self.savedButton];
    [self.navBar addSubview:self.cancelButton];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 64, 310, 40)];
    self.titleTextField.layer.masksToBounds=YES;
   
    self.titleTextField.placeholder = @"Note Title";
    
  
    [self.view addSubview:self.titleTextField];
    
    self.noteTextField = [[UITextView alloc]initWithFrame:CGRectMake(5, 104, 310, 568 - 104)];
    self.noteTextField.backgroundColor = [UIColor whiteColor];
    self.noteTextField.text = @"What on you mind my man?";
    self.noteTextField.textColor = [UIColor lightGrayColor];
    [self.noteTextField setFont:[UIFont systemFontOfSize:18]];
    self.noteTextField.delegate = self;
    self.noteTextField.textAlignment = NSTextAlignmentLeft;
    self.noteTextField.dataDetectorTypes = UIDataDetectorTypeAll;
    //self.noteTextField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.noteTextField];
    
    if (self.isSaving) {
        self.titleTextField.text = self.note.title;
        self.noteTextField.text = self.note.text;
        self.noteTextField.textColor = [UIColor blackColor];
        self.titleTextField.textColor = [UIColor blackColor];
    }
    
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.isSaving) {
        self.noteTextField.text = @"";
        self.noteTextField.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if (!self.isSaving ) {
        if(self.noteTextField.text.length == 0){
            self.noteTextField.textColor = [UIColor lightGrayColor];
            self.noteTextField.text = @"What on you mind my man?";
            [self.noteTextField resignFirstResponder];
        }
    }
    
    return;
}

- (void) cancelButtonDidFire: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) savedButtonDidFire: (id)sender {
    if (self.isSaving) {
        self.note.title = self.titleTextField.text;
        self.note.text = self.noteTextField.text;
        
        AppDelegate *myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [myApp saveContext];
        
    
    } else {
        
        [[Datasource sharedInstance] addNewNote:self.titleTextField.text andNote:self.noteTextField.text];
        
    }
    
 
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
       
    
}



@end
