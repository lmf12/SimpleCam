//
//  SCVisualEffectView.m
//  SimpleCam
//
//  Created by Lyman on 2019/6/1.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCVisualEffectView.h"

@interface SCVisualEffectView ()

@property (strong, nonatomic) UIBlurEffect *blurEffect;

@end

@implementation SCVisualEffectView

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scale = 1.0;
}

- (UIBlurEffect *)blurEffect {
    if (_blurEffect == nil) {
        NSString *className = [@[@"_", @"U", @"I", @"C", @"u", @"s", @"t", @"o", @"m", @"B", @"l", @"u", @"r", @"E", @"f", @"f", @"e", @"c", @"t"] componentsJoinedByString:@""];
        _blurEffect = [[NSClassFromString(className) alloc] init];
    }
    return _blurEffect;
}

#pragma mark - Properties

- (CGFloat)grayscaleTintLevel {
    return [[self blurValueForSelector:@selector(grayscaleTintLevel)] doubleValue];
}

- (void)setGrayscaleTintLevel:(CGFloat)grayscaleTintLevel {
    [self setBlurValue:@(grayscaleTintLevel) forSelector:@selector(grayscaleTintLevel)];
}

- (CGFloat)grayscaleTintAlpha {
    return [[self blurValueForSelector:@selector(grayscaleTintAlpha)] doubleValue];
}

- (void)setGrayscaleTintAlpha:(CGFloat)grayscaleTintAlpha {
    [self setBlurValue:@(grayscaleTintAlpha) forSelector:@selector(grayscaleTintAlpha)];
}

- (BOOL)lightenGrayscaleWithSourceOver {
    return [[self blurValueForSelector:@selector(lightenGrayscaleWithSourceOver)] boolValue];
}

- (void)setLightenGrayscaleWithSourceOver:(BOOL)lightenGrayscaleWithSourceOver {
    [self setBlurValue:@(lightenGrayscaleWithSourceOver) forSelector:@selector(lightenGrayscaleWithSourceOver)];
}

- (UIColor *)colorTint {
    return [self blurValueForSelector:@selector(colorTint)] ;
}

- (void)setColorTint:(UIColor *)colorTint {
    [self setBlurValue:colorTint forSelector:@selector(colorTint)];
}

- (CGFloat)colorTintAlpha {
    return [[self blurValueForSelector:@selector(colorTintAlpha)] doubleValue];
}

- (void)setColorTintAlpha:(CGFloat)colorTintAlpha {
    [self setBlurValue:@(colorTintAlpha) forSelector:@selector(colorTintAlpha)];
}

- (CGFloat)colorBurnTintLevel {
    return [[self blurValueForSelector:@selector(colorBurnTintLevel)] doubleValue];
}

- (void)setColorBurnTintLevel:(CGFloat)colorBurnTintLevel {
    [self setBlurValue:@(colorBurnTintLevel) forSelector:@selector(colorBurnTintLevel)];
}

- (CGFloat)colorBurnTintAlpha {
    return [[self blurValueForSelector:@selector(colorBurnTintAlpha)] doubleValue];
}

- (void)setColorBurnTintAlpha:(CGFloat)colorBurnTintAlpha {
    [self setBlurValue:@(colorBurnTintAlpha) forSelector:@selector(colorBurnTintAlpha)];
}

- (CGFloat)darkeningTintAlpha {
    return [[self blurValueForSelector:@selector(darkeningTintAlpha)] doubleValue];
}

- (void)setDarkeningTintAlpha:(CGFloat)darkeningTintAlpha {
    [self setBlurValue:@(darkeningTintAlpha) forSelector:@selector(darkeningTintAlpha)];
}

- (CGFloat)darkeningTintHue {
    return [[self blurValueForSelector:@selector(darkeningTintHue)] doubleValue];
}

- (void)setDarkeningTintHue:(CGFloat)darkeningTintHue {
    [self setBlurValue:@(darkeningTintHue) forSelector:@selector(darkeningTintHue)];
}

- (CGFloat)darkeningTintSaturation {
    return [[self blurValueForSelector:@selector(darkeningTintSaturation)] doubleValue];
}

- (void)setDarkeningTintSaturation:(CGFloat)darkeningTintSaturation {
    [self setBlurValue:@(darkeningTintSaturation) forSelector:@selector(darkeningTintSaturation)];
}

- (BOOL)darkenWithSourceOver {
    return [[self blurValueForSelector:@selector(darkenWithSourceOver)] boolValue];
}

- (void)setDarkenWithSourceOver:(BOOL)darkenWithSourceOver {
    [self setBlurValue:@(darkenWithSourceOver) forSelector:@selector(darkenWithSourceOver)];
}

- (CGFloat)blurRadius {
    return [[self blurValueForSelector:@selector(blurRadius)] doubleValue];
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    [self setBlurValue:@(blurRadius) forSelector:@selector(blurRadius)];
}

- (CGFloat)saturationDeltaFactor {
    return [[self blurValueForSelector:@selector(saturationDeltaFactor)] doubleValue];
}

- (void)setSaturationDeltaFactor:(CGFloat)saturationDeltaFactor {
    [self setBlurValue:@(saturationDeltaFactor) forSelector:@selector(saturationDeltaFactor)];
}

- (CGFloat)scale {
    return [[self blurValueForSelector:@selector(scale)] doubleValue];
}

- (void)setScale:(CGFloat)scale {
    [self setBlurValue:@(scale) forSelector:@selector(scale)];
}

- (CGFloat)zoom {
    return [[self blurValueForSelector:@selector(zoom)] doubleValue];
}

- (void)setZoom:(CGFloat)zoom {
    [self setBlurValue:@(zoom) forSelector:@selector(zoom)];
}

#pragma mark - Private

- (id)blurValueForSelector:(SEL)selector {
    return [self.blurEffect valueForKeyPath:NSStringFromSelector(selector)];
}

- (void)setBlurValue:(id)value forSelector:(SEL)selector {
    [self.blurEffect setValue:value forKeyPath:NSStringFromSelector(selector)];
    self.effect = self.blurEffect;
}

@end
