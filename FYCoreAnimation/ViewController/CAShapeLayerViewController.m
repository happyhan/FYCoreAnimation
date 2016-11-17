//
//  CAShapeLayerViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/10/27.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "CAShapeLayerViewController.h"

@interface CAShapeLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *No1View;
@property (weak, nonatomic) IBOutlet UIView *No2View;
@property (weak, nonatomic) IBOutlet UIView *No3View;
@property (weak, nonatomic) IBOutlet UIView *No3ContainerView;

@property (weak, nonatomic) IBOutlet UIView *NoView4;
@property (weak, nonatomic) IBOutlet UIView *reflectView;

@property (weak, nonatomic) IBOutlet UIView *NoView5;
@property (weak, nonatomic) IBOutlet UIView *NoView6;

@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self shaperLayer];
    [self CAGradientLayer];
    [self CAReplicatorLayer];
    [self creatReflectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view layoutIfNeeded];
}

/**
 CAShaperLayer
 */
- (void)shaperLayer{
    
    //creat path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(12, 10)];
    [path addArcWithCenter:CGPointMake(10, 10) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path moveToPoint:CGPointMake(10, 12)];
    [path addLineToPoint:CGPointMake(10, 18)];//脖子
    
    [path moveToPoint:CGPointMake(2, 15)];
    [path addLineToPoint:CGPointMake(18, 15)];//手臂
    
    [path moveToPoint:CGPointMake(10, 18)];
    [path addLineToPoint:CGPointMake(8, 20)];
    [path moveToPoint:CGPointMake(10, 18)];
    [path addLineToPoint:CGPointMake(12, 20)];
    
    //圆角矩形
    CGRect rect = CGRectMake(5, 21, 10, 6);
    CGSize readii = CGSizeMake(20, 20);
    UIRectCorner corner = UIRectCornerTopLeft| UIRectCornerTopRight;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:readii];
    
    //creat shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 0.5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapButt;
    
    shapeLayer.path = path.CGPath;
    
    [self.No1View.layer addSublayer:shapeLayer];
    
    CAShapeLayer *shapeLayer2 = shapeLayer;
    shapeLayer2.path = path2.CGPath;
    [self.No1View.layer addSublayer:shapeLayer2];
}

/**
 渐变CAGradientLayer的真正好处在于绘制使用了硬件加速。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
 */
- (void)CAGradientLayer{
    
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.No2View.bounds;
    [self.No2View.layer addSublayer:gradientLayer];
    
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    //locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置，同样的，也是以单位坐标系进行标定。0.0代表着渐变的开始，1.0代表着结束。
    gradientLayer.locations = @[@0, @0.25, @0.5];
    
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

/**
 重复图层
 */
- (void)CAReplicatorLayer{
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.No3ContainerView.bounds;
    [self.No3ContainerView.layer addSublayer:replicator];
    //configure the replicator
    replicator.instanceCount = 10;
    //apple a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 80, 0);
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -80, 0);
    replicator.instanceTransform = transform;
    
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    //create a sublayer and place it inside the replicator
    CALayer *layer =[CALayer layer];
    layer.frame = CGRectMake(0, 0, 40, 40);
    layer.backgroundColor =[UIColor grayColor].CGColor;
    [replicator addSublayer:layer];
    
}

/**
 创建反射效果
 */
- (void)creatReflectionView{
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.frame = self.reflectView.bounds;
    [self.reflectView.layer addSublayer:layer];
    
    layer.instanceCount = 2;
    
    //move reflection instance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.reflectView.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.transform = transform;
    
    layer.instanceAlphaOffset = -0.6;
    
    
//    CALayer *lay = [CALayer layer];
//    layer.frame = self.reflectView.bounds;
//    
//    [layer addSublayer:lay];
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
