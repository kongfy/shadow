//
//  ShadowViewController.m
//  shadow
//
//  Created by kongfy on 14-4-1.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "ShadowViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface ShadowViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
}


- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}


@end
