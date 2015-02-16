//
//  GameObject.h
//  GoalingBall
//
//  Created by GrepRuby on 29/12/14.
//  Copyright (c) 2014 GrepRuby. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t monsterCategory       =  0x1 << 1; //Weapon category to get collision
static const uint32_t RichterCategory       =  0x1 << 4; //Richter category to get collision
static const uint32_t coinCategory          =  0X1 << 2;
static const uint32_t weaponShipCategory    =  0X1 << 3;
static const uint32_t eagleCategory         =  0X1 << 4;


@interface BaseSpriteNode : SKSpriteNode

#pragma mark - Essential and Change Restricted Function
/*
 This function is essential for all sprite node initialization with position and texture.
 There should not be any changes in this function.
 */
- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg;

@end
