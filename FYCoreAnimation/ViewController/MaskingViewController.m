//
//  MaskingViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/18.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "MaskingViewController.h"
#import "SolidObjectViewController.h"

@interface MaskingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;

@property (weak, nonatomic) IBOutlet UIView *layerView;

@property (nonatomic, strong) CAShapeLayer *maskLayerUp;
@property (nonatomic, strong) CAShapeLayer *maskLayerDown;

@end

@implementation MaskingViewController{
    NSTimeInterval duration;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    duration = 5;
    self.greenImageView.layer.mask = [self greenHeadMaskLayer];
    [self startGreenHeadAnimation];
    
    
}

- (CALayer *)greenHeadMaskLayer{
    
    CALayer *mask = [CALayer layer];
    mask.frame = self.imageView.bounds;
    
    self.maskLayerUp = [CAShapeLayer layer];
    self.maskLayerUp.bounds = CGRectMake(0, 0, 30.0f, 30.0f);
    self.maskLayerUp.fillColor = [UIColor greenColor].CGColor; // Any color but clear will be OK
    self.maskLayerUp.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(15.0f, 15.0f)
                                                           radius:15.0f
                                                       startAngle:0
                                                         endAngle:2*M_PI
                                                        clockwise:YES].CGPath;
    self.maskLayerUp.opacity = 0.8f;
    self.maskLayerUp.position = CGPointMake(-5.0f, -5.0f);
    [mask addSublayer:self.maskLayerUp];
    
    self.maskLayerDown = [CAShapeLayer layer];
    self.maskLayerDown.bounds = CGRectMake(0, 0, 30.0f, 30.0f);
    self.maskLayerDown.fillColor = [UIColor greenColor].CGColor; // Any color but clear will be OK
    self.maskLayerDown.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(15.0f, 15.0f)
                                                             radius:15.0f
                                                         startAngle:0
                                                           endAngle:2*M_PI
                                                          clockwise:YES].CGPath;
    self.maskLayerDown.position = CGPointMake(35.0f, 35.0f);
    [mask addSublayer:self.maskLayerDown];
    
    return mask;
    
}

- (void)startGreenHeadAnimation
{
    CABasicAnimation *downAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    downAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-5.0f, -5.0f)];
    downAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(10.0f, 10.0f)];
    downAnimation.duration = duration;
    [self.maskLayerUp addAnimation:downAnimation forKey:@"downAnimation"];
    
    CABasicAnimation *upAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    upAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(35.0f, 35.0f)];
    upAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(20.0f, 20.0f)];
    upAnimation.duration = duration;
    [self.maskLayerDown addAnimation:upAnimation forKey:@"upAnimation"];
}

- (IBAction)jumpToView:(id)sender {
    
    SolidObjectViewController *solid = [[SolidObjectViewController alloc] init];
    [self presentViewController:solid animated:YES completion:nil];
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
