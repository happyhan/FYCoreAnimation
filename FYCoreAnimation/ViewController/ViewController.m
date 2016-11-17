//
//  ViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/13.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;//(300,300)

@property (weak, nonatomic) IBOutlet UIView *firstLayerView;
@property (weak, nonatomic) IBOutlet UIView *secondLayerView;
@property (weak, nonatomic) IBOutlet UIView *thirdLayerView;
@property (weak, nonatomic) IBOutlet UIView *foryLayerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"morning"];
    self.layerView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    //设置显示图片的拉伸格式,UIViewContentModeScaleAspectFit
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    self.layerView.layer.masksToBounds = YES;
    
    //图片拼合
    UIImage *heartImage = [UIImage imageNamed:@"Heart"];
    [self addSpriteImage:heartImage withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.firstLayerView.layer];
    [self addSpriteImage:heartImage withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.secondLayerView.layer];
    [self addSpriteImage:heartImage withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.thirdLayerView.layer];
    [self addSpriteImage:heartImage withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.foryLayerView.layer];
  
    
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer{
    
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
