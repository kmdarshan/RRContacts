//
//  RRContact.m
//  RoundRobin
//
//  Created by Darshan Katrumane on 8/19/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import "RRContact.h"

@implementation RRContact

#pragma mark - Encoding/Decoding

NSString *const EmailKey = @"NameKey";
NSString *const FacebookIDKey = @"FacebookIDKey";
NSString *const NameKey = @"YearKey";
NSString *const NumberKey = @"NumberKey";
NSString *const TypeKey = @"TypeKey";
NSString *const SelectedKey = @"SelectedKey";
NSString *const PictureKey = @"PictureKey";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _email = [aDecoder decodeObjectForKey:EmailKey];
        _facebookId = [aDecoder decodeObjectForKey:FacebookIDKey];
        _name = [aDecoder decodeObjectForKey:NameKey];
        _number = [aDecoder decodeObjectForKey:NumberKey];
        _picture = [aDecoder decodeObjectForKey:PictureKey];
        _selected = [aDecoder decodeBoolForKey:SelectedKey];
        _type = [aDecoder decodeIntForKey:TypeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.email forKey:EmailKey];
    [aCoder encodeObject:self.facebookId forKey:FacebookIDKey];
    [aCoder encodeObject:self.name forKey:NameKey];
    [aCoder encodeObject:self.number forKey:NumberKey];
    [aCoder encodeObject:self.picture forKey:PictureKey];
    [aCoder encodeBool:self.selected forKey:SelectedKey];
    [aCoder encodeInt:self.type forKey:TypeKey];
}
@end
