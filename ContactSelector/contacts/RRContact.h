//
//  RRContact.h
//  RoundRobin
//
//  Created by Darshan Katrumane on 8/19/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    RRContactTypeFacebook = 0,
    RRContactTypeAddressBook = 1,
    RRContactTypeEmail = 2,
    RRContactTypeDummy
} RRContactType;

@interface RRContact : NSObject
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* facebookId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* number;
@property (nonatomic) int type;
@property (nonatomic) BOOL selected;
@property (nonatomic, strong) UIImage* picture;
@end
