//
//  RRAddFriendsViewController.h
//  RoundRobin
//
//  Created by Darshan Katrumane on 11/25/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRContactsViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *friends;
@end
