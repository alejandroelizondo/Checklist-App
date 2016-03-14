//
//  Memorama.m
//  Checklist
//
//  Created by Alejandro Elizondo on 31/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#define winTag 1
#define loseTag 2

#import "Memorama.h"
#import "ViewController.h"
#include <stdlib.h>

@implementation Memorama

- (id)initWithNumberOfPairs:(NSInteger)p time:(CGFloat)t delegate:(id)d{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
        
        pairs = p;
        time = t;
        delegate = d;
        
        matrix = [[DCTableView alloc] initWithFrame:self.frame];
        matrix.delegate = self;
        if (pairs < 10)
            matrix.columns = 2;
        else
            matrix.columns = 4;
        matrix.organized = YES;
        [self addSubview:matrix];
        
        cells = [[NSMutableArray alloc] init];
        colors = [[NSMutableArray alloc] init];
        for (int a = 0, c = 0; c < pairs/2.0; a += 2, c++){
            if (a == 0){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.95 green:0.2 blue:0.1 alpha:1],
                                    @"id":@"1"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.95 green:0.2 blue:0.1 alpha:1],
                                    @"id":@"1"}];
            }else if (a == 2){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:0.8 blue:1 alpha:1],
                                    @"id":@"2"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:0.8 blue:1 alpha:1],
                                    @"id":@"2"}];
            }else if (a == 4){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:1 blue:0.8 alpha:1],
                                    @"id":@"3"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:1 blue:0.8 alpha:1],
                                    @"id":@"3"}];
            }else if (a == 6){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.95 green:0.95 blue:0 alpha:1],
                                    @"id":@"4"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.95 green:0.95 blue:0 alpha:1],
                                    @"id":@"4"}];
            }else if (a == 8){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.3 green:0.4 blue:0.8 alpha:1],
                                    @"id":@"5"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.3 green:0.4 blue:0.8 alpha:1],
                                    @"id":@"5"}];
            }else if (a == 10){
                [colors addObject:@{@"color":[UIColor colorWithWhite:1 alpha:1],
                                    @"id":@"6"}];
                [colors addObject:@{@"color":[UIColor colorWithWhite:1 alpha:1],
                                    @"id":@"6"}];
            }else if (a == 12){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.8 green:0.5 blue:0.75 alpha:1],
                                    @"id":@"7"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.8 green:0.5 blue:0.75 alpha:1],
                                    @"id":@"7"}];
            }else if (a == 14){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1],
                                    @"id":@"8"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1],
                                    @"id":@"8"}];
            }else if (a == 16){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.4 green:0.7 blue:0.5 alpha:1],
                                    @"id":@"9"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.4 green:0.7 blue:0.5 alpha:1],
                                    @"id":@"9"}];
            }else if (a == 18){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.75 green:0.75 blue:0 alpha:1],
                                    @"id":@"10"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.75 green:0.75 blue:0 alpha:1],
                                    @"id":@"10"}];
            }else if (a == 20){
                [colors addObject:@{@"color":[UIColor colorWithWhite:0.5 alpha:1],
                                    @"id":@"11"}];
                [colors addObject:@{@"color":[UIColor colorWithWhite:0.5 alpha:1],
                                    @"id":@"11"}];
            }else if (a == 22){
                [colors addObject:@{@"color":[UIColor colorWithRed:0.5 green:0.2 blue:0.45 alpha:1],
                                    @"id":@"12"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0.5 green:0.2 blue:0.45 alpha:1],
                                    @"id":@"12"}];
            }else if (a == 24){
                [colors addObject:@{@"color":[UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                    @"id":@"13"}];
                [colors addObject:@{@"color":[UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                    @"id":@"13"}];
            }
        }
        
        [matrix reloadData];
        matrix.frame = CGRectMake(0, 0, matrix.contentSize.width, matrix.contentSize.height);
        matrix.center = self.center;

        NSLog(@"cells: %@", cells);
        NSLog(@"matrix: %@", matrix);
        
        counter = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
        counter.textAlignment = NSTextAlignmentRight;
        counter.textColor = [UIColor whiteColor];
        counter.text = [@(t) stringValue];
        [self addSubview:counter];
        
        firstSelected = 0;
    }
    return self;
}

-(NSInteger)DCTableViewNumberOfObjects:(DCTableView *)tableView{
    return pairs;}
-(UIView *)DCTableView:(DCTableView *)tableView cellForRow:(NSInteger)row column:(NSInteger)column index:(NSInteger)index{
    UIButton *cell = [UIButton buttonWithType:UIButtonTypeSystem];
    UIView *cellTag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    cell.frame = CGRectMake(0, 0, 320/(pairs/tableView.columns), 548/(pairs/tableView.columns));
    int n = arc4random()%[colors count];
    cell.backgroundColor = colors[n][@"color"];
    cellTag.backgroundColor = colors[n][@"color"];
    cellTag.tag = [colors[n][@"id"] intValue];
    [cell addSubview:cellTag];
    [cells addObject:cell];
    [colors removeObjectAtIndex:n];
    return cell;
}
-(void)DCTableView:(DCTableView *)tableView didSelectCell:(UIView *)cell AtIndex:(NSInteger)index{
    UIView *cellTag = cell.subviews[0];
    int tag = (int)cellTag.tag;
    
    cell.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        cell.backgroundColor = cellTag.backgroundColor;
    }];
    
    if (firstSelected == 0){
        firstSelected = tag;
    }else{
        if (firstSelected == tag)
            [self foundAPairWithTag:tag];
        else
            [self restart];
        firstSelected = 0;
    }
    
}

-(void)foundAPairWithTag:(int)t{
    for (int a = 0; a < [cells count]; a++){
        UIButton *cell = cells[a];
        int tag = (int)[cell.subviews[0] tag];
        if (tag == t){
            cell.userInteractionEnabled = NO;
            [cells removeObjectAtIndex:a];
            a--;
        }
    }
    if ([cells count] == 0){
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great!" message:@"You've won the privilege of unlocking this sexy picture" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = winTag;
        [alert show];
    }
}

-(void)restart{
    for (int a = 0; a < [cells count]; a++){
        UIButton *cell = cells[a];
        cell.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5 animations:^{
            cell.backgroundColor = [UIColor lightGrayColor];
        }];
    }
}

-(void)start{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
    for (int a = 0; a < [cells count]; a++){
        UIButton *cell = cells[a];
        [UIView animateWithDuration:0.5 animations:^{
            cell.backgroundColor = [UIColor lightGrayColor];
        }];
    }
}

-(void)timerCounter{
    counter.text = [NSString stringWithFormat:@"%d", [counter.text intValue]-1];
    if ([counter.text intValue] <= 0){
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lost!" message:@"Better luck next time! The sexy picture is waiting for you..." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = loseTag;
        [alert show];
    }
}

-(void)exit{
    id __block s = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        s = nil;
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == winTag){
        if ([(id)delegate respondsToSelector:@selector(canUnlock:)])
            [delegate canUnlock:YES];
    }else{
        if ([(id)delegate respondsToSelector:@selector(canUnlock:)])
            [delegate canUnlock:NO];
    }
    [self exit];
}

@end
