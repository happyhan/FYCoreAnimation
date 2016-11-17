//
//  AnchorPointViewController.m
//  FYCoreAnimation
//
//  Created by zhangferry on 16/9/14.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "AnchorPointViewController.h"

@interface AnchorPointViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hourHand;

@property (weak, nonatomic) IBOutlet UIImageView *minuteHand;

@property (weak, nonatomic) IBOutlet UIImageView *secondHand;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation AnchorPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial hand positions
    [self tick];
    
    self.hourHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    
    self.minuteHand.layer.zPosition = 1.0;//调整图层位置
    self.hourHand.layer.zPosition = 2.0;
}

- (void)tick{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
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
