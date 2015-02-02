//
//  RRHelper.h
//  RoundRobin
//
//  Created by kmd on 7/19/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor_categories.h"
typedef void(^RRCallback)(BOOL success, id result);

#pragma mark - font
static NSString *kFontBold = @"Arimo-Bold";
static NSString *kFontBoldItalic = @"Arimo-BoldItalic";
static NSString *kFontItalic = @"Arimo-Italic";
static NSString *kFontRegular = @"Arimo";
static NSInteger mainViewPaddingX = 8.0;
static NSInteger mainViewPaddingY = 8.0;
static NSInteger kStatusBarHeight = 40;
static CGFloat kFontNormalSize = 18.0f;
static CGFloat kFontNavigationBarSize = 18.0f;
static CGFloat kFontSmallSize = 12.0f;
static CGFloat kFontSizeListingTextLabel = 16.0f;
static CGFloat kFontSizeListingDetailedTextLabel = 12.0f;
#pragma mark - height
static NSInteger kRowHeight = 55;
static NSInteger kRowHeightEventDescriptionCell = 205;
#pragma mark - notifications
static NSString *notificationAddFriends = @"com.redflower.addEvents.friends";
static NSString *notificationSelectFriends = @"com.redflower.addEvents.addFriendsViewController";
#pragma mark - names
static NSString *kAddEvent = @"ADD EVENT";
static NSString *kAddFriends = @"Friends";
static NSString *kInviteByEmail = @"INVITE BY EMAIL";
#pragma mark - object names
static NSString *kEventDetails = @"eventDetails";
#pragma mark - verbs
static NSString *kBy = @" By ";
static NSString *kDone = @"DONE";
#pragma mark - paddings
static NSInteger kPaddingEventDetailsTableViewCells = 2.0f;
@interface RRHelper : NSObject
+(UIImage*) resizeImage:(UIImage *)image toSize:(CGSize)size;
+(UIColor*) appBlue;
+(UIColor*) lightGrey;
+(UIColor*) mediumGrey;
+(UIColor*) darkGrey;
+(UIColor*) greenColor;
+(UIColor*) redColor;
@end
