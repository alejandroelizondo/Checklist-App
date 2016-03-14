//
//  Messages.m
//  Checklist
//
//  Created by Alejandro Elizondo on 01/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "Messages.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"

@implementation Messages

+(void)downloadNewMessages:(void(^)(BOOL success, id JSON))callback{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/messages.php?name=%@", mainURL, [Delegate owner]]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        if (JSON){
            for (int a = (int)[JSON count]-1; a >= 0; a--)
                [messages insertObject:JSON[a] atIndex:0];
        }
        callback(YES, [messages mutableCopy]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        callback(NO, error);
    }];
    [operation start];
}


+(void)saveMessages:(NSMutableArray*)messages{
    [self savePlist:messages];}
+(void)savePlist:(NSMutableArray*)messages{
    NSString *filePath = [self dataFilePath];
    [messages writeToFile:filePath atomically:YES];
}


+(NSMutableArray*)getSavedMessages{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    else
        return [[NSMutableArray alloc] init];
}


+(NSString*)dataFilePath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"messages.plist"];}

@end
