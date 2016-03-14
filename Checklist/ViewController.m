//
//  ViewController.m
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "AFJSONRequestOperation.h"
#import "SendData.h"
#import "DetailedController.h"
#import "HalfCircle.h"
#import "Extras.h"
#import "AppDelegate.h"
#import "Passcode.h"
#import "Memorama.h"
#import "Messages.h"
#import "PasswordProtected.h"
#import "AdjustProfilePicture.h"
#import "GPUImage.h"

@interface ViewController () {
    HalfCircle *loading;
}

@end

@implementation ViewController
@synthesize listIndicator = _listIndicator;
@synthesize objects = _objects;
@synthesize colorOfStatus = _colorOfStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:231/255.0 blue:226/255.0 alpha:1];
    navBarMainView.backgroundColor = green;
    navBarMenuView.backgroundColor = green;
    _colorOfStatus = @"w";
    [self setNeedsStatusBarAppearanceUpdate];
    
    [mainView.layer setMasksToBounds:NO];
    [mainView.layer setShadowOffset:CGSizeMake(0, 0) color:[UIColor blackColor] opacity:0.75 radius:10 inView:mainView.layer];
    [menuProfilePicture.layer setBorderWidth:0 radius:menuProfilePicture.frame.size.width/2.0 color:[UIColor clearColor] mask:YES];
    menuUsername.text = [Delegate owner];
    
    table.alpha = 0;
    listIndicatorBackground.backgroundColor = [UIColor colorWithRed:72/255.0 green:174/255.0 blue:98/255.0 alpha:1];
    [[listIndicatorBackground layer] setCornerRadius:listIndicatorBackground.frame.size.width/2.0];
    [activity startAnimating];
    
    loading = [[HalfCircle alloc] initWithFrame:CGRectMake(320/2.0-15, 10, 30, 30)];
    loading.theColor = green;
    loading.startsAt = 0;
    loading.separation = 15;
    [table addSubview:loading];
    [table sendSubviewToBack:loading];
    
    if ([Extras getUserProfile])
        [menuProfilePicture setImage:[Extras getUserProfile] forState:UIControlStateNormal];
    
    [self downloadMyPP];
    [self downloadRecipientProfilePicture];
    [self readJSON:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/data.php", mainURL]]];
}
-(void)downloadMyPP{
    [self downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/profiles/%@.png", mainURL, [Delegate owner]]] completionBlock:^(BOOL succeeded, UIImage *image){
        if (image)
            [menuProfilePicture setImage:image forState:UIControlStateNormal];
    }];
}
-(void)downloadRecipientProfilePicture{
    [self downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/profiles/%@.png", mainURL, [Delegate to]]] completionBlock:^(BOOL succeeded, UIImage *image){
        if (image)
            [chatProfilePicture setImage:image forState:UIControlStateNormal];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([Extras getBrushColor]){
        background.tintColor = (UIColor*)[Extras getBrushColor];
        background2.tintColor = (UIColor*)[Extras getBrushColor];
    }
    if ([Extras getBucketColor]){
        background.backgroundColor = (UIColor*)[Extras getBucketColor];
        background2.backgroundColor = (UIColor*)[Extras getBucketColor];
    }
    [self updateStatus];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStatus) object:nil];
}
-(void)updateStatus{
    NSLog(@"%s", __FUNCTION__);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/status.php?name=%@", mainURL, [Delegate to]]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON && [JSON count] > 0)
            status.text = JSON[0][@"status"];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStatus) object:nil];
        [self performSelector:@selector(updateStatus) withObject:nil afterDelay:10];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStatus) object:nil];
        [self performSelector:@selector(updateStatus) withObject:nil afterDelay:10];
    }];
    [operation start];
}
-(IBAction)showMenu{
    menuView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        menuBackgroundHidder.alpha = 1;
        mainView.frame = CGRectMake(220, mainView.frame.origin.y, 320, mainView.frame.size.height);
    } completion:^(BOOL finished) {
        [mainView bringSubviewToFront:menuBackgroundHidder];
    }];
}
-(IBAction)hideMenu{
    [UIView animateWithDuration:0.3 animations:^{
        menuBackgroundHidder.alpha = 0;
        mainView.frame = CGRectMake(0, mainView.frame.origin.y, 320, mainView.frame.size.height);
    } completion:^(BOOL finished) {
        [mainView sendSubviewToBack:menuBackgroundHidder];
        menuView.alpha = 0;
    }];
}
-(void)readJSON:(NSURL*)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"good: %@", JSON);
        if (!_objects)
            _objects = [[NSMutableArray alloc] init];
        if (JSON){
            [_objects removeAllObjects];
            [_objects addObjectsFromArray:JSON];
            [table reloadData];
        }
        [activity stopAnimating];
        table.alpha = 1;
        [loading stopLoading:table];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        [activity stopAnimating];
        table.alpha = 1;
        [loading stopLoading:table];
    }];
    [operation start];
}

