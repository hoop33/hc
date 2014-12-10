//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

@property (nonatomic, copy) NSString *hexCode;
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;

- (instancetype)initWithHexCode:(NSString *)hexCode;
- (instancetype)initWithRGB:(float)red green:(float)green blue:(float)blue;
- (Color *)lighten:(int)percent;
- (Color *)darken:(int)percent;

@end