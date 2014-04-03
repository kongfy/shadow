//
//  ShadowViewController.m
//  shadow
//
//  Created by kongfy on 14-4-1.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowViewController.h"
#import "ShadowObject.h"

#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>

/** @def CC_DEGREES_TO_RADIANS
 converts degrees to radians
 */
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180

/** @def CC_RADIANS_TO_DEGREES
 converts radians to degrees
 */
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

@interface ShadowViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *motionQueue;
@property (weak, nonatomic) UIImagePickerController *cameraController;
@property (weak, nonatomic) UIView *mapView;

@end

@implementation ShadowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpLayers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetObjectViews];
    
    __weak ShadowViewController *weakSelf = self;
    if (self.motionManager.isDeviceMotionAvailable) {
        [weakSelf.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:weakSelf.motionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [weakSelf motionUpdates:motion withError:error];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.motionManager stopDeviceMotionUpdates];
    
    [super viewWillDisappear:animated];
}

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.02;
    }
    return _motionManager;
}

- (NSOperationQueue *)motionQueue
{
    if (!_motionQueue) {
        _motionQueue = [[NSOperationQueue alloc] init];
    }
    return _motionQueue;
}

- (void)setObjects:(NSArray *)objects
{
    for (ShadowObject *object in _objects) {
        [object.shadowView removeFromSuperview];
    }
    _objects = objects;
}

- (void)resetObjectViews
{
    for (ShadowObject *object in self.objects) {
        [self.mapView addSubview:object.shadowView];
        object.shadowView.alpha = 0.0f;
    }
}

- (void)setUpLayers
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if ([self.delegate respondsToSelector:@selector(errorHandle:)]) {
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:@"Camera not availeble" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:CameraError userInfo:userinfo];
            [self.delegate errorHandle:error];
        }
        return;
    }
    
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置为录像模式以占满全屏幕
    // cameraController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    // 隐藏相机控制界面
    cameraController.showsCameraControls = NO;
    [self addChildViewController:cameraController];
    cameraController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    cameraController.view.frame = self.view.bounds;
    [self.view addSubview:cameraController.view];
    [cameraController didMoveToParentViewController:self];
    self.cameraController = cameraController;
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:view];
    self.mapView = view;
}


- (void)motionUpdates:(CMDeviceMotion *)motion withError:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
        if ([self.delegate respondsToSelector:@selector(errorHandle:)]) {
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:MotionError userInfo:userinfo];
            [self.delegate errorHandle:error];
        }
        return;
    }
    
    CMAttitude *currentAttitude = motion.attitude;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (ShadowObject *object in self.objects) {
            
            //刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                CGPoint point = self.view.center;
                point.x = CC_RADIANS_TO_DEGREES(currentAttitude.roll) / 180 * 160 + 160;
                object.shadowView.center = point;
                object.shadowView.alpha = 1.0f;
            });
        }
    });

    NSLog(@"motion : %f, %f, %f", CC_RADIANS_TO_DEGREES(currentAttitude.roll), CC_RADIANS_TO_DEGREES(currentAttitude.pitch), CC_RADIANS_TO_DEGREES(currentAttitude.yaw));
}


@end
