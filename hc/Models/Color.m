//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "Color.h"

#define kDefaultHexCode @"#000000"
#define kHexCodeLength 7
#define kDegreesCharacterCode 176
#define kDegreesInCircle 360

@implementation Color

- (instancetype)initWithHexCode:(NSString *)hexCode {
  self = [super init];
  if (self != nil) {
    _hexCode = hexCode;
    [self normalizeHexCode];
    [self calculateRGBFromHex];
    [self calculateHSLFromRGB];
  }
  return self;
}

- (instancetype)initWithRGB:(int)red
                      green:(int)green
                       blue:(int)blue {
  self = [super init];
  if (self != nil) {
    _red = red;
    _green = green;
    _blue = blue;
    [self normalizeRGB];
    [self calculateHexCodeFromRGB];
    [self calculateHSLFromRGB];
  }
  return self;
}

- (instancetype)initWithHSL:(int)hue
                 saturation:(int)saturation
                  lightness:(int)lightness {
  self = [super init];
  if (self != nil) {
    _hue = hue;
    _saturation = saturation;
    _lightness = lightness;
    [self normalizeHSL];
    [self calculateRGBFromHSL];
    [self calculateHexCodeFromRGB];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"hex: %@\nrgb: %d, %d, %d\nhsl: %d%c, %d%%, %d%%",
                                    _hexCode,
                                    _red,
                                    _green,
                                    _blue,
                                    _hue,
      kDegreesCharacterCode,
                                    _saturation,
                                    _lightness];
}

- (Color *)complement {
  int hue = _hue + (kDegreesInCircle / 2);
  if (hue >= kDegreesInCircle) {
    hue -= kDegreesInCircle;
  }
  return [[Color alloc] initWithHSL:hue
                         saturation:_saturation
                          lightness:_lightness];
}

- (Color *)lighten:(int)percent {
  float mult = percent / 100.0;
  return [[Color alloc] initWithRGB:MIN(MAX(0, _red + (_red * mult)), 255)
                              green:MIN(MAX(0, _green + (_green * mult)), 255)
                               blue:MIN(MAX(0, _blue + (_blue * mult)), 255)];
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
  if (_red < 0 || _red > 255 ||
    _green < 0 || _green > 255 ||
    _blue < 0 || _blue > 255) {
    _hexCode = kDefaultHexCode;
    [self calculateRGBFromHex];
  }
}

- (void)normalizeHSL {
  if (_hue < 0 || _hue > 359 ||
    _saturation < 0 || _saturation > 100 ||
    _lightness < 0 || _lightness > 100) {
    _hexCode = kDefaultHexCode;
    [self calculateRGBFromHex];
    [self calculateHSLFromRGB];
  }
}

- (void)calculateRGBFromHex {
  uint rgb = 0;
  NSScanner *scanner = [NSScanner scannerWithString:[_hexCode substringFromIndex:1]];
  [scanner scanHexInt:&rgb];

  _red = ((rgb & 0xFF0000) >> 16);
  _green = ((rgb & 0x00FF00) >> 8);
  _blue = (rgb & 0x0000FF);
}

- (void)calculateRGBFromHSL {
  float lightness = _lightness / 100.0f;
  float saturation = _saturation / 100.0f;
  float c = (1 - ABS((2 * lightness) - 1)) * saturation;
  float x = c * (1 - ABS(fmodf((_hue / 60), 2) - 1));
  float m = lightness - (c / 2);
  float red, green, blue;
  if (_hue < 60) {
    red = c;
    green = x;
    blue = 0;
  } else if (_hue < 120) {
    red = x;
    green = c;
    blue = 0;
  } else if (_hue < 180) {
    red = 0;
    green = c;
    blue = x;
  } else if (_hue < 240) {
    red = 0;
    green = x;
    blue = c;
  } else if (_hue < 300) {
    red = x;
    green = 0;
    blue = c;
  } else {
    red = c;
    green = 0;
    blue = x;
  }

  _red = (red + m) * 255;
  _green = (green + m) * 255;
  _blue = (blue + m) * 255;
}

- (void)calculateHexCodeFromRGB {
  NSMutableString *temp = [NSMutableString stringWithCapacity:kHexCodeLength];
  [temp appendString:@"#"];

  [temp appendFormat:@"%02x", _red];
  [temp appendFormat:@"%02x", _green];
  [temp appendFormat:@"%02x", _blue];

  _hexCode = [temp lowercaseString];
}

- (void)calculateHSLFromRGB {
  float red = _red / 255.0f;
  float green = _green / 255.0f;
  float blue = _blue / 255.0f;

  float minValue = MIN(red, MIN(green, blue));
  float maxValue = MAX(red, MAX(green, blue));
  float range = maxValue - minValue;

  _lightness = (maxValue + minValue) / 0.02f;

  if (range == 0.0f) {
    _hue = 0;
    _saturation = 0;
  } else {
    _saturation = 100 * ((_lightness < 50) ?
      range / (maxValue + minValue) :
      range / (2 - maxValue - minValue));

    if (red == maxValue) {
      _hue = 60 * fmodf(((green - blue) / range), 6);
    } else if (green == maxValue) {
      _hue = 60 * (((blue - red) / range) + 2);
    } else {
      _hue = 60 * (((red - green) / range) + 4);
    }
  }
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