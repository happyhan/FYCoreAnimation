//
//  AffineViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/19.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "AffineViewController.h"

@interface AffineViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *layerView;

@property (weak, nonatomic) IBOutlet UIView *layerView2;

@end

@implementation AffineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self transfrom3D];
}

- (void)transformBasic{
    
    // Do any additional setup after loading the view.
    //CGAffineTransform transform = CGAffineTransformIdentity;
    
    /**
     我们使用了UIView的transform属性旋转了钟的指针，但并没有解释背后运作的原理，实际上UIView的transform属性是一个CGAffineTransform类型，用于在二维空间做旋转，缩放和平移
     */
    //    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    //    transform = CGAffineTransformRotate(transform, M_PI/180*30);
    //    transform = CGAffineTransformTranslate(transform, 0, 200);
    //    self.layerView.layer.affineTransform = transform;
    CATransform3D transform3 = CATransform3DIdentity;
    transform3.m34 = -1.0/500.0;
    transform3 = CATransform3DRotate(transform3, M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform3;

}

- (void)transfrom3D{
    
    //apply perspective transform to container
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = - 1.0 / 500.0;
    self.contentView.layer.sublayerTransform = perspective;
    //rotate layerView1 by 45 degrees along the Y axis
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform1;
    //rotate layerView2 by 45 degrees along the Y axis
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.layerView2.layer.transform = transform2;
    
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
