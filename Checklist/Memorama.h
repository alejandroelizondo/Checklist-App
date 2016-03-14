//
//  Memorama.h
//  Checklist
//
//  Created by Alejandro Elizondo on 31/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTableView.h"

@interface Memorama : UIView <DCTableViewDelegate, UIAlertViewDelegate>{
    NSInteger pairs, time;
    NSInteger currentPairs;
    DCTableView *matrix;
    NSMutableArray *colors, *cells;
    int firstSelected;
    id delegate;
    UILabel *counter;
    NSTimer *timer;
}

-(id)initWithNumberOfPairs:(NSInteger)p time:(CGFloat)t delegate:(id)d;
-(void)start;

@end
