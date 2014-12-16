//
//  MainMenuScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/15/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "MainMenuScene.h"
#import "LevelSelectionScene.h"
#import "GameScene.h"
#import "Player.h"
#import "Button.h"

@implementation MainMenuScene

- (instancetype)initWithSize:(CGSize)size
{
  self = [super initWithSize:size];
  if (self) {
    // Blue background that matches buttons
    self.backgroundColor = [SKColor colorWithRed:0.16 green:0.27 blue:0.3 alpha:1.0];
    
    // Setup title node
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    title.text = @"Alien Runner";
    title.fontColor = [SKColor colorWithRed:0.518 green:0.78 blue:1.0 alpha:1.0];
    title.fontSize = 40;
    title.position = CGPointMake(size.width * 0.5, size.height - 100);
    [self addChild:title];
    
    // Setup alien.
    Player *alien = [[Player alloc] init];
    alien.position = CGPointMake(size.width * 0.5, size.height - 150);
    alien.state = Running;
    [self addChild:alien];
    
    // Create label node to display level.
    SKLabelNode *levelDisplay = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    levelDisplay.text = @"Level 1";
    levelDisplay.fontColor = [SKColor colorWithRed:0.518 green:0.78 blue:1.0 alpha:1.0];
    levelDisplay.fontSize = 15;
    levelDisplay.position = CGPointMake(size.width * 0.5, size.height - 195);
    [self addChild:levelDisplay];
    
    // Create Play button
    Button *playButton = [Button spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ButtonPlay"]];
    playButton.position = CGPointMake(size.width * 0.5 - 55, 90);
    [playButton setPressedTarget:self withAction:@selector(pressedPlayButton)];
    [self addChild:playButton];
    
    // Create level select button
    Button *levelButton = [Button spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ButtonLevel"]];
    levelButton.position = CGPointMake(size.width * 0.5 + 55, 90);
    [levelButton setPressedTarget:self withAction:@selector(pressedLevelButton)];
    [self addChild:levelButton];
    
  }
  return self;
}

- (void)pressedPlayButton
{
  [self.view presentScene:[[GameScene alloc] initWithSize:self.size]];
}

- (void)pressedLevelButton
{
  LevelSelectionScene *levelSelectionScene = [[LevelSelectionScene alloc] initWithSize:self.size];
  [self.view presentScene:levelSelectionScene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.6]];
  
}
@end
