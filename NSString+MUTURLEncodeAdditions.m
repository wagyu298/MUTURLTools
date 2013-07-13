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
#import "MUTURLComponents.h"

static inline BOOL
escape_reqd(unsigned char ch)
{
    // <を含む文字列はNSURLがURLと認識しないので。>は問題ないっぽいけどペアなの>で一応
    return (ch <= 0x20 || ch >= 0x7f || ch == '<' || ch == '>');
}

static inline int
is_hexdig(int ch)
{
    return ((ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'F') || (ch >= 'a' && ch <= 'f'));
}

static inline int
is_hexdig_un(unichar ch)
{
    return ((ch >= L'0' && ch <= L'9') || (ch >= L'A' && ch <= L'F') || (ch >= L'a' && ch <= L'f'));
}

@implementation NSString (MUTURLEncodeAdditions)

- (NSString *)encodeURIComponentUsingEncoding:(NSStringEncoding)encoding
{
    // javascriptのencodeURIComponentは!'()*-._~をエスケープしない
    CFStringRef rv = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(";:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(encoding));
    return (NSString *)CFBridgingRelease(rv);
}

// Similar JavaScript encodeURIComponent function
- (NSString *)encodeURIComponent
{
    return [self encodeURIComponentUsingEncoding:NSUTF8StringEncoding];
}

// Similar JavaScript decodeURIComponent function
- (NSString *)decodeURIComponentUsingEncoding:(NSStringEncoding)encoding
{
    // たぶんstringByReplacingPercentEscapesUsingEncodingと一緒なんだけど一応
    CFStringRef rv = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
    return (NSString *)CFBridgingRelease(rv);
}

// Similar JavaScript decodeURIComponent function
- (NSString *)decodeURIComponent
{
    return [self decodeURIComponentUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeURLSafeUsingEncoding:(NSStringEncoding)encoding
{
    if ([self length] == 0) {
        return self;
    }
    
    const unsigned char *s = (const unsigned char *)[self cStringUsingEncoding:encoding];
    NSMutableData *data = [[NSMutableData alloc] init];

    while (*s != '\0') {
        if (escape_reqd(*s)) {
            char buf[4];
            sprintf(buf, "%%%02X", *s++);
            [data appendBytes:buf length:3];
            continue;
        } else if (*s == '%') {
            BOOL unsafe = NO;
            if (!is_hexdig(s[1])) {
                unsafe = YES;
            } else if (!is_hexdig(s[2])) {
                unsafe = YES;
            }
            if (unsafe) {
                [data appendBytes:"%25" length:3];
                s++;
            } else {
                [data appendBytes:s length:3];
                s += 3;
            }
            continue;
        }
        
        const unsigned char *t = s++;
        for ( ; *s != '\0' && !(escape_reqd(*s) || *s == '%'); ++s)
            ;
        [data appendBytes:t length:s - t];
    }
    NSString *escaped = [[NSString alloc] initWithData:data encoding:encoding];
    return escaped;
}

- (NSString *)encodeURLSafe
{
    return [self encodeURLSafeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)decodeURLSafeUsingEncoding:(NSStringEncoding)encoding
{
    size_t len = [self length];
    if (len == 0) {
        return self;
    }
    
    const unichar *s = CFStringGetCharactersPtr((__bridge CFStringRef)self);
    NSMutableData *data;
    if (s == NULL) {
        data = [NSMutableData dataWithLength:len * sizeof(unichar)];
        [self getCharacters:[data mutableBytes]];
        s = [data bytes];
    }
    if (s == NULL) {
        return nil;
    }
    
    // %Xy等のアンエスケープ不可な文字を含むとCFURLCreateStringByReplacingPercentEscapesUsingEncodingが
    // nilを返すので先にエスケープする
    NSMutableString *escaped = [[NSMutableString alloc] initWithCapacity:len];
    int i = 0;
    while (i < len) {
        int offset = i;
        if (s[i++] == L'%') {
            BOOL unsafe = NO;
            if (i == len || i + 1 == len) {
                unsafe = YES;
            } else if (!is_hexdig_un(s[i]) || !is_hexdig_un(s[i+1])) {
                unsafe = YES;
            }
            if (unsafe) {
                [escaped appendString:@"%25"];
                continue;
            }
        }
        for (; i < len && s[i] != L'%'; ++i)
            ;
        NSString *t = [[NSString alloc] initWithCharactersNoCopy:(unichar *)(&s[offset]) length:i-offset freeWhenDone:NO];
        [escaped appendString:t];
    }
    
    NSString *rv = [escaped decodeURIComponentUsingEncoding:encoding];
    return rv;
}

- (NSString *)decodeURLSafe
{
    return [self decodeURLSafeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeURLForHumanInput
{
    MUTURLComponents *u = [MUTURLComponents URLComponentsWithString:self];
    if (!u)
        return self;
    [u encode];
    return [u urlString];
}

- (NSString *)decodeURLForHumanReadable
{
    MUTURLComponents *u = [MUTURLComponents URLComponentsWithString:self];
    if (!u)
        return self;
    [u decode];
    return [u urlString];
}

@end
