//
//  GameScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"

@interface GameScene()

@property (nonatomic) JSTileMap *map;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size {
  
  if (self = [super initWithSize:size]) {
    // Sky blue background
    self.backgroundColor = [SKColor colorWithRed:0.81 green:0.91 blue:0.96 alpha:1.0];
    
    // Load level
    self.map = [JSTileMap mapNamed:@"Level1.tmx"];
    [self addChild:self.map];
    
  }
  return self;
}

@end
