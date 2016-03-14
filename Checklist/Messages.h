//
//  Messages.h
//  Checklist
//
//  Created by Alejandro Elizondo on 01/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Messages : NSObject

+(NSMutableArray*)getSavedMessages;
+(void)saveMessages:(NSMutableArray*)messages;
+(void)downloadNewMessages:(void(^)(BOOL success, id JSON))callback;

@end
