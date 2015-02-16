//
//  FourthScene.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 04/02/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScrollingBackground.h"
#import "RichterNode.h"
#import "BaseScene.h"

@interface FourthScene : BaseScene <scrollVwDelegate>

@property (nonatomic,strong) ScrollingBackground *scrollingBackground; // scrolling backgroung
@property (nonatomic, strong)RichterNode *hero;

@end
