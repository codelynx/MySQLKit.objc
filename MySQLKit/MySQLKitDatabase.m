//
//  MySQLKitDatabase.m
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import "mysql.h"
#import "MySQLKitDatabase.h"
#import "MySQLKitQuery.h"


//
//	MySQLKitDatabase ()
//

@interface MySQLKitDatabase ()
{
	MYSQL *_mysql;
}
@property (readonly) MYSQL *mysql;
@property (weak) NSThread *thread;
@end


//
//	MySQLKitDatabase
//

@implementation MySQLKitDatabase

+ (void)initialize
{
	if (self == [MySQLKitDatabase class]) {
	}
}

- (id)init
{
	if (self = [super init]) {
        if (mysql_library_init(0, NULL, NULL)) {
            NSLog(@"Database didn't connect");
			return nil;
		}
	}
	return self;
}

- (void)finalize
{
    mysql_library_end();
}

- (BOOL)connect
{
    _mysql = mysql_init(NULL);
	
	const char *host = self.host ? self.host.UTF8String : "localhost";
	const char *user = self.userName ? self.userName.UTF8String : "";
	const char *password = self.password ? self.password.UTF8String : "";
	const char *database = self.databaseName ? self.databaseName.UTF8String : NULL;
	unsigned int port = self.port ? self.port : 3306;
	const char *socket = self.socket ? self.socket.UTF8String : NULL;
	unsigned long flag = 0;

    if(!mysql_real_connect(_mysql, host, user, password, database, port, socket, flag)) {
		NSLog(@"mysql: %@", self.error);
		return NO;
    }
	
    if(!mysql_set_character_set(_mysql, "utf8")) {
		NSLog(@"mysql: character set is %s.", mysql_character_set_name(_mysql));
	}

	self.thread = [NSThread currentThread];

	return YES;
}

- (void)disconnect
{
	if (_mysql) {
        mysql_close(_mysql), _mysql = nil;
	}
}

- (void)dealloc
{
	[self disconnect];
}

- (MySQLKitQuery *)queryWithString:(NSString *)string
{
	return [[MySQLKitQuery alloc] initWithDatabase:self query:string];
}

- (MySQLKitQuery *)queryWithFormat:(NSString *)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *string = [NSString stringWithFormat:format, args];
	va_end(args);
	return [self queryWithString:string];
}

- (MySQLKitResult *)executeQueryWithString:(NSString *)string
{
	return [[self queryWithString:string] execute];
}

- (MySQLKitResult *)executeQueryWithFormat:(NSString *)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *string = [NSString stringWithFormat:format, args];
	va_end(args);

	return [self executeQueryWithString:string];
}


- (MYSQL *)mysql
{
	return _mysql;
}

- (NSInteger)errorCode
{
	return mysql_errno(_mysql);
}

- (NSError *)error
{
	if (_mysql && mysql_errno(_mysql)) {
		NSDictionary *userInfo = @{ @"message": [NSString stringWithUTF8String:mysql_error(_mysql)] };
		return [NSError errorWithDomain:@"MySQLKit" code:mysql_errno(_mysql) userInfo:userInfo];
	}
	return nil;
}

- (NSString *)errorMessage
{
	return [NSString stringWithUTF8String:mysql_error(_mysql)];
}

- (BOOL)connected
{
	return mysql_stat(_mysql) ? YES : NO;
}

- (NSInteger)autoincrementID
{
	NSInteger result = mysql_insert_id(_mysql);
	return result;
}

- (void)reportError
{
	if (_mysql) {
		if (mysql_errno(_mysql) != 0) {
			NSLog(@"mysql: %@", self.error);
		}
	}
}

- (NSString *)escapedStringFromString:(NSString *)string
{
	const char *utf8String = string.UTF8String;
	size_t length = strlen(utf8String);
	char *buffer = malloc(length * 2 + 1);
	mysql_real_escape_string(_mysql, buffer, utf8String, length);
	NSString *escapedString = [NSString stringWithUTF8String:buffer];
	free(buffer);
	return escapedString;
}

- (NSString *)hexstringFromData:(NSData *)data;
{
	const char *buffer = data.bytes;
	size_t bytes = data.length;
	NSMutableString *hexstring = [NSMutableString string];
	[hexstring appendString:@"X'"];
	while (bytes > 0) {
		const char byte = *buffer;
		[hexstring appendFormat:@"%02x", byte];
		buffer++; bytes--;
	}
	[hexstring appendString:@"'"];
	return hexstring;
}

@end
