//
//  NGOStringUtility.m
//  NGO
//
//  Created by ngo on 13-6-5.
//  Copyright (c) 2013年 NGO. All rights reserved.
//

#import "FDSStringUtility.h"

@implementation NSString (FDSUtilities)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*)telephoneWithReformat
{
    if ([self containsString:@"-"])
    {
        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([self containsString:@"("])
    {
        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([self containsString:@")"])
    {
        self = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if ([self containsString:@" "])
    {
        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if ([self containsString:@"."])
    {
        self = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    if ([self containsString:@"."])
    {
        self = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    }

    NSLog(@"%@",self);
    if (self.length>=11) {
        NSRange range=NSMakeRange(self.length-11, 11);
        return [self substringWithRange:range];
    }
    else
        return self;
}


@end
