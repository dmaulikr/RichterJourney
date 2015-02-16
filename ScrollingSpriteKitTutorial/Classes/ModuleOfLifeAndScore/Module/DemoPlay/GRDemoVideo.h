//
//  GRDemoVideo.h
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GRDemoVideo : SKVideoNode {

    AVPlayer *_player;
}

#pragma mark - Essential and Change restricted Function
/*
 Initialization of video node.
 */

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString*)url ofType:(NSString *)type;

@end