-(void)loadMoreTouched:(UIButton*)button{
    table.tableHeaderView = nil;
    //    [self reloadMessagesWithReload:YES];
}
- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (isMailbox){
    //        CustomCell *cell = [t dequeueReusableCellWithIdentifier:@"inboxCell"];
    //        NSString *text = _messages[indexPath.row][@"message"];
    //        text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    //        text = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    //        CGSize textSize = [text boundingRectWithSize:CGSizeMake(240, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:cell.to.font.fontName size:cell.to.font.pointSize]} context:nil].size;
    //        return textSize.height+16;
    //    }
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (isMailbox){
    //        if (canLoadMore && !tableView.tableHeaderView){
    //            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //            button.frame = CGRectMake(0, 0, 320, 40);
    //            [button setTitle:@"Load More" forState:UIControlStateNormal];
    //            [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    //            [button addTarget:self action:@selector(loadMoreTouched:) forControlEvents:UIControlEventTouchUpInside];
    //            tableView.tableHeaderView = button;
    //        }
    //        return [_messages count];
    //    }else
    if (!tableView.tableHeaderView)
        tableView.tableHeaderView = [UIView new];
    _listIndicator.text = [NSString stringWithFormat:@"%d", (int)[_objects count]];
    return [_objects count];}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (!isMailbox){
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    
    NSString *title = _objects[indexPath.row][@"title"];
    title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [title dataUsingEncoding:NSUTF8StringEncoding];
    title = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];

    cell.title.text = title;
    cell.check.selected = [_objects[indexPath.row][@"completed"] boolValue];
    
    cell.alert.alpha = 0;
    cell.date.alpha = 0;
    cell.date.text = @" ";
    
    if (![_objects[indexPath.row][@"date"] isEqualToString:@"0"]){
        cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, cell.title.frame.size.width, cell.title.frame.size.height);
        cell.date.text = _objects[indexPath.row][@"date"];
        cell.date.alpha = 1;
        cell.alert.alpha = 1;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        [Extras setLocalNotificationTitle:_objects[indexPath.row][@"title"] date:[dateFormatter dateFromString:_objects[indexPath.row][@"date"]] ID:_objects[indexPath.row][@"id"]];
    }
    
    cell.check.tag = indexPath.row;
    [cell.check addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    table.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    //    }else{
    //        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxCell"];
    //
    //        BOOL delivered = [_messages[indexPath.row][@"delivered"] boolValue];
    //        BOOL seen = [_messages[indexPath.row][@"seen"] boolValue];
    //        NSString *from = _messages[indexPath.row][@"from"];
    //        NSString *message = _messages[indexPath.row][@"message"];
    //
    //        message = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    //        message = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    //        if ([from isEqualToString:[Delegate owner]]){
    //            cell.from.text = @" ";
    //            cell.fromBackground.backgroundColor = [UIColor clearColor];
    //
    //            cell.to.text = message;
    //            cell.to.textColor = [UIColor whiteColor];
    //            cell.toBackground.backgroundColor = [UIColor colorWithRed:72/255.0 green:174/255.0 blue:98/255.0 alpha:1];
    //            [cell.toBackground.layer setCornerRadius:13.0];
    //
    //            cell.delivered.center = CGPointMake(320-cell.delivered.frame.size.width, cell.delivered.frame.size.height);
    //            cell.seen.center = CGPointMake(320-cell.seen.frame.size.width, cell.delivered.center.y*3);
    //        }else{
    //            cell.to.text = @" ";
    //            cell.toBackground.backgroundColor = [UIColor clearColor];
    //
    //            cell.from.text = message;
    //            cell.fromBackground.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    //            [cell.fromBackground.layer setCornerRadius:13.0];
    //
    //            cell.delivered.center = CGPointMake(cell.delivered.frame.size.width, cell.delivered.frame.size.height);
    //            cell.seen.center = CGPointMake(cell.seen.frame.size.width, cell.delivered.center.y*3);
    //        }
    //
    //        CGRect frame = CGRectMake(20, 5, 0, 0);
    //        frame.size = [cell.from sizeThatFits:CGSizeMake(240, 1000)];
    //        cell.from.frame = frame;
    //
    //        CGRect frame2 = CGRectMake(0, 5, 0, 0);
    //        frame2.size = [cell.to sizeThatFits:CGSizeMake(240, 1000)];
    //        cell.to.frame = frame2;
    //
    //        cell.to.frame = CGRectMake(320-cell.to.frame.size.width-20, cell.to.frame.origin.y, cell.to.frame.size.width, cell.to.frame.size.height);
    //
    //        cell.fromBackground.frame = CGRectMake(cell.from.frame.origin.x-5, cell.from.frame.origin.y-3, cell.from.frame.size.width+10, cell.from.frame.size.height+6);
    //        cell.toBackground.frame = CGRectMake(cell.to.frame.origin.x-5, cell.to.frame.origin.y-3, cell.to.frame.size.width+10, cell.to.frame.size.height+6);
    //
    //        cell.delivered.alpha = 0;
    //        cell.seen.alpha = 0;
    //        if (delivered)
    //            cell.delivered.alpha = 1;
    //        if (seen)
    //            cell.seen.alpha = 1;
    //
    //        table.backgroundColor = [UIColor clearColor];
    //        cell.backgroundColor = [UIColor clearColor];
    //
    //        return cell;
    //    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (!isMailbox){
    DetailedController *d = (DetailedController*)[self.storyboard instantiateViewControllerWithIdentifier:@"detailed"];
    d.view.backgroundColor = green;
    d.objects = [NSMutableDictionary dictionaryWithDictionary:_objects[indexPath.row]];
    d.topTitle.text = topTitle.text;
    [self.navigationController pushViewController:d animated:YES];
    //    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (!isMailbox){
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/delete.php?", mainURL]] callback:nil objectsAndKeys: _objects[indexPath.row][@"id"], @"id", nil];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [Delegate setChangesMade:YES];
    }
    //    }
}

