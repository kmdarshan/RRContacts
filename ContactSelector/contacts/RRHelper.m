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
+(UIColor*) greenColor {
    return [UIColor colorWithHexString:@"#00a651"];
}
+(UIColor*) redColor {
    return [UIColor colorWithHexString:@"#ef3b42"];
}
@end
