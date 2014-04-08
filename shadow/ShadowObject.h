//
//  ShadowObject.h
//  shadow
//
//  Created by kongfy on 14-4-3.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class CMAttitude;

typedef struct {
    double x, y, z;     // 方向向量<x, y, z>，以 CMAttitudeReferenceFrameXTrueNorthZVertical 作为refrence frame
    double d;           // 距离，double值，单位米(m)
} ObjectVector;

@interface ShadowObject : NSObject

@property (nonatomic) ObjectVector vector;
@property (strong, nonatomic) UIView *shadowView;   // 图层

- (ObjectVector)multiplyByRotationMatrix:(CMRotationMatrix)rotationMatrix;

- (id)initWithVector:(ObjectVector)vector;
- (id)initWithDistance:(double)d X:(double)x Y:(double)y Z:(double)z;

@end
