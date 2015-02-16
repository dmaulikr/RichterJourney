//
//  Richter.h
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "BaseSpriteNode.h"

@interface RichterNode : BaseSpriteNode {

    SKTextureAtlas *atlas;
}

- (void)addRichterPosition:(CGPoint)posit;

- (void)richterWalkAction;
- (void)jumpUpOfRichter:(CGPoint)location withUpTexture:(NSArray *)texturesUp textureDown:(NSArray *)texturesDown Duration:(NSTimeInterval)timeInterval;
- (void)richterDiedAtLocation:(CGPoint)location withTexture:(SKTexture*)texture;
- (void)richterRemoveRunAction;
- (void)turnLeftOfRichterWithLocation:(CGPoint)location;
- (void)turnRightOfRichterWithLocation:(CGPoint)location;

@end
