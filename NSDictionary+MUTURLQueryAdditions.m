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

#import "NSDictionary+MUTURLQueryAdditions.h"
#import "NSArray+MUTURLQueryAdditions.h"

@implementation NSDictionary (MUTURLQueryAdditions)

- (NSString *)stringByComposingURLQueryUsingEncoding:(NSStringEncoding)encoding
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [self keyEnumerator];
    for (id key in enumerator) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            for (id v in value) {
                [array addObject:@{@"key":key, @"value":v}];
            }
        } else {
            [array addObject:@{@"key":key, @"value":value}];
        }
    }
    return [array stringByComposingURLQueryUsingEncoding:encoding];
}

- (NSString *)stringByComposingURLQuery
{
    return [self stringByComposingURLQueryUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataByComposingURLQueryUsingEncoding:(NSStringEncoding)encoding
{
    NSString *s = [self stringByComposingURLQueryUsingEncoding:encoding];
    return [s dataUsingEncoding:encoding];
}

- (NSData *)dataByComposingURLQuery
{
    return [self dataByComposingURLQueryUsingEncoding:NSUTF8StringEncoding];
}

@end
