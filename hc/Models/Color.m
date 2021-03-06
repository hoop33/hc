//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

@import AppKit;

#import <math.h>
#import "Color.h"

typedef float (^BlendModeBlock)(float backdrop, float source);

NSString *const kDefaultHexCode = @"#000000";
const int kHexCodeLength = 7;
const int kDegreesCharacterCode = 176;
const int kDegreesInCircle = 360;
const float kEpsilon = 0.0000000001f;
const float kRGBDivisor = 255.0f;

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
  return [self spin:kDegreesInCircle / 2];
}

- (Color *)spin:(int)degrees {
  int spinDegrees = degrees % kDegreesInCircle;
  if (spinDegrees < 0) spinDegrees += kDegreesInCircle;
  int hue = _hue + spinDegrees;
  if (hue >= kDegreesInCircle) {
    hue -= kDegreesInCircle;
  }
  return [[Color alloc] initWithHSL:hue
                         saturation:_saturation
                          lightness:_lightness];
}

- (Color *)lighten:(int)percent {
  return [[Color alloc] initWithHSL:_hue
                         saturation:_saturation
                          lightness:MAX(0, MIN(100, _lightness + percent))];
}

- (Color *)darken:(int)percent {
  return [self lighten:-percent];
}

- (Color *)saturate:(int)percent {
  return [[Color alloc] initWithHSL:_hue
                         saturation:MAX(0, MIN(100, _saturation + percent))
                          lightness:_lightness];
}

- (Color *)desaturate:(int)percent {
  return [self saturate:-percent];
}

- (Color *)grayscale {
  return [self desaturate:100];
}

- (Color *)mix:(Color *)color weight:(int)weight {
  float percent1 = weight / 100.0f;
  float percent2 = 1.0f - percent1;

  return [[Color alloc] initWithRGB:(int)((_red * percent1) + (color.red * percent2))
                              green:(int)((_green * percent1) + (color.green * percent2))
                               blue:(int)((_blue * percent1) + (color.blue * percent2))];
}

- (Color *)multiply:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return (backdrop * source);
  }];
}

- (Color *)screen:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return ((backdrop + source) - (backdrop * source));
  }];
}

- (Color *)overlay:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    backdrop *= 2;
    return backdrop <= 1 ? backdrop * source :
    ((backdrop - 1 + source) - ((backdrop - 1) * source));
  }];
}

- (Color *)softlight:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    float tmp1 = 1.0f;
    float tmp2 = backdrop;
    if (source > 0.5f) {
      tmp2 = 1.0f;
      tmp1 = backdrop > 0.25f ?
      (float)(sqrt(backdrop)) :
      ((16 * backdrop - 12) * backdrop + 4) * backdrop;
    }
    return backdrop - (1 - 2 * source) * tmp2 * (tmp1 - backdrop);
  }];
}

- (Color *)hardlight:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    source *= 2;
    return source <= 1 ? source * backdrop :
    ((source - 1 + backdrop) - ((source - 1) * backdrop));
  }];
}

- (Color *)difference:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return fabsf(backdrop - source);
  }];
}

- (Color *)exclusion:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return (backdrop + source) - (2 * backdrop * source);
  }];
}

- (Color *)average:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return (backdrop + source) / 2;
  }];
}

- (Color *)negation:(Color *)color {
  return [self blend:color blendMode:(BlendModeBlock) ^(float backdrop, float source) {
    return 1 - fabsf(backdrop + source - 1);
  }];
}

- (NSImage *)asImage:(CGSize)size {
  NSRect rect = NSRectFromCGRect(CGRectMake(0.0f,
    0.0f,
    size.width,
    size.height));
  NSImage *image = [[NSImage alloc] initWithSize:size];
  [image lockFocus];
  [[NSColor colorWithDeviceRed:(_red / kRGBDivisor)
                         green:(_green / kRGBDivisor)
                          blue:(_blue / kRGBDivisor)
                         alpha:1.0f] set];
  NSRectFill(rect);
  [image unlockFocus];
  return image;
}

#pragma mark - Private methods

- (Color *)blend:(Color *)color blendMode:(BlendModeBlock)blendMode {
  int red = (int)(blendMode(_red / kRGBDivisor, color.red / kRGBDivisor) * kRGBDivisor);
  int green = (int)(blendMode(_green / kRGBDivisor, color.green / kRGBDivisor) * kRGBDivisor);
  int blue = (int)(blendMode(_blue / kRGBDivisor, color.blue / kRGBDivisor) * kRGBDivisor);
  return [[Color alloc] initWithRGB:red
                              green:green
                               blue:blue];
}

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
  // Adapted from rapidtables.com.
  // At least some results are off by one from LESS's.
  // LESS uses algorithm from easyrgb.com
  // I tried that one, and get off-by-one errors from LESS's results anyway,
  // I assume due to rounding.
  // I tried adding one to red, green, and blue, e.g.:
  //   _red = MIN(255, ((red + m) * 255) + 1);
  // And then I matched the LESS results. But then got off-by-ones in other places.
  float lightness = _lightness / 100.0f;
  float saturation = _saturation / 100.0f;
  float c = (1 - ABS((2 * lightness) - 1)) * saturation;
  float x = c * (1 - ABS(fmodf((_hue / 60.0f), 2.0f) - 1));
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

  _red = (int)((red + m) * 255);
  _green = (int)((green + m) * 255);
  _blue = (int)((blue + m) * 255);
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
  float red = _red / kRGBDivisor;
  float green = _green / kRGBDivisor;
  float blue = _blue / kRGBDivisor;

  float minValue = MIN(red, MIN(green, blue));
  float maxValue = MAX(red, MAX(green, blue));
  float range = maxValue - minValue;

  _lightness = (int)((maxValue + minValue) / 0.02f);

  if (range == 0.0f) {
    _hue = 0;
    _saturation = 0;
  } else {
    _saturation = (int)(100 * ((_lightness < 50) ?
      range / (maxValue + minValue) :
      range / (2 - maxValue - minValue)));

    if (fabs(red - maxValue) < kEpsilon) {
      _hue = (int)(60 * fmodf(((green - blue) / range), 6));
    } else if (fabs(green - maxValue) < kEpsilon) {
      _hue = (int)(60 * (((blue - red) / range) + 2));
    } else {
      _hue = (int)(60 * (((red - green) / range) + 4));
    }
  }
  if (_hue < 0) _hue += kDegreesInCircle;
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
