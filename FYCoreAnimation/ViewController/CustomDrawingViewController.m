//
//  CustomDrawingViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/13.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "CustomDrawingViewController.h"

@interface CustomDrawingViewController ()
@property (weak, nonatomic) IBOutlet UIView *showLayerView;

@end

@implementation CustomDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //set controller as layer delegate
    blueLayer.delegate = self;
    
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [self.showLayerView.layer addSublayer:blueLayer];
    
    //force layer to redraw
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
