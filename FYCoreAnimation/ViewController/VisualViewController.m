//
//  VisualViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/18.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "VisualViewController.h"

@interface VisualViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation VisualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.layerView1.layer.cornerRadius = 20;
    //self.layerView2.layer.cornerRadius = 20;
    
    self.layerView1.layer.borderWidth = 5;
    //self.layerView2.layer.borderWidth = 5;
    
    self.layerView1.layer.shadowOpacity = 0.5;
    self.layerView1.layer.shadowOffset = CGSizeMake(0, 5);
    self.layerView1.layer.shadowRadius = 5;
    
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowRadius = 5;
    
    //self.layerView2.layer.masksToBounds = YES;
    
    //shadowPath属性
    self.layerView2.layer.shadowOpacity = 0.5;
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.layerView2.frame);
    self.layerView2.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
    
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