-(IBAction)seeChatProfilePicture{
    AdjustProfilePicture * __block adjust = [[AdjustProfilePicture alloc] initViewWithImage:chatProfilePicture.imageView.image callback:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
        }completion:^(BOOL finished) {
            [adjust removeFromSuperview];
            adjust = nil;
        }];
    }];
    adjust.delegate = self;
    adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
    [self.view addSubview:adjust];
    _colorOfStatus = @"b";
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        adjust.frame = [UIScreen mainScreen].bounds;
    }completion:nil];
}

-(IBAction)options{
    [self hideMenu];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"options"] animated:YES];
}
-(IBAction)notifyUser{
    [self hideMenu];
    table.tableHeaderView = nil;
    topTitle.text = @"Bucketlist";
    [table reloadData];
    table.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height-60);
    table.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 3){
        if (buttonIndex == 0){ // See Profile
            AdjustProfilePicture * __block adjust = [[AdjustProfilePicture alloc] initViewWithImage:menuProfilePicture.imageView.image callback:^(BOOL finished) {
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
                }completion:^(BOOL finished) {
                    [adjust removeFromSuperview];
                    adjust = nil;
                }];
            }];
            adjust.delegate = self;
            adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
            [self.view addSubview:adjust];
            _colorOfStatus = @"b";
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                adjust.frame = [UIScreen mainScreen].bounds;
            }completion:nil];
        }else if (buttonIndex == 1){ // Change Profile
            willChangeProfile = YES;
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *pairs = @[[@(8) stringValue],[@(12) stringValue],[@(16) stringValue],[@(20) stringValue],[@(24) stringValue]];
    return pairs[row];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    double compressionRatio = 1;
    NSData *imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], compressionRatio);
    int count = 0;
    while ([imgData length] > 4000000 && count < 10) {
        compressionRatio = compressionRatio * 0.5;
        imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], compressionRatio);
        count++;
    }
    
    NSLog(@"bytes: %lu", (unsigned long)[imgData length]);
    if (willChangeProfile){
        AdjustProfilePicture * __block adjust = [[AdjustProfilePicture alloc] initCropWithImage:[UIImage imageWithData:imgData] callback:^(UIImage *image) {
            if (image){
                NSLog(@"saved");
                double compressionRatio = 1;
                NSData *imgData = UIImageJPEGRepresentation(image, compressionRatio);
                int count = 0;
                while ([imgData length] > 4000000 && count < 10) {
                    compressionRatio = compressionRatio * 0.5;
                    imgData = UIImageJPEGRepresentation(image, compressionRatio);
                    count++;
                }
                
                [menuProfilePicture setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                [Extras saveUserProfile:[UIImage imageWithData:imgData]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/updateProfile.php?", mainURL]];
                [SendData sendDataToURL:url
                               callback:^(NSString *returnString) {
                                   if ([returnString isEqualToString:@"1"]){
                                       [Extras sendNotificationWithMessage:[NSString stringWithFormat:@"%@ has changed his profile picture!", [Delegate owner]]];
                                   }else{
                                       [Extras insertURLQueries:url objectsAndKeys:
                                        [[UIImageView alloc] initWithImage:[UIImage imageWithData:imgData]], [NSString stringWithFormat:@"%@.png", [Delegate owner]],
                                        [Delegate owner], @"name", nil];
                                   }
                               } objectsAndKeys:
                 [[UIImageView alloc] initWithImage:[UIImage imageWithData:imgData]], [NSString stringWithFormat:@"%@.png", [Delegate owner]],
                 [Delegate owner], @"name", nil];
            }
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
            }completion:^(BOOL finished) {
                [adjust removeFromSuperview];
                adjust = nil;
            }];
        }];
        adjust.delegate = self;
        [picker dismissViewControllerAnimated:YES completion:nil];
        adjust.frame = CGRectMake(0, adjust.frame.size.height, adjust.frame.size.width, adjust.frame.size.height);
        [self.view addSubview:adjust];
        _colorOfStatus = @"b";
        [self setNeedsStatusBarAppearanceUpdate];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            adjust.frame = [UIScreen mainScreen].bounds;
        }completion:nil];
    }
}
-(void)downloadImageWithURL:(NSURL*)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{
    [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error){
         if (!error){
             UIImage *image = [[UIImage alloc] initWithData:data];
             completionBlock(YES, image);
         } else{
             completionBlock(NO, nil);
         }
     }];
}
-(void)canUnlock:(BOOL)unlock{
    if (unlock){
        NSLog(@"will unlock: %d", unlockingIndex);
        NSLog(@"images1: %@", images);
        NSDictionary *dic = images[[unlockingView superview].tag];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               dic[@"id"], @"id",
               dic[@"image"], @"image",
               dic[@"value1"], @"value1",
               dic[@"value2"], @"value2",
               @"0", @"protected", nil];
        [images replaceObjectAtIndex:unlockingIndex withObject:dic];
        [unlockingView removeFromSuperview];
        unlockingView = nil;
    }
}

