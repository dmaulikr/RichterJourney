//
//  Richter.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "RichterNode.h"
#import "sprites.h"
#import "BaseAction.h"

@implementation RichterNode

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        atlas = [SKTextureAtlas atlasNamed:SPRITES_ATLAS_NAME];
        self = [self initWithTexture:SPRITE_WALK_01];
        [self addRichterPosition:position];
    }
    return self;
}

#pragma mark- Add Richer position

- (void)addRichterPosition:(CGPoint)posit {

    self.position = posit;//
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        // self.zPosition = 1;
    self.anchorPoint = CGPointMake(0, 0);
    self.physicsBody.dynamic = YES;
    self.physicsBody.velocity = CGVectorMake(0,0);
    self.name = @"Richter";
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = RichterCategory;
    self.physicsBody.contactTestBitMask = monsterCategory| coinCategory;
    self.physicsBody.collisionBitMask = 0;

    [self runAction:[self walkOfNode] withKey:@"Run"];
}

- (SKAction *)walkOfNode {

    SKAction *walk = [SKAction animateWithTextures:SPRITES_ANIM_WALK timePerFrame:0.09];
    SKAction *resetDirection   = [SKAction scaleXTo:1 y:1 duration:0.0];
    SKAction *walkAndMove = [SKAction group:@[resetDirection,walk]];
    SKAction *repeatAction = [SKAction repeatActionForever:walkAndMove];
    return repeatAction;
}

- (void)richterWalkAction {

    [self runAction:[self walkOfNode] withKey:@"Run"];
}

- (void)richterRemoveRunAction {

    [self removeActionForKey:@"Run"];
}

- (void)jumpUpOfRichter:(CGPoint)location withUpTexture:(NSArray *)texturesUp textureDown:(NSArray *)texturesDown Duration:(NSTimeInterval)timeInterval {

    [self removeActionForKey:@"run"];
    [self runAction:[BaseAction jumpUpOfNode:location withTextureUp:texturesUp textureDown:texturesDown Duration:timeInterval]];
}

- (void)richterDiedAtLocation:(CGPoint)location withTexture:(SKTexture*)texture {

    [self removeActionForKey:@"Run"];
    [self runAction:[BaseAction jumpUpDownOfDieNode:location withTexture:texture]];// [self runAction:[BaseAction dieAtDownOnlyAtRichterJumpLocation:location withTexture:texture]];
}

- (void)turnLeftOfRichterWithLocation:(CGPoint)location {

    [self runAction:[BaseAction turnLeft:location]];
}

- (void)turnRightOfRichterWithLocation:(CGPoint)location {

    [self runAction:[BaseAction turnRight:location]];
}

@end
