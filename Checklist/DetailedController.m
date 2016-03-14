//
//  DetailedController.m
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import "DetailedController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "SendData.h"
#import "Extras.h"
@interface DetailedController ()

@end

@implementation DetailedController
@synthesize objects = _objects;
@synthesize topTitle = _topTitle;
@synthesize titleFields = _titleFields;

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
    NSString *title = _objects[@"title"];
    title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [title dataUsingEncoding:NSUTF8StringEncoding];
    title = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    _titleFields.text = title;
    
    if ([_objects[@"date"] isEqualToString:@"0"]){
        datePicker.alpha = 0;
        datePicker.minimumDate = [NSDate date];
    }else{
        [reminder setTitle:@"Remove Reminder" forState:UIControlStateNormal];
        reminder.backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0 alpha:1];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        datePicker.date = [dateFormatter dateFromString:_objects[@"date"]];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

-(IBAction)back{
    NSData *data = [_titleFields.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]\\",kCFStringEncodingUTF8));
    
    if ([reminder.titleLabel.text isEqualToString:@"Set Reminder"]){
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    _objects[@"id"], @"id",
                                    encodedString, @"title",
                                    _objects[@"completed"], @"completed",
                                    @"0", @"date", nil];
        [_objects removeAllObjects];
        [_objects addEntriesFromDictionary:dictionary];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    _objects[@"id"], @"id",
                                    encodedString, @"title",
                                    _objects[@"completed"], @"completed",
                                    strDate, @"date", nil];
        [_objects removeAllObjects];
        [_objects addEntriesFromDictionary:dictionary];
    }
    ViewController *view = (ViewController*)self.navigationController.viewControllers[0];
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:view.objects.count];
    for (int a = 0; a < [view.objects count]; a++){
        if ([view.objects[a][@"id"] intValue] == [_objects[@"id"] intValue])
            [newArray addObject:_objects];
        else
            [newArray addObject:view.objects[a]];
    }
    view.objects = newArray;
    [view reloadListAfterModifications];
    [Delegate setChangesMade:YES];
    
    [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/update.php?", mainURL]] callback:nil objectsAndKeys:
     encodedString, @"title",
     _objects[@"id"], @"id",
     _objects[@"completed"], @"completed",
     _objects[@"date"], @"date", nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    [Extras setLocalNotificationTitle:encodedString date:[dateFormatter dateFromString:_objects[@"date"]] ID:_objects[@"id"]];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)setReminder{
    if ([reminder.titleLabel.text isEqualToString:@"Set Reminder"]){
        [self showDatePicker];
    }else{
        [self hideDatePicker];
        [Extras cancelLocalNotificationID:_objects[@"id"]];
    }
}

-(void)hideDatePicker{
    [UIView animateWithDuration:0.5 animations:^{
        datePicker.alpha = 0;
        reminder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        [reminder setTitle:@"Set Reminder" forState:UIControlStateNormal];
    }];
    
}
-(void)showDatePicker{
    [UIView animateWithDuration:0.5 animations:^{
        datePicker.alpha = 1;
        reminder.backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0 alpha:1];
        [reminder setTitle:@"Remove Reminder" forState:UIControlStateNormal];
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{[_titleFields resignFirstResponder];return YES;}
-(UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}
- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
@end
