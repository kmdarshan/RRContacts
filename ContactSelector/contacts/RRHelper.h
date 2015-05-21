//
//  RRHelper.h
//  RoundRobin
//
//  Created by kmd on 7/19/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor_categories.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RRContact.h"
typedef void(^RRCallback)(BOOL success, id result);
typedef enum {
    kRRContactTypeFacebook = 0,
    kRRContactTypeAddressBook = 1,
    kRRContactTypeEmail = 2,
    kRRContactTypeDummy
} RRContactType;

#pragma mark - font
static NSString *kFontRegular = @"Arimo";
static NSInteger kMainViewPaddingX  = 8.0;
static CGFloat kFontNormalSize = 18.0f;
static CGFloat kFontSizeListingTextLabel = 16.0f;
static CGFloat kFontSizeListingDetailedTextLabel = 12.0f;

#pragma mark - height
static NSInteger kRowHeight = 55;
static NSInteger kRowHeightEventDescriptionCell = 205;

#pragma mark - notifications
static NSString *RRNotificationSelectFriends = @"com.redflower.addFriendsViewController.friends";

#pragma mark - names
static NSString *kAddEvent = @"ADD EVENT";
static NSString *kAddFriends = @"Friends";
static NSString *kInviteByEmail = @"INVITE BY EMAIL";

#pragma mark - keys
static NSString *kFacebookID = @"FacebookAppID";

@interface RRHelper : NSObject
+(UIImage*) resizeImage:(UIImage *)image toSize:(CGSize)size;
+(UIColor*) appBlue;
+(UIColor*) lightGrey;
+(UIColor*) mediumGrey;
+(UIColor*) darkGrey;
+(BOOL)isKeyValidInPlist:(NSString*) key;
+(void) permissionForAccessingAddressbook:(RRCallback) callback;
+(NSMutableArray*) contactsFromAddressBook;
@end
