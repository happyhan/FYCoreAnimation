//
//  MainViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 2016/11/2.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "AnchorPointViewController.h"
#import "MaskingViewController.h"
#import "CustomDrawingViewController.h"
#import "CAShapeLayerViewController.h"

#import "SolidObjectViewController.h"
#import "FYSimpleAnimationViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *sectionArray;
@property (strong, nonatomic) NSArray *idArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sectionArray = [NSMutableArray array];
    
    self.titleArray = @[@"常用功能",@"锚点",@"遮罩",@"圆角",@"CAShape"];
    NSArray *xibTitleArray = @[@"固体对象",@"隐式动画"];
    self.idArray = @[@"normal",@"anchor",@"mask",@"corner",@"shape"];
    [self.sectionArray addObject:self.titleArray];
    [self.sectionArray addObject:xibTitleArray];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.sectionArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.sectionArray[indexPath.section][indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:self.idArray[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                SolidObjectViewController *vc = [[SolidObjectViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 1:
            {
                FYSimpleAnimationViewController *vc = [[FYSimpleAnimationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
                
            default:
                break;
        }
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
