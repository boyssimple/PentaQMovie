//
//  HelloView.m
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "HelloView.h"

@implementation HelloView

+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HelloView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    UIImage *image = [UIImage imageNamed:@"thumbImage"];
    [self.progressSlider setThumbImage:image forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:image forState:UIControlStateHighlighted];
    self.blackBg.alpha = 0.8;
    self.progressSlider.value = 0;
    self.playerView.userInteractionEnabled = TRUE;
}


-(void)playWith:(NSURL*)videoUrl{
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, self.playerView.frame.size.width, self.frame.size.height);
    [self.playerView.layer addSublayer:self.playerLayer];
    [self addObserver];
    [self addProgressObserver];
    
    //添加视频点击事件
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewClick)];
    [self.playerView addGestureRecognizer:videoTap];
}

-(void)addObserver{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 观察视频播放各个监听触发
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {//播放状态
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusFailed:
                NSLog(@"播放失败");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"AVPlayerStatusReadyToPlay");
                CMTime duration = self.playerItem.duration;// 获取视频总长度
                self.self.progressSlider.maximumValue = 1;
                NSLog(@"总数量：%f",CMTimeGetSeconds(duration));
                [self playerViewClick];
                [self videoClick];
                break;
            default:
                NSLog(@"default:");
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){//缓冲
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        
        CMTime duration = _playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        NSLog(@"缓冲数据Time Interval:%f/%f",timeInterval / totalDuration);
        
//        [self.progressSlider setProgress:timeInterval/totalDuration animated:YES];
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if(self.player.currentItem.playbackBufferEmpty){
            NSLog(@"缓冲区为空");
        }else{
            NSLog(@"缓冲区不为空======");
        }
    }else{
        NSLog(@"++++++++++");
    }
}

//添加播放进度条更新
-(void)addProgressObserver{
    __weak __typeof(self) weakself = self;
    AVPlayerItem *playerItem = self.player.currentItem;
    NSLog(@"//添加播放进度条更新");
    playbackObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSString *currentTime = [weakself getStringFromCMTime:weakself.player.currentTime];
        NSString *totalTime = [weakself getStringFromCMTime:playerItem.duration];
        weakself.timeStr.text = [NSString stringWithFormat:@"%@/%@",currentTime,totalTime];
        NSLog(@"%f",CMTimeGetSeconds(self.playerItem.currentTime) / CMTimeGetSeconds(self.playerItem.duration));
        weakself.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    }];
}

-(void)playerViewClick{
    if (!self.toolBarShow) {
        self.toolBarShow = YES;
        [self showToolBar];
    }
    
}

#pragma mark ------ 显示控制栏
-(void)showToolBar{
     __weak __typeof(self) weakself = self;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakself.toolBar.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideToolBar) withObject:nil afterDelay:4.0f];
    }];
}

#pragma mark ------ 显示控制栏
-(void)hideToolBar{
    __weak __typeof(self) weakself = self;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakself.toolBar.alpha = 0;
    } completion:^(BOOL finished) {
        self.toolBarShow = FALSE;
    }];
}

#pragma mark ------ 缓冲数值格式化
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerLayer.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark ------ 格式化时间
-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
//    int hours = mins / 60.0f;
    int secs = fmodf(currentSeconds, 60.0);
    mins = fmodf(mins, 60.0f);
    
//    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    
    
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

#pragma mark ------ 播放控制
-(void)videoClick{
    if (!self.playBtn.selected) {
        [self.playerLayer.player play];
    }else{
        [self.playerLayer.player pause];
    }
    self.playBtn.selected = !self.playBtn.selected;
}

- (IBAction)playAction:(id)sender {
    [self videoClick];
}

- (IBAction)fullAction:(id)sender {
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.transform = CGAffineTransformMakeRotation(M_PI / 2);
    self.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    NSLog(@"x=%f,y=%f,width=%f,height=%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
}
@end
