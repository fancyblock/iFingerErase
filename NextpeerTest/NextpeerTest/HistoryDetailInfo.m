//
//  HistoryDetailInfo.m
//  iFingerErase
//
//  Created by He jia bin on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryDetailInfo.h"


@implementation historyInfo

@synthesize _enemy;
@synthesize _loseTimes;
@synthesize _winTimes;
@synthesize _pendingTimes;
@synthesize _challenger;

@end


@implementation HistoryDetailInfo

@synthesize _txtName;
@synthesize _txtTimes;
@synthesize _btnDetail;
@synthesize _imgProfile;
@synthesize _info;


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


/**
 * @desc    show detail
 * @para    sender
 * @return  none
 */
- (IBAction)onDetail:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopupHistoryDetail" object:self._info userInfo:nil];
}


@end
