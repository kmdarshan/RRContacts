//
//  RRAddFriendsViewController.m
//  RoundRobin
//
//  Created by Darshan Katrumane on 11/25/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import "RRContactsViewController.h"
#import "RRTextField.h"
#import "RRContact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+AFNetworking.h"
#import "RRContactTableViewCell.h"
static CGSize keyboardRect;
@interface RRContactsViewController ()
{
    RRTextField* addEmailTextfield;
    UITableView* friendsTableview;
    UIView *alphaScreen;
}
@end

@implementation RRContactsViewController

#pragma mark Views
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.title = kAddEvent;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // trying out group dispatch, if this would work
    if (![self.friends count]>0) {
//        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_group_t group = dispatch_group_create();
//        __weak __typeof(self) weakSelf = self;
//        dispatch_group_async(group, globalQueue, ^{
//            [weakSelf callFacebook];
//        });
//        dispatch_group_async(group, globalQueue, ^{
//            [weakSelf callAddressBook];
//        });
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        NSLog(@"finished up group dispatch");
        [self callAddressBook];
        [self callFacebook];
    }
}

#pragma mark - setup
-(void) setup {
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = kAddFriends;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    topBorder.backgroundColor = [RRHelper lightGrey].CGColor;
    [backgroundView.layer addSublayer:topBorder];
    [backgroundView setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    [self.view addSubview:backgroundView];

    UIView *handleTextfields = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width-(self.view.frame.size.width * 0.05), 50)];
    [handleTextfields setCenter:CGPointMake(backgroundView.center.x, backgroundView.frame.size.height/2.0f)];
    [backgroundView addSubview:handleTextfields];

    addEmailTextfield = [[RRTextField alloc] initWithFrame:CGRectMake(0, 0, handleTextfields.frame.size.width*0.80, 40)];
    [addEmailTextfield setPadding:10.0f];
    [addEmailTextfield setDelegate:self];
    [addEmailTextfield setPlaceholder:kInviteByEmail];
    [addEmailTextfield setFrame:CGRectMake(0, 0, handleTextfields.frame.size.width, 40)];
    [addEmailTextfield setCenter:CGPointMake(addEmailTextfield.center.x, handleTextfields.frame.size.height/2.0f)];
    addEmailTextfield.returnKeyType = UIReturnKeyDone;
    [addEmailTextfield setBorderStyle:UITextBorderStyleRoundedRect];
    [handleTextfields addSubview:addEmailTextfield];
    
    alphaScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - handleTextfields.frame.size.height)];
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [alphaScreen addGestureRecognizer:dismissKeyboard];
    [alphaScreen setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:alphaScreen];
    
    friendsTableview = [[UITableView alloc] initWithFrame:CGRectMake(kMainViewPaddingX , self.view.frame.origin.y, self.view.frame.size.width - (kMainViewPaddingX *2), alphaScreen.frame.size.height) style:UITableViewStylePlain];
    [friendsTableview setDelegate:self];
    [friendsTableview setDataSource:self];
    [self.view insertSubview:friendsTableview aboveSubview:alphaScreen];
    friendsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.friends = [NSMutableArray new];
}

#pragma mark - text field
-(void) addEmail:(UITapGestureRecognizer*) recognizer {
    if ([[addEmailTextfield text] length] > 0) {
        RRContact *contact = [RRContact new];
        [contact setEmail:[addEmailTextfield text]];
        [contact setSelected:YES];
        [contact setType:kRRContactTypeEmail];
        [self.friends insertObject:contact atIndex:1];
        [friendsTableview reloadData];
        NSMutableArray *friendsArray = [self.friends mutableCopy];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:friendsArray forKey:@"friends"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RRNotificationSelectFriends object:self userInfo:userInfo];
    }
}

