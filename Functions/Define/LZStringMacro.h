//
//  LZDefine.h
//  VideoDownloader
//
//  Created by lz on 2023/9/9.
//

#import <Foundation/Foundation.h>

#define LZStringize(x) #x
#define LZStringize2(x) LZStringize(x)
#define LZObjcStringize(text) @ LZStringize2(text)