-(IBAction)addNew{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add New" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* titleField = [alertView textFieldAtIndex:0];
    titleField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    titleField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleField.placeholder = @"New Experience";
    alertView.tag = 2;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 2){
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSData *data = [textField.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]\\",kCFStringEncodingUTF8));
        [_objects addObject:@{@"title":encodedString,
                              @"completed":@"0",
                              @"date":@"0",
                              @"id":@"0"}];
        [table reloadData];
        [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/insert.php?", mainURL]] callback:nil objectsAndKeys:encodedString, @"title", nil];
        [Delegate setChangesMade:YES];
    }
}

-(void)buttonClicked:(UIButton*)button{
    NSString *ID = _objects[button.tag][@"id"];
    NSString *completed = _objects[button.tag][@"completed"];
    NSString *title = _objects[button.tag][@"title"];
    NSString *date = _objects[button.tag][@"date"];
    completed = [NSString stringWithFormat:@"%d", abs([completed intValue]-1)];
    [_objects replaceObjectAtIndex:button.tag withObject:@{@"title":title,
                                                           @"completed":completed,
                                                           @"id":ID,
                                                           @"date":date}];
    button.selected = [completed boolValue];
    if (button.selected)
        [Extras cancelLocalNotificationID:ID];
    [SendData sendDataToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/update.php?", mainURL]] callback:nil objectsAndKeys: ID, @"id",
     completed, @"completed",
     title, @"title",
     date, @"date", nil];
    [Delegate setChangesMade:YES];
}






-(void)updateIndicatorWithNotification:(NSDictionary*)notification{
    NSLog(@"notification: %@", notification);
    NSString *alert = notification[@"aps"][@"alert"];
    if (!notification[@"aps"])
        alert = notification[@"alert"];
    if (notification[@"aps"][@"badge"])
        [UIApplication sharedApplication].applicationIconBadgeNumber = [notification[@"aps"][@"badge"] intValue];
    UIView *view = [Extras sendBarMessage:alert withRecipient:NO];
    UITapGestureRecognizer *barTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barMessageTapped:)];
    barTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:barTap];
    
    if ([alert rangeOfString:@"profile picture"].location != NSNotFound)
        [self downloadRecipientProfilePicture];
}
-(void)barMessageTapped:(UITapGestureRecognizer*)gesture{
    UIView *tapped = [gesture view];
    id __block t = tapped;
    [UIView animateWithDuration:0.5 animations:^{
        tapped.frame = CGRectMake(0, -60, 320, 60);
    } completion:^(BOOL finished) {
        [[Delegate window] setWindowLevel:UIWindowLevelNormal];
        [t removeFromSuperview];
        t = nil;
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{[loading isScrolling:scrollView];}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [loading scrollingEnded:scrollView];
    if (loading.isLoading){
        [self readJSON:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/data.php", mainURL]]];
    }
}
-(IBAction)changeProfilePicture{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"See Profile", @"Change Profile", nil];
    sheet.tag = 3;
    [sheet showInView:self.view];
}
-(void)reloadListAfterModifications{[table reloadData];}
-(UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"%s", __FUNCTION__);
    if ([_colorOfStatus isEqualToString:@"w"])
        return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;}
- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
@end
