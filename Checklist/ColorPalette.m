//
//  ColorPalette.m
//  Dation
//
//  Created by Alejandro Elizondo on 13/03/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "ColorPalette.h"
#import "Extras.h"

@implementation ColorPalette
static NSString *key = @"savedConfiguration";
@synthesize delegate = _delegate;

- (id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 310, 310);
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.alpha = 0;
        
        canColor = YES;
        config = [[NSMutableArray alloc] initWithCapacity:22];
        buttons = [[NSMutableArray alloc] initWithCapacity:22];
        
        CGFloat buttonWidth = 20;
        UILabel *colorsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        colorsTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        colorsTitle.backgroundColor = [UIColor clearColor];
        colorsTitle.textAlignment = NSTextAlignmentCenter;
        colorsTitle.text = @"Colores\nRecientes";
        colorsTitle.numberOfLines = 2;
        [colorsTitle sizeToFit];
        colorsTitle.center = CGPointMake(250+buttonWidth+2, 22);
        [self addSubview:colorsTitle];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:key])
            config = [config getForKey:key];
        BOOL restartConfig = FALSE;
        if ([config count] == 0)
            restartConfig = TRUE;
        for (int a = 0, c = 0; a < 2; a++)
            for (int b = 0; b < 11; b++, c++){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(250+a*buttonWidth+a*4, 44+b*buttonWidth+b*3, buttonWidth, buttonWidth);
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = c;
                [btn addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
                [btn.layer setBorderWidth:1.2 radius:buttonWidth/2.0 color:[UIColor colorWithWhite:0.3 alpha:1] mask:YES];
                [self addSubview:btn];
                [buttons addObject:btn];
                if (restartConfig)
                    [config addObject:@{@"px":@(0),@"py":@(0),@"sx":@(0),@"sy":@(0),
                                        @"alpha":@(100),@"color":[UIColor clearColor]}];
            }
        
        satBriImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"colorSatBri" ofType:@"png"]]];
        satBriImage.backgroundColor = [UIColor redColor];
        satBriImage.frame = CGRectMake(20, 44, 170, 200);
        satBriImage.userInteractionEnabled = YES;
        [self addSubview:satBriImage];
        UIPanGestureRecognizer *satBriImgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(satBriImagePanning:)];
        [satBriImage addGestureRecognizer:satBriImgPan];
        UITapGestureRecognizer *satBriImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(satBriImageTap:)];
        [satBriImage addGestureRecognizer:satBriImgTap];

        paletteImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"colorPanel" ofType:@"png"]]];
        paletteImage.backgroundColor = [UIColor clearColor];
        paletteImage.frame = CGRectMake(210, 44, 20, 200);
        paletteImage.userInteractionEnabled = YES;
        [self addSubview:paletteImage];
        UIPanGestureRecognizer *paletteImgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paletteImagePanning:)];
        [paletteImage addGestureRecognizer:paletteImgPan];
        UITapGestureRecognizer *paletteImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paletteImageTap:)];
        [paletteImage addGestureRecognizer:paletteImgTap];

        satBriCursor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        satBriCursor.backgroundColor = [UIColor clearColor];
        satBriCursor.userInteractionEnabled = YES;
        [satBriImage addSubview:satBriCursor];
        [satBriCursor.layer setBorderWidth:1 radius:5 color:[UIColor blackColor] mask:YES];
        [satBriCursor.layer setShadowOffset:CGSizeMake(0, 0) color:[UIColor whiteColor] opacity:0.8 radius:0.6 inView:satBriImage.layer];
        UIPanGestureRecognizer *satBriPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(satBriCursorPanning:)];
        [satBriCursor addGestureRecognizer:satBriPan];
        
        paletteCursor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 5)];
        paletteCursor.backgroundColor = [UIColor clearColor];
        paletteCursor.userInteractionEnabled = YES;
        paletteCursor.center = CGPointMake(paletteImage.frame.size.width/2.0, 1);
        [paletteImage addSubview:paletteCursor];
        [paletteCursor.layer setBorderWidth:1 radius:0 color:[UIColor blackColor] mask:YES];
        [paletteCursor.layer setShadowOffset:CGSizeMake(0, 0) color:[UIColor whiteColor] opacity:0.8 radius:0.6 inView:paletteImage.layer];
        UIPanGestureRecognizer *palettePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paletteCursorPanning:)];
        [paletteCursor addGestureRecognizer:palettePan];
        
        alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(satBriImage.frame.origin.x, satBriImage.frame.origin.y+satBriImage.frame.size.height+10, paletteImage.frame.origin.x, 28)];
        alphaSlider.minimumValue = 0;
        alphaSlider.maximumValue = 100;
        alphaSlider.value = 100;
        [alphaSlider addTarget:self action:@selector(sliderMoving:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:alphaSlider];
        
        UILabel *alphaText = [[UILabel alloc] initWithFrame:CGRectMake(alphaSlider.frame.origin.x, alphaSlider.frame.origin.y+alphaSlider.frame.size.height-10, alphaSlider.frame.size.width+10, 40)];
        alphaText.backgroundColor = [UIColor clearColor];
        alphaText.textAlignment = NSTextAlignmentLeft;
        alphaText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        alphaText.text = @"0%        Opacidad        100%";
        [self addSubview:alphaText];
       
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(satBriImage.frame.origin.x, 0, 20, satBriImage.frame.origin.y)];
        num.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        num.backgroundColor = [UIColor clearColor];
        num.textColor = [UIColor darkGrayColor];
        num.text = @"#";
        [self addSubview:num];
        
        hex = [[UITextField alloc] initWithFrame:CGRectMake(satBriImage.frame.origin.x+20, 0, satBriImage.frame.size.width-20, satBriImage.frame.origin.y)];
        hex.autocapitalizationType = UITextAutocapitalizationTypeNone;
        hex.autocorrectionType = UITextAutocorrectionTypeNo;
        hex.placeholder = @"FFFFFF";
        hex.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        hex.backgroundColor = [UIColor clearColor];
        hex.textColor = [UIColor darkGrayColor];
        hex.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        hex.borderStyle = UITextBorderStyleNone;
        hex.delegate = self;
        [hex addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventAllEditingEvents];
        [self addSubview:hex];
        
        corner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        corner.backgroundColor = self.backgroundColor;
        corner.transform = CGAffineTransformRotate(corner.transform, M_PI_4);
        [self addSubview:corner];
        [self sendSubviewToBack:corner];
        corner.center = CGPointMake(0, self.frame.size.height/2.0);
        self.clipsToBounds = NO;
        
        [self.layer setBorderWidth:1.5 radius:20 color:[UIColor clearColor] mask:NO];
        [self.layer setShadowOffset:CGSizeMake(0,1) color:[UIColor blackColor] opacity:.4 radius:1.5 inView:self.layer];
    }
    return self;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0){
        if ([textView.text isEqualToString:@"white"] || [textView.text isEqualToString:@"blanco"])
            [self show:[UIColor whiteColor]];
        else if ([textView.text isEqualToString:@"black"] || [textView.text isEqualToString:@"negro"])
            [self show:[UIColor blackColor]];
        else if ([textView.text isEqualToString:@"blue"] || [textView.text isEqualToString:@"azul"])
            [self show:[UIColor blueColor]];
        else if ([textView.text isEqualToString:@"brown"] || [textView.text isEqualToString:@"cafe"])
            [self show:[UIColor brownColor]];
        else if ([textView.text isEqualToString:@"yellow"] || [textView.text isEqualToString:@"amarillo"])
            [self show:[UIColor yellowColor]];
        else if ([textView.text isEqualToString:@"red"] || [textView.text isEqualToString:@"rojo"])
            [self show:[UIColor redColor]];
        else if ([textView.text isEqualToString:@"gray"] || [textView.text isEqualToString:@"gris"])
            [self show:[UIColor grayColor]];
        else if ([textView.text isEqualToString:@"green"] || [textView.text isEqualToString:@"verde"])
            [self show:[UIColor greenColor]];
        else if ([textView.text isEqualToString:@"orange"] || [textView.text isEqualToString:@"naranja"])
            [self show:[UIColor orangeColor]];
        else if ([textView.text isEqualToString:@"purple"] || [textView.text isEqualToString:@"morado"])
            [self show:[UIColor purpleColor]];
        else{
            UIColor *color = [textView.text convertHEXToColor];
            NSArray *hsv = [color getHSV];
            CGFloat xAxis = satBriImage.frame.size.width*[hsv[1] doubleValue]/100.0;
            CGFloat yAxis = satBriImage.frame.size.height*(1.0-[hsv[2] doubleValue]/100.0);
            satBriCursor.center = CGPointMake(xAxis, yAxis);
            CGPoint panelPoint = CGPointMake(paletteImage.frame.size.width/2.0, (1.0-[hsv[0] doubleValue]/360.0)*(paletteImage.frame.size.height/2)/0.5);
            paletteCursor.center = panelPoint;
            UIColor *satBriColor = [self getColorInPaletteCursor];
            alphaSlider.value = 100;
            satBriImage.backgroundColor = satBriColor;
            currentColor = [self getColorInSatBriCursor];
        }
    }
}
-(void)setHEX:(UIColor *)uiColor{
    CGColorRef color = [uiColor CGColor];
    
    int numComponents = (int)CGColorGetNumberOfComponents(color);
    int red, green, blue;
    const CGFloat *components = CGColorGetComponents(color);
    if (numComponents == 4){
        red =  (int)(components[0] * 255.0) ;
        green = (int)(components[1] * 255.0);
        blue = (int)(components[2] * 255.0);
    }else{
        red  =  (int)(components[0] * 255.0) ;
        green  =  (int)(components[0] * 255.0);
        blue  =  (int)(components[0] * 255.0);
    }
    
    hex.text = [NSString stringWithFormat:@"%02X%02X%02X", red, green, blue];
}
-(void)sliderMoving:(UISlider*)slider{
    NSArray *rgb = [currentColor getRGB];
    currentColor = [UIColor colorWithRed:[rgb[0] floatValue]
                                   green:[rgb[1] floatValue]
                                    blue:[rgb[2] floatValue]
                                   alpha:slider.value/100.0];
    if ([(id)_delegate respondsToSelector:@selector(colorDidChange:)])
        [_delegate colorDidChange:currentColor];
}
-(void)colorSelected:(UIButton*)button{
    NSDictionary *d = config[button.tag];
    if ([d[@"px"] integerValue] != 0){
        CGPoint pCenter = CGPointMake([d[@"px"] floatValue], [d[@"py"] floatValue]);
        CGPoint sCenter = CGPointMake([d[@"sx"] floatValue], [d[@"sy"] floatValue]);
        CGFloat alpha = [d[@"alpha"] floatValue];
        paletteCursor.center = pCenter;
        satBriCursor.center = sCenter;
        alphaSlider.value = alpha;
        [self paletteCursorColoring];
        [self setHEX:[self getColorInSatBriCursor]];
    }
}
-(void)satBriImagePanning:(UIGestureRecognizer*)panning{
    CGPoint translatedPoint = [panning locationInView:satBriImage];
    
    translatedPoint = CGPointMake(translatedPoint.x, translatedPoint.y);
    translatedPoint = [self satBriCursorLimits:translatedPoint];
    
    satBriCursor.center = translatedPoint;
    
    if (canColor)
        [self satBriQueries];
}
-(void)satBriImageTap:(UIGestureRecognizer*)tap{[self satBriImagePanning:tap];}
-(void)satBriCursorPanning:(UIPanGestureRecognizer*)panning{
    CGPoint translatedPoint = [panning translationInView:satBriImage];
    
    if (panning.state == UIGestureRecognizerStateBegan){
        axisX = panning.view.center.x;
        axisY = panning.view.center.y;
    }
    
    translatedPoint = CGPointMake(axisX+translatedPoint.x, axisY+translatedPoint.y);
    translatedPoint = [self satBriCursorLimits:translatedPoint];
    
    satBriCursor.center = translatedPoint;

    if (canColor)
        [self satBriQueries];
}
-(void)paletteImagePanning:(UIGestureRecognizer*)panning{
    CGPoint translatedPoint = [panning locationInView:paletteImage];
    
    translatedPoint = CGPointMake(paletteImage.frame.size.width/2.0, translatedPoint.y);
    translatedPoint = [self paletteCursorLimits:translatedPoint];
    
    paletteCursor.center = translatedPoint;

    if (canColor)
        [self paletteQueries];
}
-(void)paletteImageTap:(UIGestureRecognizer*)tap{[self paletteImagePanning:tap];}
-(void)paletteCursorPanning:(UIPanGestureRecognizer*)panning{
    CGPoint translatedPoint = [panning translationInView:paletteImage];
    
    if (panning.state == UIGestureRecognizerStateBegan){
        axisY = panning.view.center.y;
    }
    
    translatedPoint = CGPointMake(paletteImage.frame.size.width/2.0, axisY+translatedPoint.y);
    translatedPoint = [self paletteCursorLimits:translatedPoint];
    
    paletteCursor.center = translatedPoint;
    
    if (canColor)
        [self paletteQueries];
}
-(CGPoint)satBriCursorLimits:(CGPoint)translatedPoint{
    if (translatedPoint.x < 0)
        translatedPoint = CGPointMake(0, translatedPoint.y);
    else if (translatedPoint.x > satBriImage.frame.size.width)
        translatedPoint = CGPointMake(satBriImage.frame.size.width, translatedPoint.y);
    if (translatedPoint.y < 0)
        translatedPoint = CGPointMake(translatedPoint.x, 0);
    else if (translatedPoint.y > satBriImage.frame.size.height)
        translatedPoint = CGPointMake(translatedPoint.x, satBriImage.frame.size.height);
    return translatedPoint;}
