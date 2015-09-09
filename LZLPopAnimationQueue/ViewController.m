//
//  ViewController.m
//  LZLPopAnimationQueue
//
//  Created by 卢政 on 15/9/4.
//  Copyright (c) 2015年 卢政. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *schedulingQueue; //下一轮用于展示pop动画的元素队列
@property (nonatomic, assign) float animationInterval;
@property (nonatomic, strong) NSDate *lastClickDate;
@property (nonatomic, assign) int lastPopNumber; //上一次的冒泡数
@property (nonatomic, assign) float baseY;
@property (nonatomic, assign) float baseX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.schedulingQueue = [NSMutableArray new];
    self.animationInterval = 0;
    self.lastClickDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.lastPopNumber = 0;
    self.baseY = 300; //基准线坐标
    self.baseX = 10;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.schedulingQueue removeAllObjects];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearBtnClicked:(id)sender {
    for (UILabel *label in self.schedulingQueue) {
        [label removeFromSuperview];
    }
    [self.schedulingQueue removeAllObjects];
}


- (IBAction)addBtnClicked:(id)sender {

    if ([self.lastClickDate isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
        self.lastClickDate = [NSDate date];
    } else if([[NSDate date] timeIntervalSinceDate:self.lastClickDate] <= self.lastPopNumber*self.animationInterval){
        return;
    }
    int randomNumber = [self generateRandomNumber];
    self.lastPopNumber = randomNumber;
    self.animationInterval = 1 - randomNumber / 10.f;
    for (int i=0; i<randomNumber; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){{self.baseX, self.baseY},{200,30}}];
        label.backgroundColor = [UIColor yellowColor];
        label.numberOfLines = 0;
        label.text = [self generateRandomString];
        [label sizeToFit];
        
        [self performSelector:@selector(addLabel:) withObject:label afterDelay:i*self.animationInterval];
    }
    self.lastClickDate = [NSDate date];
    
}

- (void)addLabel:(UILabel*)newLabel{
    CGFloat animateHeight = CGRectGetHeight(newLabel.frame);
    for (UILabel *label in self.schedulingQueue) {
        [UIView animateWithDuration:self.animationInterval animations:^{
            label.frame = CGRectOffset(label.frame, 0, -animateHeight-5);
        }];
    }
    [self.view addSubview:newLabel];
    [UIView animateWithDuration:self.animationInterval animations:^{
        newLabel.frame = CGRectOffset(newLabel.frame, 0, -animateHeight-5);
    }];
    [self.schedulingQueue addObject:newLabel];
    
}

- (int)generateRandomNumber{
    return arc4random() % 9 + 1;
}
- (NSString*)generateRandomString{
    NSArray *stringArray = @[@"Hello World!", @"This is a long string.", @"This is a long long long long long long long string"];
    int random =  arc4random() % stringArray.count;
    return stringArray[random];
}

@end
