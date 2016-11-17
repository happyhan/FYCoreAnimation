//
//  SolidObjectViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/21.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "SolidObjectViewController.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0.8
#define AMBIENT_LIGHT 0.5

@interface SolidObjectViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *faces;

@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation SolidObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self addFaceView];
}

- (void)viewDidAppear:(BOOL)animated{
    //[self addFaceView];
}

- (void)addFaceView{
    
    //set up the container sublayer transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
    NSLog(@"%@",self.faces);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    //应用此变换
    self.containerView.layer.sublayerTransform = perspective;
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    //get the face view and add it to the container
    UIView *face = self.faces[index];
    face.frame = CGRectMake(0, 0, 200, 200);
    
    
    face.bounds = self.containerView.bounds;
    [self.containerView addSubview:face];
    //center the face view within the container
    
    CGSize containerSize = self.containerView.bounds.size;
//    NSLog(@"%@",NSStringFromCGRect(self.containerView.frame));
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    
    // apply the transform
    face.layer.transform = transform;
    NSLog(@"%@",NSStringFromCGRect(face.frame));
    [self applyLightingToFace:face.layer];
    
}


/**
 添加光影效果
 */
- (void)applyLightingToFace:(CALayer *)face{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //GLKMatrix4 has the same structure as CATransform3D
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal= GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get fot produce with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION,LIGHT_DIRECTION,LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
    
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
