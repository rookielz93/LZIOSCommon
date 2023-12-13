//
//  LZObjcProperty.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZObjcProperty.h"

NSString * const LZOBJCPropertyTypeEncodingAttribute                  = @"T";

NSString * const LZOBJCPropertyCopyAttribute                          = @"C";
NSString * const LZOBJCPropertyRetainAttribute                        = @"&";
NSString * const LZOBJCPropertyWeakReferenceAttribute                 = @"W";

NSString * const LZOBJCPropertyNonAtomicAttribute                     = @"N";
NSString * const LZOBJCPropertyBackingIVarNameAttribute               = @"V";

NSString * const LZOBJCPropertyCustomGetterAttribute                  = @"G";
NSString * const LZOBJCPropertyCustomSetterAttribute                  = @"S";
NSString * const LZOBJCPropertyDynamicAttribute                       = @"D";
NSString * const LZOBJCPropertyEligibleForGarbageCollectionAttribute  = @"P";
NSString * const LZOBJCPropertyOldTypeEncodingAttribute               = @"t";
NSString * const LZOBJCPropertyReadOnlyAttribute                      = @"R";

#define LZToNSString(s) [NSString stringWithUTF8String:s]

@interface LZObjcProperty ()
{
    objc_property_t _prop;
    NSMutableDictionary<NSString *, NSString *> *_attributeDict;
}
@end

@implementation LZObjcProperty

+ (instancetype)prop:(objc_property_t)prop {
    LZObjcProperty *p = [[LZObjcProperty alloc] init];
    p->_prop = prop;
    p->_name = [NSString stringWithUTF8String:property_getName(prop)];
    p->_attributeDict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(prop, &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_attribute_t attr = attrs[i];
        p->_attributeDict[LZToNSString(attr.name)] = LZToNSString(attr.value).length ? LZToNSString(attr.value) : @"";
    }
    free(attrs);
    return p;
}

- (LZPropAttrOwnerShip)ownerShip {
    if (_attributeDict[LZOBJCPropertyCopyAttribute]) { return LZPropAttrOwnerShipCopy; }
    else if (_attributeDict[LZOBJCPropertyRetainAttribute]) { return LZPropAttrOwnerShipStrong; }
    else if (_attributeDict[LZOBJCPropertyWeakReferenceAttribute]) { return LZPropAttrOwnerShipWeak; }
    else return LZPropAttrOwnerShipAssign;
}

- (BOOL)isNonatomic {
    return [_attributeDict[LZOBJCPropertyNonAtomicAttribute] boolValue];
}

- (NSString *)ivarName {
    return _attributeDict[LZOBJCPropertyBackingIVarNameAttribute];
}

- (NSString *)typeEncoding {
    return _attributeDict[LZOBJCPropertyTypeEncodingAttribute];
}

- (NSString *)oldTypeEncoding {
    return _attributeDict[LZOBJCPropertyOldTypeEncodingAttribute];
}

- (BOOL)isReadOnly {
    return [_attributeDict[LZOBJCPropertyReadOnlyAttribute] boolValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"--------\n   name: %@\n   type: %@ \n   ownerShip:%@\n   isNonatomic: %@\n   ivarName: %@", self.name, self.typeEncoding, [self ownerShipString], @(self.isNonatomic), self.ivarName];
}

- (NSString *)ownerShipString {
    switch (self.ownerShip) {
        case LZPropAttrOwnerShipCopy: return @"Copy";
        case LZPropAttrOwnerShipAssign: return @"Assign";
        case LZPropAttrOwnerShipStrong: return @"Strong";
        case LZPropAttrOwnerShipWeak: return @"Weak";
        default: return nil;
    }
}

@end
