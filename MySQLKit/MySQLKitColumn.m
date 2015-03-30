//
//  MySQLKitColumn.m
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/26.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import "mysql.h"
#import "MySQLKitColumn.h"
#import "MySQLKitResult.h"


//
//	MySQLKitColumn ()
//

@interface MySQLKitColumn ()

@property (weak) MySQLKitResult *result;
@property (copy) NSString *name;
@property (assign) enum enum_field_types fieldType;
@property (assign) unsigned int flags;
@property (assign) NSInteger index;

@end


//
//	MySQLKitColumn
//

@implementation MySQLKitColumn

- (id)initWithResult:(MySQLKitResult *)result field:(MYSQL_FIELD)field index:(NSInteger)index
{
	if (self = [super init]) {
		self.result = result;
		self.name = [NSString stringWithUTF8String:field.name];
		self.fieldType = field.type;
		self.flags = field.flags;
		self.index = index;
	}
	return self;
}

- (void)dealloc
{
}

- (NSInteger)type
{
	return (NSInteger)self.fieldType;
}

- (BOOL)isBinary
{
	return self.flags & BINARY_FLAG;
}

- (id)valueFromPointer:(const char *)pointer length:(unsigned long)length
{
	NSString *string = [NSString stringWithUTF8String:pointer];
	switch (self.fieldType) {
	case MYSQL_TYPE_DECIMAL: case MYSQL_TYPE_NEWDECIMAL:
		return [NSDecimalNumber decimalNumberWithString:string];
	case MYSQL_TYPE_TINY: case MYSQL_TYPE_SHORT: case MYSQL_TYPE_LONG: case MYSQL_TYPE_INT24:
		return [NSNumber numberWithInteger:string.integerValue];
	case MYSQL_TYPE_FLOAT: case MYSQL_TYPE_DOUBLE:
		return [NSNumber numberWithFloat:string.doubleValue];
	case MYSQL_TYPE_NULL:
		return [NSNull null];
	case MYSQL_TYPE_TIMESTAMP:
		return string;
	case MYSQL_TYPE_LONGLONG:
		return [NSNumber numberWithLongLong:string.longLongValue];
	case MYSQL_TYPE_BIT:
		break;
	case MYSQL_TYPE_TINY_BLOB: case MYSQL_TYPE_MEDIUM_BLOB: case MYSQL_TYPE_LONG_BLOB: case MYSQL_TYPE_BLOB:
		if (self.isBinary) {
			return [NSData dataWithBytes:pointer length:length];
		}
		else {
			return string;
		}
		break;
	default:
		return string;
	}
	return string;

}

@end
