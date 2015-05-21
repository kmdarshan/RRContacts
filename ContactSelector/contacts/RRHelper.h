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
static const NSString *kFontRegular = @"Arimo";
static const NSInteger mainViewPaddingX = 8.0;
static const NSInteger mainViewPaddingY = 8.0;
static const CGFloat kFontNormalSize = 18.0f;
static const CGFloat kFontSizeListingTextLabel = 16.0f;
static const CGFloat kFontSizeListingDetailedTextLabel = 12.0f;
#pragma mark - height
static const NSInteger kRowHeight = 55;
static const NSInteger kRowHeightEventDescriptionCell = 205;
#pragma mark - notifications
static const NSString *notificationAddFriends = @"com.redflower.addEvents.friends";
static const NSString *notificationSelectFriends = @"com.redflower.addEvents.addFriendsViewController";
#pragma mark - names
static const NSString *kAddEvent = @"ADD EVENT";
static const NSString *kAddFriends = @"Friends";
static const NSString *kInviteByEmail = @"INVITE BY EMAIL";
#pragma mark - paddings
@interface RRHelper : NSObject
+(UIImage*) resizeImage:(UIImage *)image toSize:(CGSize)size;
+(UIColor*) appBlue;
+(UIColor*) lightGrey;
+(UIColor*) mediumGrey;
+(UIColor*) darkGrey;
+(UIColor*) greenColor;
+(UIColor*) redColor;
@end
