//
//  RRJSONResponseSerializerWithData.h
//  RoundRobin
//
//  Created by kmd on 7/20/14.
//  Copyright (c) 2014 Happy Days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"
/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface RRJSONResponseSerializerWithData : AFJSONResponseSerializer

@end
