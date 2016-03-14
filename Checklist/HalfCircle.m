//
//  HalfCircle.m
//  Dation
//
//  Created by Alejandro Elizondo on 08/01/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "HalfCircle.h"

@implementation HalfCircle
@synthesize theColor = _theColor;
@synthesize startAngle = _startAngle;
@synthesize innerRadius = _innerRadius;
@synthesize activityIndicator = _activityIndicator;
@synthesize separation = _separation;
@synthesize startsAt = _startsAt;
@synthesize isLoading = _isLoading;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        frame.size.height = frame.size.width;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        _theColor = [UIColor colorWithRed:0.7 green:0.85 blue:0 alpha:1];
        _startAngle = 0;
        _innerRadius = frame.size.width/2.0-5;
        _separation = 20;
        _startsAt = 65;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.color = [UIColor colorWithRed:0.7 green:0.85 blue:0 alpha:1];
        _activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _activityIndicator.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        [self addSubview:_activityIndicator];
        
        _isLoading = NO;
        totalHeight = self.frame.size.height+(_separation*2);
    }
    return self;
}
-(void)drawSlice0to100:(CGFloat)percentage{
    CGFloat radius = self.frame.size.width/2.0;
    circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, radius+_innerRadius, radius+_innerRadius) cornerRadius:self.frame.size.width/2.0].CGPath;
    circle.position = CGPointMake(self.frame.size.width/4.0-_innerRadius/2.0, self.frame.size.height/4.0-_innerRadius/2.0);
    circle.strokeEnd = percentage;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = _theColor.CGColor;
    circle.lineWidth = radius-_innerRadius;
    [self.layer addSublayer:circle];
}
-(void)isScrolling:(UIScrollView*)scrollView{
    if (_isLoading)
        [scrollView setContentOffset:CGPointMake(0, -totalHeight) animated:NO];
    if (scrollView.contentOffset.y <= -_separation){
        self.center = CGPointMake(self.center.x, _startsAt+(_separation/2.0)+(self.frame.size.height/2.0)+scrollView.contentOffset.y);
        if (circle) [circle removeFromSuperlayer];
        [self drawSlice0to100:fabs((scrollView.contentOffset.y+_separation)/self.frame.size.height)];
    }}
-(void)scrollingEnded:(UIScrollView*)scrollView{
    [_activityIndicator stopAnimating];
    if (scrollView.contentOffset.y <= -totalHeight && !_isLoading){
        _isLoading = YES;
        scrollView.contentOffset = CGPointMake(0, -totalHeight);
        [_activityIndicator startAnimating];
    }}
-(void)stopLoading:(id)scrollView{
    _isLoading = NO;
    [_activityIndicator stopAnimating];
    [circle removeFromSuperlayer];
    [UIView animateWithDuration:0.5 animations:^{[scrollView setContentOffset:CGPointMake(0, 0)];}];}

-(void)setTheColor:(UIColor *)theColor{_theColor = theColor;}
-(void)setStartAngle:(CGFloat)startAngle{_startAngle = startAngle;}
-(void)setInnerRadius:(CGFloat)innerRadius{_innerRadius = innerRadius;}
-(void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator{_activityIndicator = activityIndicator;}
-(void)setSeparation:(CGFloat)separation{_separation = separation;}
-(void)setStartsAt:(CGFloat)startsAt{if(startsAt == 0) startsAt = 1; _startsAt = startsAt;}
-(void)setIsLoading:(BOOL)isLoading{_isLoading = isLoading;}
@end
