//
//  PasswordProtected.h
//  Checklist
//
//  Created by Alejandro Elizondo on 01/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordProtected : NSObject

+(UIView*)passwordProtectWithID:(NSString*)ID size:(CGSize)size;
+(void)protectImageID:(NSString*)ID value1:(NSString*)value1 value2:(NSString*)value2 withProtectionKey:(NSString*)key;

@end
