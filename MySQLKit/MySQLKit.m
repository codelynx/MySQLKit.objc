//
//  MySQLKit.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Based on Matthew Moore on 11/2/13.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import "MySQLKit.h"
#import "mysql.h"


#define CASE_RETURN_STRING(code) case code: return @"##code"


//
//	MySQLKit
//

@implementation MySQLKit

+ (NSString *)stringFromState:(NSInteger)state
{
	switch (state) {
	CASE_RETURN_STRING(MYSQL_STMT_INIT_DONE);
	CASE_RETURN_STRING(MYSQL_STMT_PREPARE_DONE);
	CASE_RETURN_STRING(MYSQL_STMT_EXECUTE_DONE);
	CASE_RETURN_STRING(MYSQL_STMT_FETCH_DONE);
	default: return [NSString stringWithFormat:@"Unknown state=%zd", state];
	}
}

@end

