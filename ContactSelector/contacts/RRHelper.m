//
//  RRHelper.m
//  RoundRobin
//
//  Created by kmd on 7/19/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import "RRHelper.h"
@implementation RRHelper
+ (UIImage *) resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIColor*) navigationBarBackgroundColor {
    return [UIColor colorWithHexString:@"#f6f6f6"];
}
+(UIColor*) darkGrey {
    return [UIColor colorWithHexString:@"#575757"];
}
+(UIColor*) mediumGrey {
    return [UIColor colorWithHexString:@"#959595"];
}
+(UIColor*) lightGrey {
    return [UIColor colorWithHexString:@"#cccccc"];
}
+(UIColor*) appBlue {
    return [UIColor colorWithHexString:@"#4bb5c1"];
}
+(BOOL)isKeyValidInPlist:(NSString*) key {
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:key]) {
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:key] length] > 0) {
            return YES;
        }
    }
    return NO;
}
+(void) permissionForAccessingAddressbook:(RRCallback) callback {
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:{
            callback(NO, nil);
        }
        case kABAuthorizationStatusAuthorized:
            callback(YES, nil);
        default:{
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                if (!granted){
                    callback(NO, nil);
                } else {
                    callback(YES, nil);
                }
            });
        }
    }
}
@end
