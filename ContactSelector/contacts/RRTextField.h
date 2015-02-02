//
//  RRTextField.h
//  RoundRobin
//
//  Created by Darshan Katrumane on 8/5/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRHelper.h"

@interface RRTextField : UITextField
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic) float padding;
@property (nonatomic) UIColor *placeHolderFontcolor;
@property (nonatomic) UIFont *placeHolderFont;
@property (nonatomic) UIColor *textFontcolor;
@property (nonatomic) UIFont *textFont;
@end