-(CGPoint)paletteCursorLimits:(CGPoint)translatedPoint{
    if (translatedPoint.y < 0)
        translatedPoint = CGPointMake(translatedPoint.x, 0);
    else if (translatedPoint.y > paletteImage.frame.size.height)
        translatedPoint = CGPointMake(translatedPoint.x, paletteImage.frame.size.height);
    return translatedPoint;}
-(void)satBriCursorColoring{
    currentColor = [self getColorInSatBriCursor];
    [self setHEX:currentColor];
    canColor = YES;}
-(void)paletteCursorColoring{
    satBriImage.backgroundColor = [self getColorInPaletteCursor];
    currentColor = [self getColorInSatBriCursor];
    [self setHEX:currentColor];
    canColor = YES;}
-(void)satBriQueries{
    [self performSelector:@selector(satBriCursorColoring) withObject:nil afterDelay:0.1];
    canColor = NO;}
-(void)paletteQueries{
    [self performSelector:@selector(paletteCursorColoring) withObject:nil afterDelay:0.1];
    canColor = NO;}
-(UIColor*)getPaletteColor{ return [self getColorInPaletteCursor]; }
-(UIColor*)getSatBriColor{ return currentColor; }
- (UIColor*)getColorInPaletteCursor{
    CGFloat h = 0;
    h = 1-paletteCursor.center.y/paletteImage.frame.size.height;
    return [UIColor colorWithHue:h saturation:1 brightness:1 alpha:alphaSlider.value/100.0];}
