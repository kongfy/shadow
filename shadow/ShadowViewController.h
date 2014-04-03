//
//  ShadowViewController.h
//  shadow
//
//  Created by kongfy on 14-4-1.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ERROR_DOMAIN @"com.kongfy.shadow"
typedef enum
{
    MotionError = -100,
    CameraError,
    
} ShadowErrorCode;

@protocol ShadowVCDelegate <NSObject>

@required

- (void)errorHandle:(NSError *)error;

@optional

@end

@interface ShadowViewController : UIViewController

@property (weak, nonatomic) id <ShadowVCDelegate> delegate;

@property (strong, nonatomic) NSArray *objects;

@end
