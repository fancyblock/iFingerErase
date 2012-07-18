//
//  HistoryInfoCellView.m
//  iFingerErase
//
//  Created by He jia bin on 7/18/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "HistoryInfoCellView.h"

@implementation HistoryInfoCellView

@synthesize _time;
@synthesize _title;
@synthesize _result;
@synthesize _background;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
