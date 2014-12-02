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
#import "NSString+MUTURLQueryAdditions.h"

@implementation NSString (MUTURLQueryAdditions)

- (NSMutableDictionary *)mutableDictionaryByParsingURLQueryWithEncoding:(NSStringEncoding)encoding;
{
    // Based upon http://stackoverflow.com/questions/8756683/best-way-to-parse-url-string-to-get-values-for-keys
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [self componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSString *key, *value;
        NSRange range = [keyValuePair rangeOfString:@"="];
        if (range.location == NSNotFound) {
            key = keyValuePair;
            value = @"";
        } else {
            key = [keyValuePair substringToIndex:range.location];
            value = [[keyValuePair substringFromIndex:range.location + 1] decodeURIComponentUsingEncoding:encoding];
        }
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

- (NSMutableDictionary *)mutableDictionaryByParsingURLQuery;
{
    return [self mutableDictionaryByParsingURLQueryWithEncoding:NSUTF8StringEncoding];
}

- (NSMutableArray *)mutableArrayByParsingURLQueryWithEncoding:(NSStringEncoding)encoding;
{
    NSMutableArray *queryStringArray = [[NSMutableArray alloc] init];
    NSArray *urlComponents = [self componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSString *name, *value;
        NSRange range = [keyValuePair rangeOfString:@"="];
        if (range.location == NSNotFound) {
            name = [keyValuePair decodeURIComponentUsingEncoding:encoding];
            value = @"";
        } else {
            name = [[keyValuePair substringToIndex:range.location] decodeURIComponentUsingEncoding:encoding];
            value = [[keyValuePair substringFromIndex:range.location + 1] decodeURIComponentUsingEncoding:encoding];
        }
        NSDictionary *pair = [[NSDictionary alloc] initWithObjectsAndKeys:
            name, @"name", value, @"value", nil];
        [queryStringArray addObject:pair];
    }
    return queryStringArray;
}

- (NSMutableArray *)mutableArrayByParsingURLQuery;
{
    return [self mutableArrayByParsingURLQueryWithEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryByParsingURLQueryWithEncoding:(NSStringEncoding)encoding
{
    return [self mutableDictionaryByParsingURLQueryWithEncoding:encoding];
}

- (NSDictionary *)dictionaryByParsingURLQuery
{
    return [self mutableDictionaryByParsingURLQuery];
}

- (NSArray *)arrayByParsingURLQueryWithEncoding:(NSStringEncoding)encoding
{
    return [self mutableArrayByParsingURLQueryWithEncoding:encoding];
}

- (NSArray *)arrayByParsingURLQuery
{
    return [self mutableArrayByParsingURLQuery];
}

@end
