//
//  Extras.m
//  Checklist
//
//  Created by Alejandro Elizondo on 20/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "Extras.h"
#import "AppDelegate.h"
#import "NWHub.h"
#import "NWPusher.h"
#import "NWNotification.h"
#import "NWLCore.h"
#import "NWSSLConnection.h"
#import "NWSecTools.h"
#import "SendData.h"
#import "AFJSONRequestOperation.h"
#import "ViewController.h"

@implementation Extras

+(NSMutableDictionary*)getLocalNotifications{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"localNotifChecklist"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)saveLocalNotifications:(NSMutableDictionary*)dictionary{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [defaults setObject:data forKey:@"localNotifChecklist"];}

+(NSMutableArray*)getPasscode{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"checklistPasscode"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)savePasscode:(NSMutableArray *)array{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [defaults setObject:data forKey:@"checklistPasscode"];}

+(UIColor*)getBrushColor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"backgroundColorBrush"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)saveBrushColor:(UIColor*)color{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    [defaults setObject:data forKey:@"backgroundColorBrush"];}

+(UIColor*)getBucketColor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"backgroundColorBucket"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)saveBucketColor:(UIColor*)color{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    [defaults setObject:data forKey:@"backgroundColorBucket"];}

+(UIImage*)getUserProfile{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userProfilePicture"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)saveUserProfile:(UIImage*)image{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:image];
    [defaults setObject:data forKey:@"userProfilePicture"];}

+(NSMutableArray*)getURLQueries{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"checklistQueries"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
+(void)saveURLQueries:(NSMutableArray *)queries{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:queries];
    [defaults setObject:data forKey:@"checklistQueries"];}
+(void)insertURLQueries:(NSURL *)url objectsAndKeys:(id)firstObject, ...{
    NSMutableArray *objects;
    if ([self getURLQueries])
        objects = [self getURLQueries];
    else
        objects = [NSMutableArray new];
    
    NSMutableArray *objectsAndKeys = [NSMutableArray new];
    if (firstObject){
        [objectsAndKeys addObject:firstObject];
        id eachObject;
        va_list argumentList;
        va_start(argumentList, firstObject);
        while ((eachObject = va_arg(argumentList, id)))
            [objectsAndKeys addObject:eachObject];
        va_end(argumentList);
    }
    
    NSMutableArray  *organizedObjectsAndKeys = [NSMutableArray new];
    for (int a = 0; a < [objectsAndKeys count]; a+=2){
        id object = objectsAndKeys[a];
        id key = objectsAndKeys[a+1];
        [organizedObjectsAndKeys addObject:object];
        [organizedObjectsAndKeys addObject:key];
    }
    [objects addObject:@{@"objects":organizedObjectsAndKeys,@"url":url,@"id":[@([objects count]) stringValue]}];
    [self saveURLQueries:objects];
}

