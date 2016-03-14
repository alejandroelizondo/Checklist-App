//
//  DCTableView.h
//  Dation
//
//  Created by Alejandro Elizondo on 09/03/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCTableView;
@protocol DCTableViewDelegate

-(NSInteger)DCTableViewNumberOfObjects:(DCTableView*)tableView;
-(UIView*)DCTableView:(DCTableView*)tableView cellForRow:(NSInteger)row column:(NSInteger)column index:(NSInteger)index;

@optional
-(UIView *)DCTableViewHeader:(DCTableView*)tableView;
-(void)DCTableView:(DCTableView *)tableView didSelectCell:(UIView*)cell AtIndex:(NSInteger)index;
-(void)DCTableViewWillBeginDragging:(UIScrollView*)tableView;
-(void)DCTableViewDidScroll:(UIScrollView*)tableView;
-(void)DCTableViewDidEndDecelerating:(UIScrollView*)tableView;
-(void)DCTableViewDidEndDragging:(UIScrollView *)tableView;
-(void)DCTableViewDidClosePreview;

@end

@interface DCTableView : UIView <UIScrollViewDelegate>{
    NSInteger numberOfRows;
    UIScrollView *scroller;
    UIImage *previewImg;
    CGFloat headerExtra;
//    int currentFirstRow;
//    int currentLastRow;
}

@property (nonatomic) NSInteger columns;
@property (nonatomic) BOOL scrollable;
@property (nonatomic) BOOL scrollWithBounce;
@property (nonatomic) BOOL organized;
@property (nonatomic) BOOL deleteIfNotInScreen;
@property (nonatomic) NSInteger borderWidth;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic, strong) NSMutableDictionary *views, *images;
@property (nonatomic, unsafe_unretained) id <DCTableViewDelegate> delegate;

-(void)reloadData;
-(void)reloadColumnAtIndex:(int)index;
-(UIImage*)previewImage;
-(void)previewImageAtIndex:(NSInteger)index;
-(void)tableViewWillClose;
-(void)scrollToNewContentAnimated:(BOOL)animated;

@end