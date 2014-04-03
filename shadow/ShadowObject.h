//
//  ShadowObject.h
//  shadow
//
//  Created by kongfy on 14-4-3.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMAttitude;

@interface ShadowObject : NSObject

@property (strong, nonatomic) CMAttitude *attitude; // 方位，以 CMAttitudeReferenceFrameXTrueNorthZVertical 作为refrence frame
@property (strong, nonatomic) NSNumber *distance;   // 距离，double值，单位米(m)
@property (strong, nonatomic) UIView *shadowView;   // 图层

@end
