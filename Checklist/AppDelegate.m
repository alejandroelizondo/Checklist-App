//
//  AppDelegate.m
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import "AppDelegate.h"
#import "Extras.h"
#import "AFJSONRequestOperation.h"
#import "SendData.h"
#import "ViewController.h"
#import "Passcode.h"

@implementation AppDelegate
@synthesize to = _to;
@synthesize owner = _owner;
@synthesize changesMade = _changesMade;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification)
        [self application:application didReceiveLocalNotification:notification];

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }else
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    if (![Extras getLocalNotifications])
        [Extras saveLocalNotifications:[NSMutableDictionary new]];
        
    if (![Extras getBrushColor])
        [Extras saveBrushColor:[UIColor colorWithRed:0.775 green:0.723941 blue:0.592647 alpha:0.380952]];
//        [Extras saveBrushColor:[UIColor colorWithRed:102/255.0 green:204/255.0 blue:128/255.0 alpha:1]];
    if (![Extras getBucketColor])
        [Extras saveBucketColor:[UIColor whiteColor]];
    
//    NSMutableArray *queries = [Extras getURLQueries];
//    if (queries)
//        if ([queries count] > 0){
//            for (int __block a = 0; a < [queries count]; a++){
//                NSURL *url = queries[a][@"url"];
//                NSMutableArray *objects = queries[a][@"objects"];
//                [SendData sendDataToURL:url 
//                               callback:^(NSString *returnString) {
//                                   if ([returnString isEqualToString:@"1"]){
//                                       for (int b = 0; b < [queries count]; b++){
//                                           int ID = [queries[b][@"id"] intValue];
//                                           if (ID == [queries[a][@"id"] intValue]){
//                                               [queries removeObjectAtIndex:b];
//                                               [Extras saveURLQueries:queries];
//                                               a--;
//                                           }
//                                       }
//                                   }
//                               }
//                         objectsAndKeysInArray:objects];
//            }
//        }
    
    _changesMade = NO;
    _owner = @"User2";
    _to = ([_owner isEqualToString:@"User2"]) ? @"Alex" : @"User2";
    
    green = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:128/255.0 alpha:1];
    
    return YES;
}

-(NSString*)getSendingToken{
    return ([_owner isEqualToString:@"User2"]) ?
    @"d3d898cbe8c0b50fa5ae616ce4bbc8fc4815920f08d3582caa7c33fb79cf3053": // Alex
    @"d3d898cbe8c0b50fa5ae616ce4bbc8fc4815920f08d3582caa7c33fb79cf3053"; // User2
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{NSLog(@"Failed to get token: %@", error);}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification{
    NSLog(@"%s", __FUNCTION__);
    UINavigationController *navControl = (UINavigationController*)self.window.rootViewController;
    ViewController *controller = (ViewController*)navControl.viewControllers[0];
    [controller updateIndicatorWithNotification:notification];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    [self application:application didReceiveRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"%s", __FUNCTION__);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token: %@", token);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"%s", __FUNCTION__);
    UIApplicationState state = [application applicationState];
    NSString *message = [NSString stringWithFormat:@"Reminder: %@", notification.alertBody];
    if (state == UIApplicationStateActive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSMutableDictionary *dic = [Extras getLocalNotifications];
    NSArray *IDS = [dic allKeys];
    NSString *date = [NSString stringWithFormat:@"%@", notification.fireDate];
    for (int a = 0; a < [dic count]; a++){
        NSString *date2 = [NSString stringWithFormat:@"%@", dic[IDS[a]][@"date"]];
        if ([date isEqualToString:date2])
            [Extras cancelLocalNotificationID:IDS[a]];
    }
    [Extras sendNotificationWithMessage:message];
}
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    [self application:application didReceiveLocalNotification:notification];
}


- (void)applicationWillResignActive:(UIApplication *)application{
    if (_changesMade){
        [Extras sendNotificationWithMessage:[NSString stringWithFormat:@"%@ has modified the checklist!", _owner]];
        _changesMade = NO;
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [Extras sendStatusToDB:@" "];
//    [Extras sendStatusToDB:[self lastSeenDate]];
    
//    [SendData sendDataToURL:[NSURL URLWithString:@"http://az0806ades.bugs3.com/updateStatus.php?"]
//                   callback:^(NSString *returnString) {
//                   }
//             objectsAndKeys:
//     [Delegate owner], @"name",
//     [self lastSeenDate], @"status", nil];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
//    [self setPasscode];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Extras sendStatusToDB:[NSString stringWithFormat:@"%@ is online", _to]];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)setPasscode{
    if (!passcode)
        passcode = [[Passcode alloc] init];
    [_window addSubview:passcode];
    [passcode show];
}

-(NSString*)lastSeenDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d 'at' HH:mm"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"last seen on %@", [strDate lowercaseString]];
}

@end
