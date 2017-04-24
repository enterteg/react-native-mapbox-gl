/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTMapboxAnnotation.h"

#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>
#import <React/RCTBridge.h>
#import <React/RCTUtils.h>


@interface RCTMapboxAnnotation ()

@property (nonatomic, readwrite) CATransform3D lastAppliedRotateTransform;

@end

@implementation RCTMapboxAnnotation

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _lastAppliedRotateTransform = CATransform3DIdentity;
        _rotatesToMatchCamera = NO;
    }
    return self;
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self updateRotateTransform];
}

- (UIView *)reactSuperview {
    return self.map;
}

- (void)reactSetFrame:(CGRect)frame {
    // Keep center position when updating view's frame
    CGPoint center = self.center;
    [super reactSetFrame:frame];
    self.center = center;
}

- (void)updateRotateTransform
{
    if (self.rotatesToMatchCamera == NO) return;

    CATransform3D undoOfLastRotateTransform = CATransform3DInvert(_lastAppliedRotateTransform);

    CGFloat directionRad = self.map.direction * M_PI / 180.0;
    CATransform3D newRotateTransform = CATransform3DMakeRotation(-directionRad, 0, 0, 1);
    CATransform3D effectiveTransform = CATransform3DConcat(undoOfLastRotateTransform, newRotateTransform);

    self.layer.transform = CATransform3DConcat(self.layer.transform, effectiveTransform);
    _lastAppliedRotateTransform = newRotateTransform;
}

- (void)setRotatesToMatchCamera:(BOOL)rotatesToMatchCamera
{
    if (_rotatesToMatchCamera != rotatesToMatchCamera) {
        _rotatesToMatchCamera = rotatesToMatchCamera;
        [self updateRotateTransform];
    }
}

@end
