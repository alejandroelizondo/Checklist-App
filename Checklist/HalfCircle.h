//
//  HalfCircle.h
//  Dation
//
//  Created by Alejandro Elizondo on 08/01/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HalfCircle : UIView{
    CGFloat totalHeight;
    CAShapeLayer *circle;
}
@property (nonatomic, strong) UIColor *theColor;
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat separation;
@property (nonatomic) CGFloat startsAt;
@property (readonly) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

-(void)stopLoading:(id)scrollView;
-(void)isScrolling:(UIScrollView*)scrollView;
-(void)scrollingEnded:(UIScrollView*)scrollView;
@end
