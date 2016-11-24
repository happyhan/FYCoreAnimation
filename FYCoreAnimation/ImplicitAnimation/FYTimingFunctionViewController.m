//
//  FYTimingFunctionViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/11/24.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "FYTimingFunctionViewController.h"

@interface FYTimingFunctionViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (strong, nonatomic) CALayer *moveLayer;

@property (weak, nonatomic) IBOutlet UIView *contentView2;
@property (weak, nonatomic) IBOutlet UIView *contentView3;

@end

@implementation FYTimingFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadContentView1];
    [self loadContentView2];
    [self loadCOntentView3];
    
}

- (void)loadContentView1{
    
    self.moveLayer = [CALayer layer];
    self.moveLayer.frame = CGRectMake(0, 0, 100, 100);
    self.moveLayer.position = CGPointMake(self.contentView1.bounds.size.width/2.0, self.contentView1.bounds.size.height/2.0);
    self.moveLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.contentView1.layer addSublayer:self.moveLayer];
    
}

- (IBAction)changeColor:(id)sender {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[ (__bridge id)[UIColor blueColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor greenColor].CGColor,
                          (__bridge id)[UIColor blueColor].CGColor ];
    
    //add timing function
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunction = function;
    [self.moveLayer addAnimation:animation forKey:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     kCAMediaTimingFunctionLinear 线性运动
     kCAMediaTimingFunctionEaseIn 慢慢加速>突然停止
     kCAMediaTimingFunctionEaseOut 全速开始>慢慢减速
     kCAMediaTimingFunctionEaseInEaseOut 慢慢加速>慢慢减速
     kCAMediaTimingFunctionDefault 同上（用于隐式动画更合适）
     对应UIView的缓冲方法
     UIViewAnimationOptionCurveEaseInOut 默认值
     UIViewAnimationOptionCurveEaseIn
     UIViewAnimationOptionCurveEaseOut
     UIViewAnimationOptionCurveLinear
     */
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    self.moveLayer.position = [[touches anyObject] locationInView:self.contentView1];
    [CATransaction commit];
}


/**
 使用UIBezierPath绘制CAMediaTimingFunction
 */
- (void)loadContentView2{
    
    //CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    
    //get Control points
    CGPoint controlPoint1,controlPoint2;//取值0-4，第一个和最后一个是起始结束点，中间两个是拐点
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    //放大曲线
    [path applyTransform:CGAffineTransformMakeScale(160, 160)];
    //添加shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.path = path.CGPath;
    [self.contentView2.layer addSublayer:shapeLayer];
    //flip geometry so that 0,0 is in the bottom-left
    self.contentView2.layer.geometryFlipped = YES;
}

- (void)loadCOntentView3{
    
    
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
