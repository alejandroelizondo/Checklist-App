//
//  AppDelegate.h
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Passcode.h"
#define Delegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Passcode *passcode;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *to, *owner;
@property (nonatomic) BOOL changesMade;

-(NSString*)getSendingToken;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification;
@end
