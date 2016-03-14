//
//  Snake.h
//  Checklist
//
//  Created by Alejandro Elizondo on 31/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTableView.h"

@interface Snake : UIView <DCTableViewDelegate>{
    NSInteger lives, speed, fruits;
    NSInteger currentLives, currentFruits;
    NSMutableArray *snake;
    DCTableView *matrix;
    NSString *currentSwipe, *oldSwipe;
}

-(id)initWithNumberOfLives:(NSInteger)l speed:(NSInteger)s fruits:(NSInteger)f;

@end