+(void)setLocalNotificationTitle:(NSString*)title date:(NSDate*)date ID:(NSString *)ID{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:strDate];
    NSComparisonResult result = [today compare:date]; // comparing two dates
    
    if(result == NSOrderedAscending){
        NSMutableDictionary *dic = [Extras getLocalNotifications];
        if (dic){
            if (dic[ID])
                [Extras cancelLocalNotificationID:ID];
        }else
            dic = [NSMutableDictionary new];

        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [title dataUsingEncoding:NSUTF8StringEncoding];
        title = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = title;
        localNotification.alertAction = @"Reminder: ";
        localNotification.soundName = @"alert.mp3";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [dic addEntriesFromDictionary:@{ID:@{@"notif":localNotification,@"date":date}}];
        [Extras saveLocalNotifications:dic];
        NSLog(@"notifications: %@", [Extras getLocalNotifications]);
    }
}
+(void)setInstantLocalNotificationTitle:(NSString*)title{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = title;
    localNotification.alertAction = @"Reminder: ";
    localNotification.soundName = @"a.mp3";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
+(void)cancelLocalNotificationID:(NSString *)ID{
    NSMutableDictionary *dic = [Extras getLocalNotifications];
    if (dic[ID]){
        [[UIApplication sharedApplication] cancelLocalNotification:(UILocalNotification*)dic[ID][@"notif"]];
        [dic removeObjectForKey:ID];
        [Extras saveLocalNotifications:dic];
    }
}

+(void)sendDeliveryMessage:(NSString*)message callback:(void (^)(void))callback{
    [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/newMessage.php?", mainURL]]
                   callback:^(NSString *returnString){
                       if ([returnString isEqualToString:@"1"]){
                           NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
                           NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
                           NWPusher *pusher = [[NWPusher alloc] init];
                           NWError connect = [pusher connectWithPKCS12Data:pkcs12 password:@"alex8347"];
                           if (connect == kNWSuccess){
                               NSString *payload = [NSString stringWithFormat:@"{\"alert\":\"%@\",\"type\":\"d\"}", message];
                               NSString *token = [Delegate getSendingToken];
                               NWError push = [pusher pushPayload:payload token:token identifier:rand()];
                               if (push == kNWSuccess) {
                                   if (callback)
                                       callback();
                               }
                           }
                       }else
                           [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Changes could not be saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                   }
             objectsAndKeys:[Delegate owner], @"from",
                            message, @"message", nil];
}
+(void)sendSeenInMessageAlert:(NSString*)alert{
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NWPusher *pusher = [[NWPusher alloc] init];
    NWError connect = [pusher connectWithPKCS12Data:pkcs12 password:@"alex8347"];
    if (connect == kNWSuccess){
        NSString *payload = [NSString stringWithFormat:@"{\"type\":\"s\",\"alert\":\"%@\"}", alert];
        NSString *token = [Delegate getSendingToken];
        NWError push = [pusher pushPayload:payload token:token identifier:rand()];
        if (push == kNWSuccess) {
            NSLog(@"seen sucessful");
        }
    }
}
+(void)sendStatusToDB:(NSString*)status{
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NWPusher *pusher = [[NWPusher alloc] init];
    NWError connect = [pusher connectWithPKCS12Data:pkcs12 password:@"alex8347"];
    if (connect == kNWSuccess){
        NSString *payload = [NSString stringWithFormat:@"{\"alert\":\"%@\",\"type\":\"o\"}", status];
        NSString *token = [Delegate getSendingToken];
        NWError push = [pusher pushPayload:payload token:token identifier:rand()];
        if (push == kNWSuccess){
            [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/updateStatus.php?", mainURL]]
                           callback:nil
                     objectsAndKeys:[Delegate owner], @"name",
                                    status, @"status", nil];
        }
    }
}
+(void)sendNotificationWithMessage:(NSString*)message{
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NWPusher *pusher = [[NWPusher alloc] init];
    NWError connect = [pusher connectWithPKCS12Data:pkcs12 password:@"alex8347"];
    if (connect == kNWSuccess){
        NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@\",\"sound\":\"alert.aiff\"}}", message];
        NSString *token = [Delegate getSendingToken];
        NWError push = [pusher pushPayload:payload token:token identifier:rand()];
        if (push != kNWSuccess) {
            NSLog(@"Unable to sent: %@", [NWErrorUtil stringWithError:push]);
        }
    }
}

+(UIView*)sendBarMessage:(NSString*)message withRecipient:(BOOL)recipient{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 270, 20)];
    title.text = [Delegate to];
    if (!recipient)
        title.text = @"Bucketlist";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [view addSubview:title];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 270, 60-20-5)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 2;
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(280, 15, 30, 30);
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeBarMessage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [[Delegate window] addSubview:view];
    [[Delegate window] setWindowLevel:UIWindowLevelStatusBar];

    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(0, 0, 320, 60);
    } completion:^(BOOL finished) {
        [Extras performSelector:@selector(closeBarMessage:) withObject:button afterDelay:4.0];
    }];
    return view;
}
+(void)closeBarMessage:(UIButton*)button{
    UIView __block *view = [button superview];
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(0, -60, 320, 60);
    } completion:^(BOOL finished) {
        [[Delegate window] setWindowLevel:UIWindowLevelNormal];
        [view removeFromSuperview];
        view = nil;
    }];
}
@end

