//
//  ChallengeCellView.m
//  iFingerErase
//
//  Created by He jia bin on 6/21/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import "ChallengeCellView.h"
#import "GlobalWork.h"


@implementation ChallengeCellView


@synthesize _imgChallenger;
@synthesize _txtInfo;


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