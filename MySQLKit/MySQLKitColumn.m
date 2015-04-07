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
{
	MySQLKitResult *_result;
	NSString *_name;
	enum enum_field_types _fieldType;
	unsigned int _flags;
	NSInteger _index;
}

@end


//
//	MySQLKitColumn
//

@implementation MySQLKitColumn

- (id)initWithResult:(MySQLKitResult *)result field:(MYSQL_FIELD)field index:(NSInteger)index
{
	if (self = [super init]) {
		_result = result;
		_name = [NSString stringWithUTF8String:field.name];
		_fieldType = field.type;
		_flags = field.flags;
		_index = index;
	}
	return self;
}

- (void)dealloc
{
}

- (NSInteger)type
{
	return (NSInteger)_fieldType;
}

- (BOOL)isBinary
{
	return _flags & BINARY_FLAG;
}

- (id)valueFromPointer:(const char *)pointer length:(unsigned long)length
{
	NSString *string = [NSString stringWithUTF8String:pointer];
	switch (_fieldType) {
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
