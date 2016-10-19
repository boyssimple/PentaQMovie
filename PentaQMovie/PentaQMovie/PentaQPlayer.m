//
//  PentaQPlayer.m
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "PentaQPlayer.h"

@implementation PentaQPlayer


-(id)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL{
    {
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
            self.playerItem = [AVPlayerItem playerItemWithURL:contentURL];
            self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self.layer addSublayer:self.playerLayer];
            [self addObserver];
            [self addProgressObserver];
            //添加视频点击事件
            UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoClick)];
            [self addGestureRecognizer:videoTap];
        }
        return self;
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
        NSLog(@"当前：%@,总时间：%@",currentTime,totalTime);
    }];
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

-(void)videoClick{
    if (isPlay) {
        [self.playerLayer.player pause];
    }else{
         [self.playerLayer.player play];
    }
    isPlay = !isPlay;
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

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hours = mins / 60.0f;
    int secs = fmodf(currentSeconds, 60.0);
    mins = fmodf(mins, 60.0f);
    
    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    
    
    return [NSString stringWithFormat:@"%@:%@:%@", hoursString,minsString, secsString];
}


@end
