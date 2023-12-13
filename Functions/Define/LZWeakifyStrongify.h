//
//  LZWeakifyStrongify.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#ifndef LZWeakifyStrongify_h
#define LZWeakifyStrongify_h

#ifndef    lz_weakify
#if __has_feature(objc_arc)

#define lz_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __weak __typeof__(x) __weak_##x##__ = (x); \
_Pragma("clang diagnostic pop")

#else

#define lz_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __block __typeof__(x) __block_##x##__ = (x); \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    lz_strongify
#if __has_feature(objc_arc)

#define lz_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define lz_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif

#ifndef    lz_strongify_with_returnvalue
#if __has_feature(objc_arc)

#define lz_strongify_with_returnvalue( x , ret ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
if(nil == x) {return ret;} \
_Pragma("clang diagnostic pop")

#else

#define lz_strongify_with_returnvalue( x , ret ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
if(nil == x) {return ret;} \
_Pragma("clang diagnostic pop")

#endif

#endif

#endif

#endif /* LZWeakifyStrongify_h */
