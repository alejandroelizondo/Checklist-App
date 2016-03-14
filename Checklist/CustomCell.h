//
//  CustomCell.h
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title, *date, *from, *to;
@property (nonatomic, strong) IBOutlet UIButton *check;
@property (nonatomic, strong) IBOutlet UIImageView *alert, *fromBackground, *toBackground, *delivered, *seen;

@end
