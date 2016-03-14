//
//  OptionsViewController.h
//  Checklist
//
//  Created by Alejandro Elizondo on 02/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ColorPalette.h"

@interface OptionsViewController : UIViewController <ColorPaletteDelegate>{
    IBOutlet UIButton *brushColor;
    IBOutlet UIButton *bucketColor;
    IBOutlet UIButton *background;
    BOOL isBrush;
    ColorPalette *palette;
    UIButton *paletteHide;
}

-(IBAction)save;
-(IBAction)back;
-(IBAction)bucketPressed;
-(IBAction)brushPressed;

@end
