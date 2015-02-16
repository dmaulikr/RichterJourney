//
//  GRDemoVideo.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "GRDemoVideo.h"

@implementation GRDemoVideo

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString*)url ofType:(NSString *)type {

    if(self = [super init]) {

        NSURL *fileURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:url ofType:type]];
        _player = [AVPlayer playerWithURL : fileURL];
        _player.volume = 1.0;
        self = [self initWithAVPlayer:_player];
        self.size = frame.size;
        self.position = frame.origin;
        self.zPosition = 1.0;
        [self play];
    }
    return self;
}

@end
