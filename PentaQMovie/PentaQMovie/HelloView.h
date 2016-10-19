//
//  HelloView.h
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HelloView : UIView{
    BOOL isPlay;
    id playbackObserver;
}
+ (instancetype)videoPlayView;
-(void)playWith:(NSURL*)videoUrl;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIImageView *playerView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *timeStr;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *blackBg;


//player
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, assign) BOOL toolBarShow;//控制栏是否显示

- (IBAction)playAction:(id)sender;
- (IBAction)fullAction:(id)sender;
@end
