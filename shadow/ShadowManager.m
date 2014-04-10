//
//  ShadowManager.m
//  shadow
//
//  Created by kongfy on 14-4-10.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowManager.h"

@implementation ShadowManager

#define FOV_HORIZONAL_RADIANS 1.0716
#define FOV_VERTICAL_RADIANS 0.8377

+ (double)FOVHorizonal
{
    return FOV_HORIZONAL_RADIANS;
}

+ (double)FOVVertical
{
    return FOV_VERTICAL_RADIANS;
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
    point.x = atan(vector.x / z) / ([self FOVHorizonal] / 2) * rect.size.width + center.x;
    point.y = -(atan(vector.y / z) / ([self FOVVertical] / 2) * rect.size.height) + center.y;
    
    return point;
}

@end
