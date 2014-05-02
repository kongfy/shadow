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

+ (CGPoint)centerForObjectVector:(ObjectVector)vector inRect:(CGRect)rect outBound:(BOOL *)outBound
{
    *outBound = NO;
    
    if (vector.z >= 0) {
        *outBound = YES;
    }
    
    CGPoint center = CGPointZero;
    center.x = rect.size.width / 2;
    center.y = rect.size.height / 2;
    
    CGPoint point = CGPointZero;
    double z = fabs(vector.z);
    point.x = atan(vector.x / z) / ([self FOVonX] / 2) * rect.size.width + center.x;
    point.y = -(atan(vector.y / z) / ([self FOVonY] / 2) * rect.size.height) + center.y;
    
    if (point.x > rect.size.width || point.x < 0.0f) {
        *outBound = YES;
    }
    if (point.y > rect.size.height || point.y < 0.0f) {
        *outBound = YES;
    }

    return point;
}


+ (CGPoint)centerForIndicator:(UIView *)indicator inRect:(CGRect)rect withPosition:(CGPoint)position transformAngle:(CGFloat *)angle
{
    CGFloat width = rect.size.width / 2;
    CGFloat height = rect.size.height / 2;
    
    // 以屏幕中心为原点的坐标
    CGPoint point = {position.x - width, position.y - height};
    
    if (fabsf(point.x) > width) {
        float scale = width / fabsf(point.x);
        point.x *= scale;
        point.y *= scale;
    }
    
    if (fabs(point.y) > height) {
        float scale = height / fabsf(point.y);
        point.x *= scale;
        point.y *= scale;
    }
    
    if (point.x >= 0) {
        point.x -= indicator.bounds.size.width / 2;
    } else {
        point.x += indicator.bounds.size.width / 2;
    }
    
    if (point.y >= 0) {
        point.y -= indicator.bounds.size.height / 2;
    } else {
        point.y += indicator.bounds.size.height / 2;
    }
    
    // 默认箭头指向X轴正方向，计算旋转
    *angle = atanf(point.y / point.x);
    if (point.x < 0.0f) {
        *angle += M_PI;
    }
    
    // 转换为屏幕左上角为原点
    point.x += width;
    point.y += height;
    
    return point;
}

@end
