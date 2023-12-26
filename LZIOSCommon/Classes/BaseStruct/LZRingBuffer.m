//
//  LZRingBuffer.m
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/25.
//

#import "LZRingBuffer.h"
#import "LZLog.h"

@interface LZRingBuffer ()
{
    uint8_t *_buffer;
    int _writePos;
    int _readPos;
}
@end

@implementation LZRingBuffer

- (void)dealloc {
    if (_buffer) {
        free(_buffer);
        _buffer = NULL;
    }
}

- (LZRingBuffer *)initWithCapacity:(int)capacity {
    if (self == [super init]) {
        _capacity = capacity;
        _buffer = malloc(_capacity);
        [self reset];
    }
    return self;
}

- (void)reset {
    _availableLen = 0;
    _writePos = 0;
    _readPos = 0;
}

- (int)write:(uint8_t *)data len:(int)len {
    if (_availableLen + len > _capacity) {
        LZLoggerInfo(@"write data len(%d) is more than capacity(%d)!", len, _capacity);
        return 0;
    }
    
    if (_writePos + len <= _capacity) {
        memcpy(_buffer + _writePos, data, len);
        _writePos += len;
    } else {
        int rightLen = _capacity - _writePos;
        int leftLen = len - rightLen;
        memcpy(_buffer + _writePos, data, rightLen);
        memcpy(_buffer, data + rightLen, leftLen);
        _writePos = leftLen;
    }
    
    _availableLen += len;
    return len;
}

- (int)read:(uint8_t *)data len:(int)len {
    int realLen = len;
    if (_availableLen < len) realLen = _availableLen;
    
    if (_readPos + realLen <= _capacity) {
        memcpy(data, _buffer + _readPos, realLen);
        _readPos += realLen;
    } else {
        int rightLen = _capacity - _readPos;
        int leftLen = realLen - rightLen;
        memcpy(data, _buffer + _readPos, rightLen);
        memcpy(data + rightLen, _buffer, leftLen);
        _readPos = leftLen;
    }

    _availableLen -= realLen;
    return realLen;
}

@end
