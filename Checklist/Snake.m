//
//  Snake.m
//  Checklist
//
//  Created by Alejandro Elizondo on 31/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#define winTag 1
#define loseTag 2

#import "Snake.h"

@implementation Snake

-(id)initWithNumberOfLives:(NSInteger)l speed:(NSInteger)s fruits:(NSInteger)f{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
        
        lives = l;
        speed = s;
        fruits = f;
        
        UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
        swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeL];

        UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
        swipeR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeR];

        UISwipeGestureRecognizer *swipeU = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
        swipeU.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeU];

        UISwipeGestureRecognizer *swipeD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
        swipeD.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeD];

        matrix = [[DCTableView alloc] initWithFrame:self.frame];
//        matrix.userInteractionEnabled = NO;
        matrix.delegate = self;
        matrix.columns = 10;
        matrix.organized = YES;
        [self addSubview:matrix];
        
        snake = [[NSMutableArray alloc] init];
        [snake addObject:@"50"];
        [snake addObject:@"51"];
        [snake addObject:@"52"];
        [snake addObject:@"53"];
        [snake addObject:@"54"];
//        NSMutableDictionary *objects = [[NSMutableDictionary alloc] init];
//        for (int a = 0, c = 0; a < matrix.columns; a++){
//            for (int b = 0; b < 540/(320/matrix.columns); b++){
//                if (a > matrix.columns/2-3 && a < matrix.columns/2+3 && b == 5){
//                    [objects addEntriesFromDictionary:@{[@(b) stringValue]:@"1"}];
//                    if (c == 0){
//                        head = CGPointMake(a, b);
//                        c++;
//                    }
//                }else
//                    [objects addEntriesFromDictionary:@{[@(b) stringValue]:@"0"}];
//            }
//            [snake addEntriesFromDictionary:@{[@(a) stringValue]:[objects mutableCopy]}];
//            [objects removeAllObjects];
//        }
        
        [matrix reloadData];
        
        oldSwipe = @"r";
        currentSwipe = @"d";
        
        [self performSelector:@selector(start) withObject:nil afterDelay:1.0];
    }
    return self;
}


-(NSInteger)DCTableViewNumberOfObjects:(DCTableView *)tableView{
    return matrix.columns*540/(320/matrix.columns);}
-(UIView *)DCTableView:(DCTableView *)tableView cellForRow:(NSInteger)row column:(NSInteger)column index:(NSInteger)index{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320/matrix.columns, 320/matrix.columns)];
    cell.backgroundColor = [UIColor clearColor];
    
    for (int a = 0; a < [snake count]; a++){
        if ([snake[a] intValue] == index){
            cell.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    return cell;
}

-(void)start{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (currentFruits < 5){
        [self performSelector:@selector(start) withObject:nil afterDelay:3.0-1.0/speed];
        for (int a = 0; a < [snake count]; a++)
            [self snakeMovements:a];
        [matrix reloadData];
//        for (int a = 0; a < matrix.columns; a++)
//            [matrix reloadColumnAtIndex:a];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great!" message:@"You've won the privilege of unlocking this sexy picture" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = winTag;
        [alert show];
    }
}

-(void)snakeMovements:(int)part{
    NSLog(@"current: %@", currentSwipe);
    if ([currentSwipe isEqualToString:@"l"]){
        if (part == 0){ // Head
            [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-1) stringValue]];
        }else{
            if ([oldSwipe isEqualToString:@"l"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"r"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"u"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-matrix.columns) stringValue]];
            }else if ([oldSwipe isEqualToString:@"d"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+matrix.columns) stringValue]];
            }
            if (part == [snake count]-1) // change oldSwipe
                oldSwipe = currentSwipe;
        }
    }else if ([currentSwipe isEqualToString:@"r"]){
        if (part == 0){ // Head
            [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+1) stringValue]];
        }else{
            if ([oldSwipe isEqualToString:@"l"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"r"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"u"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-matrix.columns) stringValue]];
            }else if ([oldSwipe isEqualToString:@"d"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+matrix.columns) stringValue]];
            }
            if (part == [snake count]-1) // change oldSwipe
                oldSwipe = currentSwipe;
        }
    }else if ([currentSwipe isEqualToString:@"u"]){
        if (part == 0){ // Head
            [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-matrix.columns) stringValue]];
        }else{
            if ([oldSwipe isEqualToString:@"l"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"r"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"u"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-matrix.columns) stringValue]];
            }else if ([oldSwipe isEqualToString:@"d"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+matrix.columns) stringValue]];
            }
            if (part == [snake count]-1) // change oldSwipe
                oldSwipe = currentSwipe;
        }
    }else if ([currentSwipe isEqualToString:@"d"]){
        if (part == 0){ // Head
            [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+matrix.columns) stringValue]];
        }else{
            if ([oldSwipe isEqualToString:@"l"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"r"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+1) stringValue]];
            }else if ([oldSwipe isEqualToString:@"u"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]-matrix.columns) stringValue]];
            }else if ([oldSwipe isEqualToString:@"d"]){
                [snake replaceObjectAtIndex:part withObject:[@([snake[part] intValue]+matrix.columns) stringValue]];
            }
            if (part == [snake count]-1) // change oldSwipe
                oldSwipe = currentSwipe;
        }
    }
}

-(void)swipeRecognizer:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        currentSwipe = @"l";

    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        currentSwipe = @"r";
    
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionUp){
        currentSwipe = @"u";
        
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionDown){
        currentSwipe = @"d";
        
    }
}

@end
