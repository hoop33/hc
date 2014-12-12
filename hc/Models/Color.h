//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

@property (nonatomic, copy) NSString *hexCode;
@property (nonatomic) int red;
@property (nonatomic) int green;
@property (nonatomic) int blue;
@property (nonatomic) int hue;
@property (nonatomic) int saturation;
@property (nonatomic) int lightness;

- (instancetype)initWithHexCode:(NSString *)hexCode;
- (instancetype)initWithRGB:(int)red green:(int)green blue:(int)blue;
- (instancetype)initWithHSL:(int)hue saturation:(int)saturation lightness:(int)lightness;
- (Color *)lighten:(int)percent;
- (Color *)darken:(int)percent;
- (Color *)complement;
- (Color *)spin:(int)degrees;
- (NSImage *)asImage:(CGSize)size;

@end