//
//  PentaQPlayer.h
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PentaQPlayer : UIView{
    BOOL isPlay;
    id playbackObserver;
}
//avplayer
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;


-(id)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL;
@end
