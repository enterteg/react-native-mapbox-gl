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
    RCTMapboxAnnotation *marker = [[RCTMapboxAnnotation alloc] init];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
//    // setting this to NO allows the parent MapView to continue receiving marker selection events
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    [marker addGestureRecognizer:tapGestureRecognizer];
    marker.bridge = self.bridge;
    marker.coordinate = kCLLocationCoordinate2DInvalid;
    return marker;
}

RCT_EXPORT_VIEW_PROPERTY(id, NSString)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(subtitle, NSString)

RCT_CUSTOM_VIEW_PROPERTY(coordinate, CLLocationCoordinate2D, RCTMapboxAnnotation)
{
    if (!CLLocationCoordinate2DIsValid(view.coordinate)) {
        // This is the first time this property gets set
        view.coordinate = [RCTConvert CLLocationCoordinate2D:json];
    }
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


@end
