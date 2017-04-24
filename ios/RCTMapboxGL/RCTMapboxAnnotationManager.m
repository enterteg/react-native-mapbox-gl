/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTMapboxAnnotationManager.h"

#import <React/RCTUIManager.h>
#import <React/RCTConvert+CoreLocation.h>
#import <React/UIView+React.h>
#import "RCTMapboxAnnotation.h"

@interface RCTMapboxAnnotationManager () <MGLMapViewDelegate>

@end

@implementation RCTMapboxAnnotationManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RCTMapboxAnnotation *marker = [[RCTMapboxAnnotation alloc] initWithReuseIdentifier:nil];
    marker.reused = YES;
    return marker;
}

RCT_EXPORT_VIEW_PROPERTY(id, NSString)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(subtitle, NSString)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(rotatesToMatchCamera, BOOL)

RCT_CUSTOM_VIEW_PROPERTY(coordinate, CLLocationCoordinate2D, RCTMapboxAnnotation)
{
    // Annotation views that are not visible get set x-offset that is lower than 0 (-10 times the width of the view atm)
    BOOL movedOffScreen = view.frame.origin.x + view.frame.size.width < 0.0;
    if (view.reused || movedOffScreen) {
        // This is the first time this property gets set or the view is outside the visible area in which case we don't want to animate the transition
        view.coordinate = [RCTConvert CLLocationCoordinate2D:json];
        view.reused = NO;
    } else {
        [UIView animateWithDuration:1.0
                              delay:0
                            options:(UIViewAnimationOptionCurveLinear |
                                     UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             view.coordinate = [RCTConvert CLLocationCoordinate2D:json];
                         }
                         completion:NULL];
    }
}


@end
