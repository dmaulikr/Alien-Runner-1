//
//  MainMenuScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/15/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

- (instancetype)initWithSize:(CGSize)size
{
  self = [super initWithSize:size];
  if (self) {
    // Blue background that matches buttons
    self.backgroundColor = [SKColor colorWithRed:0.16 green:0.27 blue:0.3 alpha:1.0];
  }
  return self;
}

@end
