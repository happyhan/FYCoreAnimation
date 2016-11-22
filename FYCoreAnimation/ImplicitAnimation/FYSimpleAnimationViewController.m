//
//  FYSimpleAnimationViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/11/17.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "FYSimpleAnimationViewController.h"

@interface FYSimpleAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) CALayer *colorLayer;

@end

@implementation FYSimpleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [self.view.layer addSublayer:self.contentView.layer];
    self.colorLayer = [CALayer layer];
    self.colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    self.colorLayer.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame)-20, CGRectGetHeight(self.contentView.frame)-20);
    
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor":transition};
    
    [self.contentView.layer addSublayer:self.colorLayer];
}

- (IBAction)changeColor:(id)sender {
    //begin a new transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    [CATransaction setCompletionBlock:^{
       
        //动画完成时渐变事物出栈，旋转动画默认0.25秒
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_4);
        self.colorLayer.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //begin入栈，commit出栈
    [CATransaction commit];
    
    /*
     当属性在动画快之外发生改变，UIView直接通过返回nil来禁止隐式动画。但如果在动画范围之内，根据动画具体类型返回相应的属性。
     //也可以通过这个禁止隐式动画
     [CATransaction setDisableActions:YES];
     */
    NSLog(@"Outside: %@", [self.contentView actionForLayer:self.contentView.layer forKey:@"backgroundColor"]);
    //begin animation block
    [UIView beginAnimations:nil context:nil];
    //test layer action when inside of animation block
    NSLog(@"Inside: %@", [self.contentView actionForLayer:self.contentView.layer forKey:@"backgroundColor"]);
    //end animation block
    [UIView commitAnimations];
}
//点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }else{
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
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
