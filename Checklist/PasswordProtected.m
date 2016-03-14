//
//  PasswordProtected.m
//  Checklist
//
//  Created by Alejandro Elizondo on 01/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "PasswordProtected.h"
#import "SendData.h"

@implementation PasswordProtected

+(UIView*)passwordProtectWithID:(NSString*)ID size:(CGSize)size{
    UIView *protection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if ([ID intValue] == memoramaTag)
        protection.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.5 alpha:1];
    else
        protection.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock.png"]];
    lock.frame = CGRectMake(0, 0, 40, 40);
    lock.center = CGPointMake(size.width/2.0, size.height/2.0);
    [protection addSubview:lock];
    
    return protection;
}

+(void)protectImageID:(NSString*)ID value1:(NSString*)value1 value2:(NSString*)value2 withProtectionKey:(NSString*)key{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/updateImage.php", mainURL];
    [SendData sendDataToURL:[NSURL URLWithString:urlStr]
                   callback:nil
             objectsAndKeys:ID, @"id", value1, @"value1", value2, @"value2", key, @"protected", nil];
}

@end
