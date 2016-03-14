//
//  ColorPalette.h
//  Dation
//
//  Created by Alejandro Elizondo on 13/03/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPaletteDelegate
-(void)colorDidChange:(UIColor*)color;
@end
@interface ColorPalette : UIView <UITextFieldDelegate, UITextViewDelegate>{
    UIImageView *satBriCursor, *satBriImage;
    UIImageView *paletteCursor, *paletteImage;
    UIImageView *corner;
    UIColor *currentColor;
    NSMutableArray *config, *buttons;
    UISlider *alphaSlider;
    UITextField *hex;
    double axisX, axisY;
    BOOL canColor;
}

@property (nonatomic, unsafe_unretained) id <ColorPaletteDelegate> delegate;

-(void)setCornerToBottom:(BOOL)isBottom distanceZeroToHundred:(CGFloat)percentage;
-(void)setCornerToLeft:(BOOL)isLeft distanceZeroToHundred:(CGFloat)percentage;
-(UIColor*)getPaletteColor;
-(UIColor*)getSatBriColor;
-(void)show:(id)object;
-(void)hide;

@end
