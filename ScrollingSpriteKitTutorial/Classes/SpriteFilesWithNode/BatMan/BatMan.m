//
//  Monster.m
//  GoalingBall
//
//  Created by GrepRuby on 29/12/14.
//  Copyright (c) 2014 GrepRuby. All rights reserved.
//

#import "BatMan.h"
#import "BaseAction.h"

@implementation BatMan

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithTexture:textureBg];
        [self addBatsWithPosition:position];
    }
    return self;
}

#pragma mark- Add monster

- (void)addBatsWithPosition:(CGPoint)position {

    // Create sprite
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask =  monsterCategory;
    self.physicsBody.contactTestBitMask =  eagleCategory;
    self.name = @"bat";
    self.physicsBody.collisionBitMask = 0;
    self.speed = 2.5;
    self.position = CGPointMake(position.x,position.y);
}

- (void)runningTextureOfBats:(CGPoint)location withTextures:(NSArray *)arryTexture  {

    [self runAction:[BaseAction monsterActionWithTexture:arryTexture ofLocation:location withTimeFrame:0.2]];
}

@end
