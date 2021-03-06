//
//  ViewController.m
//  ContactSelector
//
//  Created by kmd on 2/1/15.
//  Copyright (c) 2015 Happy Days. All rights reserved.
//

#import "ViewController.h"
#import "RRContactsViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

-(void) setup {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 300.0f, 60.0f)];
    [button setCenter:self.view.center];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitle:@"Show contacts" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showContacts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)viewDidAppear:(BOOL)animated {
    [self showContacts];
}
-(void) showContacts {
    RRContactsViewController *addFriendsController = [RRContactsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addFriendsController];
    //[navigationController pushViewController:addFriendsController animated:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
