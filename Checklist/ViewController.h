//
//  ViewController.h
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIView *mainView, *menuView;
    IBOutlet UIImageView *navBarMainView, *navBarMenuView;
    IBOutlet UIButton *background, *background2, *menuBackgroundHidder;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITableView *table;
    IBOutlet UILabel *topTitle, *menuUsername;
    IBOutlet UIButton *menuProfilePicture, *chatProfilePicture;
    IBOutlet UIButton *addNewCheck;
    IBOutlet UIImageView *listIndicatorBackground;
    IBOutlet UILabel *status;
    NSString *recieverStatus;
    BOOL keyboardWillMove;
    int maxid;
    
    NSMutableArray *images;
    
    int unlockingIndex;
    UIView *unlockingView;
    BOOL willChangeProfile;
}

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) IBOutlet UILabel *listIndicator;
@property (nonatomic, strong) NSString *colorOfStatus;

-(IBAction)notifyUser;
-(IBAction)options;

-(IBAction)seeChatProfilePicture;
-(IBAction)changeProfilePicture;
-(IBAction)addNew;
-(IBAction)showMenu;
-(IBAction)hideMenu;
-(void)updateIndicatorWithNotification:(NSDictionary*)notification;
-(void)reloadListAfterModifications;
-(void)canUnlock:(BOOL)unlock;

@end