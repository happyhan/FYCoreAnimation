//
//  FYMediaTimingViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/11/23.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "FYMediaTimingViewController.h"

@interface FYMediaTimingViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (weak, nonatomic) IBOutlet UITextField *durationField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) CALayer *shipLayer;

@property (weak, nonatomic) IBOutlet UIView *contentView2;

@property (weak, nonatomic) IBOutlet UIView *contentView3;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (strong, nonatomic) CALayer *shipLayer2;
@property (weak, nonatomic) IBOutlet UISlider *timeOffsetSlider;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeOffsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation FYMediaTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadContentView1];
    [self loadContentView2];
    [self loadContentView3];
}

- (void)loadContentView1{
    
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 80, 80);
    self.shipLayer.position = CGPointMake(150, 80);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ship.png"].CGImage;
    [self.contentView1.layer addSublayer:self.shipLayer];
}

- (void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

- (IBAction)startAnimation:(id)sender {
    
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    //完整动画是以下两者乘积
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    
    
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    //disable controls
    [self setControlsEnabled:NO];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画播放完，使控件可编辑
    [self setControlsEnabled:YES];
}

- (void)loadContentView2{
    
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 80, 160);
    
    doorLayer.position = CGPointMake(self.contentView2.bounds.size.width/2, self.contentView2.bounds.size.height/2);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed:@"door"].CGImage;
    [self.contentView2.layer addSublayer:doorLayer];
    //apply persperctive transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500;
    self.contentView2.layer.sublayerTransform = perspective;
    
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);//逆时针90度
    animation.duration = 2.0;
    animation.repeatCount = INFINITY;//无限轮播
    animation.autoreverses = YES;//让动画自动回放
    [doorLayer addAnimation:animation forKey:nil];
}

- (void)loadContentView3{
    
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(0, 100)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 100) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 150)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.contentView3.layer addSublayer:pathLayer];
    //add the ship
    self.shipLayer2 = [CALayer layer];
    self.shipLayer2.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer2.position = CGPointMake(0, 100);
    self.shipLayer2.contents = (__bridge id)[UIImage imageNamed: @"ship"].CGImage;
    [self.contentView3.layer addSublayer:self.shipLayer2];
    //set initial values
    [self updateSliders];
}

- (IBAction)updateSliders
{
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
    
    self.shipLayer2.timeOffset = timeOffset;
    
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
}

- (IBAction)play
{
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    /*beginTime指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）。*/
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.duration = 1.0;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = YES;//removeOnCompletion被设置为NO的动画将会在动画结束的时候仍然保持之前的状态
    [self.shipLayer2 addAnimation:animation forKey:@"slide"];
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
