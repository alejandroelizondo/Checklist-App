//
//  SendData.h
//  Dation
//
//  Created by Alejandro Elizondo on 15/04/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendData : NSObject

+(void)sendDataToURL:(NSURL*)url callback:(void(^)(NSString *returnString))callback objectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
+(void)sendDataToURL:(NSURL*)url callback:(void(^)(NSString *returnString))callback objectsAndKeysInArray:(NSMutableArray*)array;

@end
