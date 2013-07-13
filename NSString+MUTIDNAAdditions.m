/*
The MIT License (MIT)

Copyright (c) 2013 Masanori Mikawa.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "NSString+MUTCaseCompareAdditions.h"
#import "NSString+MUTPunycodeAdditions.h"
#import "NSString+MUTIDNAAdditions.h"

static NSString * const acePrefix = @"xn--";

static NSString *
stringprep(NSString *s)
{
    // Zap code set B.1 of RFC 3454
    NSRegularExpression *codeset_b1 = [NSRegularExpression regularExpressionWithPattern:@"[\u00AD\u034F\u1806\u180B\u180C\u180D\u200B\u200C\u200D\u2060\uFE00\uFE01\uFE02\uFE03\uFE04\uFE05\uFE06\uFE07\uFE08\uFE09\uFE0A\uFE0B\uFE0C\uFE0D\uFE0E\uFE0F\uFEFF]" options:0 error:nil];
    NSString *t = [codeset_b1 stringByReplacingMatchesInString:s options:0 range:NSMakeRange(0, [s length]) withTemplate:@""];
    // And normalize with KC form
    return [t precomposedStringWithCompatibilityMapping];
}

@implementation NSString (MUTIDNAAdditions)

- (NSString *)idnaToAscii
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringprep(self)];
    NSCharacterSet *delim = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSCharacterSet *nonAscii = [[NSCharacterSet characterSetWithRange:NSMakeRange(1, 127)] invertedSet];

    NSMutableString *rv = [[NSMutableString alloc] init];
    while (![scanner isAtEnd]) {
        NSString *s;
        if ([scanner scanUpToCharactersFromSet:delim intoString:&s]) {
            NSRange range = [s rangeOfCharacterFromSet:nonAscii];
            if (range.location != NSNotFound) {
                NSString *t = [s punycodeEncode];
                if (!t)
                    return nil;
                [rv appendString:acePrefix];
                [rv appendString: t];
            } else {
                [rv appendString:s];
            }
        }
        if ([scanner scanCharactersFromSet:delim intoString:&s])
           [rv appendString:s];
    }
    return rv;
}

- (NSString *)idnaToUnicode
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    NSCharacterSet *delim = [NSCharacterSet characterSetWithCharactersInString:@"."];

    NSMutableString *rv = [[NSMutableString alloc] init];
    while (![scanner isAtEnd]) {
        NSString *s;
        if ([scanner scanUpToCharactersFromSet:delim intoString:&s]) {
            if ([s caseInsensitiveHasPrefix:acePrefix]) {
                NSString *t = [[s substringFromIndex:4] punycodeDecode];
                if (!t)
                    return nil;
                [rv appendString:t];
            } else {
                [rv appendString:s];
            }
        }
        if ([scanner scanCharactersFromSet:delim intoString:&s])
            [rv appendString:s];
    }
    return rv;
}

@end
