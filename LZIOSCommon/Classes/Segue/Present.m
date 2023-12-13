//
//  Present.m
//  Scales
//
//  Created by lz on 2019/11/5.
//  Copyright © 2019 new. All rights reserved.
//

#import "Present.h"

@implementation Present

- (void)perform {
    UIViewController *vc = self.sourceViewController.navigationController ?: self.sourceViewController;
    self.destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc presentViewController:self.destinationViewController animated:YES completion:^{
        
    }];
}

@end
