//
//  FYBasicAnimationViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/11/18.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "FYBasicAnimationViewController.h"

@interface FYBasicAnimationViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (strong, nonatomic) IBOutlet CALayer *colorLayer;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) CALayer *shipLayer;

@end

@implementation FYBasicAnimationViewController{
    BOOL isStart;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
    //添加渐变动画
    [self createBezierPathAnimation];
}

- (IBAction)changeColor:(id)sender {
    
    //[self basicAnimation];
    [self keyFrameAnimation];
    
}

//修改动画立刻恢复到原始状态的一个可复用函数
- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer{
    //set the from value
    animation.fromValue = [layer.presentationLayer ?: layer valueForKeyPath:animation.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    //显示动画默认会覆盖隐式动画，需要用CATransaction禁掉隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKey:animation.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
    
}
//animation动画结束的代理

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    
    //也可以在代理中设置隐式动画的屏蔽，防止产生两遍动画
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//    [CATransaction commit];
    
    //log that the animation stopped
    NSLog(@"The animation stopped (finished: %@)", flag? @"YES": @"NO");
    
}

- (void)basicAnimation{
    //create a new random color
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
    
    //此方法和代理方法作用相同
    [self applyBasicAnimation:animation toLayer:self.colorLayer];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}

//CAKeyframeAnimation关键帧动画

- (void)keyFrameAnimation{
    CAKeyframeAnimation *animatin = [CAKeyframeAnimation animation];
    animatin.keyPath = @"backgroundColor";
    animatin.duration = 2.0;
    //开始结束时间一致是为了让动画更加平滑，不致突变
    animatin.values = @[
                        (__bridge id)[UIColor blueColor].CGColor,
                        (__bridge id)[UIColor greenColor].CGColor,
                        (__bridge id)[UIColor redColor].CGColor,
                        (__bridge id)[UIColor blueColor].CGColor
                        ];
    //apply  animation to layer
    [self.colorLayer addAnimation:animatin forKey:nil];
}

#pragma mark - 轨迹动画

- (void)createBezierPathAnimation{
    [self shapeLayerAnimation];
    [self shipTransform];
    
}

- (void)shapeLayerAnimation{
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    //add shapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 2;
    [self.contentView.layer addSublayer:pathLayer];
    //add ship
    self.shipLayer = [CALayer layer];
    _shipLayer.frame = CGRectMake(0, 0, 64, 64);
    _shipLayer.position = CGPointMake(0, 150);
    _shipLayer.contents = (__bridge id)[UIImage imageNamed:@"ship"].CGImage;
    [self.contentView.layer addSublayer:_shipLayer];
    //add keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.duration = 4.0;
    animation.delegate = self;
    //路线动画
    animation.keyPath = @"position";
    animation.path = bezierPath.CGPath;
    //使动画主体延曲线切线方向运动
    animation.rotationMode = kCAAnimationRotateAuto;
    [_shipLayer addAnimation:animation forKey:@"shipFly"];

}
//旋转动画
- (void)shipTransform{
    self.shipLayer = [CALayer layer];
    _shipLayer.frame = CGRectMake(0, 0, 128, 128);
    _shipLayer.position = CGPointMake(150, 150);
    _shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ship"].CGImage;
    [self.contentView.layer addSublayer:_shipLayer];
    
    }

//创建自定义过渡效果
- (IBAction)performTransition:(id)sender {
    //preserve the current view snapshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    /*CALayer有一个-renderInContext:方法，可以通过把它绘制到Core Graphics的上下文中捕获当前内容的图片，然后在另外的视图中显示出来*/
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    //insert snapshot view in front of this one
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    //update the view (we'll simply randomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //perform animation (anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        //scale, rotate and fade the view
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //remove the cover view now we're finished with it
        [coverView removeFromSuperview];
    }];
    
}
//控制动画开关
- (IBAction)controlAnimation:(id)sender {
    isStart = !isStart;
    if (isStart) {
        CABasicAnimation *animation =[CABasicAnimation animation];
        animation.duration = 2.0;
        //利用transform
        //    animation.keyPath = @"transform";
        //    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
        //利用transform.rotation
        animation.keyPath = @"transform.rotation";
        animation.byValue = @(M_PI *2);
        animation.delegate = self;
        [self.shipLayer addAnimation:animation forKey:@"rotationTransform"];

    }else{
        [self.shipLayer removeAnimationForKey:@"rotationTransform"];
    }
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
