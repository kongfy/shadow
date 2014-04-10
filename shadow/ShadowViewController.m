//
//  ShadowViewController.m
//  shadow
//
//  Created by kongfy on 14-4-1.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowViewController.h"
#import "ShadowObject.h"
#import "ShadowManager.h"

#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>

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
    } else {
        if ([self.delegate respondsToSelector:@selector(errorHandle:)]) {
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:@"DeviceMotionIsNotAvailable" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:MotionError userInfo:userinfo];
            [self.delegate errorHandle:error];
        }
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

    // 隐藏相机控制界面
    cameraController.showsCameraControls = NO;
    [self addChildViewController:cameraController];
    cameraController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    CGRect frame = self.view.bounds;
    // 维持相机长宽比
    frame.size.height = 426.66f;
    cameraController.view.frame = frame;
    [self.view addSubview:cameraController.view];
    [cameraController didMoveToParentViewController:self];
    self.cameraController = cameraController;
    
    UIView *view = [[UIView alloc] initWithFrame:self.cameraController.view.bounds];
    view.clipsToBounds = YES;
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
            
            // 转换座标系
            ObjectVector vector = [object multiplyByRotationMatrix:currentAttitude.rotationMatrix];
            // NSLog(@"vector : %f %f %f %f", vector.x, vector.y, vector.z, vector.d);
            
            // 将向量转换为屏幕坐标
            CGPoint center = [ShadowManager centerForObjectVector:vector inRect:self.cameraController.view.bounds];
            
            // 刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if (center.x < 0 && center.y < 0) {
                    object.shadowView.alpha = 0.0f;
                } else {
                    object.shadowView.alpha = 1.0f;
                }
                object.shadowView.center = center;
            });
        }
    });
    
}


@end
