//
//  PushSegueNoAnimation.m
//  Scales
//
//  Created by lz on 2019/11/27.
//  Copyright © 2019 new. All rights reserved.
//

#import "PushSegueNoAnimation.h"

@implementation PushSegueNoAnimation

- (void)perform {
   [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:NO];
}

@end
