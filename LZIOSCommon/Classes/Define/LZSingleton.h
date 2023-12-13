
#define LZSingletonH + (instancetype)sharedInstance;

#define LZSingletonM                                    \
+ (id)allocWithZone:(struct _NSZone *)zone {            \
    return [self sharedInstance];                       \
}                                                       \
                                                        \
- (id)copyWithZone:(NSZone *)zone {                     \
    return [self.class sharedInstance];                 \
}                                                       \
                                                        \
- (id)mutableCopyWithZone:(NSZone *)zone {              \
    return [self.class sharedInstance];                 \
}                                                       \
                                                        \
+ (instancetype)sharedInstance {                        \
    static id _instance = nil;                          \
    static dispatch_once_t onceToken;                   \
    dispatch_once(&onceToken, ^{                        \
        _instance = [[super allocWithZone:NULL] init];  \
        [_instance _setup];                             \
    });                                                 \
    return _instance;                                   \
}
