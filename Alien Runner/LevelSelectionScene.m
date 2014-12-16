//
//  LevelSelectionScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/15/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "LevelSelectionScene.h"

@implementation LevelSelectionScene

- (instancetype)initWithSize:(CGSize)size
{
  self = [super initWithSize:size];
  if (self) {
    // Set background color.
    self.backgroundColor = [SKColor colorWithRed:0.16 green:0.27 blue:0.3 alpha:1.0];
    // Setup title node.
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    title.text = @"Select Level";
    title.fontColor = [SKColor colorWithRed:0.518 green:0.78 blue:1.0 alpha:1.0];
    title.fontSize = 40;
    title.position = CGPointMake(size.width * 0.5, size.height - 100);
    [self addChild:title];
  }
  return self;
}


@end
