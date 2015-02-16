//
//  ThirdScene.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 23/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScrollingBackground.h"
#import "RichterNode.h"
#import "BaseScene.h"

@interface ThirdScene : BaseScene <scrollVwDelegate>

@property (nonatomic,strong) ScrollingBackground *scrollingBackground; // scrolling backgroung
@property (nonatomic, strong)RichterNode *hero;

@end
