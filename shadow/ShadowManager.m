//
//  ShadowManager.m
//  shadow
//
//  Created by kongfy on 14-4-10.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowManager.h"

@implementation ShadowManager

#define FOV_Y_RADIANS 1.0716
#define FOV_X_RADIANS 0.8377

+ (double)FOVonX
{
    return FOV_X_RADIANS;
}

+ (double)FOVonY
{
    return FOV_Y_RADIANS;
}

+ (CGPoint)centerForObjectVector:(ObjectVector)vector inRect:(CGRect)rect
{
    if (vector.z >= 0) {
        return CGPointMake(-1.0f, -1.0f);
    }
    
    CGPoint center = CGPointZero;
    center.x = rect.size.width / 2;
    center.y = rect.size.height / 2;
    
    CGPoint point = CGPointZero;
    double z = fabs(vector.z);
    point.x = atan(vector.x / z) / ([self FOVonX] / 2) * rect.size.width + center.x;
    point.y = -(atan(vector.y / z) / ([self FOVonY] / 2) * rect.size.height) + center.y;
    
    return point;
}

@end
