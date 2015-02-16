//
//  Richter.h
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "BaseSpriteNode.h"

@interface Monster : BaseSpriteNode {

    SKTextureAtlas *atlas;
}

- (void)runningTextureOfMonsterWithLocation:(CGPoint)location withTextures:(NSArray *)arryTexture;

@end
