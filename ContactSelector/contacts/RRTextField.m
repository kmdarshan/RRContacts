//
//  RRTextField.m
//  RoundRobin
//
//  Created by Darshan Katrumane on 8/5/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import "RRTextField.h"
@interface RRTextField () {
    CGFloat placeHolderPadding;
}
@end

@implementation RRTextField

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.padding = 0;
        self.placeHolderFont = [UIFont fontWithName:kFontRegular size:kFontNormalSize];
        self.placeHolderFontcolor = [RRHelper lightGrey];
        self.textFontcolor = [RRHelper darkGrey];
        self.textFont = [UIFont fontWithName:kFontRegular size:kFontNormalSize];
        
        self.adjustsFontSizeToFitWidth = YES;
        self.textColor = [RRHelper darkGrey];
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.returnKeyType = UIReturnKeyDone;
        self.enabled = YES;
        self.font = [UIFont fontWithName:kFontRegular size:kFontNormalSize];
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect {
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2, rect.size.width, kRowHeight);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.textFont, NSFontAttributeName, self.textFontcolor, NSForegroundColorAttributeName, nil];
    [self.text drawInRect:placeholderRect withAttributes:attr];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += self.padding;
    return bounds;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2, rect.size.width, kRowHeight);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.placeHolderFont, NSFontAttributeName, self.placeHolderFontcolor, NSForegroundColorAttributeName, nil];
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
}

- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x = textRect.origin.x + kMainViewPaddingX  + 10;
    return textRect;
}
@end
