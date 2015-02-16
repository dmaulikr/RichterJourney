//
//  GRNodeLife.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "GRNodeLife.h"

@implementation GRNodeLife

- (instancetype)initWithPosition:(CGPoint)position {

    if(self = [super initWithImageNamed:@"Heart"]) {

        [self addLifeWithPosition:position];
    }
    return self;
}

#pragma mark- Add Life of node

- (void)addLifeWithPosition:(CGPoint)position {

    // Create sprite
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 30)];
    self.physicsBody.dynamic = NO;
    self.size = CGSizeMake(30, 30);
    self.zPosition = 1.0;
    self.name = @"heart";
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.position = CGPointMake(position.x, position.y);
}

@end
