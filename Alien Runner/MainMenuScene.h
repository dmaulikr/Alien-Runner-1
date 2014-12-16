//
//  MainMenuScene.h
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/15/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
  Home,
  LevelFailed,
  LevelCompleted,
} MenuMode;

@interface MainMenuScene : SKScene

@property (nonatomic) MenuMode mode;

@end
