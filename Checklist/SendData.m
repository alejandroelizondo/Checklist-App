//
//  SendData.m
//  Dation
//
//  Created by Alejandro Elizondo on 15/04/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "SendData.h"
#import "AFJSONRequestOperation.h"

@implementation SendData

+(void)sendDataToURL:(NSURL *)url callback:(void(^)(NSString *returnString))callback objectsAndKeys:(id)firstObject, ...{
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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    for (int a = 0; a < [objectsAndKeys count]; a+=2){
        id object = objectsAndKeys[a];
        id key = objectsAndKeys[a+1];
        if ([object isKindOfClass:[UIImageView class]] || [object isKindOfClass:[NSData class]]){
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            if ([key rangeOfString:@"."].location != NSNotFound){
                NSArray *comp = [key componentsSeparatedByString:@"."];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n", comp[0], comp[1]] dataUsingEncoding:NSUTF8StringEncoding]];
            }else
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".png\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            if ([object isKindOfClass:[UIImageView class]])
                [body appendData:UIImagePNGRepresentation([object image])];
            else [body appendData:object];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[object dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (connectionError){
            if (callback)
                callback(@"error");
            NSLog(@"error");
        }else{
            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"return: %@", returnString);
            if (callback)
                callback(returnString);
        }
    }];
}

+(void)sendDataToURL:(NSURL*)url callback:(void(^)(NSString *returnString))callback objectsAndKeysInArray:(NSMutableArray*)array{
    NSMutableArray *objectsAndKeys = array;
    
    if (objectsAndKeys){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        for (int a = 0; a < [objectsAndKeys count]; a+=2){
            id object = objectsAndKeys[a];
            id key = objectsAndKeys[a+1];
            if ([object isKindOfClass:[UIImageView class]] || [object isKindOfClass:[NSData class]]){
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                if ([key rangeOfString:@"."].location != NSNotFound){
                    NSArray *comp = [key componentsSeparatedByString:@"."];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n", comp[0], comp[1]] dataUsingEncoding:NSUTF8StringEncoding]];
                }else
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".png\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                if ([object isKindOfClass:[UIImageView class]])
                    [body appendData:UIImagePNGRepresentation([object image])];
                else [body appendData:object];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[object dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            if (connectionError){
                if (callback)
                    callback(@"error");
                NSLog(@"error");
            }else{
                NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"return: %@", returnString);
                if (callback)
                    callback(returnString);
            }
        }];
    }
}

//+(void)sendDataToURL:(NSURL *)url callback:(void(^)(NSString *returnString))callback objectsAndKeys:(id)firstObject, ...{
//    NSMutableArray *objectsAndKeys = [NSMutableArray new];
//    
//    if (firstObject){
//        [objectsAndKeys addObject:firstObject];
//        id eachObject;
//        va_list argumentList;
//        va_start(argumentList, firstObject);
//        while ((eachObject = va_arg(argumentList, id)))
//            [objectsAndKeys addObject:eachObject];
//        va_end(argumentList);
//    }
//    
//    NSMutableString *uploadStr = [[NSMutableString alloc] init];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    [request setHTTPMethod:@"POST"];
//    for (int a = 0; a < [objectsAndKeys count]; a+=2){
//        id object = objectsAndKeys[a];
//        id key = objectsAndKeys[a+1];
//        if (a != 0)
//            [uploadStr appendString:@"&"];
//        [uploadStr appendString:[NSString stringWithFormat:@"%@=%@", key, object]];
//    }
//    NSLog(@"sending: %@", uploadStr);
//    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[uploadStr length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:[uploadStr dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
//        if (connectionError){
//            if (callback)
//                callback(@"error");
//            NSLog(@"error");
//        }else{
//            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", returnString);
//            if (callback)
//                callback(returnString);
//        }
//    }];
//}

@end
