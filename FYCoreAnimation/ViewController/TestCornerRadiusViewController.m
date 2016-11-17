//
//  TestCornerRadiusViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/21.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "TestCornerRadiusViewController.h"

@interface TestCornerRadiusViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *girlImageView;
@end

@implementation TestCornerRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutViewShow];
}

- (void)viewDidAppear:(BOOL)animated{
    
    //[self layoutViewShow];
}

- (void)layoutViewShow{
    
    NSLog(@"调用layoutIfNeeded之前%@",NSStringFromCGRect(self.imageView.frame));
    [self.view layoutIfNeeded];
    NSLog(@"调用layoutIfNeeded之后%@",NSStringFromCGRect(self.imageView.frame));
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    
    
    CGRect frame = self.imageView.frame;
    
    frame.origin.y += 150;
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    self.girlImageView.frame = frame;

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
