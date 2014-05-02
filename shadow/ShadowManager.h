//
//  ShadowManager.h
//  shadow
//
//  Created by kongfy on 14-4-10.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShadowObject.h"

@interface ShadowManager : NSObject

+ (CGPoint)centerForObjectVector:(ObjectVector)vector inRect:(CGRect)rect outBound:(BOOL *)outBound;
+ (CGPoint)centerForIndicator:(UIView *)indicator inRect:(CGRect)rect withPosition:(CGPoint)position transformAngle:(CGFloat *)angle;

@end
