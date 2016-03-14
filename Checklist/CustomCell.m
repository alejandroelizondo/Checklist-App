//
//  CustomCell.m
//  Checklist
//
//  Created by Alejandro Elizondo on 17/05/15.
//  Copyright (c) 2015 Alejandro Elizondo. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize fromBackground = _fromBackground;
@synthesize toBackground = _toBackground;
@synthesize delivered = _delivered;
@synthesize seen = _seen;
@synthesize title = _title;
@synthesize date = _date;
@synthesize check = _check;
@synthesize alert = _alert;
@synthesize from = _from;
@synthesize to = _to;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
