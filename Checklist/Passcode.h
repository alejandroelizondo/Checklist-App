//
//  Passcode.h
//  Checklist
//
//  Created by Alejandro Elizondo on 24/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Passcode : UIView{
    NSMutableArray *buttons, *code;
    BOOL isNew;
}

-(void)show;

@end
