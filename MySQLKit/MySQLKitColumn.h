//
//  MySQLKitColumn.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/26.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


//
//	MySQLKitColumn
//

@interface MySQLKitColumn : NSObject

@property (copy, readonly) NSString *name;
@property (readonly) NSInteger type;
@property (readonly) NSInteger index;

- (id)valueFromPointer:(const char *)pointer length:(unsigned long)length;

@end
