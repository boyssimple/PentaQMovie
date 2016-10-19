//
//  ViewController.m
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "ViewController.h"
//#import "PentaQPlayer.h"
//#import "HelloView.h"

#import "PQPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *videoUrl = [NSURL URLWithString:@"http://w5.dwstatic.com/8/6/1551/380767-100-1450416171.mp4"];
//    PentaQPlayer *pentaqVideo = [[PentaQPlayer alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) contentURL:videoUrl];
//    [pentaqVideo setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:pentaqVideo];
    
//    HelloView *hello = [HelloView videoPlayView];
//    hello.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
//    [self.view addSubview:hello];
//    [hello playWith:videoUrl];
//    self.navigationController.navigationBarHidden = TRUE;
    
    
    PQPlayer *player = [PQPlayer videoPlayView];
    player.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.width * 9 / 16);
    [self.view addSubview:player];
    [player playWith:videoUrl];
    player.container = self;
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
