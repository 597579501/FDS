//
//  NGOStringUtility.h
//  NGO
//
//  Created by ngo on 13-6-5.
//  Copyright (c) 2013年 NGO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FDSUtilities)
- (BOOL)containsString:(NSString *)aString;
- (NSString*)telephoneWithReformat;
@end