@implementation CALayer (Extras)
-(void)setBorderWidth:(CGFloat)width radius:(CGFloat)radius color:(UIColor*)color mask:(BOOL)mask{
    [self setMasksToBounds:mask];
    [self setBorderWidth:width];
    [self setBorderColor:color.CGColor];
    [self setCornerRadius:radius];}
-(void)setShadowOffset:(CGSize)off color:(UIColor*)col opacity:(double)opa radius:(CGFloat)radius inView:(CALayer*)superLayer{
    if (superLayer == self){
        [self setShadowOffset:off];
        [self setShadowColor:col.CGColor];
        [self setShadowOpacity:opa];
        [self setShadowRadius:radius];
    }else{
        CALayer *containerLayer = [CALayer layer];
        [containerLayer setShadowOffset:off];
        [containerLayer setShadowColor:col.CGColor];
        [containerLayer setShadowOpacity:opa];
        [containerLayer setShadowRadius:radius];
        [containerLayer addSublayer:self];
        [superLayer addSublayer:containerLayer];
    }
}
@end

@implementation UIColor (Extras)

-(NSArray*)getRGB{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    int numComponents = (int)CGColorGetNumberOfComponents(self.CGColor);
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (numComponents == 2){
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    }else{
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r), @(g), @(b), @(a)];
}
-(NSArray*)getHSV{
    NSArray *components = [self getRGB];
    CGFloat r = [components[0] floatValue];
    CGFloat g = [components[1] floatValue];
    CGFloat b = [components[2] floatValue];
    CGFloat h = 0, s = 0, v = 0;
    float min = 0, max = 0, delta = 0;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    v = max;
    delta = max - min;
    if(max != 0)
        s = delta / max;
    else
        return nil;
    if( r == max )
        h = ( g - b ) / delta;
    else if( g == max )
        h = 2 + ( b - r ) / delta;
    else
        h = 4 + ( r - g ) / delta;
    h *= 60;
    if(h < 0)
        h += 360;
    s *= 100;
    v *= 100;
    return @[@([@(h) integerValue]), @([@(s) integerValue]), @([@(v) integerValue])];
}
@end
@implementation NSString (Extras)
-(UIColor*)convertHEXToColor{
    NSString *str = self;
    str = [[self stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (str.length < 6)
        for (int a = (int)str.length; a <= 6; a++)
            str = [NSString stringWithFormat:@"%@0", str];
    NSArray *h = [self prepareForHEX:str];
    CGFloat r = 0, g = 0, b = 0;
    for (int a = 0; a < 3; a++){
        NSString *str = h[a];
        int f = 0;
        f = [self convertCharToNumber:tolower([str characterAtIndex:0])];
        f++;
        f *= 16;
        f--;
        int s = 0;
        s = [self convertCharToNumber:tolower([str characterAtIndex:1])];
        s++;
        f -= 16-s;
        if (a == 0)
            r = f;
        else if (a == 1)
            g = f;
        else
            b = f;
    }
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}
-(NSArray*)prepareForHEX:(NSString*)hexStr{
    return @[[hexStr substringToIndex:2],
             [hexStr substringWithRange:NSMakeRange(2, 2)],
             [hexStr substringFromIndex:4]];}
-(int)convertCharToNumber:(char)character{
    int number = character-48;
    switch (character){
        case 'a': number = 10; break;
        case 'b': number = 11; break;
        case 'c': number = 12; break;
        case 'd': number = 13; break;
        case 'e': number = 14; break;
        case 'f': number = 15; break;
    }
    return number;
}
@end
@implementation NSData (Extras)
- (NSString*)MD5{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (int)self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
@end
@implementation NSObject (Extras)
-(NSMutableArray*)getForKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];}
-(void)saveForKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:key];}
@end