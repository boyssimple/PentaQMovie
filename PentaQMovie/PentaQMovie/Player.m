//
//  Player.m
//  PentaQMovie
//
//  Created by zhouMR on 16/2/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
    
}

-(AVPlayer *) player{
    
    return [(AVPlayerLayer *)[self layer] player];
    
}

- (void)setPlayer:(AVPlayer*)player {
    
    [(AVPlayerLayer*)[self layer] setPlayer:player];
    
}

@end
