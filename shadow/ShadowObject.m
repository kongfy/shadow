//
//  ShadowObject.m
//  shadow
//
//  Created by kongfy on 14-4-3.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowObject.h"

@implementation ShadowObject

- (id)initWithDistance:(double)d X:(double)x Y:(double)y Z:(double)z
{
    ObjectVector vector;
    vector.x = x;
    vector.y = y;
    vector.z = z;
    vector.d = d;
    
    self = [self initWithVector:vector];
    if (self) {
    }
    return self;
}

- (id)initWithVector:(ObjectVector)vector
{
    self = [super init];
    if (self) {
        self.vector = vector;
    }
    return self;
}

- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadowDefault"]];
    }
    return _shadowView;
}

// http://en.wikipedia.org/wiki/Rotation_matrix
- (ObjectVector)multiplyByRotationMatrix:(CMRotationMatrix)rotationMatrix
{
    ObjectVector result;
    
    result.d = self.vector.d;
    
    result.x = self.vector.x * rotationMatrix.m11
               + self.vector.y * rotationMatrix.m12
               + self.vector.z * rotationMatrix.m13;
    result.y = self.vector.x * rotationMatrix.m21
               + self.vector.y * rotationMatrix.m22
               + self.vector.z * rotationMatrix.m23;
    result.z = self.vector.x * rotationMatrix.m31
               + self.vector.y * rotationMatrix.m32
               + self.vector.z * rotationMatrix.m33;
    
    return result;
}


@end
