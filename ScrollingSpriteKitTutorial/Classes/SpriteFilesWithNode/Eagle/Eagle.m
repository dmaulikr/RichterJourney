//
//  Richter.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "Eagle.h"
#import "sprites.h"

@implementation Eagle

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithTexture:textureBg];
        [self runAction:[SKAction scaleXTo:2 y:2 duration:0.0]];
        [self addObstacleWithPosition:position];
    }
    return self;
}


#pragma mark- Add monster

- (void)addObstacleWithPosition:(CGPoint)position {

    // Create sprite
    // self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20,20)];
    self.physicsBody.dynamic = NO;
        // self.physicsBody.categoryBitMask =  monsterCategory;
        // self.physicsBody.contactTestBitMask =  RichterCategory;
    self.name = @"eagle";

    // and along a random position along the Y axis as calculated above
    self.position = CGPointMake(position.x, position.y);
}

@end
