//
//  AdjustProfilePicture.m
//  Checklist
//
//  Created by Alejandro Elizondo on 02/06/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "AdjustProfilePicture.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Extras.h"
#import "GPUImage.h"

@implementation AdjustProfilePicture
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Image filtering

- (void)setupDisplayFiltering;
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *inputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    //    sepiaFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    GPUImageView *imageView = (GPUImageView *)primaryView;
    [sepiaFilter forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    
    [sourcePicture addTarget:sepiaFilter];
    [sepiaFilter addTarget:imageView];
    
    [sourcePicture processImage];
}

- (void)setupImageFilteringToDisk;
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *inputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    NSLog(@"First image filtering");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
    GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
    vignetteImageFilter.vignetteEnd = 0.6;
    vignetteImageFilter.vignetteStart = 0.4;
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter addTarget:vignetteImageFilter];
    
    [vignetteImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    @autoreleasepool {
        UIImage *currentFilteredImage = [vignetteImageFilter imageFromCurrentFramebuffer];
        
        NSData *dataForPNGFile = UIImagePNGRepresentation(currentFilteredImage);
        if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-filtered1.png"] options:NSAtomicWrite error:&error])
        {
            NSLog(@"Error: Couldn't save image 1");
        }
        dataForPNGFile = nil;
        currentFilteredImage = nil;
    }
    
    // Do a simpler image filtering
    //    GPUImageSketchFilter *stillImageFilter2 = [[GPUImageSketchFilter alloc] init];
    //    GPUImageSobelEdgeDetectionFilter *stillImageFilter2 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    //    GPUImageAmatorkaFilter *stillImageFilter2 = [[GPUImageAmatorkaFilter alloc] init];
    //    GPUImageUnsharpMaskFilter *stillImageFilter2 = [[GPUImageUnsharpMaskFilter alloc] init];
    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
    NSLog(@"Second image filtering");
    UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:inputImage];
    
    // Write images to disk, as proof
    NSData *dataForPNGFile2 = UIImagePNGRepresentation(quickFilteredImage);
    
    if (![dataForPNGFile2 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-filtered2.png"] options:NSAtomicWrite error:&error])
    {
        NSLog(@"Error: Couldn't save image 2");
    }
}

- (void)setupImageResampling;
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *inputImage = UIGraphicsGetImageFromCurrentImageContext();
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // Linear downsampling
    GPUImageBrightnessFilter *passthroughFilter = [[GPUImageBrightnessFilter alloc] init];
    [passthroughFilter forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [stillImageSource addTarget:passthroughFilter];
    [passthroughFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *nearestNeighborImage = [passthroughFilter imageFromCurrentFramebuffer];
    
    // Lanczos downsampling
    [stillImageSource removeAllTargets];
    GPUImageLanczosResamplingFilter *lanczosResamplingFilter = [[GPUImageLanczosResamplingFilter alloc] init];
    [lanczosResamplingFilter forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [stillImageSource addTarget:lanczosResamplingFilter];
    [lanczosResamplingFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *lanczosImage = [lanczosResamplingFilter imageFromCurrentFramebuffer];
    
    // Trilinear downsampling
    GPUImagePicture *stillImageSource2 = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    GPUImageBrightnessFilter *passthroughFilter2 = [[GPUImageBrightnessFilter alloc] init];
    [passthroughFilter2 forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [stillImageSource2 addTarget:passthroughFilter2];
    [passthroughFilter2 useNextFrameForImageCapture];
    [stillImageSource2 processImage];
    UIImage *trilinearImage = [passthroughFilter2 imageFromCurrentFramebuffer];
    
    NSData *dataForPNGFile1 = UIImagePNGRepresentation(nearestNeighborImage);
    NSData *dataForPNGFile2 = UIImagePNGRepresentation(lanczosImage);
    NSData *dataForPNGFile3 = UIImagePNGRepresentation(trilinearImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error = nil;
    if (![dataForPNGFile1 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-NN.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }
    
    if (![dataForPNGFile2 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-Lanczos.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }
    
    if (![dataForPNGFile3 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-Trilinear.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }
}
































-(id)initViewWithImage:(UIImage *)image callback:(void(^)(BOOL finished))callback{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        primaryView = [[GPUImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [self setupDisplayFiltering];
//        [self setupImageResampling];
//        [self setupImageFilteringToDisk];

        
        
        
        profile = [[UIImageView alloc] initWithImage:image];
        CGFloat scale = 320/image.size.width;
        if (image.size.height < image.size.height)
            scale = 320/image.size.height;
        profile.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
        [self addSubview:profile];
        profile.center = self.center;
        
        profile.userInteractionEnabled = YES;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [profile addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [profile addGestureRecognizer:pan];

        cropMargin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [cropMargin.layer setBorderWidth:1 radius:0 color:[UIColor lightGrayColor] mask:YES];
        cropMargin.center = self.center;
        cropMargin.alpha = 0;
        [self addSubview:cropMargin];

        
        navBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        navBar.backgroundColor = self.backgroundColor;
        [self addSubview:navBar];

        UIImageView *lineNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height-1, 320, 1)];
        lineNavBar.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [navBar addSubview:lineNavBar];
        
        
        cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        cancel.frame = CGRectMake(5, 20, 70, 30);
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [[cancel titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [cancel setTintColor:[UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        title.text = @"Profile Picture";
        title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
        [navBar addSubview:title];
                
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        viewCompletion = callback;
    }
    return self;
}

-(void)viewTapped:(UITapGestureRecognizer*)tap{
    if (navBar.alpha == 1){
        [UIView animateWithDuration:0.3 animations:^{
            navBar.alpha = 0;
            cancel.alpha = 0;
            self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
            [[Delegate window] setWindowLevel:UIWindowLevelStatusBar];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            navBar.alpha = 1;
            cancel.alpha = 1;
            self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            [[Delegate window] setWindowLevel:UIWindowLevelNormal];
        }];
    }
}

-(id)initCropWithImage:(UIImage*)image callback:(void(^)(UIImage *image))callback{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        
        profile = [[UIImageView alloc] initWithImage:image];
        CGFloat scale = 260/image.size.width;
        if (image.size.height < image.size.height)
            scale = 260/image.size.height;
        profile.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
        [self addSubview:profile];
        profile.center = self.center;
        
        profile.userInteractionEnabled = YES;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [profile addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [profile addGestureRecognizer:pan];
        
        cropMargin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
        [cropMargin.layer setBorderWidth:1 radius:0 color:[UIColor lightGrayColor] mask:YES];
        cropMargin.center = self.center;
        [self addSubview:cropMargin];
        
        navBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        navBar.backgroundColor = self.backgroundColor;
        [self addSubview:navBar];
        
        cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        cancel.frame = CGRectMake(5, 20, 70, 30);
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [[cancel titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [cancel setTintColor:[UIColor colorWithRed:1 green:0.9 blue:0 alpha:1]];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
        save.frame = CGRectMake(320-70-5, 20, 70, 30);
        [save setTitle:@"Save" forState:UIControlStateNormal];
        [[save titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [save setTintColor:[UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]];
        [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:save];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.text = @"Adjust Picture";
        title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
        [self addSubview:title];
        
        cropCompletion = callback;
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer*)gesture{
    CGPoint translatedPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        axisX = gesture.view.center.x;
        axisY = gesture.view.center.y;
    }
    
    translatedPoint = CGPointMake(axisX+translatedPoint.x, axisY+translatedPoint.y);

    profile.center = translatedPoint;
    
    if (profile.frame.origin.x > cropMargin.frame.origin.x)
        profile.frame = CGRectMake(cropMargin.frame.origin.x, profile.frame.origin.y, profile.frame.size.width, profile.frame.size.height);
    if (profile.frame.origin.x+profile.frame.size.width < cropMargin.frame.origin.x+cropMargin.frame.size.width)
        profile.frame = CGRectMake(cropMargin.frame.origin.x+cropMargin.frame.size.width-profile.frame.size.width, profile.frame.origin.y, profile.frame.size.width, profile.frame.size.height);
    if (profile.frame.origin.y > cropMargin.frame.origin.y)
        profile.frame = CGRectMake(profile.frame.origin.x, cropMargin.frame.origin.y, profile.frame.size.width, profile.frame.size.height);
    if (profile.frame.origin.y+profile.frame.size.height < cropMargin.frame.origin.y+cropMargin.frame.size.height)
        profile.frame = CGRectMake(profile.frame.origin.x, cropMargin.frame.origin.y+cropMargin.frame.size.height-profile.frame.size.height, profile.frame.size.width, profile.frame.size.height);
}

- (void)pinch:(UIPinchGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = gesture.view.frame.size.width / gesture.view.bounds.size.width;
        CGFloat newScale = currentScale * gesture.scale;
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        gesture.view.transform = transform;
        gesture.scale = 1;
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        if (profile.frame.size.width < profile.frame.size.height){
            if (profile.frame.size.width < cropMargin.frame.size.width){
                CGFloat scale = cropMargin.frame.size.width/profile.frame.size.width;
                [UIView animateWithDuration:0.3 animations:^{
                    profile.frame = CGRectMake(320/2.0-(profile.frame.size.width*scale)/2.0, 568/2.0-(profile.frame.size.height*scale)/2.0, profile.frame.size.width*scale, profile.frame.size.height*scale);
                }];
            }
            else if (profile.frame.size.width > cropMargin.frame.size.width+200){
                CGFloat scale = (cropMargin.frame.size.width+200)/profile.frame.size.width;
                [UIView animateWithDuration:0.3 animations:^{
                    profile.frame = CGRectMake(320/2.0-(profile.frame.size.width*scale)/2.0, 568/2.0-(profile.frame.size.height*scale)/2.0, profile.frame.size.width*scale, profile.frame.size.height*scale);
                }];
            }
        }else{
            if (profile.frame.size.height < cropMargin.frame.size.height){
                CGFloat scale = cropMargin.frame.size.height/profile.frame.size.height;
                [UIView animateWithDuration:0.3 animations:^{
                    profile.frame = CGRectMake(320/2.0-(profile.frame.size.width*scale)/2.0, 568/2.0-(profile.frame.size.height*scale)/2.0, profile.frame.size.width*scale, profile.frame.size.height*scale);
                }];
            }
            else if (profile.frame.size.height > cropMargin.frame.size.height+200){
                CGFloat scale = (cropMargin.frame.size.height+200)/profile.frame.size.height;
                [UIView animateWithDuration:0.3 animations:^{
                    profile.frame = CGRectMake(320/2.0-(profile.frame.size.width*scale)/2.0, 568/2.0-(profile.frame.size.height*scale)/2.0, profile.frame.size.width*scale, profile.frame.size.height*scale);
                }];
            }
        }
    }
}

-(void)cancel{
    if (_delegate){
        [_delegate setColorOfStatus:@"w"];
        [_delegate setNeedsStatusBarAppearanceUpdate];
    }
    if (cropCompletion)
        cropCompletion(nil);
    else if (viewCompletion)
        viewCompletion(YES);
}

-(void)save{
    if (_delegate){
        [_delegate setColorOfStatus:@"w"];
        [_delegate setNeedsStatusBarAppearanceUpdate];
    }
    UIGraphicsBeginImageContext(cropMargin.frame.size);
    [profile.image drawInRect:CGRectMake(profile.frame.origin.x-cropMargin.frame.origin.x, profile.frame.origin.y-cropMargin.frame.origin.y, profile.frame.size.width, profile.frame.size.height)];
    UIImage *myimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (cropCompletion)
        cropCompletion(myimage);
}

-(UIStatusBarStyle)preferredStatusBarStyle{  return UIStatusBarStyleDefault;  }
@end