#pragma mark - Contacts
-(void) loadFacebookfriends:(RRCallback) callback {
    if (!FBSession.activeSession.isOpen) {
        __weak __typeof(self) weakSelf = self;
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              callback(NO, nil);
                                          } else if (session.isOpen) {
                                              [weakSelf loadFacebookfriends:^(BOOL success, id result) {
                                                  if (success) {
                                                      callback(YES, nil);
                                                  } else {
                                                      callback(NO, nil);
                                                  }
                                              }];
                                          }
                                      }];
    }else{
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        __weak __typeof(self) weakSelf = self;
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
            if (error) {
                callback(NO, @"session is open but error getting friends");
            }else{
                // need to change this into a set for quicker access
                NSArray* friends = [result objectForKey:@"data"];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    if ([weakSelf isContactPresent:[friend objectID]] == NO) {
                        RRContact* contact = [[RRContact alloc] init];
                        [contact setType:kRRContactTypeFacebook];
                        [contact setFacebookId:[friend objectID]];
                        [contact setName:[NSString stringWithFormat:@"%@", [friend name]]];
                        [contact setSelected:NO];
                        [weakSelf.friends addObject:contact];
                    }
                }
                callback(YES, nil);
            }
        }];
    }
}
-(BOOL) isContactPresent:(NSString*) objectId {
    for (RRContact *contact in self.friends) {
        if ([contact type] == kRRContactTypeFacebook) {
            if ([[[contact facebookId] lowercaseString] isEqualToString:[objectId lowercaseString]]) {
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - sorting 
-(void) sortFriends {
    [self.friends sortUsingComparator:^ NSComparisonResult(RRContact *contact1, RRContact *contact2) {
        NSString *n1 = [contact1 name];
        NSString *n2 = [contact2 name];
        NSComparisonResult result = [n1 localizedCompare:n2];
        return result;
    }];
}

#pragma mark - Table data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

#pragma mark - Table view cells
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RRContact *contact = [self.friends objectAtIndex:[indexPath row]];
    if ([contact selected] == YES) {
        [contact setSelected:NO];
    } else {
        [contact setSelected:YES];
    }
    [self.friends removeObjectAtIndex:[indexPath row]];
    [self.friends insertObject:contact atIndex:[indexPath row]];
    [friendsTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:[indexPath row] inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSMutableArray *friendsArray = [self.friends mutableCopy];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:friendsArray forKey:@"friends"];
    [[NSNotificationCenter defaultCenter] postNotificationName:RRNotificationSelectFriends object:self userInfo:userInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RRContactTableViewCell class])];
    if (!cell) {
        cell = [[RRContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([RRContactTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setupCell:(RRContactTableViewCell*)cell forIndexPath:indexPath];
}
#pragma mark - keyboard helpers
-(void) dismissKeyboard {
    [self.view sendSubviewToBack:alphaScreen];
    [addEmailTextfield resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view sendSubviewToBack:alphaScreen];
    [addEmailTextfield resignFirstResponder];
    
    if ([[addEmailTextfield text] length] > 0) {
        RRContact *contact = [RRContact new];
        [contact setEmail:[addEmailTextfield text]];
        [contact setSelected:YES];
        [contact setType:kRRContactTypeEmail];
        [self.friends insertObject:contact atIndex:1];
        [friendsTableview reloadData];
        NSMutableArray *friendsArray = [self.friends mutableCopy];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:friendsArray forKey:@"friends"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RRNotificationSelectFriends object:self userInfo:userInfo];
        [self performSelector:@selector(animateEmailCell) withObject:nil afterDelay:0.5f];
    }
    return YES;
}
-(void)animateEmailCell {
    UITableViewCell *cell = [friendsTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [UIView animateWithDuration:0.5f animations:^{
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }];
}
-(void)keyboardWillShow:(NSNotification*) notification {
    [self.view bringSubviewToFront:alphaScreen];
    NSDictionary* keyboardInfo = [notification userInfo];
    keyboardRect = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= keyboardRect.height;
        rect.size.height += keyboardRect.height;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardRect.height;
        rect.size.height -= keyboardRect.height;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark - Helpers
-(void) callFacebook {
    if([RRHelper isKeyValidInPlist:kFacebookID]) {
        // facebookID present, load friends from facebook
        __block UITableView *blockFriendsTableView = friendsTableview;
        __weak __typeof(self) weakSelf = self;
        [self loadFacebookfriends:^(BOOL success, id result) {
            if (success) {
                [weakSelf sortFriends];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blockFriendsTableView reloadData];
                });
            } else {
                NSLog(@"error loading friends from facebook");
            }
        }];
    } else
    {
        // show error
        [self showError:@"You need to add the key FacebookID in your plist."];
    }
}
-(void) callAddressBook {
    __block UITableView *blockFriendsTableView = friendsTableview;
    __weak __typeof(self) weakSelf = self;
    [RRHelper permissionForAccessingAddressbook:^(BOOL success, id result) {
        if (success) {
            // load contacts from address book
            weakSelf.friends = [[RRHelper contactsFromAddressBook] mutableCopy];
            [weakSelf sortFriends];
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockFriendsTableView reloadData];
            });
        } else
        {
            [weakSelf showError:@"You must give the app permission to add the contact first."];
        }
    }];
}
-(void) setupCell:(RRContactTableViewCell*) cell forIndexPath:(NSIndexPath*) indexPath {
    
    RRContact *contact = [self.friends objectAtIndex:[indexPath row]];
    if ([contact selected] == YES) {
        UIImageView *selectedImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        [selectedImageview setFrame:CGRectMake(0, 0, 24, 19)];
        cell.accessoryView = selectedImageview;
    } else {
        UIImageView *selectedImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unselected"]];
        [selectedImageview setFrame:CGRectMake(0, 0, 24, 19)];
        cell.accessoryView = selectedImageview;
    }
    
    cell.imageView.image = [RRHelper resizeImage:[UIImage imageNamed:@"avatar"] toSize:CGSizeMake(42, 35)];
    [[cell textLabel] setFont:[UIFont fontWithName:kFontRegular size:kFontSizeListingTextLabel]];
    [[cell textLabel] setTextColor:[RRHelper darkGrey]];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:kFontRegular size:kFontSizeListingDetailedTextLabel]];
    [[cell detailTextLabel] setTextColor:[RRHelper mediumGrey]];
    
    if ([contact type] == kRRContactTypeEmail) {
        [[cell textLabel] setText:[contact email]];
    } else
        if ([contact type] == kRRContactTypeAddressBook) {
            [[cell textLabel] setText:[contact name]];
            [[cell detailTextLabel] setText:[contact email]];
            if (contact.picture) {
                UIImageView * roundedView = [[UIImageView alloc] initWithImage: contact.picture];
                [roundedView setFrame:CGRectMake(0, 0, kImageSize, kImageSize)];
                CALayer * l = [roundedView layer];
                [l setMasksToBounds:YES];
                [l setCornerRadius:roundedView.frame.size.width / 2.0f];
                [cell.imageView addSubview:roundedView];
            }
        } else
            if ([contact type] == kRRContactTypeFacebook) {
                
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [RRHelper resizeImage:[UIImage imageNamed:@"facebook"] toSize:CGSizeMake(16, 16)];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", [contact name]] attributes:@{ NSFontAttributeName : [UIFont fontWithName:kFontRegular size:15.0f]}];
                [myString appendAttributedString:attachmentString];
                cell.textLabel.attributedText = myString;
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=50&height=50", [contact facebookId]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
                __weak UITableViewCell *blockCell = cell;
                [cell.imageView setImageWithURLRequest:request placeholderImage:cell.imageView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIImageView * roundedView = [[UIImageView alloc] initWithImage: image];
                        [roundedView setFrame:CGRectMake(0, 0, kImageSize, kImageSize)];
                        CALayer * l = [roundedView layer];
                        [l setMasksToBounds:YES];
                        [l setCornerRadius:roundedView.frame.size.width / 2.0f];
                        [blockCell.imageView addSubview:roundedView];
                        
                    });
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"not able to download images");
                }];
                
            } if ([contact type] == kRRContactTypeDummy) {
                cell.textLabel.text = @"";
            }
}

-(void) showError:(NSString*) message {
    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Please take note" message: message delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [cantAddContactAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
