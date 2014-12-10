//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "Color.h"

#define kDefaultHexCode @"#000000"
#define kHexCodeLength 7

@implementation Color

- (instancetype)initWithHexCode:(NSString *)hexCode {
  self = [super init];
  if (self != nil) {
    _hexCode = hexCode;
    [self normalizeHexCode];
    [self calculateRGB];
  }
  return self;
}

- (instancetype)initWithRGB:(float)red green:(float)green blue:(float)blue {
  self = [super init];
  if (self != nil) {
    _red = red;
    _green = green;
    _blue = blue;
    [self normalizeRGB];
    [self calculateHexCode];
  }
  return self;
}

- (Color *)lighten:(int)percent {
  float mult = percent / 100.0;
  Color *color =  [[Color alloc] initWithRGB:MIN(MAX(0, _red + (_red * mult)), 1.0)
                              green:MIN(MAX(0, _green + (_green * mult)), 1.0)
                               blue:MIN(MAX(0, _blue + (_blue * mult)), 1.0)];
  return color;
}

- (Color *)darken:(int)percent {
  return [self lighten:-percent];
}

#pragma mark - Private methods

- (void)normalizeHexCode {
  if (![self isValidHexCode]) {
    _hexCode = kDefaultHexCode;
  }

  NSMutableString *temp = [NSMutableString stringWithCapacity:kHexCodeLength];
  [temp appendString:@"#"];

  NSUInteger start = [_hexCode hasPrefix:@"#"] ? 1 : 0;
  NSUInteger length = [_hexCode length];
  if (length - start == 6) {
    [temp appendString:[_hexCode substringFromIndex:start]];
  } else {
    [temp appendFormat:@"%c%c%c%c%c%c",
                       [_hexCode characterAtIndex:start],
                       [_hexCode characterAtIndex:start],
                       [_hexCode characterAtIndex:start + 1],
                       [_hexCode characterAtIndex:start + 1],
                       [_hexCode characterAtIndex:start + 2],
                       [_hexCode characterAtIndex:start + 2]];
  }
  _hexCode = [temp lowercaseString];
}

- (void)normalizeRGB {
  if (_red < 0.0 || _red > 1.0 ||
    _green < 0.0 || _green > 1.0 ||
    _blue < 0.0 || _blue > 1.0) {
    _hexCode = kDefaultHexCode;
    [self calculateRGB];
  }
}

- (void)calculateRGB {
  uint rgb = 0;
  NSScanner *scanner = [NSScanner scannerWithString:[_hexCode substringFromIndex:1]];
  [scanner scanHexInt:&rgb];

  _red = ((rgb & 0xFF0000) >> 16) / 255.0;
  _green = ((rgb & 0x00FF00) >> 8) / 255.0;
  _blue = (rgb & 0x0000FF) / 255.0;
}

- (void)calculateHexCode {
  NSMutableString *temp = [NSMutableString stringWithCapacity:kHexCodeLength];
  [temp appendString:@"#"];

  [temp appendFormat:@"%02x", (int) (_red * 255.0)];
  [temp appendFormat:@"%02x", (int) (_green * 255.0)];
  [temp appendFormat:@"%02x", (int) (_blue * 255.0)];

  _hexCode = [temp lowercaseString];
}

- (BOOL)isValidHexCode {
  BOOL valid = YES;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^#?[0-9a-f]{3}([0-9a-f]{3})?$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
  if (regex == nil) {
    valid = NO;
  } else {
    NSTextCheckingResult *match = [regex firstMatchInString:_hexCode
                                                    options:0
                                                      range:NSMakeRange(0, [_hexCode length])];
    valid = match != nil;
  }
  return valid;
}

@end