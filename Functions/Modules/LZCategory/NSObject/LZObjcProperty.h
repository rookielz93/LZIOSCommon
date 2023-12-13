//
//  LZObjcProperty.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const LZOBJCPropertyTypeEncodingAttribute;
extern NSString * const LZOBJCPropertyBackingIVarNameAttribute;
extern NSString * const LZOBJCPropertyCopyAttribute;
extern NSString * const LZOBJCPropertyRetainAttribute;
extern NSString * const LZOBJCPropertyCustomGetterAttribute;
extern NSString * const LZOBJCPropertyCustomSetterAttribute;
extern NSString * const LZOBJCPropertyDynamicAttribute;
extern NSString * const LZOBJCPropertyEligibleForGarbageCollectionAttribute;
extern NSString * const LZOBJCPropertyNonAtomicAttribute;
extern NSString * const LZOBJCPropertyOldTypeEncodingAttribute;
extern NSString * const LZOBJCPropertyReadOnlyAttribute;
extern NSString * const LZOBJCPropertyWeakReferenceAttribute;

//    NSString 的objc_property_attributes
//    name: T  value: @"NSString"  type
//    name: &  value:              &: string, C: copy, W: weak, nil: assign
//    name: N  value:              N: isNonatomic, nil atomic
//    name: V  value: _name        V: 对应的ivar名
typedef NS_ENUM(NSInteger, LZPropAttrOwnerShip) {
    LZPropAttrOwnerShipAssign,
    LZPropAttrOwnerShipCopy,
    LZPropAttrOwnerShipStrong,
    LZPropAttrOwnerShipWeak,
};

@interface LZObjcProperty : NSObject

//- (instancetype)initWithProperty:(objc_property_t)prop;
+ (instancetype)prop:(objc_property_t)prop;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) id value;

#pragma mark - objc property attributes
@property (nonatomic, readonly, copy) NSString *typeEncoding;    ///< T
@property (nonatomic, readonly, copy) NSString *oldTypeEncoding; ///< t
@property (nonatomic, readonly, copy) NSString *ivarName;        ///< N
@property (nonatomic, readonly, assign) LZPropAttrOwnerShip ownerShip;      ///< &: string, C: copy, W: weak, nil: assign
@property (nonatomic, readonly, assign) BOOL isNonatomic;
@property (nonatomic, readonly, assign) BOOL isReadOnly;

@end

NS_ASSUME_NONNULL_END
