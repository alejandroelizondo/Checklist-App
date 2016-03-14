//
//  DetailedController.h
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedController : UIViewController <UITextFieldDelegate>{
    IBOutlet UIButton *reminder;
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, strong) IBOutlet UITextField *titleFields;
@property (nonatomic, strong) IBOutlet UILabel *topTitle;
@property (nonatomic, strong) NSMutableDictionary *objects;

-(IBAction)back;
-(IBAction)setReminder;

@end
