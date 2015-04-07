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

@property (copy) NSString *socket;
@property (copy) NSString *host;
@property (copy) NSString *databaseName;
@property unsigned int port;
@property (copy) NSString *userName;
@property (copy) NSString *password;
@property (readonly) NSError *error;


- (BOOL)connect;
- (void)disconnect;
//- (NSString *) r_escape:(NSString*)s; // escape simbols in the SQL string
- (NSInteger)autoincrementID;
- (BOOL)connected;
- (NSString *)errorMessage;

- (MySQLKitQuery *)queryWithString:(NSString *)string;
- (MySQLKitQuery *)queryWithFormat:(NSString *)format, ...;

- (MySQLKitResult *)executeQueryWithString:(NSString *)string;
- (MySQLKitResult *)executeQueryWithFormat:(NSString *)format, ...;

- (void)reportError;

- (NSString *)escapedStringFromString:(NSString *)string;
- (NSString *)hexstringFromData:(NSData *)data;

@end
