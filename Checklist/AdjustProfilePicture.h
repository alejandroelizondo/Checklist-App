//
//  AdjustProfilePicture.h
//  Checklist
//
//  Created by Alejandro Elizondo on 02/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GPUImage.h"

@interface AdjustProfilePicture : UIView{
    void (^cropCompletion)(UIImage *image);
    void (^viewCompletion)(BOOL finished);
    UIImageView *profile;
    UIImageView *cropMargin;
    UIImageView *navBar;
    UIButton *cancel;
    UILabel *title;
    CGFloat axisX, axisY;
    
    GPUImagePicture *sourcePicture;
    GPUImageView *primaryView;
    GPUImageOutput<GPUImageInput> *sepiaFilter, *sepiaFilter2;
}

@property (nonatomic, unsafe_unretained) id delegate;

-(id)initCropWithImage:(UIImage*)image callback:(void(^)(UIImage *image))callback;
-(id)initViewWithImage:(UIImage*)image callback:(void(^)(BOOL finished))callback;

@end
