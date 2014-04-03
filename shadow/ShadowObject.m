//
//  ShadowObject.m
//  shadow
//
//  Created by kongfy on 14-4-3.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowObject.h"

@implementation ShadowObject

- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadowDefault"]];
    }
    return _shadowView;
}

@end
