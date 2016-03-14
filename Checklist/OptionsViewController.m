//
//  OptionsViewController.m
//  Checklist
//
//  Created by Alejandro Elizondo on 02/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "OptionsViewController.h"
#import "ViewController.h"
#import "Extras.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = green;
    [self setNeedsStatusBarAppearanceUpdate];
    
    palette = [[ColorPalette alloc] init];
    palette.delegate = self;
    palette.frame = CGRectMake(320-palette.frame.size.width-5, 65, palette.frame.size.width, palette.frame.size.height);
    [self.view addSubview:palette];

    paletteHide = [UIButton buttonWithType:UIButtonTypeCustom];
    paletteHide.frame = CGRectMake(0, 60, 320, 548-60);
    [paletteHide addTarget:self action:@selector(colorPaletteWillDisappear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:paletteHide];
    [self.view sendSubviewToBack:paletteHide];
    
    if ([Extras getBrushColor]){
        background.tintColor = (UIColor*)[Extras getBrushColor];
        brushColor.backgroundColor = (UIColor*)[Extras getBrushColor];
    }
    if ([Extras getBucketColor]){
        background.backgroundColor = (UIColor*)[Extras getBucketColor];
        bucketColor.backgroundColor = (UIColor*)[Extras getBucketColor];
    }
    
    [brushColor.layer setBorderWidth:1 radius:brushColor.frame.size.width/2.0 color:[UIColor darkGrayColor] mask:YES];
    [bucketColor.layer setBorderWidth:1 radius:bucketColor.frame.size.width/2.0 color:[UIColor darkGrayColor] mask:YES];
}


-(IBAction)bucketPressed{
    if (palette.alpha == 0 || isBrush){
        isBrush = NO;
        [palette setCornerToBottom:NO distanceZeroToHundred:85];
        [self.view bringSubviewToFront:paletteHide];
        [self.view bringSubviewToFront:palette];
        [palette show:bucketColor.backgroundColor];
        palette.frame = CGRectMake(320-palette.frame.size.width-5, bucketColor.frame.origin.y+bucketColor.frame.size.height+5, palette.frame.size.width, palette.frame.size.height);
    }else if (!isBrush)
        [self colorPaletteWillDisappear];
}
-(IBAction)brushPressed{
    if (palette.alpha == 0 || !isBrush){
        isBrush = YES;
        [palette setCornerToBottom:NO distanceZeroToHundred:85];
        [self.view bringSubviewToFront:paletteHide];
        [self.view bringSubviewToFront:palette];
        [palette show:brushColor.backgroundColor];
        palette.frame = CGRectMake(320-palette.frame.size.width-5, brushColor.frame.origin.y+brushColor.frame.size.height+5, palette.frame.size.width, palette.frame.size.height);
    }else if (isBrush)
        [self colorPaletteWillDisappear];
}
-(void)colorPaletteWillDisappear{
    [self.view sendSubviewToBack:paletteHide];
    [palette hide];}
-(void)colorDidChange:(UIColor *)color{
    if (isBrush){
        background.tintColor = color;
        brushColor.backgroundColor = color;
    }else{
        background.backgroundColor = color;
        bucketColor.backgroundColor = color;
    }
}


-(IBAction)save{
    [Extras saveBrushColor:brushColor.backgroundColor];
    [Extras saveBucketColor:bucketColor.backgroundColor];
    [self back];
}
-(IBAction)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}
- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
@end
