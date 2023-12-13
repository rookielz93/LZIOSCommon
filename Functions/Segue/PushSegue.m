//
//  PushSegue.m
//  Scales
//
//  Created by lz on 2019/11/5.
//  Copyright © 2019 new. All rights reserved.
//

#import "PushSegue.h"

@implementation PushSegue

- (void)perform {
   [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:YES];
}

@end
