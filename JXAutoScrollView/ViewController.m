//
//  ViewController.m
//  JXAutoScrollView
//
//  Created by 谢东华 on 2018/3/20.
//  Copyright © 2018年 谢东华. All rights reserved.
//

#import "ViewController.h"
#import "JXSquareAutoScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wkself = self;
    JXSquareAutoScrollView *scrollView = [[JXSquareAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200) tapHandler:^(NSInteger index) {
        [wkself alertView:index];
    }];
    NSMutableArray *imageUrlArray = [NSMutableArray arrayWithCapacity:6];
    for (int i=1; i<7; i++) {
        [imageUrlArray addObject:[NSString stringWithFormat:@"http://d.5857.com/yrmn_170118/00%d.jpg", i]];
    }
    
    [scrollView configWithImageUrlstr:imageUrlArray];
    scrollView.center = self.view.center;
    [self.view addSubview:scrollView];
}

- (void)alertView:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"tap index:%lu", index] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
