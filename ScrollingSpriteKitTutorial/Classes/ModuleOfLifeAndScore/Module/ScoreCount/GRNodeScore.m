//
//  GRNodeScore.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "GRNodeScore.h"

@implementation GRNodeScore

- (instancetype)initWithPosition:(CGPoint)position withLabelFont:(NSString *)fontName {

    if(self = [super initWithFontNamed:fontName]) {

        [self addScoreWithPosition:position];
    }
    return self;
}

#pragma mark- Add Score of node

- (void)addScoreWithPosition:(CGPoint)position {

    self.physicsBody.dynamic = NO;
    self.color = [UIColor whiteColor];
    self.zPosition = 1.0;
    self.position = CGPointMake(position.x, position.y);
    self.fontSize = 22.0;
    self.color = [UIColor greenColor];
    self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
}

@end
