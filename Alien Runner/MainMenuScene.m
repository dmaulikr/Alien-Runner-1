//
//  MainMenuScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/15/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "MainMenuScene.h"
#import "Player.h"

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
    
  }
  return self;
}

@end
