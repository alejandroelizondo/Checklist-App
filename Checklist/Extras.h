//
//  Extras.h
//  Checklist
//
//  Created by Alejandro Elizondo on 20/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Extras : NSObject

+(NSMutableDictionary*)getLocalNotifications;
+(void)saveLocalNotifications:(NSMutableDictionary*)dictionary;

+(NSMutableArray*)getPasscode;
+(void)savePasscode:(NSMutableArray*)array;

+(UIColor*)getBrushColor;
+(void)saveBrushColor:(UIColor*)color;

+(UIColor*)getBucketColor;
+(void)saveBucketColor:(UIColor*)color;

+(UIImage*)getUserProfile;
+(void)saveUserProfile:(UIImage*)image;

+(NSMutableArray*)getURLQueries;
+(void)saveURLQueries:(NSMutableArray*)queries;
+(void)insertURLQueries:(NSURL*)url objectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

+(void)setLocalNotificationTitle:(NSString*)title date:(NSDate*)date ID:(NSString*)ID;
+(void)setInstantLocalNotificationTitle:(NSString*)title;
+(void)cancelLocalNotificationID:(NSString*)ID;
+(void)sendDeliveryMessage:(NSString*)message callback:(void (^)(void))callback;
+(void)sendSeenInMessageAlert:(NSString*)alert;
+(void)sendStatusToDB:(NSString*)status;
+(void)sendNotificationWithMessage:(NSString*)message;
+(UIView*)sendBarMessage:(NSString*)message withRecipient:(BOOL)recipient;

@end
@interface NSString (Extras)

-(UIColor*)convertHEXToColor;

@end
@interface CALayer (Extras)

-(void)setBorderWidth:(CGFloat)width radius:(CGFloat)radius color:(UIColor*)color mask:(BOOL)mask;
-(void)setShadowOffset:(CGSize)off color:(UIColor*)col opacity:(double)opa radius:(CGFloat)radius inView:(CALayer*)superLayer;

@end
@interface UIColor (Extras)

-(NSArray*)getRGB;
-(NSArray*)getHSV;

@end
@interface NSData (Extras)

-(NSString*)MD5;

@end
@interface NSObject (Extras)

-(NSMutableArray*)getForKey:(NSString*)key;
-(void)saveForKey:(NSString*)key;

@end