- (UIColor*)getColorInSatBriCursor{
    CGFloat h = 0, s = 0, b = 0;
    h = 1-paletteCursor.center.y/paletteImage.frame.size.height;
    s = satBriCursor.center.x/satBriImage.frame.size.width;
    b = 1-satBriCursor.center.y/satBriImage.frame.size.height;
    UIColor *c = [UIColor colorWithHue:h saturation:s brightness:b alpha:alphaSlider.value/100.0];
    if ([(id)_delegate respondsToSelector:@selector(colorDidChange:)])
        [_delegate colorDidChange:c];
    return c;}
-(void)setCornerToBottom:(BOOL)isBottom distanceZeroToHundred:(CGFloat)percentage{
    CGFloat center = (self.frame.size.width-30)*percentage/100.0;
    if (isBottom)
        [UIView animateWithDuration:0.3 animations:^{ corner.center = CGPointMake(15+center, self.frame.size.height); }];
    else
        [UIView animateWithDuration:0.3 animations:^{ corner.center = CGPointMake(15+center, 0); }];
}
-(void)setCornerToLeft:(BOOL)isLeft distanceZeroToHundred:(CGFloat)percentage{
    CGFloat center = (self.frame.size.height-30)*percentage/100.0;
    if (isLeft)
        [UIView animateWithDuration:0.3 animations:^{ corner.center = CGPointMake(0, 15+center); }];
    else
        [UIView animateWithDuration:0.3 animations:^{ corner.center = CGPointMake(self.frame.size.width, 15+center); }];
}
-(void)show:(id)object{
    UIColor *color = object;
    NSArray *rgba = [color getRGB];
    NSArray *hsv = [color getHSV];
    
    CGFloat xAxis = satBriImage.frame.size.width*[hsv[1] doubleValue]/100.0;
    CGFloat yAxis = satBriImage.frame.size.height*(1.0-[hsv[2] doubleValue]/100.0);
    CGPoint panelPoint = CGPointMake(paletteImage.frame.size.width/2.0, (1.0-[hsv[0] doubleValue]/360.0)*(paletteImage.frame.size.height/2)/0.5);
    
    satBriCursor.center = CGPointMake(xAxis, yAxis);
    paletteCursor.center = panelPoint;
    
    UIColor *satBriColor = [self getColorInPaletteCursor];
    satBriImage.backgroundColor = satBriColor;
    alphaSlider.value = [rgba[3] floatValue]*100;
    currentColor = [self getColorInSatBriCursor];
    [self setHEX:currentColor];

    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 1; }];
}
-(void)hide{
    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 0; } completion:^(BOOL finished){
        [self makeSpace];
        if (currentColor)
        [config replaceObjectAtIndex:0
                          withObject:@{@"px":@(paletteCursor.center.x),@"py":@(paletteCursor.center.y),
                                       @"sx":@(satBriCursor.center.x),@"sy":@(satBriCursor.center.y),
                                       @"alpha":@(alphaSlider.value),@"color":currentColor}];
        [config saveForKey:key];
        for (int a = 0; a < [config count]; a++){
            UIButton *button = buttons[a];
            button.backgroundColor = config[a][@"color"];
        }
    }];
}
-(void)makeSpace{
    int removedIndex = (int)[config count]-1;
    BOOL hasFound = FALSE;
    for (int a = 0; a < [config count] && !hasFound; a++)
        if ([config[a][@"color"] isEqual:currentColor]){
            hasFound = TRUE;
            removedIndex = a;
        }
    for (int a = removedIndex; a > 0; a--){
        [config replaceObjectAtIndex:a
                                withObject:@{@"px":config[a-1][@"px"],@"py":config[a-1][@"py"],
                                             @"sx":config[a-1][@"sx"],@"sy":config[a-1][@"sy"],
                                             @"alpha":config[a-1][@"alpha"],
                                             @"color":config[a-1][@"color"]}];
    }
}
@end
