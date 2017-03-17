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

#import "NSString+MUTURLEncodeAdditions.h"
#import "NSArray+MUTURLQueryAdditions.h"

@implementation NSArray (MUTURLQueryAdditions)

- (NSString *)stringByComposingURLQueryUsingEncoding:(NSStringEncoding)encoding
{
    NSArray *sorted = [self sortedArrayUsingComparator:^(id item1, id item2){
        NSDictionary *d1 = item1;
        NSDictionary *d2 = item2;
        NSComparisonResult r = [[d1 objectForKey:@"key"] compare:[d2 objectForKey:@"key"]];
        if (r != NSOrderedSame)
            return r;
        return [[d1 objectForKey:@"value"] compare:[d2 objectForKey:@"value"]];
    }];

    NSMutableString *s = [[NSMutableString alloc] init];
    BOOL first = YES;
    for (NSDictionary *d in sorted) {
        id _key = [d objectForKey:@"key"];
        id _value = [d objectForKey:@"value"];
        NSString *key, *value;
        if ([_key isKindOfClass:[NSString class]])
            key = _key;
        else
            key = [_key description];
        if ([_value isKindOfClass:[NSString class]])
            value = _value;
        else
            value = [_value description];
        if (first) {
            [s appendFormat:@"%@=%@", [key encodeURIComponent], [value encodeURIComponent]];
            first = NO;
        } else {
            [s appendFormat:@"&%@=%@", [key encodeURIComponent], [value encodeURIComponent]];
        }
    }
    return s;
}

- (NSString *)stringByComposingURLQuery
{
    return [self stringByComposingURLQueryUsingEncoding:NSUTF8StringEncoding];
}

@end
