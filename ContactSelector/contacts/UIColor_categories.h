//
//  UIColor_categories.h
//  RoundRobin
//
//  Created by kmd on 9/27/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIColor(RRCategory)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
