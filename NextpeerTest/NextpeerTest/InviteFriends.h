//
//  InviteFriends.h
//  iFingerErase
//
//  Created by He jia bin on 7/9/12.
//  Copyright (c) 2012 CoconutIslandStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriends : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    //TODO 
}

@property (nonatomic, retain) IBOutlet UITableView* _tableView;

@property (nonatomic, retain) NSArray* _friendList;


- (IBAction)onBack:(id)sender;

@end
