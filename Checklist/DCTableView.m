//
//  DCTableView.m
//  Dation
//
//  Created by Alejandro Elizondo on 09/03/14.
//  Copyright (c) 2014 Alejandro Elizondo. All rights reserved.
//

#import "DCTableView.h"

@interface DCTableView ()

@end

@implementation DCTableView
@synthesize deleteIfNotInScreen = _deleteIfNotInScreen;
@synthesize scrollWithBounce = _scrollWithBounce;
@synthesize contentOffset = _contentOffset;
@synthesize contentSize = _contentSize;
@synthesize borderWidth = _borderWidth;
@synthesize scrollable = _scrollable;
@synthesize organized = _organized;
@synthesize delegate = _delegate;
@synthesize columns = _columns;
@synthesize images = _images;
@synthesize views = _views;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.backgroundColor = [UIColor clearColor];
        [self addSubview:scroller];
        _views = [[NSMutableDictionary alloc] init];
        _images = [[NSMutableDictionary alloc] init];
        _columns = 1;
        headerExtra = 0;
        _borderWidth = 0;
        _organized = YES;
        _scrollable = YES;
        _deleteIfNotInScreen = YES;
//        currentFirstRow = 0;
//        currentLastRow = 0;
        _contentOffset = CGPointMake(0, 0);
    }
    return self;
}

-(void)reloadColumnAtIndex:(int)index{
    BOOL finishedY = NO;
    numberOfRows = [_delegate DCTableViewNumberOfObjects:self];
    for (int a = index%_columns, b = 0, c = 0; a < numberOfRows && !finishedY; a += _columns, b++){
        UIView *view = _views[[NSString stringWithFormat:@"%d", a]];
        
        if (c == 0){
            c = 1;
            view.frame = CGRectMake(view.frame.origin.x, headerExtra, view.frame.size.width, view.frame.size.height);
        }else{
            UIView *view2 = _views[[NSString stringWithFormat:@"%d", a-(int)_columns]];
            view.frame = CGRectMake(view.frame.origin.x, view2.frame.origin.y+view2.frame.size.height-_borderWidth, view.frame.size.width, view.frame.size.height);
        }
        
        if (view.frame.origin.y+view.frame.size.height-scroller.contentOffset.y < 0 ||
                  view.frame.origin.y-scroller.contentOffset.y-headerExtra > self.frame.size.height){
            finishedY = YES;
            view = nil;
        }else{
            if (_scrollable)
                scroller.contentSize = CGSizeMake(MAX(scroller.contentSize.width, view.frame.origin.x+view.frame.size.width), MAX(scroller.contentSize.height, MAX(view.frame.origin.y+view.frame.size.height, self.frame.size.width+10)));
        }
    }
}

