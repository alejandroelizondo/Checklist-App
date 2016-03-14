//
//  Passcode.m
//  Checklist
//
//  Created by Alejandro Elizondo on 24/05/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "Passcode.h"
#import "Extras.h"
#import "AppDelegate.h"

@implementation Passcode

- (id)init{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:231/255.0 blue:226/255.0 alpha:1];
        
        buttons = [[NSMutableArray alloc] initWithCapacity:9];
        code = [[NSMutableArray alloc] initWithCapacity:9];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
        title.text = @"Passcode";
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
        title.textColor = [UIColor colorWithWhite:0.25 alpha:1];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];

        UIColor *normal = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:128/255.0 alpha:1];
        
        UIView *passcode = [[UIView alloc] initWithFrame:CGRectMake(25, 548-270-100, 270, 270)];
        passcode.backgroundColor = [UIColor clearColor];
        [self addSubview:passcode];
        
        for (int a = 0, c = 0; a < 3; a++){
            for (int b = 0; b < 3; b++, c++){
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setImage:[UIImage imageNamed:@"passcode_normal"] forState:UIControlStateNormal];
                button.tintColor = normal;
                button.frame = CGRectMake(b*90, a*90, 90, 90);
                button.tag = c;
                [button addTarget:self action:@selector(circleSelected:) forControlEvents:UIControlEventTouchDown];
                [passcode addSubview:button];
                [buttons addObject:button];
            }
        }
        
        UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
        reset.frame = CGRectMake(30, 548-30-20, 120, 30);
        [reset setTitle:@"Reset" forState:UIControlStateNormal];
        [reset setTitleColor:title.textColor forState:UIControlStateNormal];
        [[reset titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
        [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reset];
        
        NSLog(@"passcode: %@", [Extras getPasscode]);
        if (![Extras getPasscode]){
            UIButton *next = [UIButton buttonWithType:UIButtonTypeSystem];
            next.frame = CGRectMake(320-120-30, 548-30-20, 120, 30);
            [next setTitle:@"Continue" forState:UIControlStateNormal];
            [next setTitleColor:title.textColor forState:UIControlStateNormal];
            [[next titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
            [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:next];
            isNew = YES;
        }else{
            reset.center = CGPointMake(self.center.x, reset.center.y);
            isNew = NO;
        }
    }
    return self;
}

-(void)reset{
    UIColor *normal = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:128/255.0 alpha:1];
    for (int a = 0; a < [buttons count]; a++){
        UIButton *button = (UIButton*)buttons[a];
        button.tintColor = normal;
    }
    if ([code count] > 0)
        [code removeAllObjects];
}
-(void)circleSelected:(UIButton*)button{
    UIColor *selected = [UIColor colorWithRed:72/255.0 green:174/255.0 blue:98/255.0 alpha:1];
    button.tintColor = selected;
    [code addObject:[NSString stringWithFormat:@"%d", (int)button.tag]];
    if (!isNew)
        [self verify];
}

-(void)verify{
    NSMutableArray *passcode = [Extras getPasscode];
    int b = 1;
    for (int a = 0; a < [code count] && b != 0; a++){
        if ([code[a] intValue] == [passcode[a] intValue])
            b++;
        else
            b = 0;
    }
    if (b == [passcode count]+1)
        [self next];
}

-(void)next{
    if ([code count] != 0){
        if (isNew)
            [Extras savePasscode:code];
        [[Delegate window] setWindowLevel:UIWindowLevelNormal];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 548, 320, 548);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self reset];
        }];
    }
}

-(void)show{
    self.alpha = 1;
    self.frame = [UIScreen mainScreen].bounds;
    [[Delegate window] setWindowLevel:UIWindowLevelStatusBar];
//    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 1; }];
}

@end
