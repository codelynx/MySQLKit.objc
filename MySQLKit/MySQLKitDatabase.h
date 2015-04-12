//
//  MySQLKitDatabase.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MySQLKitQuery;
@class MySQLKitResult;


//
//	MySQLKitDatabase
//

@interface MySQLKitDatabase : NSObject

@property (readonly) NSError *error;

- (BOOL)connectWithSocket:(NSString *)socket username:(NSString *)username password:(NSString *)password database:(NSString *)database;
- (BOOL)connectWithHost:(NSString *)host port:(unsigned int)port username:(NSString *)username password:(NSString *)password database:(NSString *)database;

- (void)disconnect;
//- (NSString *) r_escape:(NSString*)s; // escape simbols in the SQL string
- (NSInteger)autoincrementID;
- (BOOL)isConnected;
- (NSString *)errorMessage;

- (MySQLKitQuery *)queryWithString:(NSString *)string;
- (MySQLKitQuery *)queryWithFormat:(NSString *)format, ...;

- (MySQLKitResult *)executeQueryWithString:(NSString *)string;
- (MySQLKitResult *)executeQueryWithFormat:(NSString *)format, ...;

- (void)reportError;

- (NSString *)escapedStringFromString:(NSString *)string;
- (NSString *)hexstringFromData:(NSData *)data;

@end