-(void)reloadData{
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewNumberOfObjects:)] &&
        [(id)_delegate respondsToSelector:@selector(DCTableView:cellForRow:column:index:)]){
        UIView *header = nil;
        if ([(id)_delegate respondsToSelector:@selector(DCTableViewHeader:)]){
            header = [_delegate DCTableViewHeader:self];
            header.frame = CGRectMake(0, 0, header.frame.size.width, header.frame.size.height);
            headerExtra = header.frame.size.height;
            [scroller addSubview:header];
        }
        if (_organized){
//            numberOfRows = [_delegate DCTableViewNumberOfObjects:self];
//            int a = (int)numberOfRows/(int)_columns;
//            if (numberOfRows%_columns != 0)
//                a++;
//            a -= 1;
//            if (a < 0)
//                a = 0;
//            int b = (int)_columns-1;
//            int c = (int)numberOfRows-1;
//            UIView *view = [_delegate DCTableView:self cellForRow:a column:b index:c];
//            view.frame = CGRectMake(c%_columns*view.frame.size.width,
//                                    a*(view.frame.size.height-_borderWidth)+headerExtra,
//                                    view.frame.size.width, view.frame.size.height);
//            if (_scrollable)
//                scroller.contentSize = CGSizeMake(MAX(scroller.contentSize.width, view.frame.origin.x+view.frame.size.width), MAX(scroller.contentSize.height, MAX(view.frame.origin.y+view.frame.size.height, self.frame.size.width+10)));
//            else
//                scroller.contentSize = CGSizeMake(0, 0);
        }
        [self reloadViews];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please implement delegate functions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)reloadViews{
    NSLog(@"%s", __FUNCTION__);
    numberOfRows = [_delegate DCTableViewNumberOfObjects:self];
    CGFloat eX = 0, y = _borderWidth;
    BOOL finishedX, finishedY = NO;
    if (_organized){
        for (int a = 0, c = 0; c < numberOfRows && !finishedY; a++){
            finishedX = NO;
            for (int b = 0; b < _columns && c < numberOfRows && !finishedX; b++, c++){
                UIView *view = [_delegate DCTableView:self cellForRow:a column:b index:c];
                
                if (c > 0 && c%_columns == 0)
                    y = view.frame.size.height-_borderWidth;
                eX = -_borderWidth*(c%_columns);
                
                view.frame = CGRectMake(c%_columns*view.frame.size.width+eX,
                                        a*y+headerExtra,
                                        view.frame.size.width, view.frame.size.height);
                
                if ((view.frame.origin.x+view.frame.size.width-scroller.contentOffset.x < 0 ||
                    view.frame.origin.x-scroller.contentOffset.x > self.frame.size.width) && _deleteIfNotInScreen){
                    finishedX = YES;
                    view = nil;
                }else if ((view.frame.origin.y+view.frame.size.height-scroller.contentOffset.y < 0 ||
                          view.frame.origin.y-scroller.contentOffset.y-headerExtra > self.frame.size.height) && _deleteIfNotInScreen){
                    finishedX = YES;
                    finishedY = YES;
                    view = nil;
                }else{
                    view.tag = c;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                    tap.numberOfTapsRequired = 1;
                    tap.numberOfTouchesRequired = 1;
                    [view addGestureRecognizer:tap];
                    
                    if (!_views[[@(c) stringValue]]){
                        [scroller addSubview:view];
                        [_views addEntriesFromDictionary:@{[@(c) stringValue]:view}];
                    }
                }
                if (_scrollable)
                    scroller.contentSize = CGSizeMake(MAX(scroller.contentSize.width, view.frame.origin.x+view.frame.size.width), MAX(scroller.contentSize.height, MAX(view.frame.origin.y+view.frame.size.height, self.frame.size.width+10)));
                else
                    scroller.contentSize = CGSizeMake(0, 0);
            }
        }
//        scroller.frame = CGRectMake(0, 0, scroller.contentSize.width, scroller.contentSize.height);
    }else{
        for (int a = 0, c = 0; c < numberOfRows && !finishedY; a++){
            finishedX = NO;
            for (int b = 0; b < _columns && c < numberOfRows && !finishedX; b++, c++){
                UIView *view = [_delegate DCTableView:self cellForRow:a column:b index:c];
                
                if (c > 0 && c%_columns == 0)
                    y = view.frame.size.height-_borderWidth;
                eX = -_borderWidth*(c%_columns);
                
                CGFloat newY = headerExtra;
                if (c >= _columns)
                    newY = [(UIView*)_views[[@(c-_columns) stringValue]] frame].origin.y+[(UIView*)_views[[@(c-_columns) stringValue]] frame].size.height;
                view.frame = CGRectMake(c%_columns*view.frame.size.width+eX,
                                        newY-_borderWidth,
                                        view.frame.size.width, view.frame.size.height);
                
                if (view.frame.origin.x+view.frame.size.width-scroller.contentOffset.x < 0 ||
                    view.frame.origin.x-scroller.contentOffset.x > self.frame.size.width){
                    finishedX = YES;
                    view = nil;
                }else if (view.frame.origin.y-scroller.contentOffset.y-headerExtra > self.frame.size.height){
                    finishedX = YES;
                    finishedY = YES;
                    view = nil;
                }else{
                    view.tag = c;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                    tap.numberOfTapsRequired = 1;
                    tap.numberOfTouchesRequired = 1;
                    [view addGestureRecognizer:tap];
                    
                    if (!_views[[@(c) stringValue]]){
                        [scroller addSubview:view];
                        [_views addEntriesFromDictionary:@{[@(c) stringValue]:view}];
                    }
                }
//                currentLastRow = c/_columns;
                if (_scrollable)
                    scroller.contentSize = CGSizeMake(MAX(scroller.contentSize.width, view.frame.origin.x+view.frame.size.width), MAX(scroller.contentSize.height, MAX(view.frame.origin.y+view.frame.size.height, self.frame.size.width+10)));
                else
                    scroller.contentSize = CGSizeMake(0, 0);
            }
        }
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tap{
    if ([(id)_delegate respondsToSelector:@selector(DCTableView:didSelectCell:AtIndex:)])
        [_delegate DCTableView:self didSelectCell:tap.view AtIndex:tap.view.tag];}
-(void)previewImageAtIndex:(NSInteger)index{
    if (_images){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.alpha = 0;
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
        [self addSubview:view];
        
        previewImg = [_images[[@(index) stringValue]] image];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:previewImg];
        imageView.frame = CGRectMake(5, 50, MIN(view.frame.size.width-10, previewImg.size.width), MIN(view.frame.size.height-55, previewImg.size.height));
        imageView.center = CGPointMake(view.center.x+2, view.center.y+25);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.frame = CGRectMake(view.frame.size.width-45, 5, 40, 40);
        [close setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"closeButton3@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(previewClosed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:close];
        
        [UIView animateWithDuration:0.5 animations:^{ view.alpha = fabs(view.alpha-1); }];
    }
}
-(UIImage*)previewImage{ return previewImg; }
-(void)previewClosed:(UIButton*)button{
    UIView *view = [button superview];
    [UIView animateWithDuration:0.5 animations:^{ view.alpha = 0; }
                     completion:^(BOOL finished){ [view removeFromSuperview]; }];
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewDidClosePreview)])
        [_delegate DCTableViewDidClosePreview];
}
-(void)tableViewWillClose{
    for (UIView *view in _views)
        [view removeFromSuperview];
    for (UIImageView *imageView in _images)
        [imageView removeFromSuperview];
    [_views removeAllObjects];
    [_images removeAllObjects];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewWillBeginDragging:)])
        [_delegate DCTableViewWillBeginDragging:scrollView];}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewDidScroll:)])
        [_delegate DCTableViewDidScroll:scrollView];
//    if (_views && [_views count] != 0){
//        UIView *view = (UIView*)_views[[@(currentFirstRow*_columns) stringValue]];
//        UIView *view2 = (UIView*)_views[[@(currentLastRow*_columns-1) stringValue]];
//        BOOL canReload = YES;
//        if ((view.tag == 0 &&
//             scroller.contentOffset.y < headerExtra) ||
//            (view2.tag == numberOfRows-1 &&
//             scroller.contentOffset.y > scroller.contentSize.height-scroller.frame.size.height))
//            canReload = NO;
//        if (canReload){
//            if (view.frame.origin.y+view.frame.size.height-scroller.contentOffset.y < 0){
//                NSLog(@"a-1");
//                currentFirstRow++;
//                if (currentFirstRow >= numberOfRows/_columns)
//                    currentFirstRow = (int)(numberOfRows/_columns-1);
//                [self reloadViews];
//            }else if (view.frame.origin.y-scroller.contentOffset.y > 0){
//                NSLog(@"a-2");
//                currentFirstRow--;
//                if (currentFirstRow < 0)
//                    currentFirstRow = 0;
//                [self reloadViews];
//            }else if (view2.frame.origin.y-scroller.contentOffset.y-headerExtra > self.frame.size.height){
//                NSLog(@"a-3");
//                currentLastRow--;
//                if (currentLastRow < 0)
//                    currentLastRow = 0;
//                [self reloadViews];
//            }else if (view2.frame.origin.y+view2.frame.size.height-scroller.contentOffset.y < self.frame.size.height){
//                NSLog(@"a-4: %d", currentLastRow*(int)_columns-1);
//                currentLastRow++;
//                if (currentLastRow >= numberOfRows/_columns)
//                    currentLastRow = (int)(numberOfRows/_columns-1);
//                [self reloadViews];
//            }
//        }
//    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewDidEndDecelerating:)])
        [_delegate DCTableViewDidEndDecelerating:scrollView];}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([(id)_delegate respondsToSelector:@selector(DCTableViewDidEndDragging:)])
        [_delegate DCTableViewDidEndDragging:scrollView];}
-(void)scrollToNewContentAnimated:(BOOL)animated{
    if (animated)
        [UIView animateWithDuration:0.5 animations:^{
            scroller.contentOffset = CGPointMake(scroller.contentOffset.x, scroller.contentOffset.y+70);
        }];
    else
        scroller.contentOffset = CGPointMake(scroller.contentOffset.x, scroller.contentOffset.y+70);
}
-(void)setScrollWithBounce:(BOOL)scrollWithBounce{scroller.bounces = scrollWithBounce;}
-(void)setScrollable:(BOOL)scrollable{if (!scrollable) scroller.contentSize = CGSizeMake(0,0);}
-(void)setDelegate:(id<DCTableViewDelegate>)delegate{ _delegate = delegate; scroller.delegate = self; }
-(void)setContentSize:(CGSize)contentSize{scroller.contentSize = contentSize;}
-(void)setContentOffset:(CGPoint)contentOffset{scroller.contentOffset = contentOffset;}
-(CGSize)contentSize{return scroller.contentSize;}
-(CGPoint)contentOffset{return scroller.contentOffset;}
-(BOOL)scrollWithBounce{return scroller.bounces;}
@end
